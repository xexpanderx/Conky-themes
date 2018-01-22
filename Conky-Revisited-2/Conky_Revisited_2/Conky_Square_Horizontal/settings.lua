--[[
---------------- USER CONFIGURATION ----------------
Change the parameters below to fit your needs.
]]--

-- Colors

HTML_color_battery = "#FFFFFF"
HTML_color_drive_1 = "#FFFFFF"
HTML_color_drive_2 = "#FFFFFF"
HTML_background_CPU = "#FFFFFF"
HTML_color_RAM = "#FFFFFF"
HTML_color_BORDER = "#FFFFFF"
transparency_battery = 0.6
transparency_drive_1 = 0.6
transparency_drive_2 = 0.6
transparency_CPU = 0.6
transparency_RAM = 0.6
transparency_border = 0.1

--[[
Show battery:
	true
	false
]]--
battery = true

--[[
Battery number. Default=BAT0. Change this number if you get following errors:
conky: can't open /sys/class/power_supply/BAT0/uevent
conky: can't open /proc/acpi/battery/BAT0/state: No such file or directory

Try with number BAT1 or BAT2 e.t.c.
]]--
battery_number="BAT0"

--[[
Modes:
	1 = Show background area
	2 = No background area
]]--
mode = 1

-- Path of drives for free space status.
drive_paths = {"/home", "/"}

-- Names of drives for free space status.
drive_names = {"Home", "Root"}

-- Number of drives to show free space status. Adjust the conky "height"-parameter in config manually to adjust for the increase in Conky height when adding more drives.
drives = 2

-- Number of CPUs
number_of_cpus = 4

-- Special border width
special_border = 0

-- Normal border size
border_size = 4

-- Distance between each area.
gap_x_distance = 10





























--[[
-- DON'T EDIT BELOW IF YOU DO NOT KNOW WHAT YOU ARE DOING!!!
]]--


require 'cairo'

operator = {CAIRO_OPERATOR_SOURCE,
			CAIRO_OPERATOR_CLEAR
		   }
		   
operator_transpose = {CAIRO_OPERATOR_CLEAR,
			CAIRO_OPERATOR_SOURCE
		   }

function hex2rgb(hex)
	hex = hex:gsub("#","")
	return (tonumber("0x"..hex:sub(1,2))/255), (tonumber("0x"..hex:sub(3,4))/255), tonumber(("0x"..hex:sub(5,6))/255)
end


r_battery, g_battery, b_battery = hex2rgb(HTML_color_battery)
r_CPU, g_CPU, b_CPU = hex2rgb(HTML_background_CPU)
r_RAM, g_RAM, b_RAM = hex2rgb(HTML_color_RAM)

r_border, g_border, b_border = hex2rgb(HTML_color_BORDER)

r_drive_1, g_drive_1, b_drive_1 = hex2rgb(HTML_color_drive_1)
r_drive_2, g_drive_2, b_drive_2 = hex2rgb(HTML_color_drive_2)

drive_colors = {{r_drive_1, g_drive_1, b_drive_1,transparency_drive_1},
				{r_drive_2, g_drive_2, b_drive_2,transparency_drive_2}}


function draw_square(cr,pos_x,pos_y,rectangle_x,rectangle_y,color1,color2,color3, trans)
	cairo_set_operator(cr, operator[mode])
	cairo_set_source_rgba(cr, color1,color2,color3,trans)
	cairo_set_line_width(cr, 2)
	cairo_rectangle(cr, pos_x, pos_y, rectangle_x,rectangle_y)
	cairo_fill(cr)
  
	cairo_set_operator(cr, operator_transpose[mode])
	cairo_set_line_width(cr, special_border)
	cairo_set_source_rgba(cr, color1,color2,color3, trans)
	cairo_move_to(cr,pos_x+3,pos_y+3)  	
	cairo_rel_line_to(cr,rectangle_x-6,0)
	cairo_rel_line_to(cr,0, rectangle_y-6)
	cairo_rel_line_to(cr,-(rectangle_x-6))
	cairo_close_path(cr)
	cairo_stroke(cr)
	
	cairo_set_operator(cr, operator[mode])
	cairo_set_source_rgba(cr, r_border,g_border,b_border,transparency_border)
	cairo_set_line_width(cr, border_size) 
	cairo_rectangle(cr, pos_x, pos_y, rectangle_x,rectangle_y)
	cairo_stroke(cr)

