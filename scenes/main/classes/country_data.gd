extends Node

func _ready() -> void:
	return
	for n in COUNTRY_DETAILS.size():
		print(COUNTRY_DETAILS.keys()[n])


func get_country_defence_value(country : String) -> float:
	var country_data : Dictionary = COUNTRY_DETAILS.get(country, {})
	if country_data.is_empty():
		printerr("NO COUNTRY DATA TO CALCULATE DEFENSE: %s" % country)
		return 0
	else:
		return ((country_data["population"] / country_data["size"]) * country_data["corruption"] ) / 10000


func set_lost_specimen_per_country(country_name : String, lost_specimen_per_second : int) -> void:
	var value : Dictionary = COUNTRY_DETAILS.get(country_name, {})
	value["lost_specimen_per_second"] = lost_specimen_per_second
	COUNTRY_DETAILS.set(
		country_name, 
		value
	)


func get_country_data_dict(country : String) -> Dictionary:
	return COUNTRY_DETAILS.get(country, {})


var COUNTRY_DETAILS: Dictionary = {
	"denmark": {
		"population": 5831404,
		"median_age": 42.0,
		"size": 43094.0,
		"corruption": 0.90
	},
	"somalia": {
		"population": 17635975,
		"median_age": 17.8,
		"size": 637657.0,
		"corruption": 0.08
	},
	"japan": {
		"population": 125800000,
		"median_age": 48.6,
		"size": 377975.0,
		"corruption": 0.74
	},
	"brazil": {
		"population": 215000000,
		"median_age": 33.5,
		"size": 8515767.0,
		"corruption": 0.38
	},
	"albania": {
		"population": 2877797,
		"median_age": 38.0,
		"size": 28748.0,
		"corruption": 0.43
	},
	"andorra": {
		"population": 77265,
		"median_age": 45.0,
		"size": 468.0,
		"corruption": 0.88
	},
	"armenia": {
		"population": 2963243,
		"median_age": 36.0,
		"size": 29743.0,
		"corruption": 0.47
	},
	"austria": {
		"population": 9006398,
		"median_age": 44.0,
		"size": 83879.0,
		"corruption": 0.83
	},
	"azerbaijan": {
		"population": 10239177,
		"median_age": 32.0,
		"size": 86600.0,
		"corruption": 0.35
	},
	"belarus": {
		"population": 9449323,
		"median_age": 40.0,
		"size": 207600.0,
		"corruption": 0.42
	},
	"belgium": {
		"population": 11589623,
		"median_age": 42.0,
		"size": 30528.0,
		"corruption": 0.77
	},
	"bosnia_and_herzegovina": {
		"population": 3280819,
		"median_age": 42.0,
		"size": 51209.0,
		"corruption": 0.43
	},
	"bulgaria": {
		"population": 6951482,
		"median_age": 44.0,
		"size": 110879.0,
		"corruption": 0.45
	},
	"croatia": {
		"population": 4095267,
		"median_age": 43.0,
		"size": 56594.0,
		"corruption": 0.60
	},
	"cyprus": {
		"population": 1207359,
		"median_age": 38.0,
		"size": 9251.0,
		"corruption": 0.70
	},
	"czechia": {
		"population": 10708981,
		"median_age": 42.0,
		"size": 78865.0,
		"corruption": 0.70
	},
	"france": {
		"population": 67391582,
		"median_age": 42.0,
		"size": 551695.0,
		"corruption": 0.69
	},
	"georgia": {
		"population": 3989167,
		"median_age": 38.0,
		"size": 69700.0,
		"corruption": 0.42
	},
	"germany": {
		"population": 84000000,
		"median_age": 45.0,
		"size": 357022.0,
		"corruption": 0.80
	},
	"greece": {
		"population": 10423054,
		"median_age": 45.0,
		"size": 131957.0,
		"corruption": 0.60
	},
	"hungary": {
		"population": 9660351,
		"median_age": 43.0,
		"size": 93030.0,
		"corruption": 0.60
	},
	"iceland": {
		"population": 376248,
		"median_age": 36.0,
		"size": 103000.0,
		"corruption": 0.90
	},
	"ireland": {
		"population": 5360000,
		"median_age": 38.0,
		"size": 70273.0,
		"corruption": 0.80
	},
	"italy": {
		"population": 60262770,
		"median_age": 47.0,
		"size": 301340.0,
		"corruption": 0.60
	},
	"kosovo": {
		"population": 1831000,
		"median_age": 30.0,
		"size": 10887.0,
		"corruption": 0.40
	},
	"latvia": {
		"population": 1886198,
		"median_age": 43.0,
		"size": 64559.0,
		"corruption": 0.70
	},
	"liechtenstein": {
		"population": 38128,
		"median_age": 44.0,
		"size": 160.0,
		"corruption": 0.90
	},
	"lithuania": {
		"population": 2722289,
		"median_age": 45.0,
		"size": 65300.0,
		"corruption": 0.70
	},
	"luxembourg": {
		"population": 645397,
		"median_age": 39.0,
		"size": 2586.0,
		"corruption": 0.80
	},
	"malta": {
		"population": 514000,
		"median_age": 42.0,
		"size": 316.0,
		"corruption": 0.80
	},
	"moldova": {
		"population": 2657637,
		"median_age": 39.0,
		"size": 33846.0,
		"corruption": 0.42
	},
	"monaco": {
		"population": 39242,
		"median_age": 52.0,
		"size": 2.0,
		"corruption": 0.90
	},
	"montenegro": {
		"population": 622359,
		"median_age": 40.0,
		"size": 13812.0,
		"corruption": 0.50
	},
	"netherlands": {
		"population": 17441139,
		"median_age": 42.0,
		"size": 41850.0,
		"corruption": 0.80
	},
	"north_macedonia": {
		"population": 2083459,
		"median_age": 38.0,
		"size": 25713.0,
		"corruption": 0.40
	},
	"norway": {
		"population": 5421241,
		"median_age": 39.0,
		"size": 148729.0,
		"corruption": 0.90
	},
	"poland": {
		"population": 38386000,
		"median_age": 42.0,
		"size": 312696.0,
		"corruption": 0.70
	},
	"portugal": {
		"population": 10329506,
		"median_age": 45.0,
		"size": 92212.0,
		"corruption": 0.80
	},
	"romania": {
		"population": 19237691,
		"median_age": 43.0,
		"size": 238397.0,
		"corruption": 0.60
	},
	"san_marino": {
		"population": 33931,
		"median_age": 50.0,
		"size": 61.0,
		"corruption": 0.90
	},
	"serbia": {
		"population": 8772235,
		"median_age": 43.0,
		"size": 77474.0,
		"corruption": 0.50
	},
	"slovakia": {
		"population": 5456362,
		"median_age": 41.0,
		"size": 49035.0,
		"corruption": 0.60
	},
	"slovenia": {
		"population": 2078654,
		"median_age": 45.0,
		"size": 20273.0,
		"corruption": 0.80
	},
	"spain": {
		"population": 46719142,
		"median_age": 44.0,
		"size": 505992.0,
		"corruption": 0.70
	},
	"sweden": {
		"population": 10379295,
		"median_age": 41.0,
		"size": 450295.0,
		"corruption": 0.85
	},
	"switzerland": {
		"population": 8715496,
		"median_age": 43.0,
		"size": 41284.0,
		"corruption": 0.90
	},
	"turkey": {
		"population": 85000000,
		"median_age": 32.0,
		"size": 783562.0,
		"corruption": 0.39
	},
	"ukraine": {
		"population": 41660982,
		"median_age": 41.0,
		"size": 603550.0,
		"corruption": 0.35
	},
	"united_kingdom": {
		"population": 68000000,
		"median_age": 40.5,
		"size": 243610.0,
		"corruption": 0.77
	},
	"vatican_city": {
		"population": 825,
		"median_age": 47.0,
		"size": 0.44,
		"corruption": 0.95
	},
	"usa": {
	"population": 347275807,
	"median_age": 38.9,
	"size": 9835170,
	"corruption": 0.67
  },
  "canada": {
	"population": 40126723,
	"median_age": 41.1,
	"size": 9984670,
	"corruption": 0.74
  },
  "mexico": {
	"population": 131946900,
	"median_age": 29.3,
	"size": 1964375,
	"corruption": 0.28
  },
  "guatemala": {
	"population": 18687881,
	"median_age": 21.5,
	"size": 107160,
	"corruption": 0.26
  },
  "haiti": {
	"population": 11906095,
	"median_age": 23.1,
	"size": 27560,
	"corruption": 0.25
  },
  "dominican_republic": {
	"population": 11520487,
	"median_age": 28.2,
	"size": 48320,
	"corruption": 0.29
  },
  "honduras": {
	"population": 11005850,
	"median_age": 23.8,
	"size": 111890,
	"corruption": 0.28
  },
  "cuba": {
	"population": 10937203,
	"median_age": 42.4,
	"size": 106440,
	"corruption": 0.47
  },
  "nicaragua": {
	"population": 7007502,
	"median_age": 26.6,
	"size": 120340,
	"corruption": 0.29
  },
  "panama": {
	"population": 5070000,
	"median_age": 29.3,
	"size": 75417,
	"corruption": 0.38
  },
  "belize": {
	"population": 465000,
	"median_age": 26.5,
	"size": 22966,
	"corruption": 0.30
  },
  "costa_rica": {
	"population": 5191000,
	"median_age": 32.5,
	"size": 51100,
	"corruption": 0.58
  },
  "el_salvador": {
	"population": 6351000,
	"median_age": 26.1,
	"size": 21041,
	"corruption": 0.38
  },
  "dominica": {
	"population": 63200,
	"median_age": 36.9,
	"size": 751,
	"corruption": 0.52
  },
  "barbados": {
	"population": 263700,
	"median_age": 40.2,
	"size": 430,
	"corruption": 0.58
  },
  "saint_kitts_and_nevis": {
	"population": 53100,
	"median_age": 33.4,
	"size": 261,
	"corruption": 0.55
  },
  "saint_lucia": {
	"population": 183600,
	"median_age": 34.3,
	"size": 616,
	"corruption": 0.54
  },
  "saint_vincent_and_the_grenadines": {
	"population": 110000,
	"median_age": 32.8,
	"size": 389,
	"corruption": 0.52
  },
  "trinidad_and_tobago": {
	"population": 1400000,
	"median_age": 34.5,
	"size": 5128,
	"corruption": 0.40
  },
  "antigua_and_barbuda": {
	"population": 103600,
	"median_age": 33.5,
	"size": 443,
	"corruption": 0.50
  },
  "bahamas": {
	"population": 409000,
	"median_age": 31.6,
	"size": 13880,
	"corruption": 0.60
  },
  "grenada": {
	"population": 116400,
	"median_age": 34.1,
	"size": 344,
	"corruption": 0.56
  },

  "colombia": {
	"population": 53425635,
	"median_age": 32.2,
	"size": 1141748,
	"corruption": 0.39
  },
  "argentina": {
	"population": 45851378,
	"median_age": 32.0,
	"size": 2780400,
	"corruption": 0.38
  },
  "peru": {
	"population": 34576665,
	"median_age": 30.2,
	"size": 1285216,
	"corruption": 0.38
  },
  "venezuela": {
	"population": 28767104,
	"median_age": 29.5,
	"size": 916445,
	"corruption": 0.15
  },
  "chile": {
	"population": 19116209,
	"median_age": 35.4,
	"size": 756102,
	"corruption": 0.67
  },
  "ecuador": {
	"population": 18456126,
	"median_age": 26.8,
	"size": 283561,
	"corruption": 0.39
  },
  "bolivia": {
	"population": 11830742,
	"median_age": 25.7,
	"size": 1098581,
	"corruption": 0.29
  },
  "paraguay": {
	"population": 7132530,
	"median_age": 26.1,
	"size": 406752,
	"corruption": 0.29
  },
  "suriname": {
	"population": 652000,
	"median_age": 31.2,
	"size": 163820,
	"corruption": 0.30
  },
  "uruguay": {
	"population": 3477000,
	"median_age": 34.4,
	"size": 176215,
	"corruption": 0.71
  },
  "guyana": {
	"population": 786000,
	"median_age": 27.5,
	"size": 214969,
	"corruption": 0.28
  },
  "french_guiana": {
	"population": 300000,
	"median_age": 25.0,
	"size": 83534,
	"corruption": 0.38
  },
	 "algeria": {"population": 46400000, "median_age": 30.0, "size": 2381741.0, "corruption": 0.36},
	  "angola": {"population": 32866272, "median_age": 16.0, "size": 1246700.0, "corruption": 0.20},
	  "benin": {"population": 12123200, "median_age": 19.0, "size": 112622.0, "corruption": 0.416},
	  "botswana": {"population": 2141206, "median_age": 24.0, "size": 581730.0, "corruption": 0.60},
	  "burkina_faso": {"population": 23300000, "median_age": 17.0, "size": 272967.0, "corruption": 0.41},
	  "burundi": {"population": 10114505, "median_age": 17.0, "size": 27834.0, "corruption": 0.30},
	  "cabo_verde": {"population": 531239, "median_age": 30.0, "size": 4033.0, "corruption": 0.58},
	  "cameroon": {"population": 22709892, "median_age": 18.0, "size": 475442.0, "corruption": 0.28},
	  "central_african_republic": {"population": 4998000, "median_age": 18.0, "size": 622984.0, "corruption": 0.29},
	  "chad": {"population": 14497000, "median_age": 16.0, "size": 1284000.0, "corruption": 0.28},
	  "comoros": {"population": 806153, "median_age": 19.0, "size": 2235.0, "corruption": 0.30},
	  "congo_democratic_republic": {"population": 102000000, "median_age": 17.0, "size": 2344858.0, "corruption": 0.18},
	  "congo_republic": {"population": 4741000, "median_age": 19.0, "size": 342000.0, "corruption": 0.28},
	  "djibouti": {"population": 900000, "median_age": 27.0, "size": 23200.0, "corruption": 0.47},
	  "egypt": {"population": 104000000, "median_age": 24.0, "size": 1002450.0, "corruption": 0.35},
	  "equatorial_guinea": {"population": 1402985, "median_age": 26.0, "size": 28051.0, "corruption": 0.24},
	  "eritrea": {"population": 3500000, "median_age": 18.0, "size": 117600.0, "corruption": 0.28},
	  "eswatini": {"population": 1200000, "median_age": 21.0, "size": 17364.0, "corruption": 0.42},
	  "ethiopia": {"population": 126000000, "median_age": 19.0, "size": 1104300.0, "corruption": 0.26},
	  "gabon": {"population": 2130000, "median_age": 24.0, "size": 267668.0, "corruption": 0.36},
	  "gambia": {"population": 2400000, "median_age": 18.0, "size": 11295.0, "corruption": 0.29},
	  "ghana": {"population": 34581288, "median_age": 21.0, "size": 238533.0, "corruption": 0.377},
	  "guinea": {"population": 13400000, "median_age": 18.0, "size": 245857.0, "corruption": 0.28},
	  "guinea_bissau": {"population": 2000000, "median_age": 19.0, "size": 36125.0, "corruption": 0.28},
	  "ivory_coast": {"population": 27000000, "median_age": 19.0, "size": 322463.0, "corruption": 0.416},
	  "kenya": {"population": 53771296, "median_age": 20.0, "size": 580367.0, "corruption": 0.30},
	  "lesotho": {"population": 2000000, "median_age": 24.0, "size": 30355.0, "corruption": 0.42},
	  "liberia": {"population": 5000000, "median_age": 18.0, "size": 111369.0, "corruption": 0.29},
	  "libya": {"population": 7000000, "median_age": 29.0, "size": 1759540.0, "corruption": 0.35},
	  "madagascar": {"population": 27691018, "median_age": 19.0, "size": 587041.0, "corruption": 0.28},
	  "malawi": {"population": 19000000, "median_age": 18.0, "size": 118484.0, "corruption": 0.28},
	  "mali": {"population": 24000000, "median_age": 16.0, "size": 1240192.0, "corruption": 0.28},
	  "mauritania": {"population": 4600000, "median_age": 19.0, "size": 1030700.0, "corruption": 0.28},
	  "mauritius": {"population": 1265000, "median_age": 37.0, "size": 2040.0, "corruption": 0.58},
	  "morocco": {"population": 37000000, "median_age": 29.0, "size": 710850.0, "corruption": 0.39},
	  "mozambique": {"population": 30000000, "median_age": 17.0, "size": 801590.0, "corruption": 0.28},
	  "namibia": {"population": 2600000, "median_age": 21.0, "size": 825615.0, "corruption": 0.42},
	  "niger": {"population": 25000000, "median_age": 14.8, "size": 1267000.0, "corruption": 0.28},
	  "nigeria": {"population": 223800000, "median_age": 18.0, "size": 923768.0, "corruption": 0.28},
	  "rwanda": {"population": 13000000, "median_age": 20.0, "size": 26338.0, "corruption": 0.28},
	  "senegal": {"population": 18000000, "median_age": 19.0, "size": 196722.0, "corruption": 0.416},
	  "seychelles": {"population": 98000, "median_age": 38.0, "size": 455.0, "corruption": 0.58},
	  "sierra_leone": {"population": 8000000, "median_age": 19.0, "size": 71740.0, "corruption": 0.28},
	  "south_africa": {"population": 60000000, "median_age": 27.0, "size": 1219090.0, "corruption": 0.41},
	  "south_sudan": {"population": 12000000, "median_age": 18.0, "size": 619745.0, "corruption": 0.08},
	  "sudan": {"population": 40000000, "median_age": 20.0, "size": 1861484.0, "corruption": 0.28},
	  "tanzania": {"population": 59000000, "median_age": 18.0, "size": 945087.0, "corruption": 0.28},
	  "togo": {"population": 8000000, "median_age": 19.0, "size": 56785.0, "corruption": 0.28},
	  "tunisia": {"population": 11800000, "median_age": 32.0, "size": 163610.0, "corruption": 0.45},
	  "uganda": {"population": 46000000, "median_age": 16.0, "size": 241038.0, "corruption": 0.28},
	  "zambia": {"population": 18000000, "median_age": 17.0, "size": 752612.0, "corruption": 0.28},
	  "zimbabwe": {"population": 15000000, "median_age": 20.0, "size": 390757.0, "corruption": 0.28},
	  "afghanistan": {"population": 40218234, "median_age": 18.0, "size": 652230.0, "corruption": 0.02},
	  "bahrain": {"population": 1701583, "median_age": 38.0, "size": 765.0, "corruption": 0.45},
	  "bangladesh": {"population": 168304408, "median_age": 27.0, "size": 147570.0, "corruption": 0.26},
	  "bhutan": {"population": 779000, "median_age": 38.0, "size": 38394.0, "corruption": 0.28},
	  "brunei": {"population": 453000, "median_age": 32.0, "size": 5765.0, "corruption": 0.52},
	  "burma": {"population": 54800000, "median_age": 29.0, "size": 676578.0, "corruption": 0.20},
	  "cambodia": {"population": 16718971, "median_age": 25.0, "size": 181035.0, "corruption": 0.28},
	  "china": {"population": 1411778724, "median_age": 38.4, "size": 9596961.0, "corruption": 0.40},
	  "india": {"population": 1393409038, "median_age": 28.4, "size": 3287263.0, "corruption": 0.39},
	  "indonesia": {"population": 273523615, "median_age": 30.2, "size": 1904569.0, "corruption": 0.34},
	  "iran": {"population": 83992949, "median_age": 32.0, "size": 1648195.0, "corruption": 0.26},
	  "iraq": {"population": 40222503, "median_age": 20.0, "size": 438317.0, "corruption": 0.16},
	  "israel": {"population": 8655535, "median_age": 30.5, "size": 22072.0, "corruption": 0.59},
	  "jordan": {"population": 10203134, "median_age": 22.0, "size": 89342.0, "corruption": 0.47},
	  "kazakhstan": {"population": 18776707, "median_age": 31.0, "size": 2724900.0, "corruption": 0.40},
	  "korea_north": {"population": 25778816, "median_age": 34.0, "size": 120538.0, "corruption": 0.02},
	  "korea_south": {"population": 51329899, "median_age": 43.0, "size": 100032.0, "corruption": 0.61},
	  "kuwait": {"population": 4270563, "median_age": 32.0, "size": 17818.0, "corruption": 0.47},
	  "kyrgyzstan": {"population": 6524195, "median_age": 26.0, "size": 199951.0, "corruption": 0.38},
	  "laos": {"population": 7275560, "median_age": 23.0, "size": 237955.0, "corruption": 0.30},
	  "lebanon": {"population": 6825445, "median_age": 30.0, "size": 10452.0, "corruption": 0.28},
	  "malaysia": {"population": 32365999, "median_age": 30.0, "size": 330803.0, "corruption": 0.50},
	  "maldives": {"population": 521000, "median_age": 30.0, "size": 298.0, "corruption": 0.57},
	  "mongolia": {"population": 3278290, "median_age": 28.0, "size": 1564116.0, "corruption": 0.45},
	  "nepal": {"population": 29136808, "median_age": 24.0, "size": 147516.0, "corruption": 0.28},
	  "oman": {"population": 5106622, "median_age": 25.0, "size": 309500.0, "corruption": 0.46},
	  "pakistan": {"population": 225199937, "median_age": 23.0, "size": 881913.0, "corruption": 0.28},
	  "palestine": {"population": 5130000, "median_age": 20.0, "size": 6020.0, "corruption": 0.28},
	  "philippines": {"population": 113866000, "median_age": 24.0, "size": 300000.0, "corruption": 0.28},
	  "qatar": {"population": 2881053, "median_age": 32.0, "size": 11571.0, "corruption": 0.47},
	  "russia": {"population": 145912025, "median_age": 39.0, "size": 17098242.0, "corruption": 0.28},
	  "saudi_arabia": {"population": 34813871, "median_age": 31.0, "size": 2149690.0, "corruption": 0.46},
	  "singapore": {"population": 5638676, "median_age": 42.0, "size": 728.0, "corruption": 0.83},
	  "sri_lanka": {"population": 21413249, "median_age": 34.0, "size": 65610.0, "corruption": 0.28},
	  "syria": {"population": 17500657, "median_age": 24.0, "size": 185180.0, "corruption": 0.16},
	  "taiwan": {"population": 23816775, "median_age": 42.0, "size": 36193.0, "corruption": 0.68},
	  "tajikistan": {"population": 9537645, "median_age": 23.0, "size": 143100.0, "corruption": 0.24},
	  "thailand": {"population": 69950800, "median_age": 40.0, "size": 513120.0, "corruption": 0.42},
	  "timor_leste": {"population": 1318445, "median_age": 19.0, "size": 14874.0, "corruption": 0.28},
	  "turkmenistan": {"population": 6031187, "median_age": 28.0, "size": 488100.0, "corruption": 0.16},
	  "united_arab_emirates": {"population": 9770529, "median_age": 33.0, "size": 83600.0, "corruption": 0.47},
	  "uzbekistan": {"population": 33469203, "median_age": 30.0, "size": 447400.0, "corruption": 0.28},
	  "vietnam": {"population": 98168829, "median_age": 32.0, "size": 331210.0, "corruption": 0.28},
	  "yemen": {"population": 29825968, "median_age": 19.0, "size": 527968.0, "corruption": 0.16},
	  "australia": {
		"population": 26974026,
		"median_age": 38.0,
		"size": 7682300.0,
		"corruption": 0.77
	  },
	  "papua_new_guinea": {
		"population": 10762817,
		"median_age": 23.0,
		"size": 462860.0,
		"corruption": 0.18
	  },
	  "new_zealand": {
		"population": 5251899,
		"median_age": 38.0,
		"size": 263310.0,
		"corruption": 0.91
	  },
	  "fiji": {
		"population": 933154,
		"median_age": 28.0,
		"size": 18274.0,
		"corruption": 0.49
	  },
	  "solomon_islands": {
		"population": 838645,
		"median_age": 19.0,
		"size": 28896.0,
		"corruption": 0.28
	  },
	  "vanuatu": {
		"population": 335169,
		"median_age": 23.0,
		"size": 12189.0,
		"corruption": 0.28
	  },
	  "samoa": {
		"population": 219306,
		"median_age": 22.0,
		"size": 2842.0,
		"corruption": 0.28
	  },
	  "kiribati": {
		"population": 136488,
		"median_age": 22.0,
		"size": 811.0,
		"corruption": 0.28
	  },
	  "micronesia": {
		"population": 113683,
		"median_age": 23.0,
		"size": 702.0,
		"corruption": 0.28
	  },
	  "tonga": {
		"population": 103742,
		"median_age": 23.0,
		"size": 747.0,
		"corruption": 0.28
	  },
	  "palau": {
		"population": 18000,
		"median_age": 30.0,
		"size": 459.0,
		"corruption": 0.28
	  },
	  "marshall_islands": {
		"population": 59194,
		"median_age": 23.0,
		"size": 181.0,
		"corruption": 0.28
	  },
	  "nauru": {
		"population": 10824,
		"median_age": 25.0,
		"size": 21.0,
		"corruption": 0.28
	  },
	  "tuvalu": {
		"population": 11792,
		"median_age": 30.0,
		"size": 26.0,
		"corruption": 0.28
	  }
	}
