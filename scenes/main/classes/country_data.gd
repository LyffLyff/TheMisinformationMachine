extends Node

signal progression_updated
signal character_unlocked
signal country_converted
signal update_calculations

const SKILL_POINT_UNLOCKS := [
	100,
	1000,
	2000,
	5000,
	10000,
	100000,
	10000000,
	20000000,
	50000000,
	20000000
]

var TOTAL_POPULATION: int = 0

var current_skill_lvl: int = 0

var COUNTRY_DETAILS: Dictionary = {
	"denmark": {
		"population": 5831404,
		"median_age": 42.0,
		"size": 43094.0,
		"corruption": 0.90,
		"gdp_billions_usd": 395.7
	} ,
	"sao_tome_and_principe": {
		"population": 235536,
		"median_age": 19.0,
		"size": 960.0,
		"corruption": 0.45,
		"gdp_billions_usd": 0.75
	} ,
	"somalia": {
		"population": 17635975,
		"median_age": 17.8,
		"size": 637657.0,
		"corruption": 0.08,
		"gdp_billions_usd": 7.8
	} ,
	"japan": {
		"population": 125800000,
		"median_age": 48.6,
		"size": 377975.0,
		"corruption": 0.74,
		"gdp_billions_usd": 4231.1
	} ,
	"brazil": {
		"population": 215000000,
		"median_age": 33.5,
		"size": 8515767.0,
		"corruption": 0.38,
		"gdp_billions_usd": 2331.4
	} ,
	"albania": {
		"population": 2877797,
		"median_age": 38.0,
		"size": 28748.0,
		"corruption": 0.43,
		"gdp_billions_usd": 18.3
	} ,
	"andorra": {
		"population": 77265,
		"median_age": 45.0,
		"size": 468.0,
		"corruption": 0.88,
		"gdp_billions_usd": 3.3
	} ,
	"armenia": {
		"population": 2963243,
		"median_age": 36.0,
		"size": 29743.0,
		"corruption": 0.47,
		"gdp_billions_usd": 19.5
	} ,
	"austria": {
		"population": 9006398,
		"median_age": 44.0,
		"size": 83879.0,
		"corruption": 0.83,
		"gdp_billions_usd": 479.8
	} ,
	"azerbaijan": {
		"population": 10239177,
		"median_age": 32.0,
		"size": 86600.0,
		"corruption": 0.35,
		"gdp_billions_usd": 78.7
	} ,
	"belarus": {
		"population": 9449323,
		"median_age": 40.0,
		"size": 207600.0,
		"corruption": 0.42,
		"gdp_billions_usd": 68.2
	} ,
	"belgium": {
		"population": 11589623,
		"median_age": 42.0,
		"size": 30528.0,
		"corruption": 0.77,
		"gdp_billions_usd": 594.1
	} ,
	"bosnia_and_herzegovina": {
		"population": 3280819,
		"median_age": 42.0,
		"size": 51209.0,
		"corruption": 0.43,
		"gdp_billions_usd": 25.0
	} ,
	"bulgaria": {
		"population": 6951482,
		"median_age": 44.0,
		"size": 110879.0,
		"corruption": 0.45,
		"gdp_billions_usd": 89.3
	} ,
	"croatia": {
		"population": 4095267,
		"median_age": 43.0,
		"size": 56594.0,
		"corruption": 0.60,
		"gdp_billions_usd": 70.9
	} ,
	"cyprus": {
		"population": 1207359,
		"median_age": 38.0,
		"size": 9251.0,
		"corruption": 0.70,
		"gdp_billions_usd": 28.4
	} ,
	"czechia": {
		"population": 10708981,
		"median_age": 42.0,
		"size": 78865.0,
		"corruption": 0.70,
		"gdp_billions_usd": 330.8
	} ,
	"france": {
		"population": 67391582,
		"median_age": 42.0,
		"size": 551695.0,
		"corruption": 0.69,
		"gdp_billions_usd": 2937.5
	} ,
	"georgia": {
		"population": 3989167,
		"median_age": 38.0,
		"size": 69700.0,
		"corruption": 0.42,
		"gdp_billions_usd": 30.6
	} ,
	"germany": {
		"population": 84000000,
		"median_age": 45.0,
		"size": 357022.0,
		"corruption": 0.80,
		"gdp_billions_usd": 4260.5
	} ,
	"greece": {
		"population": 10423054,
		"median_age": 45.0,
		"size": 131957.0,
		"corruption": 0.60,
		"gdp_billions_usd": 238.0
	} ,
	"hungary": {
		"population": 9660351,
		"median_age": 43.0,
		"size": 93030.0,
		"corruption": 0.60,
		"gdp_billions_usd": 196.8
	} ,
	"iceland": {
		"population": 376248,
		"median_age": 36.0,
		"size": 103000.0,
		"corruption": 0.90,
		"gdp_billions_usd": 28.6
	} ,
	"ireland": {
		"population": 5360000,
		"median_age": 38.0,
		"size": 70273.0,
		"corruption": 0.80,
		"gdp_billions_usd": 499.0
	} ,
	"italy": {
		"population": 60262770,
		"median_age": 47.0,
		"size": 301340.0,
		"corruption": 0.60,
		"gdp_billions_usd": 2107.7
	} ,
	"kosovo": {
		"population": 1831000,
		"median_age": 30.0,
		"size": 10887.0,
		"corruption": 0.40,
		"gdp_billions_usd": 9.7
	} ,
	"latvia": {
		"population": 1886198,
		"median_age": 43.0,
		"size": 64559.0,
		"corruption": 0.70,
		"gdp_billions_usd": 43.0
	} ,
	"liechtenstein": {
		"population": 38128,
		"median_age": 44.0,
		"size": 160.0,
		"corruption": 0.90,
		"gdp_billions_usd": 6.8
	} ,
	"lithuania": {
		"population": 2722289,
		"median_age": 45.0,
		"size": 65300.0,
		"corruption": 0.70,
		"gdp_billions_usd": 75.4
	} ,
	"luxembourg": {
		"population": 645397,
		"median_age": 39.0,
		"size": 2586.0,
		"corruption": 0.80,
		"gdp_billions_usd": 86.7
	} ,
	"malta": {
		"population": 514000,
		"median_age": 42.0,
		"size": 316.0,
		"corruption": 0.80,
		"gdp_billions_usd": 18.9
	} ,
	"moldova": {
		"population": 2657637,
		"median_age": 39.0,
		"size": 33846.0,
		"corruption": 0.42,
		"gdp_billions_usd": 14.5
	} ,
	"monaco": {
		"population": 39242,
		"median_age": 52.0,
		"size": 2.0,
		"corruption": 0.90,
		"gdp_billions_usd": 8.1
	} ,
	"montenegro": {
		"population": 622359,
		"median_age": 40.0,
		"size": 13812.0,
		"corruption": 0.50,
		"gdp_billions_usd": 6.2
	} ,
	"netherlands": {
		"population": 17441139,
		"median_age": 42.0,
		"size": 41850.0,
		"corruption": 0.80,
		"gdp_billions_usd": 1012.8
	} ,
	"north_macedonia": {
		"population": 2083459,
		"median_age": 38.0,
		"size": 25713.0,
		"corruption": 0.40,
		"gdp_billions_usd": 14.2
	} ,
	"norway": {
		"population": 5421241,
		"median_age": 39.0,
		"size": 148729.0,
		"corruption": 0.90,
		"gdp_billions_usd": 485.5
	} ,
	"poland": {
		"population": 38386000,
		"median_age": 42.0,
		"size": 312696.0,
		"corruption": 0.70,
		"gdp_billions_usd": 811.8
	} ,
	"portugal": {
		"population": 10329506,
		"median_age": 45.0,
		"size": 92212.0,
		"corruption": 0.80,
		"gdp_billions_usd": 253.7
	} ,
	"romania": {
		"population": 19237691,
		"median_age": 43.0,
		"size": 238397.0,
		"corruption": 0.60,
		"gdp_billions_usd": 284.1
	} ,
	"san_marino": {
		"population": 33931,
		"median_age": 50.0,
		"size": 61.0,
		"corruption": 0.90,
		"gdp_billions_usd": 1.9
	} ,
	"serbia": {
		"population": 8772235,
		"median_age": 43.0,
		"size": 77474.0,
		"corruption": 0.50,
		"gdp_billions_usd": 71.7
	} ,
	"slovakia": {
		"population": 5456362,
		"median_age": 41.0,
		"size": 49035.0,
		"corruption": 0.60,
		"gdp_billions_usd": 127.8
	} ,
	"slovenia": {
		"population": 2078654,
		"median_age": 45.0,
		"size": 20273.0,
		"corruption": 0.80,
		"gdp_billions_usd": 68.1
	} ,
	"spain": {
		"population": 46719142,
		"median_age": 44.0,
		"size": 505992.0,
		"corruption": 0.70,
		"gdp_billions_usd": 1398.9
	} ,
	"sweden": {
		"population": 10379295,
		"median_age": 41.0,
		"size": 450295.0,
		"corruption": 0.85,
		"gdp_billions_usd": 635.7
	} ,
	"switzerland": {
		"population": 8715496,
		"median_age": 43.0,
		"size": 41284.0,
		"corruption": 0.90,
		"gdp_billions_usd": 813.3
	} ,
	"turkey": {
		"population": 85000000,
		"median_age": 32.0,
		"size": 783562.0,
		"corruption": 0.39,
		"gdp_billions_usd": 819.0
	} ,
	"ukraine": {
		"population": 41660982,
		"median_age": 41.0,
		"size": 603550.0,
		"corruption": 0.35,
		"gdp_billions_usd": 170.1
	} ,
	"united_kingdom": {
		"population": 68000000,
		"median_age": 40.5,
		"size": 243610.0,
		"corruption": 0.77,
		"gdp_billions_usd": 3131.0
	} ,
	"vatican": {
		"population": 825,
		"median_age": 47.0,
		"size": 0.44,
		"corruption": 0.95,
		"gdp_billions_usd": 0.03
	} ,
	"usa": {
		"population": 347275807,
		"median_age": 38.9,
		"size": 9835170,
		"corruption": 0.67,
		"gdp_billions_usd": 29184.0
	} ,
	"canada": {
		"population": 40126723,
		"median_age": 41.1,
		"size": 9984670,
		"corruption": 0.74,
		"gdp_billions_usd": 2139.9
	} ,
	"mexico": {
		"population": 131946900,
		"median_age": 29.3,
		"size": 1964375,
		"corruption": 0.28,
		"gdp_billions_usd": 1978.8
	} ,
	"guatemala": {
		"population": 18687881,
		"median_age": 21.5,
		"size": 107160,
		"corruption": 0.26,
		"gdp_billions_usd": 102.3
	} ,
	"haiti": {
		"population": 11906095,
		"median_age": 23.1,
		"size": 27560,
		"corruption": 0.25,
		"gdp_billions_usd": 20.9
	} ,
	"dominican_republic": {
		"population": 11520487,
		"median_age": 28.2,
		"size": 48320,
		"corruption": 0.29,
		"gdp_billions_usd": 113.6
	} ,
	"honduras": {
		"population": 11005850,
		"median_age": 23.8,
		"size": 111890,
		"corruption": 0.28,
		"gdp_billions_usd": 29.8
	} ,
	"cuba": {
		"population": 10937203,
		"median_age": 42.4,
		"size": 106440,
		"corruption": 0.47,
		"gdp_billions_usd": 107.4
	} ,
	"nicaragua": {
		"population": 7007502,
		"median_age": 26.6,
		"size": 120340,
		"corruption": 0.29,
		"gdp_billions_usd": 17.0
	} ,
	"panama": {
		"population": 5070000,
		"median_age": 29.3,
		"size": 75417,
		"corruption": 0.38,
		"gdp_billions_usd": 80.5
	} ,
	"belize": {
		"population": 465000,
		"median_age": 26.5,
		"size": 22966,
		"corruption": 0.30,
		"gdp_billions_usd": 2.7
	} ,
	"costa_rica": {
		"population": 5191000,
		"median_age": 32.5,
		"size": 51100,
		"corruption": 0.58,
		"gdp_billions_usd": 68.4
	} ,
	"el_salvador": {
		"population": 6351000,
		"median_age": 26.1,
		"size": 21041,
		"corruption": 0.38,
		"gdp_billions_usd": 32.8
	} ,
	"dominica": {
		"population": 63200,
		"median_age": 36.9,
		"size": 751,
		"corruption": 0.52,
		"gdp_billions_usd": 0.7
	} ,
	"barbados": {
		"population": 263700,
		"median_age": 40.2,
		"size": 430,
		"corruption": 0.58,
		"gdp_billions_usd": 5.4
	} ,
	"saint_kitts_and_nevis": {
		"population": 53100,
		"median_age": 33.4,
		"size": 261,
		"corruption": 0.55,
		"gdp_billions_usd": 1.1
	} ,
	"saint_lucia": {
		"population": 183600,
		"median_age": 34.3,
		"size": 616,
		"corruption": 0.54,
		"gdp_billions_usd": 2.2
	} ,
	"saint_vincent_and_the_grenadines": {
		"population": 110000,
		"median_age": 32.8,
		"size": 389,
		"corruption": 0.52,
		"gdp_billions_usd": 0.9
	} ,
	"trinidad_and_tobago": {
		"population": 1400000,
		"median_age": 34.5,
		"size": 5128,
		"corruption": 0.40,
		"gdp_billions_usd": 28.8
	} ,
	"antigua_and_barbuda": {
		"population": 103600,
		"median_age": 33.5,
		"size": 443,
		"corruption": 0.50,
		"gdp_billions_usd": 1.8
	} ,
	"bahamas": {
		"population": 409000,
		"median_age": 31.6,
		"size": 13880,
		"corruption": 0.60,
		"gdp_billions_usd": 13.0
	} ,
	"grenada": {
		"population": 116400,
		"median_age": 34.1,
		"size": 344,
		"corruption": 0.56,
		"gdp_billions_usd": 1.3
	} ,
	"colombia": {
		"population": 53425635,
		"median_age": 32.2,
		"size": 1141748,
		"corruption": 0.39,
		"gdp_billions_usd": 363.8
	} ,
	"argentina": {
		"population": 45851378,
		"median_age": 32.0,
		"size": 2780400,
		"corruption": 0.38,
		"gdp_billions_usd": 487.2
	} ,
	"peru": {
		"population": 34576665,
		"median_age": 30.2,
		"size": 1285216,
		"corruption": 0.38,
		"gdp_billions_usd": 242.6
	} ,
	"venezuela": {
		"population": 28767104,
		"median_age": 29.5,
		"size": 916445,
		"corruption": 0.15,
		"gdp_billions_usd": 102.4
	} ,
	"chile": {
		"population": 19116209,
		"median_age": 35.4,
		"size": 756102,
		"corruption": 0.67,
		"gdp_billions_usd": 318.7
	} ,
	"ecuador": {
		"population": 18456126,
		"median_age": 26.8,
		"size": 283561,
		"corruption": 0.39,
		"gdp_billions_usd": 115.0
	} ,
	"bolivia": {
		"population": 11830742,
		"median_age": 25.7,
		"size": 1098581,
		"corruption": 0.29,
		"gdp_billions_usd": 47.1
	} ,
	"paraguay": {
		"population": 7132530,
		"median_age": 26.1,
		"size": 406752,
		"corruption": 0.29,
		"gdp_billions_usd": 42.3
	} ,
	"suriname": {
		"population": 652000,
		"median_age": 31.2,
		"size": 163820,
		"corruption": 0.30,
		"gdp_billions_usd": 4.3
	} ,
	"uruguay": {
		"population": 3477000,
		"median_age": 34.4,
		"size": 176215,
		"corruption": 0.71,
		"gdp_billions_usd": 59.3
	} ,
	"guyana": {
		"population": 786000,
		"median_age": 27.5,
		"size": 214969,
		"corruption": 0.28,
		"gdp_billions_usd": 16.8
	} ,
	"french_guiana": {
		"population": 300000,
		"median_age": 25.0,
		"size": 83534,
		"corruption": 0.38,
		"gdp_billions_usd": 5.1
	} ,
	"east_timor": {
		"population": 1418517,
		"median_age": 21.7,
		"size": 14870.0,
		"corruption": 0.44,
		"gdp_billions_usd": 2.12
	} ,
	"algeria": { "population": 46400000, "median_age": 30.0, "size": 2381741.0, "corruption": 0.36, "gdp_billions_usd": 266.8 } ,
	"angola": { "population": 32866272, "median_age": 16.0, "size": 1246700.0, "corruption": 0.20, "gdp_billions_usd": 124.2 } ,
	"benin": { "population": 12123200, "median_age": 19.0, "size": 112622.0, "corruption": 0.416, "gdp_billions_usd": 18.7 } ,
	"botswana": { "population": 2141206, "median_age": 24.0, "size": 581730.0, "corruption": 0.60, "gdp_billions_usd": 20.8 } ,
	"burkina_faso": { "population": 23300000, "median_age": 17.0, "size": 272967.0, "corruption": 0.41, "gdp_billions_usd": 19.7 } ,
	"burundi": { "population": 10114505, "median_age": 17.0, "size": 27834.0, "corruption": 0.30, "gdp_billions_usd": 3.2 } ,
	"cabo_verde": { "population": 531239, "median_age": 30.0, "size": 4033.0, "corruption": 0.58, "gdp_billions_usd": 2.1 } ,
	"cameroon": { "population": 22709892, "median_age": 18.0, "size": 475442.0, "corruption": 0.28, "gdp_billions_usd": 47.9 } ,
	"central_african_republic": { "population": 4998000, "median_age": 18.0, "size": 622984.0, "corruption": 0.29, "gdp_billions_usd": 2.8 } ,
	"chad": { "population": 14497000, "median_age": 16.0, "size": 1284000.0, "corruption": 0.28, "gdp_billions_usd": 12.9 } ,
	"comoros": { "population": 806153, "median_age": 19.0, "size": 2235.0, "corruption": 0.30, "gdp_billions_usd": 0.7 } ,
	"democratic_congo": { "population": 102000000, "median_age": 17.0, "size": 2344858.0, "corruption": 0.18, "gdp_billions_usd": 69.5 } ,
	"congo_republic": { "population": 4741000, "median_age": 19.0, "size": 342000.0, "corruption": 0.28, "gdp_billions_usd": 14.2 } ,
	"djibouti": { "population": 900000, "median_age": 27.0, "size": 23200.0, "corruption": 0.47, "gdp_billions_usd": 3.8 } ,
	"egypt": { "population": 104000000, "median_age": 24.0, "size": 1002450.0, "corruption": 0.35, "gdp_billions_usd": 347.6 } ,
	"equatorial_guinea": { "population": 1402985, "median_age": 26.0, "size": 28051.0, "corruption": 0.24, "gdp_billions_usd": 10.2 } ,
	"eritrea": { "population": 3500000, "median_age": 18.0, "size": 117600.0, "corruption": 0.28, "gdp_billions_usd": 2.1 } ,
	"eswatini": { "population": 1200000, "median_age": 21.0, "size": 17364.0, "corruption": 0.42, "gdp_billions_usd": 4.7 } ,
	"ethiopia": { "population": 126000000, "median_age": 19.0, "size": 1104300.0, "corruption": 0.26, "gdp_billions_usd": 156.1 } ,
	"gabon": { "population": 2130000, "median_age": 24.0, "size": 267668.0, "corruption": 0.36, "gdp_billions_usd": 20.8 } ,
	"gambia": { "population": 2400000, "median_age": 18.0, "size": 11295.0, "corruption": 0.29, "gdp_billions_usd": 2.0 } ,
	"ghana": { "population": 34581288, "median_age": 21.0, "size": 238533.0, "corruption": 0.377, "gdp_billions_usd": 76.8 } ,
	"guinea": { "population": 13400000, "median_age": 18.0, "size": 245857.0, "corruption": 0.28, "gdp_billions_usd": 18.9 } ,
	"guinea_bissau": { "population": 2000000, "median_age": 19.0, "size": 36125.0, "corruption": 0.28, "gdp_billions_usd": 1.6 } ,
	"ivory_coast": { "population": 27000000, "median_age": 19.0, "size": 322463.0, "corruption": 0.416, "gdp_billions_usd": 86.9 } ,
	"kenya": { "population": 53771296, "median_age": 20.0, "size": 580367.0, "corruption": 0.30, "gdp_billions_usd": 113.4 } ,
	"lesotho": { "population": 2000000, "median_age": 24.0, "size": 30355.0, "corruption": 0.42, "gdp_billions_usd": 2.5 } ,
	"liberia": { "population": 5000000, "median_age": 18.0, "size": 111369.0, "corruption": 0.29, "gdp_billions_usd": 4.0 } ,
	"libya": { "population": 7000000, "median_age": 29.0, "size": 1759540.0, "corruption": 0.35, "gdp_billions_usd": 45.8 } ,
	"madagascar": { "population": 27691018, "median_age": 19.0, "size": 587041.0, "corruption": 0.28, "gdp_billions_usd": 15.8 } ,
	"malawi": { "population": 19000000, "median_age": 18.0, "size": 118484.0, "corruption": 0.28, "gdp_billions_usd": 13.2 } ,
	"mali": { "population": 24000000, "median_age": 16.0, "size": 1240192.0, "corruption": 0.28, "gdp_billions_usd": 20.0 } ,
	"mauritania": { "population": 4600000, "median_age": 19.0, "size": 1030700.0, "corruption": 0.28, "gdp_billions_usd": 9.7 } ,
	"mauritius": { "population": 1265000, "median_age": 37.0, "size": 2040.0, "corruption": 0.58, "gdp_billions_usd": 14.9 } ,
	"morocco": { "population": 37000000, "median_age": 29.0, "size": 710850.0, "corruption": 0.39, "gdp_billions_usd": 148.1 } ,
	"mozambique": { "population": 30000000, "median_age": 17.0, "size": 801590.0, "corruption": 0.28, "gdp_billions_usd": 18.9 } ,
	"namibia": { "population": 2600000, "median_age": 21.0, "size": 825615.0, "corruption": 0.42, "gdp_billions_usd": 14.5 } ,
	"niger": { "population": 25000000, "median_age": 14.8, "size": 1267000.0, "corruption": 0.28, "gdp_billions_usd": 16.6 } ,
	"nigeria": { "population": 223800000, "median_age": 18.0, "size": 923768.0, "corruption": 0.28, "gdp_billions_usd": 472.6 } ,
	"rwanda": { "population": 13000000, "median_age": 20.0, "size": 26338.0, "corruption": 0.28, "gdp_billions_usd": 13.3 } ,
	"senegal": { "population": 18000000, "median_age": 19.0, "size": 196722.0, "corruption": 0.416, "gdp_billions_usd": 28.9 } ,
	"seychelles": { "population": 98000, "median_age": 38.0, "size": 455.0, "corruption": 0.58, "gdp_billions_usd": 1.8 } ,
	"sierra_leone": { "population": 8000000, "median_age": 19.0, "size": 71740.0, "corruption": 0.28, "gdp_billions_usd": 4.1 } ,
	"south_africa": { "population": 60000000, "median_age": 27.0, "size": 1219090.0, "corruption": 0.41, "gdp_billions_usd": 373.2 } ,
	"south_sudan": { "population": 12000000, "median_age": 18.0, "size": 619745.0, "corruption": 0.08, "gdp_billions_usd": 3.0 } ,
	"sudan": { "population": 40000000, "median_age": 20.0, "size": 1861484.0, "corruption": 0.28, "gdp_billions_usd": 52.6 } ,
	"tanzania": { "population": 59000000, "median_age": 18.0, "size": 945087.0, "corruption": 0.28, "gdp_billions_usd": 85.4 } ,
	"togo": { "population": 8000000, "median_age": 19.0, "size": 56785.0, "corruption": 0.28, "gdp_billions_usd": 8.1 } ,
	"tunisia": { "population": 11800000, "median_age": 32.0, "size": 163610.0, "corruption": 0.45, "gdp_billions_usd": 50.3 } ,
	"uganda": { "population": 46000000, "median_age": 16.0, "size": 241038.0, "corruption": 0.28, "gdp_billions_usd": 48.1 } ,
	"zambia": { "population": 18000000, "median_age": 17.0, "size": 752612.0, "corruption": 0.28, "gdp_billions_usd": 29.2 } ,
	"zimbabwe": { "population": 15000000, "median_age": 20.0, "size": 390757.0, "corruption": 0.28, "gdp_billions_usd": 31.4 } ,
	"afghanistan": { "population": 40218234, "median_age": 18.0, "size": 652230.0, "corruption": 0.02, "gdp_billions_usd": 14.3 } ,
	"bahrain": { "population": 1701583, "median_age": 38.0, "size": 765.0, "corruption": 0.45, "gdp_billions_usd": 44.4 } ,
	"bangladesh": { "population": 168304408, "median_age": 27.0, "size": 147570.0, "corruption": 0.26, "gdp_billions_usd": 460.2 } ,
	"bhutan": { "population": 779000, "median_age": 38.0, "size": 38394.0, "corruption": 0.28, "gdp_billions_usd": 2.9 } ,
	"brunei": { "population": 453000, "median_age": 32.0, "size": 5765.0, "corruption": 0.52, "gdp_billions_usd": 15.1 } ,
	"burma": { "population": 54800000, "median_age": 29.0, "size": 676578.0, "corruption": 0.20, "gdp_billions_usd": 65.8 } ,
	"cambodia": { "population": 16718971, "median_age": 25.0, "size": 181035.0, "corruption": 0.28, "gdp_billions_usd": 29.3 } ,
	"china": { "population": 1411778724, "median_age": 38.4, "size": 9596961.0, "corruption": 0.40, "gdp_billions_usd": 17734.1 } ,
	"india": { "population": 1393409038, "median_age": 28.4, "size": 3287263.0, "corruption": 0.39, "gdp_billions_usd": 3739.2 } ,
	"indonesia": { "population": 273523615, "median_age": 30.2, "size": 1904569.0, "corruption": 0.34, "gdp_billions_usd": 1417.4 } ,
	"iran": { "population": 83992949, "median_age": 32.0, "size": 1648195.0, "corruption": 0.26, "gdp_billions_usd": 367.9 } ,
	"iraq": { "population": 40222503, "median_age": 20.0, "size": 438317.0, "corruption": 0.16, "gdp_billions_usd": 264.2 } ,
	"israel": { "population": 8655535, "median_age": 30.5, "size": 22072.0, "corruption": 0.59, "gdp_billions_usd": 481.6 } ,
	"jordan": { "population": 10203134, "median_age": 22.0, "size": 89342.0, "corruption": 0.47, "gdp_billions_usd": 50.8 } ,
	"kazakhstan": { "population": 18776707, "median_age": 31.0, "size": 2724900.0, "corruption": 0.40, "gdp_billions_usd": 220.6 } ,
	"north_korea": { "population": 25778816, "median_age": 34.0, "size": 120538.0, "corruption": 0.02, "gdp_billions_usd": 28.5 } ,
	"south_korea": { "population": 51329899, "median_age": 43.0, "size": 100032.0, "corruption": 0.61, "gdp_billions_usd": 1810.0 } ,
	"kuwait": { "population": 4270563, "median_age": 32.0, "size": 17818.0, "corruption": 0.47, "gdp_billions_usd": 164.7 } ,
	"kyrgyzstan": { "population": 6524195, "median_age": 26.0, "size": 199951.0, "corruption": 0.38, "gdp_billions_usd": 10.9 } ,
	"laos": { "population": 7275560, "median_age": 23.0, "size": 237955.0, "corruption": 0.30, "gdp_billions_usd": 18.7 } ,
	"lebanon": { "population": 6825445, "median_age": 30.0, "size": 10452.0, "corruption": 0.28, "gdp_billions_usd": 23.1 } ,
	"malaysia": { "population": 32365999, "median_age": 30.0, "size": 330803.0, "corruption": 0.50, "gdp_billions_usd": 432.3 } ,
	"maldives": { "population": 521000, "median_age": 30.0, "size": 298.0, "corruption": 0.57, "gdp_billions_usd": 6.2 } ,
	"mongolia": { "population": 3278290, "median_age": 28.0, "size": 1564116.0, "corruption": 0.45, "gdp_billions_usd": 18.4 } ,
	"nepal": { "population": 29136808, "median_age": 24.0, "size": 147516.0, "corruption": 0.28, "gdp_billions_usd": 40.9 } ,
	"oman": { "population": 5106622, "median_age": 25.0, "size": 309500.0, "corruption": 0.46, "gdp_billions_usd": 95.2 } ,
	"pakistan": { "population": 225199937, "median_age": 23.0, "size": 881913.0, "corruption": 0.28, "gdp_billions_usd": 347.7 } ,
	"palestine": { "population": 5130000, "median_age": 20.0, "size": 6020.0, "corruption": 0.28, "gdp_billions_usd": 19.1 } ,
	"philippines": { "population": 113866000, "median_age": 24.0, "size": 300000.0, "corruption": 0.28, "gdp_billions_usd": 404.3 } ,
	"qatar": { "population": 2881053, "median_age": 32.0, "size": 11571.0, "corruption": 0.47, "gdp_billions_usd": 236.0 } ,
	"russia": { "population": 145912025, "median_age": 39.0, "size": 17098242.0, "corruption": 0.28, "gdp_billions_usd": 2240.4 } ,
	"saudi_arabia": { "population": 34813871, "median_age": 31.0, "size": 2149690.0, "corruption": 0.46, "gdp_billions_usd": 833.5 } ,
	"singapore": { "population": 5638676, "median_age": 42.0, "size": 728.0, "corruption": 0.83, "gdp_billions_usd": 397.0 } ,
	"sri_lanka": { "population": 21413249, "median_age": 34.0, "size": 65610.0, "corruption": 0.28, "gdp_billions_usd": 84.0 } ,
	"syria": { "population": 17500657, "median_age": 24.0, "size": 185180.0, "corruption": 0.16, "gdp_billions_usd": 25.0 } ,
	"taiwan": { "population": 23816775, "median_age": 42.0, "size": 36193.0, "corruption": 0.68, "gdp_billions_usd": 790.7 } ,
	"tajikistan": { "population": 9537645, "median_age": 23.0, "size": 143100.0, "corruption": 0.24, "gdp_billions_usd": 11.8 } ,
	"thailand": { "population": 69950800, "median_age": 40.0, "size": 513120.0, "corruption": 0.42, "gdp_billions_usd": 534.8 } ,
	"timor_leste": { "population": 1318445, "median_age": 19.0, "size": 14874.0, "corruption": 0.28, "gdp_billions_usd": 1.6 } ,
	"turkmenistan": { "population": 6031187, "median_age": 28.0, "size": 488100.0, "corruption": 0.16, "gdp_billions_usd": 57.1 } ,
	"united_arab_emirates": { "population": 9770529, "median_age": 33.0, "size": 83600.0, "corruption": 0.47, "gdp_billions_usd": 507.2 } ,
	"uzbekistan": { "population": 33469203, "median_age": 30.0, "size": 447400.0, "corruption": 0.28, "gdp_billions_usd": 90.9 } ,
	"vietnam": { "population": 98168829, "median_age": 32.0, "size": 331210.0, "corruption": 0.28, "gdp_billions_usd": 408.8 } ,
	"yemen": { "population": 29825968, "median_age": 19.0, "size": 527968.0, "corruption": 0.16, "gdp_billions_usd": 21.6 } ,
	"australia": {
		"population": 26974026,
		"median_age": 38.0,
		"size": 7682300.0,
		"corruption": 0.77,
		"gdp_billions_usd": 1550.8
	} ,
	"papua_new_guinea": {
		"population": 10762817,
		"median_age": 23.0,
		"size": 462860.0,
		"corruption": 0.18,
		"gdp_billions_usd": 32.5
	} ,
	"new_zealand": {
		"population": 5251899,
		"median_age": 38.0,
		"size": 263310.0,
		"corruption": 0.91,
		"gdp_billions_usd": 254.9
	} ,
	"cape_verde": {
		"population": 598682,
		"median_age": 29.6,
		"size": 4033.0,
		"corruption": 0.60,
		"gdp_billions_usd": 2.6
	} ,
	"fiji": {
		"population": 933154,
		"median_age": 28.0,
		"size": 18274.0,
		"corruption": 0.49,
		"gdp_billions_usd": 5.5
	} ,
	"solomon_islands": {
		"population": 838645,
		"median_age": 19.0,
		"size": 28896.0,
		"corruption": 0.28,
		"gdp_billions_usd": 1.7
	} ,
	"vanuatu": {
		"population": 335169,
		"median_age": 23.0,
		"size": 12189.0,
		"corruption": 0.28,
		"gdp_billions_usd": 1.0
	} ,
	"samoa": {
		"population": 219306,
		"median_age": 22.0,
		"size": 2842.0,
		"corruption": 0.28,
		"gdp_billions_usd": 0.9
	} ,
	"kiribati": {
		"population": 136488,
		"median_age": 22.0,
		"size": 811.0,
		"corruption": 0.28,
		"gdp_billions_usd": 0.3
	} ,
	"micronesia": {
		"population": 113683,
		"median_age": 23.0,
		"size": 702.0,
		"corruption": 0.28,
		"gdp_billions_usd": 0.4
	} ,
	"tonga": {
		"population": 103742,
		"median_age": 23.0,
		"size": 747.0,
		"corruption": 0.28,
		"gdp_billions_usd": 0.5
	} ,
	"palau": {
		"population": 18000,
		"median_age": 30.0,
		"size": 459.0,
		"corruption": 0.28,
		"gdp_billions_usd": 0.3
	} ,
	"marshall_islands": {
		"population": 59194,
		"median_age": 23.0,
		"size": 181.0,
		"corruption": 0.28,
		"gdp_billions_usd": 0.3
	} ,
	"nauru": {
		"population": 10824,
		"median_age": 25.0,
		"size": 21.0,
		"corruption": 0.28,
		"gdp_billions_usd": 0.1
	} ,
	"tuvalu": {
		"population": 11792,
		"median_age": 30.0,
		"size": 26.0,
		"corruption": 0.28,
		"gdp_billions_usd": 0.1
	} ,
	"myanmar": {
		"population": 54500000,
		"median_age": 28.2,
		"size": 676578.0,
		"corruption": 0.16,
		"gdp_billions_usd": 74.1
	} ,
	"estonia": {
		"population": 1370000,
		"median_age": 45.0,
		"size": 45335.0,
		"corruption": 0.76,
		"gdp_billions_usd": 45.0
	} ,
	"finland": {
		"population": 5636000,
		"median_age": 43.3,
		"size": 303948.0,
		"corruption": 0.88,
		"gdp_billions_usd": 299.8
	} ,
	"jamaica": {
		"population": 2824000,
		"median_age": 30.9,
		"size": 10991.0,
		"corruption": 0.44,
		"gdp_billions_usd": 20.6
	} ,
}


