#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#define INPUT_DIR "harness_inputs"
#define CHUNK_SIZE 1000

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

    srand((unsigned int)time(NULL));
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
    while ((input_size = fread(input_bytes, sizeof(unsigned char), CHUNK_SIZE, input_file)) > 0)
    {
        // Generate a unique random file name for the input chunk
        char output_file[256];
        generate_random_filename(output_file, 16);
        strcat(output_file, ".zip");
        char output_file_path[256];
        snprintf(output_file_path, sizeof(output_file_path), "%s/%s", INPUT_DIR, output_file);

        // Write the input chunk to a temporary file
        write_chunk_to_file(output_file_path, input_bytes, input_size);

        // Create the command to run the zip tool's archive command
        char *command[] = {"../../7zz_afl_asan/CPP/7zip/Bundles/Alone2/_o/bin/7zz", "a",
                           "archive.zip", "-y", output_file_path, NULL};

        // Execute the command
        if (fork() == 0)
        {
            execvp(command[0], command);
            perror("Failed to execute zip command");
            exit(1);
        }

        // Clean up the temporary file
        remove(output_file_path);
    }

    fclose(input_file);

    return 0;
}
