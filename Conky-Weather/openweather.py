#!/usr/bin/env python
import pyowm
import argparse
import subprocess

def process (args):

    owm = pyowm.OWM(args.api_key[0])
    weather_details = owm.weather_at_place(args.city[0] + ',' + args.ccode[0])
    weather_values = weather_details.get_weather()

    if args.get_temp_c:
        print weather_values.get_temperature(unit='celsius')['temp']
    if args.get_temp_f:
        print weather_values.get_temperature(unit='fahrenheit')['temp']
    if args.get_weather_icon:
        print 'PNG/'+weather_values.get_weather_icon_name()+'.png'


parser = argparse.ArgumentParser(description='Openweather script.')
parser.add_argument('--api_key',help='OWM API key.',nargs=1,metavar=('[api_key]'), required=True)
parser.add_argument('--city',help='Cityname.',nargs=1,metavar=('[city]'), required=True)
parser.add_argument('--ccode',help='Country code.',nargs=1,metavar=('[code]'), required=True)
parser.add_argument('--get_temp_c',help='Get temperature in Celsius.',action='store_true')
parser.add_argument('--get_temp_f',help='Get temperature in Fahrenheit.',action='store_true')
parser.add_argument('--get_weather_icon',help='Get weekday.',action='store_true')
args = parser.parse_args()

process(args)
