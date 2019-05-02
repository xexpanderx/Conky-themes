
<b>Installation</b>
```
git clone https://github.com/xexpanderx/Conky-themes
cd Conky-themes/Conky-Weather/
sh install.sh
sudo pip3 install pyowm
```

<b>Configuration</b>

(1) API-key

Go to https://openweathermap.org/ and create an account to acquire an API-key.

(2) settings.lua

Edit "settings.lua" (~/.conky/Conky-Weather/settings.lua) and change the appropriate values for api_key, city, country_code and font sizes.

(3) Start it

```
 ~/.conky/Conky-Weather/start_weather.sh &
```

