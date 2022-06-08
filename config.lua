Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

Config                  = {}
Config.KeyToUse         = Keys["E"]   --The key bounded to use all the interactions
Config.Job              = "slaughter"    

--COWS
Config.MilkToGive       = 25 --How much milk a cow will give
Config.Payment          = 12 --How much payment is a person gonna get for each 10 liters aprox.
Config.MaxMilkToCarry   = 100 --How much a bucket can carry
Config.MinMilkToProcess = 50 --How much milk is mininum to have so we can pour it in our machine
Config.TimeToTakeMilk   = (5) * 1000 --Time to take milk in seconds, REPLACE INSIDE PARENTHESIS 
Config.TimeToProcessMilk= (5) * 1000 --Time to take milk in seconds, REPLACE INSIDE PARENTHESIS 
--PIGS
Config.FoodToGive       = 100 --How much food is the bag gonna have
Config.PigsPayment      = 120 --How much payment is a person gonna get for feeding the pigs
Config.TimeToSearchFood = (5) * 1000 --Time To Search Food in seconds, REPLACE INSIDE PARENTHESIS 
Config.TimeToPourFood   = (5) * 1000 --Time to pour food in seconds, REPLACE INSIDE PARENTHESIS 

Config.Locations = {
	Vacas = { -- Where is gonna be each cow
		V1 = {
			x = 2427.495, y = 4751.439, z = 33.35, head = 46.16,
		},
		V2 = {
			x = 2429.077, y = 4753.033, z = 33.35, head = 46.16,
		},
		V3 = {
			x = 2425.781, y = 4749.655, z = 33.35, head = 46.16,
		},
		V4 = {
			x = 2423.790, y = 4747.597, z = 33.35, head = 46.16,
		},
	},
	MilkMachine = { -- Where the milk machine is gonna be
		x = 2500.960, y =  4800.750, z = 34.740,
	},



	--PIGS
	Cerdos = {
		C1 = {
			x = 2461.984, y = 4777.471, z = 33.45, head = 313.15,
		},
		C2 = {
			x = 2460.937, y = 4778.376, z = 33.45, head = 313.15,
		},
		C3 = {
			x = 2459.826, y = 4779.513, z = 33.45, head = 313.15,
		},
		C4 = {
			x = 2458.792, y = 4780.538, z = 33.45, head = 313.15,
		},
	},

	FeedPoint = {
		Barrel = {
			model = "prop_wooden_barrel",
			x = 2482.754, y = 4697.442, z = 33.936,
		},
		Marker = {
			x = 2484.960, y = 4700.806, z = 33.957,
		}
	},

	CerdosPoints = {
		P1 = {
			x = 2462.464, y = 4776.917, z = 34.471, used = false,
		},
		P2 = {
			x = 2461.584, y = 4778.064, z = 34.494, used = false,
		},
		P3 = {
			x = 2460.549, y = 4779.148, z = 34.517, used = false,
		},
		P4 = {
			x = 2459.430, y = 4780.174, z = 34.540, used = false,
		},
	},

	--CLOAKROOM
	Cloakroom = { 
		--PED
		npcmodel = "a_m_m_hillbilly_01",
		npcx = 2510.684, npcy = 4757.375, npcz = 34.303, npchead = 45.50,
		--TEXT AND MARKER
		x = 2509.989, y = 4757.995, z = 34.303,
		text = "~w~[~p~E~w~] Para abrir el vestuario",
	},
	--CLOTHES
	Clothes = {
		male = {
			['tshirt_1'] = 15, ['tshirt_2'] = 0,
			['torso_1'] = 43, ['torso_2'] = 0,
			['arms'] = 37, ['arms_2'] = 0,
			['pants_1'] = 27, ['pants_2'] = 3,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['shoes_1'] = 4, ['shoes_2'] = 1
		},
		female = { 
			['tshirt_1'] = 57, ['tshirt_2'] = 0,
			['torso_1'] = 365, ['torso_2'] = 0,
			['arms'] = 3, ['arms_2'] = 0,
			['pants_1'] = 1, ['pants_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['shoes_1'] = 9, ['shoes_2'] = 0,
		},
	},

	--BLIPS
	Blips = {  --Some are requrired so the script can work!!
		BVacas = {
			Title="Vacas", 
			colour=4, 
			id=141, 
			x = 2423.232, y = 4753.343, z = 34.302,
		},
		BVestidor = {
			Title="Vestidor", 
			colour=4, 
			id=366,
			x = 2512.990, y = 4762.750, z = 34.90,
		},
		BMaquina = {
			Title="Maquina de lacteos", 
			colour=4, 
			id=402, 
			x = 2502.120, y = 4801.250, z = 43.740,
		},
		BCerdos = {
			Title="Cerdos",
			colour=4,
			id=214,
			x = 2457.775, y = 4776.867, z = 34.481,
		},
		BCerdosFood = {
			Title="Comida de cerdos",
			colour=4,
			id=214,
			x = 2482.754, y = 4697.442, z = 33.936,
		},
	},
}
