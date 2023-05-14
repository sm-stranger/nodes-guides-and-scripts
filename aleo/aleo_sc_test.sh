#!/bin/bash

NAME=''
until [ ${#NAME} > 10 ]
do
    read -p "Enter the Name of your contract: " NAME
done
