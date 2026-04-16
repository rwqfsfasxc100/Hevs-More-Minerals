extends Node

const Forsterite = {
	"name":"Mg2SiO4",
	"price":2.8,
	"color":Color("#3d6c06"),
	"handle":"recolor",
	"base":"be",
	"mass":20.0,
	"filler":"H2O",
	"min_scale":0.75,
	"max_scale":1.0,
	"purity":{
		1:0.52,
		2:0.58,
		3:0.64,
		4:0.71,
		5:0.77,
		6:0.83,
		7:0.89
	},
	
}
const Fayalite = {
	"name":"Fe2SiO4",
	"price":2.6,
	"color":Color("#875745"),
	"handle":"recolor",
	"base":"w",
	"mass":25.0,
	"filler":"H2O",
	"min_scale":0.75,
	"max_scale":1.0,
	"purity":{
		1:0.51,
		2:0.56,
		3:0.61,
		4:0.66,
		5:0.72,
		6:0.78,
		7:0.84
	},
	
}
const Diopside = {
	"name":"MgCaSi2O6",
	"price":4.6,
	"color":Color("#a0c702"),
	"handle":"recolor",
	"base":"pd",
	"mass":18.0,
	"filler":"H2O",
	"min_scale":0.75,
	"max_scale":1.0,
	"purity":{
		1:0.53,
		2:0.58,
		3:0.64,
		4:0.69,
		5:0.75,
		6:0.81,
		7:0.86
	},
	
}
const Jadeite = {
	"name":"NaAlSi2O6",
	"price":5.1,
	"color":Color("#73c9a0"),
	"handle":"recolor",
	"base":"pd",
	"mass":15.0,
	"filler":"H2O",
	"min_scale":0.75,
	"max_scale":1.0,
	"purity":{
		1:0.47,
		2:0.53,
		3:0.59,
		4:0.65,
		5:0.71,
		6:0.77,
		7:0.83
	},
	
}
const Johannsenite = {
	"name":"CaMn2Si2O6",
	"price":4.9,
	"color":Color("#9fc2b4"),
	"handle":"recolor",
	"base":"pd",
	"mass":23.0,
	"filler":"H2O",
	"min_scale":0.75,
	"max_scale":1.0,
	"purity":{
		1:0.48,
		2:0.54,
		3:0.6,
		4:0.66,
		5:0.72,
		6:0.78,
		7:0.84
	},
	
}
const Kosmochlor = {
	"name":"NaCr3Si2O6",
	"price":7.3,
	"color":Color("#2f4737"),
	"handle":"recolor",
	"base":"pd",
	"mass":14.0,
	"filler":"H2O",
	"min_scale":0.75,
	"max_scale":1.0,
	"purity":{
		1:0.46,
		2:0.52,
		3:0.58,
		4:0.64,
		5:0.7,
		6:0.76,
		7:0.82
	},
	
}
const Namansilite = {
	"name":"NaMn3Si2O6",
	"price":4.8,
	"color":Color("#934d55"),
	"handle":"recolor",
	"base":"fe",
	"mass":21.0,
	"filler":"H2O",
	"min_scale":0.75,
	"max_scale":1.0,
	"purity":{
		1:0.49,
		2:0.55,
		3:0.61,
		4:0.67,
		5:0.73,
		6:0.79,
		7:0.85
	},
	
}
const Natalyite = {
	"name":"NaV3Si2O6",
	"price":7.4,
	"color":Color("#535353"),
	"handle":"recolor",
	"base":"v",
	"mass":16.0,
	"filler":"H2O",
	"min_scale":0.75,
	"max_scale":1.0,
	"purity":{
		1:0.45,
		2:0.51,
		3:0.57,
		4:0.63,
		5:0.69,
		6:0.75,
		7:0.81
	},
	
}
const Spodumene = {
	"name":"LiAl(SiO3)2",
	"price":15.8,
	"color":Color("#829aa6"),
	"handle":"recolor",
	"base":"v",
	"mass":12.0,
	"filler":"H2O",
	"min_scale":0.75,
	"max_scale":1.0,
	"purity":{
		1:0.44,
		2:0.5,
		3:0.56,
		4:0.62,
		5:0.68,
		6:0.74,
		7:0.8
	},
	
}
const Enstatite = {
	"name":"MgSiO3",
	"price":2.4,
	"color":Color("#cb7c2e"),
	"handle":"recolor",
	"base":"w",
	"mass":19.0,
	"filler":"H2O",
	"min_scale":0.75,
	"max_scale":1.0,
	"purity":{
		1:0.48,
		2:0.54,
		3:0.6,
		4:0.66,
		5:0.72,
		6:0.78,
		7:0.84
	},
	
}
const Quartz = {
	"name":"SiO2",
	"price":3.0,
	"color":Color("#f3fcfc"),
	"handle":"recolor",
	"base":"be",
	"mass":24.0,
	"filler":"H2O",
	"min_scale":0.75,
	"max_scale":1.0,
	"purity":{
		1:0.3,
		2:0.38,
		3:0.46,
		4:0.54,
		5:0.62,
		6:0.7,
		7:0.78
	},
	
}
const Cristobalite = {
	"name":"SiO2 (Crs)",
	"price":6.2,
	"color":Color("#dafcfc"),
	"handle":"recolor",
	"base":"be",
	"mass":22.0,
	"filler":"H2O",
	"min_scale":0.5,
	"max_scale":1.0,
	"purity":{
		1:0.4,
		2:0.48,
		3:0.56,
		4:0.64,
		5:0.72,
		6:0.8,
		7:0.88
	},

}
const Tridymite = {
	"name":"SiO2 (Trd)",
	"price":9.5,
	"color":Color("#c0d7ed"),
	"handle":"recolor",
	"base":"be",
	"mass":20.0,
	"filler":"H2O",
	"min_scale":0.35,
	"max_scale":0.75,
	"purity":{
		1:0.5,
		2:0.58,
		3:0.66,
		4:0.74,
		5:0.82,
		6:0.9,
		7:0.98
	},

}
const Albite = {
	"name":"NaAlSi3O8",
	"price":6.7,
	"color":Color("#bcb29c"),
	"handle":"recolor",
	"base":"pt",
	"mass":17.0,
	"filler":"H2O",
	"min_scale":0.75,
	"max_scale":1.0,
	"purity":{
		1:0.35,
		2:0.42,
		3:0.49,
		4:0.56,
		5:0.63,
		6:0.7,
		7:0.77
	},
	
}
const Anorthite = {
	"name":"CaAl2Si2O8",
	"price":7.9,
	"color":Color("#eb864d"),
	"handle":"recolor",
	"base":"v",
	"mass":26.0,
	"filler":"H2O",
	"min_scale":0.75,
	"max_scale":1.0,
	"purity":{
		1:0.38,
		2:0.45,
		3:0.52,
		4:0.59,
		5:0.66,
		6:0.73,
		7:0.8
	},
	
}
const Orthoclase = {
	"name":"KAlSi3O8",
	"price":6.6,
	"color":Color("#c5b0a9"),
	"handle":"recolor",
	"base":"fe",
	"mass":28.0,
	"filler":"H2O",
	"min_scale":0.75,
	"max_scale":1.0,
	"purity":{
		1:0.34,
		2:0.41,
		3:0.48,
		4:0.55,
		5:0.62,
		6:0.69,
		7:0.76
	},
	
}