end

function draw_battery(cr,pos_x, pos_y,start_rect_height,color1,color2,color3,trans, gap_y_text)
	
	cairo_set_operator(cr, operator_transpose[mode])
	cairo_set_source_rgba(cr, color1,color2,color3,trans)
	cairo_set_line_width(cr, 2)  
	set_battery_blocks_x = 0
	battery_gap_y = (start_rect_height/2)-27/2+pos_y

	cairo_move_to(cr,pos_x,battery_gap_y)
	
	cairo_rel_line_to(cr,64,0)
	cairo_rel_line_to(cr,0,((27-10)/2))
	cairo_rel_line_to(cr,5,0)
	cairo_rel_line_to(cr,0,10)
	cairo_rel_line_to(cr,-5,0)
	cairo_rel_line_to(cr,0,((27-10)/2))
    	cairo_rel_line_to(cr,-64,0)
	cairo_close_path(cr)
	cairo_fill(cr)
	
	number_of_charges = math.floor((12 / 100)*tonumber(conky_parse('${battery_percent ' .. battery_number .. '}')))
	cairo_set_operator(cr, operator[mode])
	for i=1,number_of_charges do
		cairo_rectangle(cr,pos_x+3+set_battery_blocks_x,3+battery_gap_y,3,21)
		cairo_fill(cr)
		set_battery_blocks_x = set_battery_blocks_x + 5
	end
	
	cairo_set_operator(cr, operator_transpose[mode])
	percent_font_size = 21
	cairo_set_font_size(cr,percent_font_size)
	cairo_move_to(cr,pos_x+69+10, gap_y_text+pos_y)
  
	percent = conky_parse('${battery_percent ' .. battery_number .. '}')
	--ct = cairo_text_extents_t:create()	
	--cairo_text_extents(cr,percent,ct)
  
	if string.len(percent) == 1 then
		cairo_show_text(cr,"0" .. percent .. "%")
	elseif string.len(percent) == 3 then
		cairo_show_text(cr,"100%")
	else
		cairo_show_text(cr,percent .. "%")
	end

	cairo_move_to(cr,pos_x+69+10, gap_y_text+18+pos_y)
  	
	cairo_set_font_size(cr,12)
	status = conky_parse('${battery ' .. battery_number .. '}')
	if string.find(status, "discharging") then
		status = "Discharging"
	elseif string.find(status, "charging") then
		status = "Charging"
	elseif string.find(status, "charged") then
		status = "Charged"		
	end
	
	if status == "" then
		status = "N/A"
	end
	cairo_show_text(cr, status)
	cairo_move_to(cr,pos_x+69+10, gap_y_text+18+14+pos_y)
	battery_time = conky_parse('${battery_time ' .. battery_number .. '}')
	
	if battery_time == "" then
		battery_time = "N/A"
	end
	
	cairo_show_text(cr, battery_time)
end

function draw_folder(cr,x_pos,y_pos,start_rect_height,hdd,folder_name,r_color_drive,g_color_drive,b_color_drive,transparency_drive, gap_y_text)
-- Draw indicator
	cairo_set_source_rgba(cr,r_color_drive,g_color_drive,b_color_drive,transparency_drive)
	cairo_set_operator(cr, operator_transpose[mode])
	
	local distance_between_arcs = 0
	local number_of_arcs = 20
	local arcs_length = (360 - (number_of_arcs*distance_between_arcs)) / number_of_arcs
	local start_angel = 270
	local used_blocks = math.floor((number_of_arcs / 100) * tonumber(conky_parse('${fs_free_perc ' .. hdd .. '}')))
	local radius_outer = 34
	local radius_inner = 24
	local radius = 29
	cairo_set_line_width(cr, 2)
	
--	cairo_arc(cr,x_pos+10+34,(start_rect_height/2)+y_pos,radius_outer,start_angel*math.pi/180,(start_angel+360)*math.pi/180)
--	cairo_stroke(cr)
			
