#!/bin/bash

## Download
wget https://pearlhash.xyz/downloads/pearl_miner_v6.tar.gz 

## Extract
tar -xvf pearl_miner_v6.tar.gz 

## Change
cd pearl_miner_v6 

## CHmod
chmod +x pearl-miner 

## Run
./pearl-miner --host 84.32.220.219:9000 --user prl1pt27f6j9282zf6gvwcx66q9pemkhyt55wzu5c0ff38x6nm4gsgd4q3wsr9k