func _ready() -> void:
	calc_total_population()
	init_extra_details()


func init_extra_details():
	for n in COUNTRY_DETAILS.keys():
		COUNTRY_DETAILS[n]["unlocks"] = 0 # only joker unlocked -> 1, 2, 3
		COUNTRY_DETAILS[n]["progression_idx"] = 0
		COUNTRY_DETAILS[n]["dynamic_progression"] = 0.0
		COUNTRY_DETAILS[n]["total_progression"] = 0.0
		COUNTRY_DETAILS[n]["progression_started"] = false
		COUNTRY_DETAILS[n]["lost_specimen"] = 0
		COUNTRY_DETAILS[n]["dynamic_lost_specimen"] = 0.0
		COUNTRY_DETAILS[n]["lost_specimen_per_second"] = 0.0
		COUNTRY_DETAILS[n]["static_lost_specimen"] = 0.0
		COUNTRY_DETAILS[n]["is_completed"] = false

		# CHARACTERS
		COUNTRY_DETAILS[n]["JOKER_ACTIONS"] = [0.0, 0.0, 0.0, 0] # Action Duration, Converted/Action, Converted/Action, Amount
		COUNTRY_DETAILS[n]["SCAMMER_ACTIONS"] = [0.0, 0.0, 0.0, 0]
		COUNTRY_DETAILS[n]["POLITICIAN_ACTIONS"] = [0.0, 0.0, 0.0, 0]
		COUNTRY_DETAILS[n]["CONSPIRATOR_ACTIONS"] = [0.0, 0.0, 0.0, 0]

