
RPC="https://nibiru-testnet.nodejumper.io:443"
sed -i -e "s|^node *=.*|node = \"$RPC\"|" $HOME/.nibid/config/client.toml

systemctl restart nibid
