#!/bin/bash

DIR=$1
echo Updating harness for $DIR

cd $DIR/CPP/7zip/Bundles/Alone2

cp ../../../../../fuzzing/harness.cpp ../../UI/Console/MainAr.cpp

g++ $CFLAGS -c -Wall -Wextra   -DNDEBUG -D_REENTRANT -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -fPIC    -o _o/MainAr.o  ../../UI/Console/MainAr.cpp

g++ -o _o/bin/7zz $CFLAGS _o/7zBuf2.o _o/7zStream.o _o/Alloc.o _o/Bcj2.o _o/Bcj2Enc.o _o/Blake2s.o _o/Bra.o _o/Bra86.o _o/BraIA64.o _o/BwtSort.o _o/CpuArch.o _o/Delta.o _o/HuffEnc.o _o/LzFind.o _o/Lzma2Dec.o _o/Lzma2DecMt.o _o/Lzma2Enc.o _o/LzmaDec.o _o/LzmaEnc.o _o/MtCoder.o _o/MtDec.o _o/Ppmd7.o _o/Ppmd7Dec.o _o/Ppmd7aDec.o _o/Ppmd7Enc.o _o/Ppmd8.o _o/Ppmd8Dec.o _o/Ppmd8Enc.o _o/Sort.o _o/Xz.o _o/XzDec.o _o/XzEnc.o _o/XzIn.o _o/XzCrc64.o _o/XzCrc64Opt.o _o/7zCrc.o _o/7zCrcOpt.o _o/Aes.o _o/AesOpt.o _o/Sha256.o _o/Sha256Opt.o _o/Sha1.o _o/Sha1Opt.o  _o/LzFindMt.o _o/LzFindOpt.o _o/StreamBinder.o _o/Synchronization.o _o/VirtThread.o _o/MemBlocks.o _o/OutMemStream.o _o/ProgressMt.o _o/Threads.o _o/lz4-mt_common.o _o/lz4-mt_compress.o _o/lz4-mt_decompress.o _o/brotli-mt_common.o _o/brotli-mt_compress.o _o/brotli-mt_decompress.o _o/lizard-mt_common.o _o/lizard-mt_compress.o _o/lizard-mt_decompress.o _o/lz5-mt_common.o _o/lz5-mt_compress.o _o/lz5-mt_decompress.o  _o/CRC.o _o/CrcReg.o _o/DynLimBuf.o _o/IntToString.o _o/LzFindPrepare.o _o/MyMap.o _o/MyString.o _o/MyVector.o _o/MyXml.o _o/NewHandler.o _o/Sha1Prepare.o _o/Sha1Reg.o _o/Sha256Prepare.o _o/Sha256Reg.o _o/StringConvert.o _o/StringToInt.o _o/UTFConvert.o _o/Wildcard.o _o/XzCrc64Init.o _o/XzCrc64Reg.o  _o/FileDir.o _o/FileFind.o _o/FileIO.o _o/FileName.o _o/PropVariant.o _o/PropVariantConv.o _o/PropVariantUtils.o _o/System.o _o/TimeUtils.o  _o/ApfsHandler.o _o/ApmHandler.o _o/ArHandler.o _o/ArjHandler.o _o/Base64Handler.o _o/Bz2Handler.o _o/ComHandler.o _o/CpioHandler.o _o/CramfsHandler.o _o/DeflateProps.o _o/DmgHandler.o _o/ElfHandler.o _o/ExtHandler.o _o/FatHandler.o _o/FlvHandler.o _o/GzHandler.o _o/GptHandler.o _o/HandlerCont.o _o/HfsHandler.o _o/IhexHandler.o _o/LpHandler.o _o/LzhHandler.o _o/LzmaHandler.o _o/MachoHandler.o _o/MbrHandler.o _o/MslzHandler.o _o/MubHandler.o _o/NtfsHandler.o _o/PeHandler.o _o/PpmdHandler.o _o/QcowHandler.o _o/RpmHandler.o _o/SparseHandler.o _o/SplitHandler.o _o/SquashfsHandler.o _o/SwfHandler.o _o/UefiHandler.o _o/VdiHandler.o _o/VhdHandler.o _o/VhdxHandler.o _o/VmdkHandler.o _o/XarHandler.o _o/XzHandler.o _o/ZHandler.o _o/ZstdHandler.o _o/LizardHandler.o _o/Lz5Handler.o _o/Lz4Handler.o  _o/CoderMixer2.o _o/DummyOutStream.o _o/FindSignature.o _o/InStreamWithCRC.o _o/ItemNameUtils.o _o/MultiStream.o _o/OutStreamWithCRC.o _o/OutStreamWithSha1.o _o/HandlerOut.o _o/ParseProperties.o  _o/7zCompressionMode.o _o/7zDecode.o _o/7zEncode.o _o/7zExtract.o _o/7zFolderInStream.o _o/7zHandler.o _o/7zHandlerOut.o _o/7zHeader.o _o/7zIn.o _o/7zOut.o _o/7zProperties.o _o/7zSpecStream.o _o/7zUpdate.o _o/7zRegister.o  _o/CabBlockInStream.o _o/CabHandler.o _o/CabHeader.o _o/CabIn.o _o/CabRegister.o  _o/ChmHandler.o _o/ChmIn.o   _o/IsoHandler.o _o/IsoHeader.o _o/IsoIn.o _o/IsoRegister.o  _o/NsisDecode.o _o/NsisHandler.o _o/NsisIn.o _o/NsisRegister.o  _o/RarHandler.o _o/Rar5Handler.o  _o/TarHandler.o _o/TarHandlerOut.o _o/TarHeader.o _o/TarIn.o _o/TarOut.o _o/TarUpdate.o _o/TarRegister.o  _o/UdfHandler.o _o/UdfIn.o  _o/WimHandler.o _o/WimHandlerOut.o _o/WimIn.o _o/WimRegister.o  _o/ZipAddCommon.o _o/ZipHandler.o _o/ZipHandlerOut.o _o/ZipIn.o _o/ZipItem.o _o/ZipOut.o _o/ZipUpdate.o _o/ZipRegister.o  _o/Bcj2Coder.o _o/Bcj2Register.o _o/BcjCoder.o _o/BcjRegister.o _o/BitlDecoder.o _o/BranchMisc.o _o/BranchRegister.o _o/ByteSwap.o _o/BZip2Crc.o _o/BZip2Decoder.o _o/BZip2Encoder.o _o/BZip2Register.o _o/CopyCoder.o _o/CopyRegister.o _o/Deflate64Register.o _o/DeflateDecoder.o _o/DeflateEncoder.o _o/DeflateRegister.o _o/DeltaFilter.o _o/ImplodeDecoder.o _o/LzfseDecoder.o _o/LzhDecoder.o _o/Lzma2Decoder.o _o/Lzma2Encoder.o _o/Lzma2Register.o _o/LzmaDecoder.o _o/LzmaEncoder.o _o/LzmaRegister.o _o/LzmsDecoder.o _o/LzOutWindow.o _o/LzxDecoder.o _o/PpmdDecoder.o _o/PpmdEncoder.o _o/PpmdRegister.o _o/PpmdZip.o _o/QuantumDecoder.o _o/ShrinkDecoder.o _o/XpressDecoder.o _o/XzDecoder.o _o/XzEncoder.o _o/ZlibDecoder.o _o/ZlibEncoder.o _o/ZDecoder.o _o/ZstdDecoder.o _o/ZstdEncoder.o _o/ZstdRegister.o _o/Lz4Decoder.o _o/Lz4Encoder.o _o/Lz4Register.o _o/BrotliDecoder.o _o/BrotliEncoder.o _o/BrotliRegister.o _o/LizardDecoder.o _o/LizardEncoder.o _o/LizardRegister.o _o/Lz5Decoder.o _o/Lz5Encoder.o _o/Lz5Register.o _o/FastLzma2Register.o _o/LzhamRegister.o  _o/Rar1Decoder.o _o/Rar2Decoder.o _o/Rar3Decoder.o _o/Rar3Vm.o _o/Rar5Decoder.o _o/RarCodecsRegister.o  _o/7zAes.o _o/7zAesRegister.o _o/HmacSha1.o _o/HmacSha256.o _o/MyAes.o _o/MyAesReg.o _o/Pbkdf2HmacSha1.o _o/RandGen.o _o/WzAes.o _o/ZipCrypto.o _o/ZipStrong.o  _o/Rar20Crypto.o _o/Rar5Aes.o _o/RarAes.o  _o/CreateCoder.o _o/CWrappers.o _o/InBuffer.o _o/InOutTempBuffer.o _o/FilterCoder.o _o/LimitedStreams.o _o/LockedStream.o _o/MethodId.o _o/MethodProps.o _o/OffsetStream.o _o/OutBuffer.o _o/ProgressUtils.o _o/PropId.o _o/StreamObjects.o _o/StreamUtils.o _o/UniqBlocks.o  _o/md2.o _o/md4.o _o/md5.o _o/sha512.o _o/blake3.o _o/Md2Reg.o _o/Md4Reg.o _o/Md5Reg.o _o/Sha384Reg.o _o/Sha512Reg.o _o/XXH32Reg.o _o/XXH64Reg.o _o/Blake3Reg.o   _o/MyWindows.o  _o/CommandLineParser.o _o/ListFileUtils.o _o/StdInStream.o _o/StdOutStream.o  _o/ErrorMsg.o _o/FileLink.o _o/SystemInfo.o  _o/FilePathAutoRename.o _o/FileStreams.o  _o/ArchiveCommandLine.o _o/ArchiveExtractCallback.o _o/ArchiveOpenCallback.o _o/Bench.o _o/DefaultName.o _o/EnumDirItems.o _o/Extract.o _o/ExtractingFilePath.o _o/HashCalc.o _o/LoadCodecs.o _o/OpenArchive.o _o/PropIDUtils.o _o/SetProperties.o _o/SortUtils.o _o/TempFiles.o _o/Update.o _o/UpdateAction.o _o/UpdateCallback.o _o/UpdatePair.o _o/UpdateProduce.o  _o/BenchCon.o _o/ConsoleClose.o _o/ExtractCallbackConsole.o _o/HashCon.o _o/List.o _o/Main.o _o/MainAr.o _o/OpenCallbackConsole.o _o/PercentPrinter.o _o/UpdateCallbackConsole.o _o/UserInputUtils.o    -lpthread -ldl -lzstd -llz4 -lbrotlienc -lbrotlidec -lbrotlicommon -llizard -llz5 -lfast-lzma2 -llzhamcomp -llzhamdecomp -llzhamdll -L./_o/lib/7z_addon_codec -Wl,-rpath='$ORIGIN'/../lib/7z_addon_codec