func update_country_calculations(delta) -> void:
	# UPDATE COUNTRY VALUES
	for country in COUNTRY_DETAILS.keys():
		if !CountryData.is_country_completed(country):
			COUNTRY_DETAILS[country]["dynamic_progression"] = (get_dynamic_progression(country) + (get_lost_specimen_ps(country) * delta / get_population(country)))
			print("DYN: ", COUNTRY_DETAILS[country]["dynamic_progression"])
			COUNTRY_DETAILS[country]["total_progression"] = COUNTRY_DETAILS[country]["dynamic_progression"] + (get_static_lost_specimen(country) / get_population(country))
			print("STAT: ", COUNTRY_DETAILS[country]["dynamic_progression"])
			if COUNTRY_DETAILS[country]["total_progression"] > 0.1:
				print(COUNTRY_DETAILS[country]["total_progression"])
			if country == Global.CURRENT_COUNTRY:
				emit_signal("progression_updated", get_total_progression_per_country())
			print(COUNTRY_DETAILS[country])
			print("--------------------------------")
			_check_character_unlock(country)


func get_median_character_action_speed(country: String, character: String) -> float:
	# Returns the median time for a  character in a country  to complete a task
	return COUNTRY_DETAILS[country][character + "_ACTIONS"][0]


func increment_character_per_country(country: String, character: String) -> void:
	COUNTRY_DETAILS[country][character + "_ACTIONS"][3] += 1


