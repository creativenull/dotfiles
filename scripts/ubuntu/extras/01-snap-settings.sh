#!/usr/bin/env bash

echo '=> Configuring theme for snap packages'

sudo snap install bibata-all-cursor
for plug in $(snap connections | grep gtk-common-themes:icon-themes | awk '{print $2}'); do sudo snap connect ${plug} bibata-all-cursor:icon-themes; done
