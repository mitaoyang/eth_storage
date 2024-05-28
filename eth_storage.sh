#!/bin/bash

function Deploy_Application(){

# 安装nodejs
if !command -v node &> /dev/null
then 
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt-get install -y nodejs
    echo "This script help u to participant ETH_storage testnet 2"
else
    echo "node已安装"
fi

# 克隆仓库
git clone https://github.com/ethstorage/ethfs-cli.git
cd ethfs-cli

# 安装依赖
npm i -g ethfs-cli

mkdir dist
cd dist
wget -O degen.jpeg https://pbs.twimg.com/media/GN7uhY6a0AE3lLf?format=jpg&name=small
rm -rf 'GN7uhY6a0AE3lLf?format=jpg'

# 使用EOF标记符将多行内容写入文件
cat <<EOF > app.html
<html>
    <head>
        <script> 
            async function fetchData() { 
                // web3 URL is define in https://eips.ethereum.org/EIPS/eip-4804, please find more detail on https://web3url.io
                const url = 'web3://0xf14e64285Db115D3711cC5320B37264708A47f89:11155111/greeting'; 
                const response = await fetch(url); 
                const data = await response.text(); 
                document.getElementById('content').textContent = data; 
            } 
            window.onload = fetchData; 
        </script>
    </head>
    <body>
        <div id="content"> Loading greeting... </div>
        <br>
        <img src="./degen.jpeg" alt="">    
    </body>    
</html>
EOF

sleep 3

# 发送合约
read -p "请输入发送合约的私钥地址(不带0x:" private_key
cd ..
address=$(ethfs-cli create -p $private_key -c 11155111 | grep -oP 'FlatDirectory Address: \K\S+')
echo "$address"

# 发送Dapp
ethfs-cli upload -f dist -a $address -c 11155111 -p $private_key -t $1

echo "你的Dapp地址:"
echo "https://$address.sep.w3link.io/app.html"

echo "你的Dapp地址 Bob:"
echo "https://$address.3333.w3link.io/app.html"

}

function main(){  
    clear
    echo "脚本由twitter蜜桃羊的冒险@0xamiao34034编写"
    echo "请选择要执行的操作: "
    echo "1. 部署应用程序"
    echo "2. 使用 EthStorage 永久存储 BLOB"
    read -p "请输入选项（1-2）: " OPTION

    case $OPTION in
    1) Deploy_Application 1;;
    2) Deploy_Application 2;;
    *) echo "无效选项。" ;;
    esac
}

main
