$downloadUrl = "https://github.com/protocolbuffers/protobuf/releases/download/v3.13.0/protoc-3.13.0-win64.zip"
$checksum = "dfa40e6997c6ed0280e3368afa53024309152c7a14fca93f64f1d8f1257331b282935d3dd7c94c4239abbe3707eccb1c881879584dcf5d46cbbced6b4219c01d"
$temp = $PSScriptRoot + "\..\..\tmp\"
$tempFile = $temp + "\protoc.zip"
$sourceFile = $temp + "\bin\protoc.exe"
$destinationFile = $PSScriptRoot + "\protoc.exe"
$exitStatus = 0

if (!$(Get-ChildItem -Path $destinationFile -ErrorAction Ignore)) {
    Write-Host "Protoc missing, fetching"
    Invoke-WebRequest -Uri $downloadUrl -OutFile $tempFile
    $checksumDownloaded = Get-FileHash -Path $tempFile -Algorithm "sha512"
    if ($checksum.Normalize() -eq $checksumDownloaded.Hash.Normalize()) {
        Expand-Archive -path $tempFile -DestinationPath $temp
        Move-Item -Path $sourceFile -Destination $destinationFile -Force 
    } else {
        Write-Error "Checksum mismatch, Aborting!"
        Write-Error $("Checksum expected:   " + $checksum.Normalize())
        Write-Error $("Checksum calculated: " + $checksumDownloaded.Hash.Normalize())
        $exitStatus = 1
    }
    Get-ChildItem -Path $temp -Recurse -Exclude '.gitkeep' | Remove-Item -Force -Recurse
} else {
    Write-Host "Protoc present, doing nothing"
}
exit $exitStatus