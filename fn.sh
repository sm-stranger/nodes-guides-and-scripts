function enter_val(){
    vn=$2
    v=''
    until [ ${#v} -gt 0 ]
    do
        read -p "Enter Your $1: " vn
        v=$vn
    done
    echo 'export '$2'='$v >> $HOME/.bash_profile
    source $HOME/.bash_profile
}

function check_install(){
    s=$(dpkg -s $1 grep Status)
    if [ s !="Status: install ok installed" ]; then
        sudo apt install $1 -y
}
