#!/bin/bash

function enter_val(){
    v=''
    until [ ${#v} -gt 0 ]
    do
        read -p "Enter Your $1: " v
    done
    eval ${2}=$v

}

function check_install(){
    s=$(dpkg -s $1 grep Status)
    if [ s !="Status: install ok installed" ]; then
        sudo apt install $1 -y
    fi
}
