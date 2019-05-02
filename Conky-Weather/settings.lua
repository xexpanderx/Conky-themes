
-- ###Openweather settings###
api_key = "YOUR-API-KEY"
city = "YOUR-CITY-NAME"
country_code = "YOUR-COUNTRY-CODE"
-- ###Colors###
HTML_circle = "#232323"
HTML_border = "#000000"
HTML_text = "#FFFFFF"
transparency = 1.0
transparency_border = 0.2
transparency_text = 0.5
transparency_weather_icon = 1.0
-- ###Font sizes###
City_font = 9
Temperature_font = 24
Day_font = 12
-- ###Dont change code below###
require 'cairo'

function hex2rgb(hex)
	hex = hex:gsub("#","")
	return (tonumber("0x"..hex:sub(1,2))/255), (tonumber("0x"..hex:sub(3,4))/255), tonumber(("0x"..hex:sub(5,6))/255)
end

r_circle, g_circle, b_circle = hex2rgb(HTML_circle)
r_border, g_border, b_border = hex2rgb(HTML_border)
r_text, g_text, b_text = hex2rgb(HTML_text)

function fix_text(text)
	if string.len(text) == 1 then
		new_text = "0" .. text .. "%"
		return new_text
	else
		new_text = text .. "%"
		return new_text
	end
end

function draw_circle(cr, pos_x, pos_y, radius, r_border, g_border, b_border, trans)
	cairo_set_source_rgba(cr, r_border,g_border,b_border,trans)
	cairo_set_line_width(cr, 1)
	cairo_arc(cr,pos_x,pos_y,radius,0*math.pi/180,360*math.pi/180)
	cairo_fill(cr)
end

function draw_border(cr, pos_x, pos_y, radius, r_border, g_border, b_border, trans)
	cairo_set_operator(cr, CAIRO_OPERATOR_SOURCE)
	cairo_set_source_rgba(cr, r_border,g_border,b_border,trans)
	cairo_set_line_width(cr, 2)
	cairo_arc(cr,pos_x,pos_y,radius,0*math.pi/180,360*math.pi/180)
	cairo_stroke(cr)
end

function draw_weather_icon(cr, pos_x, pos_y, image_path, trans)
	cairo_set_operator(cr, CAIRO_OPERATOR_OVER)
	local image = cairo_image_surface_create_from_png (image_path)
	local w_img = cairo_image_surface_get_width (image)
	local h_img = cairo_image_surface_get_height (image)

	cairo_save(cr)
	cairo_set_source_surface (cr, image, pos_x-w_img/2, pos_y-h_img/2)
	cairo_paint_with_alpha (cr, trans)
	cairo_surface_destroy (image)
	cairo_restore(cr)
end

function draw_text(cr, pos_x, pos_y, r_text, g_text, b_text, trans, text, font_size, shift_x, shift_y)
	cairo_set_operator(cr, CAIRO_OPERATOR_SOURCE)
	cairo_set_source_rgba(cr, r_text, g_text, b_text, trans)
	ct = cairo_text_extents_t:create()
	cairo_set_font_size(cr, font_size)
	cairo_text_extents(cr,text,ct)
	cairo_move_to(cr,pos_x-ct.width/2+shift_x,pos_y+ct.height/2+shift_y)
	cairo_show_text(cr,text)
	cairo_close_path(cr)
end

function draw_function(cr)
	local w,h=conky_window.width,conky_window.height

  --Draw backgrounds
	local radius = 60
	local pos_x = w-70
	local pos_y = 70
 	draw_circle(cr, pos_x, pos_y, radius, r_circle, g_circle, b_circle, transparency)
  draw_border(cr, pos_x, pos_y, radius+1, r_border, g_border, b_border, transparency_border)

  --Draw weathor icon
	image_path = conky_parse("${exec ./openweather.py --get_weather_icon --api_key " .. api_key .. " --city " .. "\"" .. city .. "\"" .. " --ccode " .. country_code .. "}")
	draw_weather_icon(cr, pos_x-60, pos_y, image_path, transparency_weather_icon)

	--Draw text
	---Temperature
	cairo_select_font_face (cr, "Dejavu Sans Book", CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_BOLD)
	temperature = conky_parse("${exec ./openweather.py --get_temp_c --api_key " .. api_key .. " --city " .. "\"" .. city .. "\"" .. " --ccode " .. country_code .. "}")
	temperature = tostring(tonumber(string.format("%.0f", temperature)))
  draw_text(cr, pos_x, pos_y, r_text, g_text, b_text, transparency_text, temperature .. "˚C", Temperature_font, 19.25, 0)
  ----City
	cairo_select_font_face (cr, "Dejavu Sans Book", CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL)
  draw_text(cr, pos_x, pos_y, r_text, g_text, b_text, transparency_text, city, City_font, 0, -35)
  ----Day
  day = conky_parse('${exec date +%A}')
	cairo_select_font_face (cr, "Dejavu Sans Book", CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL)
  draw_text(cr, pos_x, pos_y, r_text, g_text, b_text, transparency_text, day, Day_font, 0, 35)

end

function conky_start_widgets()

	local function draw_conky_function(cr)
		draw_function(cr)
	end

	if conky_window==nil then return end
	local cs=cairo_xlib_surface_create(conky_window.display,conky_window.drawable,conky_window.visual, conky_window.width,conky_window.height)

	local cr=cairo_create(cs)

	local updates=conky_parse('${updates}')
	update_num=tonumber(updates)

	-- Check that Conky has been running for at least 5s

	if update_num>5 then
		draw_conky_function(cr)
	end
	cairo_surface_destroy(cs)
	cairo_destroy(cr)
end