const Gold = {
	"name":"Au",
	"price":8.2,
	"color":Color("#e6cf00"),
	"handle":"recolor",
	"base":"w",
	"mass":12.0,
	"filler":"H2O",
	"min_scale":0.75,
	"max_scale":1.0,
	"purity":{
		1:0.05,
		2:0.15,
		3:0.25,
		4:0.35,
		5:0.45,
		6:0.55,
		7:0.65
	},
	
}
const Copper = {
	"name":"Cu",
	"price":1.6,
	"color":Color("#d48237"),
	"handle":"recolor",
	"base":"fe",
	"mass":27.0,
	"filler":"H2O",
	"min_scale":0.75,
	"max_scale":1.0,
	"purity":{
		1:0.45,
		2:0.5,
		3:0.55,
		4:0.6,
		5:0.65,
		6:0.7,
		7:0.75
	},
	
}
const Magnesium = {
	"name":"Mg",
	"price":0.8,
	"color":Color("#5DA87C"),
	"handle":"recolor",
	"base":"pt",
	"mass":12.0,
	"filler":"H2O",
	"min_scale":0.75,
	"max_scale":1.0,
	"purity":{
		1:0.7,
		2:0.74,
		3:0.78,
		4:0.82,
		5:0.86,
		6:0.9,
		7:0.94
	},
	
}
const Nickel = {
	"name":"Ni",
	"price":1.1,
	"color":Color("#ccc3a7"),
	"handle":"recolor",
	"base":"pt",
	"mass":31.0,
	"filler":"H2O",
	"min_scale":0.75,
	"max_scale":1.0,
	"purity":{
		1:0.5,
		2:0.54,
		3:0.58,
		4:0.62,
		5:0.66,
		6:0.7,
		7:0.74
	},
	
}
const Rhenium = {
	"name":"Re",
	"price":16.3,
	"color":Color("#5E5E5E"),
	"handle":"recolor",
	"base":"fe",
	"mass":25.0,
	"filler":"H2O",
	"min_scale":0.75,
	"max_scale":1.0,
	"purity":{
		1:0.08,
		2:0.1,
		3:0.13,
		4:0.17,
		5:0.22,
		6:0.28,
		7:0.35
	},
	
}
const Titanium = {
	"name":"Ti",
	"price":4.3,
	"color":Color("#9797c2"),
	"handle":"recolor",
	"base":"v",
	"mass":7.0,
	"filler":"H2O",
	"min_scale":0.75,
	"max_scale":1.0,
	"purity":{
		1:0.62,
		2:0.66,
		3:0.72,
		4:0.78,
		5:0.84,
		6:0.9,
		7:0.96
	},
	
}
