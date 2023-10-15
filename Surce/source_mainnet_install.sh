# delete old node
sudo systemctl stop sourced && \
cd $HOME && \
rm -rf .source && \
rm -rf source && \
rm -rf $(which sourced)

