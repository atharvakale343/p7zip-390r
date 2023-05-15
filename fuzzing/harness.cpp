// MainAr.cpp

#include "StdAfx.h"

#ifdef _WIN32
#include "../../../../C/DllSecur.h"
#endif

#include "../../../Common/MyException.h"
#include "../../../Common/StdOutStream.h"

#include "../../../Windows/ErrorMsg.h"
#include "../../../Windows/NtCheck.h"

#include "../Common/ArchiveCommandLine.h"
#include "../Common/ExitCode.h"

#include "ConsoleClose.h"

// Harness imports start here
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>

#define INPUT_DIR "harness_inputs"
#define CHUNK_SIZE 1000
#define MAX_FILES 15
// Harness imports end here

using namespace NWindows;

extern CStdOutStream *g_StdStream;
CStdOutStream *g_StdStream = NULL;
extern CStdOutStream *g_ErrStream;
CStdOutStream *g_ErrStream = NULL;

extern int Main2(
#ifndef _WIN32
    int numArgs, char *args[]
#endif
);

static const char *const kException_CmdLine_Error_Message = "Command Line Error:";
static const char *const kExceptionErrorMessage = "ERROR:";
static const char *const kUserBreakMessage = "Break signaled";
static const char *const kMemoryExceptionMessage = "ERROR: Can't allocate required memory!";
static const char *const kUnknownExceptionMessage = "Unknown Error";
static const char *const kInternalExceptionMessage = "\n\nInternal Error #";

static void FlushStreams()
{
    if (g_StdStream)
        g_StdStream->Flush();
}

static void PrintError(const char *message)
{
    FlushStreams();
    if (g_ErrStream)
        *g_ErrStream << "\n\n"
                     << message << endl;
}

#if defined(_WIN32) && defined(_UNICODE) && !defined(_WIN64) && !defined(UNDER_CE)
#define NT_CHECK_FAIL_ACTION                       \
    *g_StdStream << "Unsupported Windows version"; \
    return NExitCode::kFatalError;
#endif

int MY_CDECL main_7zz(
#ifndef _WIN32
    int numArgs, char *args[]
#endif
)
{
    g_ErrStream = &g_StdErr;
    g_StdStream = &g_StdOut;

    NT_CHECK

    NConsoleClose::CCtrlHandlerSetter ctrlHandlerSetter;
    int res = 0;

    try
    {
#ifdef _WIN32
        My_SetDefaultDllDirectories();
#endif

        res = Main2(
#ifndef _WIN32
            numArgs, args
#endif
        );
    }
    catch (const CNewException &)
    {
        PrintError(kMemoryExceptionMessage);
        return (NExitCode::kMemoryError);
    }
    catch (const NConsoleClose::CCtrlBreakException &)
    {
        PrintError(kUserBreakMessage);
        return (NExitCode::kUserBreak);
    }
    catch (const CMessagePathException &e)
    {
        PrintError(kException_CmdLine_Error_Message);
        if (g_ErrStream)
            *g_ErrStream << e << endl;
        return (NExitCode::kUserError);
    }
    catch (const CSystemException &systemError)
    {
        if (systemError.ErrorCode == E_OUTOFMEMORY)
        {
            PrintError(kMemoryExceptionMessage);
            return (NExitCode::kMemoryError);
        }
        if (systemError.ErrorCode == E_ABORT)
        {
            PrintError(kUserBreakMessage);
            return (NExitCode::kUserBreak);
        }
        if (g_ErrStream)
        {
            PrintError("System ERROR:");
            *g_ErrStream << NError::MyFormatMessage(systemError.ErrorCode) << endl;
        }
        return (NExitCode::kFatalError);
    }
    catch (NExitCode::EEnum &exitCode)
    {
        FlushStreams();
        if (g_ErrStream)
            *g_ErrStream << kInternalExceptionMessage << exitCode << endl;
        return (exitCode);
    }
    catch (const UString &s)
    {
        if (g_ErrStream)
        {
            PrintError(kExceptionErrorMessage);
            *g_ErrStream << s << endl;
        }
        return (NExitCode::kFatalError);
    }
    catch (const AString &s)
    {
        if (g_ErrStream)
        {
            PrintError(kExceptionErrorMessage);
            *g_ErrStream << s << endl;
        }
        return (NExitCode::kFatalError);
    }
    catch (const char *s)
    {
        if (g_ErrStream)
        {
            PrintError(kExceptionErrorMessage);
            *g_ErrStream << s << endl;
        }
        return (NExitCode::kFatalError);
    }
    catch (const wchar_t *s)
    {
        if (g_ErrStream)
        {
            PrintError(kExceptionErrorMessage);
            *g_ErrStream << s << endl;
        }
        return (NExitCode::kFatalError);
    }
    catch (int t)
    {
        if (g_ErrStream)
        {
            FlushStreams();
            *g_ErrStream << kInternalExceptionMessage << t << endl;
            return (NExitCode::kFatalError);
        }
    }
    catch (...)
    {
        PrintError(kUnknownExceptionMessage);
        return (NExitCode::kFatalError);
    }

    return res;
}