--	cairo_arc(cr,x_pos+10+34,(start_rect_height/2)+y_pos,radius_inner,start_angel*math.pi/180,(start_angel+360)*math.pi/180)
--	cairo_stroke(cr)

	cairo_set_line_width(cr, 6)
	cairo_arc(cr,x_pos+10+34,(start_rect_height/2)+y_pos,radius,start_angel*math.pi/180,(start_angel+360)*math.pi/180)
	cairo_stroke(cr)
	
	cairo_set_line_width(cr, 3)
	cairo_set_operator(cr, operator[mode])
	for i=1, used_blocks do
		cairo_arc(cr, x_pos+10+34,(start_rect_height/2)+y_pos,radius,start_angel*math.pi/180,(start_angel+arcs_length)*math.pi/180)
		cairo_stroke(cr)
		start_angel = start_angel+arcs_length+distance_between_arcs
	end
	
	cairo_set_operator(cr, operator_transpose[mode])
  
	cairo_set_source_rgba(cr,r_color_drive,g_color_drive,b_color_drive,transparency_drive)
	cairo_set_line_width(cr, 2)
	
	cairo_move_to(cr,x_pos+10+34-15,(start_rect_height/2-5.5)+y_pos)
	cairo_rel_line_to(cr,15,-9)
	cairo_rel_line_to(cr,15,9)
	cairo_rel_line_to(cr,0,4)
	cairo_rel_line_to(cr,-15,-9)
	cairo_rel_line_to(cr,-15,9)
	cairo_close_path(cr)
	cairo_fill(cr)
	
	cairo_move_to(cr,x_pos+10+34-15+24,(start_rect_height/2-5.5)-6+y_pos)
    cairo_rel_line_to(cr,4,2)
	cairo_rel_line_to(cr,0,-5)
	cairo_rel_line_to(cr,-4,0)
	cairo_close_path(cr)
	cairo_fill(cr)
	
	cairo_move_to(cr,x_pos+10+34-15+4,(start_rect_height/2-5.5)+5+y_pos)
	cairo_rel_line_to(cr,11,-7)
	cairo_rel_line_to(cr,11,7)
	cairo_rel_line_to(cr,0,15)
	cairo_rel_line_to(cr,-(11*2-math.abs(-8))/2,0)
	cairo_rel_line_to(cr,0,-6)
	cairo_rel_line_to(cr,-8,0)
	cairo_rel_line_to(cr,0,6)
	cairo_rel_line_to(cr,-(11*2-math.abs(-8))/2,0)
	cairo_close_path(cr)
	cairo_fill(cr)

	cairo_set_operator(cr, operator_transpose[mode])	
	str = folder_name .. ": " .. conky_parse('${fs_free_perc ' .. hdd .. '}') .. "%"
	cairo_set_font_size(cr, 21)
	cairo_move_to(cr,x_pos+10+34+34+10,gap_y_text+y_pos)
	cairo_show_text(cr, conky_parse('${fs_free_perc ' .. hdd .. '}') .. "%")
	
	cairo_set_font_size(cr,12)
	
	cairo_move_to(cr, x_pos+10+34+34+10,gap_y_text+18+y_pos)
	cairo_show_text(cr,folder_name)
	cairo_move_to(cr, x_pos+10+34+34+10,gap_y_text+18+14+y_pos)
	cairo_show_text(cr,conky_parse('${fs_free ' .. hdd .. '}') .. "/" .. conky_parse('${fs_size ' .. hdd .. '}'))
end

function draw_cpu(cr,number_of_cpus,x_pos,y_pos,r,g,b,transparency, gap_y_text)
	cairo_set_operator(cr, operator_transpose[mode])
	cairo_set_source_rgba(cr,r,g,b,transparency)

	multipler = 68/100	

	for i=1,number_of_cpus do
		cairo_rectangle(cr,x_pos+((68-(5*(number_of_cpus-1)))/number_of_cpus+5)*(i-1),y_pos+68,(68-(5*(number_of_cpus-1)))/number_of_cpus,-multipler*tonumber(conky_parse('${cpu cpu' .. tostring(i) .. '}')))
		cairo_fill(cr)
	end
	
	cairo_set_font_size(cr, 21)
	cairo_move_to(cr,x_pos+68+10,gap_y_text+y_pos-10)
	cairo_show_text(cr, conky_parse('${cpu cpu0}' .. "%"))
	
	cairo_set_font_size(cr,12)
	cairo_move_to(cr, x_pos+68+10,gap_y_text+18+y_pos-10)
	cairo_show_text(cr,"CPU")
	
	cairo_set_font_size(cr,12)
	cairo_move_to(cr, x_pos+68+10,gap_y_text+18+14+y_pos-10)
	cairo_show_text(cr,"Total usage")
	
	
	
