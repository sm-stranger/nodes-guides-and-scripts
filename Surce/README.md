#### Если у вас уже есть установленная нода Source - нужно удалить ее. Для этого выполним
```
sudo systemctl stop sourced && \
cd $HOME && \
rm -rf .source && \
rm -rf source && \
rm -rf $(which sourced)
```

