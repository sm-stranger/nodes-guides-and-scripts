#!/bin/bash

NAME=''
l=${#NAME}
until [ $l > 10 ]
do
    read -p "Enter the Name of your contract: " NAME
done

echo ${#NAME}
