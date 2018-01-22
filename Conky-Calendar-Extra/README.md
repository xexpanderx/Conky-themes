Conky

<b>HowTo:</b>

(1) Install the lm-sensors package.

(2) Run sudo sensors-detect and choose YES to all YES/no questions.

(3) At the end of sensors-detect, a list of modules that needs to be loaded will displayed. Type "yes" to have sensors-detect insert those modules into /etc/modules, or edit /etc/modules yourself. 

(4) In Ubuntu, run sudo service module-init-tools restart. This will read the changes you made to /etc/modules in step 3, and insert the new modules into the kernel.  Or, if using other distributions simply restart your computer.

(5) Set your number of physical cores in lua_widgets.lua  in USER CONFIGURATION section:
```
      number_of_physical_CPU_cores = YOUR_NUMBER_HERE
```
(6) Start conky with:
```
      conky -c start_conky
```

<b>Optionally:</b>

In file lua_widgets.lua you can enable/disable graphic card temperature or changing colors, transparency and position. See lua_widgets.lua in USER CONFIGURATION section.
