param(
    [string]$zipFileName
)

if (($zipFileName -eq "")) {
    Write-Host "请提供要发布的 zip 压缩包的名称"
    exit -1
}

$bagetServer="hw.aprite.cn"
Write-Host "------ 开始发布站点：$($bagetServer) ------"

if ($zipFileName -ne "") {
	scp .\publish\$zipFileName root@$($bagetServer):/aprite/apps/baget.aprite.cn/
	ssh root@$($bagetServer) "cd /aprite/apps/baget.aprite.cn/; ./deploybaget.sh $zipFileName"
}

Write-Host "------ 结束发布站点：$($bagetServer) ------"