end

function draw_ram(cr,x_pos,y_pos, radius, r, g, b, transparency, gap_y_text)
	cairo_set_operator(cr, operator_transpose[mode])
	cairo_set_source_rgba(cr,r, g, b, transparency)

	cairo_set_line_width(cr, 2)
	local align_middle = 14 -- 50 pixel height
	
	cairo_arc(cr,x_pos+radius,y_pos+radius+align_middle,radius,180*math.pi/180,(180+90)*math.pi/180)
	cairo_arc(cr,x_pos+radius+(68-2*radius),y_pos+radius+align_middle,radius,-90*math.pi/180,(0)*math.pi/180)
	cairo_arc(cr,x_pos+radius+(68-2*radius),y_pos+radius+20+align_middle,radius,0*math.pi/180,(90)*math.pi/180)
	cairo_arc(cr,x_pos+radius,y_pos+radius+20+align_middle,radius,90*math.pi/180,(180)*math.pi/180)

	cairo_close_path(cr)
	cairo_fill(cr)
	
	local multipler = 7/100
	local free_memory = math.floor((100-tonumber(conky_parse('${memperc}')))*multipler) 
	
	for i=1, 7 do
		cairo_move_to(cr,x_pos+radius+(8*(i-1))-2,y_pos+radius+20+align_middle+10+1+2+1)
		cairo_rel_line_to(cr,4,0)
		cairo_arc(cr,x_pos+radius+(8*(i-1)),y_pos+radius+20+align_middle+10+1+2+1+4,2,0*math.pi/180,(180)*math.pi/180)
		cairo_close_path(cr)
		
		if i <= free_memory then
			cairo_stroke_preserve(cr)
			cairo_fill(cr)
		else
			cairo_stroke(cr)
		end
		
		cairo_move_to(cr,x_pos+radius+(8*(i-1))+2,y_pos+align_middle-4)
		cairo_rel_line_to(cr,-4,0)
		cairo_arc(cr,x_pos+radius+(8*(i-1)),y_pos+align_middle-4-4,2,180*math.pi/180,(0)*math.pi/180)
		cairo_close_path(cr)
		
		if i <= free_memory then
			cairo_stroke_preserve(cr)
			cairo_fill(cr)
		else
			cairo_stroke(cr)
		end
		
	end
	
	cairo_set_operator(cr, operator[mode])
	cairo_set_font_size(cr, 21)
	cairo_move_to(cr,x_pos-1+33-22,y_pos+align_middle+1+19+8)
	cairo_show_text(cr, "RAM")
	
	cairo_set_operator(cr, operator_transpose[mode])
	cairo_set_font_size(cr, 21)
	cairo_move_to(cr,x_pos+68+10,gap_y_text+y_pos-10)
	cairo_show_text(cr, tostring(100-tonumber(conky_parse('${memperc}'))) .. "%")
	
	cairo_set_font_size(cr,12)
	cairo_move_to(cr, x_pos+68+10,gap_y_text+18+y_pos-10)
	cairo_show_text(cr,"Free RAM")
	
	cairo_set_font_size(cr,12)
	cairo_move_to(cr, x_pos+68+10,gap_y_text+18+14+y_pos-10)
	cairo_show_text(cr,conky_parse('${memeasyfree}') .. '/' .. conky_parse('${memmax}'))

end