func get_character_amount_per_country(country: String, character: String) -> int:
	return COUNTRY_DETAILS[country][character + "_ACTIONS"][3]


func get_country_lost_specimen(country: String = Global.CURRENT_COUNTRY) -> int:
	return COUNTRY_DETAILS[country]["lost_specimen"]


func is_country_completed(country: String) -> bool:
	return CountryData.COUNTRY_DETAILS[country]["is_completed"]


func update_lost_specimen(delta: float) -> void:
	for country in COUNTRY_DETAILS.keys():
		COUNTRY_DETAILS[country]["dynamic_lost_specimen"] += (get_lost_specimen_ps(country) * delta)
	_check_for_skill_point()


func get_country_total_lost_specimen(country: String = Global.CURRENT_COUNTRY) -> int:
	return COUNTRY_DETAILS[country]["dynamic_lost_specimen"] + COUNTRY_DETAILS[country]["static_lost_specimen"]


func get_static_lost_specimen(country: String = Global.CURRENT_COUNTRY) -> int:
	return COUNTRY_DETAILS[country]["static_lost_specimen"]


func calc_total_population() -> void:
	var sum: int = 0
	for n in COUNTRY_DETAILS:
		sum += COUNTRY_DETAILS[n]["population"]
	TOTAL_POPULATION = sum


