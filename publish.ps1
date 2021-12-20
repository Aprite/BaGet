$publishBasePath="./publish"

#
# 发布前清空发布目录
#
if (Test-Path -Path "$($publishBasePath)/dist") {
    Remove-Item -Recurse "$($publishBasePath)/dist"
}

#
# 发布
#
$baGetProject="./src/BaGet/BaGet.csproj"
dotnet restore --force --runtime linux-x64 --force-evaluate $baGetProject
& dotnet build --no-incremental --no-restore --runtime linux-x64 --configuration Release $baGetProject
& dotnet publish --no-build --force --nologo --runtime linux-x64 --configuration Release --output "$($publishBasePath)/dist" $baGetProject

#
# 删除多余发布文件
#
$DeleteItems="appsettings.Development.json","appsettings.Staging.json","appsettings.Test.json",

    "startupdev.sh","startuptest.sh",

    "cs","de","es","fr","it","ja","ko","pl","pt-BR","ru","tr","zh-Hant"

foreach($deleteItem in $DeleteItems) {
    $deleteItemPath = "$($publishBasePath)/dist/$($deleteItem)"
    if ((Test-Path -Path $deleteItemPath) -and (Get-Item $deleteItemPath) -is [IO.FileInfo]) {
        Remove-Item -Path $deleteItemPath -Force
    } elseif ((Test-Path -Path $deleteItemPath) -and (Get-Item $deleteItemPath) -is [IO.DirectoryInfo]) {
        Remove-Item -Path $deleteItemPath -Force -Recurse
    } else {
        Write-Host "$($deleteItemPath) 文件或目录不存在!"
    }
}

#
# 创建 zip 压缩包
#
$zipFileName="baget-aprite-cn-$(Get-Date -Format 'yyyy_MM_dd__HH_mm_ss_fff').zip"
Compress-Archive -Path "$($publishBasePath)/dist" -DestinationPath "$($publishBasePath)/$($zipFileName)"
Write-Host "压缩文件名称: $($zipFileName)"