void write_chunk_to_file(const char *filename, const unsigned char *chunk, size_t size)
{
    FILE *file = fopen(filename, "wb");
    if (file == NULL)
    {
        perror("Failed to create input file");
        exit(1);
    }
    fwrite(chunk, sizeof(unsigned char), size, file);
    fclose(file);
}

void generate_random_filename(char *filename, size_t max_length)
{
    const char charset[] = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    size_t charset_length = sizeof(charset) - 1;

    for (size_t i = 0; i < max_length - 1; ++i)
    {
        filename[i] = charset[rand() % charset_length];
    }
    filename[max_length - 1] = '\0';
}

int main(int argc, char *argv[])
{
    if (argc < 2)
    {
        fprintf(stderr, "Usage: %s <input_file>\n", argv[0]);
        return 1;
    }

    srand((unsigned int)time(NULL));

    // Open the input file in binary mode
    FILE *input_file = fopen(argv[1], "rb");
    if (input_file == NULL)
    {
        perror("Failed to open input file");
        return 1;
    }

    // Read the raw bytes from the input file
    unsigned char input_bytes[CHUNK_SIZE];
    size_t input_size;

    // Array to store output file names
    char output_files[MAX_FILES][256];
    int file_count = 0;

    while ((input_size = fread(input_bytes, sizeof(unsigned char), CHUNK_SIZE, input_file)) > 0)
    {
        if (file_count == MAX_FILES) {
            break;
        }

        // Generate a unique random file name for the input chunk
        char output_file[256];
        generate_random_filename(output_file, 16);
        strcat(output_file, ".txt");

        snprintf(output_files[file_count], sizeof(output_files[file_count]), "%s/%s", INPUT_DIR, output_file);
        file_count++;

        // Write the input chunk to a temporary file
        write_chunk_to_file(output_files[file_count - 1], input_bytes, input_size);
    }

    fclose(input_file);

    // Build the command with the list of files
    char *exec_file =  (char*) "../7zz_afl_asan/CPP/7zip/Bundles/Alone2/_o/bin/7zz";

    char **command = (char **)malloc((file_count + 5) * sizeof(char *));
    command[0] = exec_file;
    command[1] = (char *)"a";

    char zip_fname[256];
    generate_random_filename(zip_fname, 16);
    strcat(zip_fname, ".zip");

    command[2] = zip_fname;
    command[3] = (char *)"-y";

    for (int i = 0; i < file_count; i++)
    {
        command[i + 4] = output_files[i];
    }
    command[file_count + 4] = NULL;

    // Execute the command
    main_7zz(file_count + 4, command);

    // Delete files
    for (int i = 0; i < file_count; i++)
    {
        remove(output_files[i]);
    }

    if (access(command[2], F_OK) == 0)
    {
        remove(command[2]);
    }

    free(command);
    return 0;
}