func get_global_population() -> float:
	return TOTAL_POPULATION


func get_total_static_lost_specimen() -> int:
	var sum: int = 0
	for n in COUNTRY_DETAILS.size():
		sum += COUNTRY_DETAILS.values()[n]["static_lost_specimen"]
	return sum


func increment_static_lost_specimen(country: String = Global.CURRENT_COUNTRY, check: bool = true):
	COUNTRY_DETAILS[country]["static_lost_specimen"] += (1 * Global.POISONING_MULTIPLIER)
	if check:
		_check_for_skill_point()
	#emit_signal("update_calculations")


func increment_static_specimen_for_all_countries() -> void:
	for n in COUNTRY_DETAILS.keys():
		increment_static_lost_specimen(n, false)
	_check_for_skill_point()


func get_dynamic_lost_specimen(country: String = Global.CURRENT_COUNTRY) -> float:
	return CountryData.COUNTRY_DETAILS[country]["dynamic_lost_specimen"]


func set_lost_specimen_per_country(country_name: String, lost_specimen_per_second: int) -> void:
	var value: Dictionary = COUNTRY_DETAILS.get(country_name, {})
	value["lost_specimen_per_second"] = lost_specimen_per_second
	COUNTRY_DETAILS.set(
		country_name,
		value
	)


