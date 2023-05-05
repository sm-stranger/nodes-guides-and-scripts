sudo apt update && sudo apt upgrade -y
sudo apt install make clang pkg-config libssl-dev build-essential gcc xz-utils git curl vim tmux ntp jq llvm ufw -y
tmux new -s deploy

read -p "Enter Your Private Key: " PK
read -p "Enter Your View Key: " VK
read -p "Enter Your Address: " ADDRESS

cd $HOME
git clone https://github.com/AleoHQ/snarkOS.git --depth 1
cd snarkOS
bash ./build_ubuntu.sh
source $HOME/.bashrc
source $HOME/.cargo/env

cd $HOME
git clone https://github.com/AleoHQ/leo.git
cd leo
cargo install --path .

read -p "Enter the Name of your contract: " CONTRACT_NAME
