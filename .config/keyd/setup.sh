#!/bin/sh

sudo mv /etc/keyd/default.conf /etc/keyd/default.conf.bak
sudo ln -s ~/.config/keyd/config /etc/keyd/default.conf
sudo systemctl restart keyd.service