func check_progression_started(country):
	COUNTRY_DETAILS[country]["progression_started"] = true


func has_progression_started(country) -> bool:
	return COUNTRY_DETAILS[country]["progression_started"]


func get_character_unlock(country: String = Global.CURRENT_COUNTRY) -> int:
	return COUNTRY_DETAILS[country].get_or_add("unlocks", 0)


func get_progression_idx(country: String = Global.CURRENT_COUNTRY):
	return COUNTRY_DETAILS[country]["progression_idx"]


func get_lost_specimen_ps(country: String):
	return COUNTRY_DETAILS[country].get("lost_specimen_per_second", 0.0)


func get_gdp(country: String) -> float:
	return float(COUNTRY_DETAILS[country]["gdp_billions_usd"]) * 1000000000


func get_dynamic_progression(country: String = Global.CURRENT_COUNTRY) -> float:
	return COUNTRY_DETAILS[country]["dynamic_progression"]


func get_population(country: String) -> float:
	return float(COUNTRY_DETAILS[country]["population"])


func get_size(country: String) -> float:
	return float(COUNTRY_DETAILS[country]["size"])


func get_corruption(country: String) -> float:
	return float(COUNTRY_DETAILS[country]["corruption"])


func get_median_age(country: String) -> float:
	return float(COUNTRY_DETAILS[country]["median_age"])


