#!/bin/bash

if [ -d ./dist ]; then
  rm -rf ./dist
fi

if [[ ! -f $1 ]]; then
  echo "请指定要发布的 zip 文件"
  exit 1
fi

if [[ ! -d ./backup ]]; then
  mkdir backup
fi

echo "开始解压发布文件 --> $1"
unzip -q $1
echo "解压发布文件完成"

echo "开始停止站点 --> test-baget"
systemctl stop kestrel-baget-aprite-cn.service
echo "停止站点完成"

echo "开始备份站点..."
backup_filename="baget.aprite.cn-`date +%Y-%m-%d__%H-%M`"
tar -zcf ./backup/${backup_filename}.tar.gz --exclude=./app/Logs ./app
echo "站点备份完成"

echo "正在发布站点..."
\cp -rf ./dist/* ./app/
\cp -rf ./prod/* ./app/

echo "站点发布完成"

chmod +x ./app/BaGet

echo "开始启动站点 --> test-baget"
systemctl start kestrel-baget-aprite-cn.service
echo "启动站点成功"

echo "------发布完成------"
