#!/bin/bash -l

mkdir -p ~/.conky/Conky-Weather/
cp -r PNG ~/.conky/Conky-Weather/
cp conky_config ~/.conky/Conky-Weather/
cp openweather.py ~/.conky/Conky-Weather/
cp settings.lua ~/.conky/Conky-Weather/
cp start_weather.sh ~/.conky/Conky-Weather/
chmod +x ~/.conky/Conky-Weather/start_weather.sh
chmod +x ~/.conky/Conky-Weather/openweather.py
