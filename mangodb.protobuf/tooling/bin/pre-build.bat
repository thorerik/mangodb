powershell.exe -ExecutionPolicy Unrestricted -File tooling/bin/DownloadTooling.ps1
tooling\bin\protoc.exe --proto_path=proto --csharp_out=src query.proto