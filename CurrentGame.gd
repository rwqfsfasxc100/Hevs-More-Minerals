extends "res://CurrentGame.gd"

#Reference numbers
#var mineralPrices = {
#	"H2O":0.1, 
#	"Be":20.5, 
#	"Fe":0.9, 
#	"Pd":2.5, 
#	"Pt":2.7, 
#	"V":3.0, 
#	"W":6.5
#}


# Merge the modded minerals with the vanilla ones
func _ready():
	#The prices of the minerals
	mineralPrices.merge({
#	"H2O": 0.25,
	
	"Au" : 8.2,
	"Cu" : 1.6,
	"Mg" : 0.8,
	"Ni" : 1.1,
	"Re" : 16.3,
	"Ti" : 4.3,
	"Fo" : 2.8, # Forsterite
	"Fa" : 2.6, # Fayalite
	"Di" : 4.6, # Diopside
	"Jd" : 5.1, # Jadeite
	"Jhn" : 4.9, # Johannsenite
	"Kos" : 7.3, # Kosmochlor
	"Nms": 4.8, # Namansilite
	"Nta": 7.4, # Natalyite
	"Spd": 15.8, # Spodumene
	"En": 2.4, # Enstatite
	"Qz": 3.0, # Quartz
	"Crs": 6.2, # Cristobalite
	"Trd": 9.5, # Tridymite
	"Ab": 6.7, # Albite
	"An": 7.9, # Anorthite
	"Or": 6.6, # Orthoclase
})

	#What color the minerals will be on the HUD/Market
	specificMineralColors.merge({
	"Au":Color("e6cf00"),
	"Cu":Color("d48237"),
	"Mg":Color("5DA87C"),
	"Ni":Color("ccc3a7"),
	"Re":Color("5E5E5E"),
	"Ti":Color("9797c2"),
	
	
	"Fo": Color("#3d6c06"), # Forsterite
	"Fa": Color("#875745"), # Fayalite
	"Di": Color("#a0c702"), # Diopside
	"Jd": Color("#73c9a0"), # Jadeite
	"Jhn": Color("#9fc2b4"), # Johannsenite	
	"Kos": Color("#2f4737"), # Kosmochlor
	"Nms": Color("#934d55"), # Namansilite
	"Nta": Color("#535353"), # Natalyite
	"Spd": Color("#829aa6"), # Spodumene
	"En": Color("#cb7c2e"), # Enstatite
	"Qz": Color("#f3fcfc"), # Quartz
	"Crs": Color("#dafcfc"), # Cristobalite
	"Trd": Color("#c0d7ed"), # Tridymite
	"Ab": Color("#bcb29c"), # Albite
	"An": Color("#eb864d"), # Anorthite
	"Or": Color("#c5b0a9"), # Orthoclase

})

	#Adds the minerals to the list of minerals that can be found in roids
	traceMinerals.append_array([
	"Au", #Similar in price to W, but with smaller average chunks
	"Cu", #Fills the gap between Fe and the valuable ones
	"Mg", #Light but very inexpensive
	"Ni", #Slightly more valuable but less common than Fe
	"Re", #Very valuable, but very impure. High water content makes it harder to process, but not fly away like Be
	"Ti", #Lighter than most, slightly more expensive than normal
	"Fo", # Forsterite
	"Fa", # Fayalite
	"Di", # Diopside
	"Jd", # Jadeite
	"Jhn", # Johannsenite
	"Kos", # Kosmochlor
	"Nms", # Namansilite
	"Nta", # Natalyite
	"Spd", # Spodumene
	"En", # Enstatite
	"Qz", # Quartz
	"Crs", # Cristobalite
	"Trd", # Tridymite
	"Ab", # Albite
	"An", # Anorthite
	"Or" # Orthoclase
])
