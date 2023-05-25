#!/bin/bash

function enter_val(){
    vn=$2
    v=''
    until [ ${#v} -gt 0 ]
    do
        read -p "Enter Your $1: " vn
        v=$vn
    done
    echo 'export '$2'='${v} >> $HOME/.bashrc
    source $HOME/.bashrc
}

function check_install(){
    s=$(dpkg -s $1 grep Status)
    if [ s !="Status: install ok installed" ]; then
        sudo apt install $1 -y
    fi
}