func get_country_data_dict(country: String) -> Dictionary:
	return COUNTRY_DETAILS.get(country, {})


func get_next_bribe_cost_per_day(nth_politician: int = get_character_amount_per_country(Global.CURRENT_COUNTRY, "POLITICIAN") + 1, country: String = Global.CURRENT_COUNTRY) -> float:
	# returns the cost of the next bribe money for the next politician in a country per day
	var x: float = CountryData.get_gdp(country) / CountryData.get_population(country) / 365
	return x * (pow(nth_politician, 2) / nth_politician)


func get_politician_idx(country: String = Global.CURRENT_COUNTRY) -> int:
	#  get amount of already bribed politicians peer country
	return COUNTRY_DETAILS[country]["POLITICIAN"].size()


func get_total_progression_per_country(country: String = Global.CURRENT_COUNTRY) -> float:
	return(get_dynamic_lost_specimen(country) + get_static_lost_specimen(country)) / get_population(country) * 100.0


func set_country_progression_idx(country, char_idx):
	COUNTRY_DETAILS[country]["progression_idx"] = char_idx


func get_current_base_money_for_all_countries(sorted: bool = false) -> Dictionary:
	var bribes: Dictionary = {}
	for n in COUNTRY_DETAILS.keys():
		bribes[n] = get_next_bribe_cost_per_day(1, n)

	if sorted:
		var items := []
		for k in bribes.keys():
			items.append([k, bribes[k]])

		# Sort by value decending
		items.sort_custom(func(a, b): return a[1] > b[1])

		# Rebuild dictionary but now in sorted order
		bribes = {}
		for pair in items:
			bribes[pair[0]] = pair[1]

	return bribes