function draw_function(cr)
	local w,h=conky_window.width,conky_window.height	
	cairo_select_font_face (cr, "Dejavu Sans Book", CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL);

   	local start_rect_height = 88
    -- Start with 172
    	local start_rect_width = 200
    	local gap_y_text = (start_rect_height/2)-7
    	local gap_x = 10
	local gap_y = 10
	local gap_x_fix = 2
   	local gap_y_fix = 2
	local start_rect_width_no_battery = 106
	local radius = 10
    
	if battery then
 
		draw_square(cr,gap_x_fix,gap_y_fix, start_rect_width, start_rect_height,r_battery, g_battery, b_battery, transparency_battery)
		draw_battery(cr,gap_x+gap_x_fix, gap_y_fix,start_rect_height,r_battery, g_battery, b_battery, transparency_battery, gap_y_text)
		
		for i=1,drives do
			draw_square(cr,(start_rect_width+gap_x_distance)*i+gap_x_fix,gap_y_fix, start_rect_width, start_rect_height,drive_colors[i][1], drive_colors[i][2], drive_colors[i][3], drive_colors[i][4])
			draw_folder(cr,(start_rect_width+gap_x_distance)*i+gap_x_fix,gap_y_fix,start_rect_height,drive_paths[i],drive_names[i],drive_colors[i][1], drive_colors[i][2], drive_colors[i][3], drive_colors[i][4],gap_y_text)
		end

		draw_square(cr,(start_rect_width+gap_x_distance)*(drives+1)+gap_x_fix,gap_y_fix, start_rect_width, start_rect_height,r_CPU, g_CPU, b_CPU, transparency_CPU)
		draw_cpu(cr,number_of_cpus, (start_rect_width+gap_x_distance)*(drives+1)+gap_x+gap_x_fix,gap_y_fix+gap_y,r_CPU, g_CPU, b_CPU, transparency_CPU,gap_y_text)

		draw_square(cr,(start_rect_width+gap_x_distance)*(drives+2)+gap_x_fix,gap_y_fix, start_rect_width, start_rect_height,r_RAM, g_RAM, b_RAM, transparency_RAM)
		draw_ram(cr,(start_rect_width+gap_x_distance)*(drives+2)+gap_x+gap_x_fix,gap_y+gap_y_fix, radius, r_RAM, g_RAM, b_RAM, transparency_RAM,gap_y_text)

	else
	
		for i=1,drives do
			draw_square(cr,(start_rect_width_no_battery)+gap_x_fix,gap_y_fix, start_rect_width, start_rect_height,drive_colors[i][1], drive_colors[i][2], drive_colors[i][3], drive_colors[i][4])
			draw_folder(cr,(start_rect_width_no_battery)+gap_x_fix,gap_y_fix,start_rect_height,drive_paths[i],drive_names[i],drive_colors[i][1], drive_colors[i][2], drive_colors[i][3], drive_colors[i][4],gap_y_text)
			start_rect_width_no_battery = start_rect_width_no_battery + gap_x_distance + 200
		end

		draw_square(cr,(start_rect_width_no_battery)+gap_x_fix,gap_y_fix, start_rect_width, start_rect_height,r_CPU, g_CPU, b_CPU, transparency_CPU)
		draw_cpu(cr,number_of_cpus,(start_rect_width_no_battery)+gap_x+gap_x_fix,gap_y_fix+gap_y,r_CPU, g_CPU, b_CPU, transparency_CPU,gap_y_text)
		start_rect_width_no_battery = start_rect_width_no_battery + gap_x_distance + 200

		draw_square(cr,(start_rect_width_no_battery)+gap_x_fix,gap_y_fix, start_rect_width, start_rect_height,r_RAM, g_RAM, b_RAM, transparency_RAM)
		draw_ram(cr,(start_rect_width_no_battery)+gap_x+gap_x_fix,gap_y+gap_y_fix, radius, r_RAM, g_RAM, b_RAM, transparency_RAM,gap_y_text)		
		
	end	
end

function conky_start_widgets()
	local function draw_conky_function(cr)
		local str=''
		local value=0		
		draw_function(cr)
	end
	
	-- Check that Conky has been running for at least 5s

	if conky_window==nil then return end
	local cs=cairo_xlib_surface_create(conky_window.display,conky_window.drawable,conky_window.visual, conky_window.width,conky_window.height)
	
	local cr=cairo_create(cs)	
	
	local updates=conky_parse('${updates}')
	update_num=tonumber(updates)
	
	if update_num>5 then
		draw_conky_function(cr)
	end
	cairo_surface_destroy(cs)
	cairo_destroy(cr)
end
