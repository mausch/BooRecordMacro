@echo off
lib\booc.exe RecordMacros\RecordMacro.boo -r:lib/fsharpx.core.dll  -o:RecordMacros\bin\Debug\RecordMacros.dll
lib\booc.exe Example\LensExtensions.boo Example\Program.boo -r:lib/fsharpx.core.dll -r:lib/FSharp.PowerPack.dll -r:RecordMacros\bin\Debug\RecordMacros.dll -o:Example\bin\debug\Example.exe
copy lib\Boo.lang.dll Example\bin\debug\
copy lib\FSharpx.Core.dll Example\bin\debug\
copy lib\FSharp.Powerpack.dll Example\bin\debug\
copy RecordMacros\bin\Debug\RecordMacros.dll Example\bin\debug\
msbuild csharpExample\CSharpExample.csproj
msbuild FSharpExample\FSharpExample.fsproj