func _get_empty_country_data_value() -> Dictionary[String, Variant]:
	# Returns the Inner Dictionary of the Country Data for a newly added country
	return {
		"JOKER": [],
		"SCAMMER": [],
		"CONSPIRATOR": [],
		"POLITICIAN": [],
		"GENERAL": {
			"JOKER": 0.0, # MEDIAN ACTION SPEED PER COUNTRY
			"SCAMMER": 0.0,
			"CONSPIRATOR": 0.0,
			"POLITICIAN": 0.0,

		}
	}


func _check_for_skill_point():
	for n in range(current_skill_lvl, SKILL_POINT_UNLOCKS.size()):
		if get_total_static_lost_specimen() + Global.LOST_SPECIMEN >= SKILL_POINT_UNLOCKS[current_skill_lvl]:
			if n == 0: # first skill point
				Dialogic.start("first_skill_point_unlock")
			Global.add_skill_point()
			GlobalSoundPlayer.play_skill_jingle()
			current_skill_lvl += 1


func _check_character_unlock(country: String) -> void:
	if is_country_completed(country):
		return

	if COUNTRY_DETAILS[country]["total_progression"] >= 1.0:
		COUNTRY_DETAILS[country]["is_completed"] = true
		emit_signal("update_calculations")
	elif COUNTRY_DETAILS[country]["total_progression"] > 0.9 and COUNTRY_DETAILS[country]["unlocks"] < 4:
		Global.add_skill_point()
		COUNTRY_DETAILS[country]["unlocks"] = 4
		GlobalSoundPlayer.play_country_unlock_jingle()
	elif COUNTRY_DETAILS[country]["total_progression"] > 0.4 and COUNTRY_DETAILS[country]["unlocks"] < 3:
		# UNLOCK POLITICIAN ON 40% Progress
		COUNTRY_DETAILS[country]["unlocks"] = 3
		Global.add_skill_point()
		GlobalSoundPlayer.play_country_progression_jingle()
		emit_signal("character_unlocked", country, 3)
	elif COUNTRY_DETAILS[country]["total_progression"] > 0.25 and COUNTRY_DETAILS[country]["unlocks"] < 2:
		# UNLOCK CONPIRATOR ON 25% Progress
		COUNTRY_DETAILS[country]["unlocks"] = 2
		Global.add_skill_point()
		GlobalSoundPlayer.play_country_progression_jingle()
		emit_signal("character_unlocked", country, 2)
	elif COUNTRY_DETAILS[country]["total_progression"] > 0.10 and COUNTRY_DETAILS[country]["unlocks"] == 0:
		# UNLOCK SCAMMER ON 10% Progress
		COUNTRY_DETAILS[country]["unlocks"] = 1
		Global.add_skill_point()
		GlobalSoundPlayer.play_country_progression_jingle()
		emit_signal("character_unlocked", country, 1)
