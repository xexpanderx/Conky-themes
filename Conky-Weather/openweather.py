#!/usr/bin/env python3
import pyowm
import argparse
import subprocess


def process(args):

    owm = pyowm.OWM(args.api_key[0])
    mgr = owm.weather_manager()
    weather_details = mgr.weather_at_place(args.city[0] + ',' + args.ccode[0])
    weather_values = weather_details.weather

    if args.get_temp_c:
        temp = weather_values.temperature(unit='celsius')['temp']
        temp = round(int(temp))
        print(temp)
    if args.get_temp_f:
        temp = weather_values.temperature(unit='fahrenheit')['temp']
        temp = round(int(temp))
        print(temp)
    if args.get_weather_icon:
        print(weather_values.weather_icon_name)


parser = argparse.ArgumentParser(description='Openweather script.')
parser.add_argument('--api_key',help='OWM API key.',nargs=1,metavar=('[api_key]'), required=True)
parser.add_argument('--city',help='Cityname.',nargs=1,metavar=('[city]'), required=True)
parser.add_argument('--ccode',help='Country code.',nargs=1,metavar=('[code]'), required=True)
parser.add_argument('--get_temp_c',help='Get temperature in Celsius.',action='store_true')
parser.add_argument('--get_temp_f',help='Get temperature in Fahrenheit.',action='store_true')
parser.add_argument('--get_weather_icon',help='Get weather icon.',action='store_true')
args = parser.parse_args()

process(args)
