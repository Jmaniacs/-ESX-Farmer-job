ESX                         = nil
local PlayerData            = {}
local isInJoblistingMarkerr = false
local tieneCubo 			= false
local lecheEnCubo 			= 0
local cuboModel 			= "prop_bucket_02a"
local sacoModel  			= "bkr_prop_fakeid_binbag_01"
local inService             = true
local cuboEnPiso 			= false
local isInZone              = false
local cuboEnManos           = nil
--
local tieneComida           = false
local comidaCant            = 0


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	Citizen.Wait(5000)
	PlayerData = ESX.GetPlayerData()
end)
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
	
	Citizen.Wait(5000)
end)

RegisterNetEvent('nl_jobGranjero:CuboEnManoAnim')
AddEventHandler('nl_jobGranjero:CuboEnManoAnim', function()
	local ad = "anim@heists@box_carry@"
	loadAnimDict( ad )
	TaskPlayAnim( PlayerPedId(), ad, "idle", 3.0, -8, -1, 63, 0, 0, 0, 0 )
end)

RegisterNetEvent('nl_jobGranjero:OrdenarAnim')
AddEventHandler('nl_jobGranjero:OrdenarAnim', function()
	Citizen.Wait(100)
	--
	local ad = "anim@amb@business@weed@weed_inspecting_lo_med_hi@"
	loadAnimDict( ad )
	TaskPlayAnim( PlayerPedId(), ad, "weed_crouch_checkingleaves_idle_02_inspector", 3.0, -8, -1, 63, 0, 0, 0, 0 )
end)

RegisterNetEvent('nl_jobGranjero:IniciarOrdenar')
AddEventHandler('nl_jobGranjero:IniciarOrdenar', function(x, y, z)
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)
	local forward   = GetEntityForwardVector(playerPed)
	if tieneCubo == true then
		DetachEntity(cuboEnManos, 1, 1)
		DeleteObject(cuboEnManos)
		ESX.Game.DeleteObject(cuboEnManos)
		tieneCubo = false
	end
	if cuboEnPiso == false then
		cuboEnPiso = true
		ESX.Game.SpawnObject(cuboModel, {
		x = x+0.3,
		y = y-0.35,
		z = z-0.3
		}, function(obj)
			FreezeEntityPosition(playerPed, true)
			TriggerEvent("nl_jobGranjero:OrdenarAnim")
			SetEntityHeading(obj, GetEntityHeading(playerPed))
			PlaceObjectOnGroundProperly(obj)
			
			Citizen.Wait(Config.TimeToTakeMilk)

			DeleteObject(obj)
			cuboEnPiso = false
			FreezeEntityPosition(playerPed, false)
			if tieneCubo == false then
				local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
				cuboEnManos = CreateObject(GetHashKey(cuboModel), x, y, z+0.2,  true,  true, true)
				AttachEntityToEntity(cuboEnManos, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 60309), 0.025, -0.24, 0.355, -75.0, 470.0, 0.0, true, true, false, true, 1, true)
				TriggerEvent("nl_jobGranjero:CuboEnManoAnim")
				tieneCubo = true
				DisableControlAction(0,22,true)
			end
		end)
	end
end)

RegisterNetEvent('nl_jobGranjero:VertirLeche')
AddEventHandler('nl_jobGranjero:VertirLeche', function()
	local playerPed = GetPlayerPed(-1)
	FreezeEntityPosition(playerPed, true)
	TriggerEvent("nl_jobGranjero:OrdenarAnim")
	Citizen.Wait(Config.TimeToProcessMilk)
	
	DetachEntity(cuboEnManos, 1, 1)
	DeleteObject(cuboEnManos)
	ESX.Game.DeleteObject(cuboEnManos)
	DisableControlAction(0,22,false)
	FreezeEntityPosition(playerPed, false)
	ClearPedTasks(playerPed)

end)

--ORDEÑAR
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		local coords = GetEntityCoords(GetPlayerPed(-1))
		for _,info in pairs(Config.Locations.Vacas) do
			if (GetDistanceBetweenCoords(coords, info.x, info.y, info.z, true) < 7.0) then
				DrawText3Ds(info.x,info.y,info.z+1.4, 'PRESIONA ~w~[~p~E~w~] PARA ORDEÑAR VACA')
			end
			if(GetDistanceBetweenCoords(coords, info.x, info.y, info.z, true) < 1.6) then
				if IsControlJustReleased(0, Config.KeyToUse) then
					if ESX.GetPlayerData().job.name == Config.Job then
						if inService == true then
							if not tieneComida then
								if lecheEnCubo < Config.MaxMilkToCarry then
									TriggerEvent("nl_jobGranjero:IniciarOrdenar", info.x, info.y, info.z)
									exports['progressBars']:startUI(Config.TimeToTakeMilk, "Ordeñando vaca...")
									--
									Citizen.Wait(Config.TimeToTakeMilk)
									--
									lecheEnCubo = lecheEnCubo + Config.MilkToGive
									ESX.ShowNotification("¡Has recolectado "..Config.MilkToGive.." litros de leche!, Ahora tienes "..lecheEnCubo.." litros de leche en tu cubo.")
								else
									ESX.ShowNotification("¡Tu cubo ~r~no soporta más ~w~litros de leche!")
								end
							else
								ESX.ShowNotification("¡~r~No ~w~debes estar en proceso de ningun otro trabajo!")
							end
						else
							ESX.ShowNotification("¡~r~No estas de servicio~w~, ve en tu GPS donde esta el vestidor y cambiate de ropa!")
						end	
					else 
						ESX.ShowNotification("¡Hey ~r~no~w~ eres granjero, ~r~vete de aqui~w~!")
					end
				end
			end
		end
	end
end)

--MENU CLOAKROOM
Citizen.CreateThread(function()
	while true do
		Wait(0)
		local coords  = GetEntityCoords(GetPlayerPed(-1))
		if (GetDistanceBetweenCoords(coords, Config.Locations.Cloakroom.x, Config.Locations.Cloakroom.y, Config.Locations.Cloakroom.z, true) <= 15.0) then
			--ESX.Game.Utils.DrawText3Ds(x = Config.Locations.Cloakroom.x, y = Config.Locations.Cloakroom.y, z = Config.Locations.Cloakroom.z+1, Config.Locations.Cloakroom.text, 0.9)
			DrawText3Ds(Config.Locations.Cloakroom.x, Config.Locations.Cloakroom.y,Config.Locations.Cloakroom.z+1, Config.Locations.Cloakroom.text)
			DrawMarker(21, Config.Locations.Cloakroom.x, Config.Locations.Cloakroom.y, Config.Locations.Cloakroom.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.9, 0.9, 0.9, 76, 42, 130, 120, true, true, 2, nil, nil, false)
			if (GetDistanceBetweenCoords(coords, Config.Locations.Cloakroom.x, Config.Locations.Cloakroom.y, Config.Locations.Cloakroom.z, true) <= 2.0) then
				if IsControlJustReleased(0, Config.KeyToUse) then
					if ESX.GetPlayerData().job.name == Config.Job then
						local elements = {
							{ label = "Ropa de civil", value = "normal_clothes" },
							{ label = "Ropa de granjero", value = "job_clothes" },
						}
						ESX.UI.Menu.Open('default', GetCurrentResourceName(), "farmer_job_menu",
							{
								title    = "Vestuario de granjero",
								align    = "center",
								elements = elements
							},
						function(data, menu)
							if(data.current.value == 'normal_clothes') then
								--normal ropa
								ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
									TriggerEvent('skinchanger:loadSkin', skin)
									ESX.ShowNotification("Has salido de servicio")
								end)
								inService = false
								menu.close()
							end
							if(data.current.value == 'job_clothes') then
								--trabajo ropa
								ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
									if skin.sex == 0 then
										TriggerEvent('skinchanger:loadClothes', skin, Config.Locations.Clothes.male)
									else
										TriggerEvent('skinchanger:loadClothes', skin, Config.Locations.Clothes.female)
									end
									ESX.ShowNotification("Has entrado de servicio, ¡Ve a ordeñar vacas o a alimentar a los cerdos!")
								end)
								inService = true
								menu.close()
							end
							menu.close()
						end, function(data, menu)
							menu.close()
						end)
					else 
						ESX.ShowNotification("¡Hey ~r~no~w~ eres granjero, ~r~vete de aqui~w~!")
					end			
				end
			end
		end

		--VERTIR LECHE
		if(GetDistanceBetweenCoords(coords, Config.Locations.MilkMachine.x, Config.Locations.MilkMachine.y, Config.Locations.MilkMachine.z, true) <= 3.0) then
			ESX.ShowAdvancedNotification('Vertir Leche', '~y~Granja', 'PRESIONA ~y~[E] ~w~PARA PROCESAR LA LECHE.', 'CHAR_PROPERTY_SONAR_COLLECTIONS', 3)
			if IsControlJustReleased(0, Config.KeyToUse) then
				if ESX.GetPlayerData().job.name == Config.Job then
					if tieneCubo == true and inService == true then
						if not tieneComida then
							if lecheEnCubo >= Config.MinMilkToProcess then
								TriggerEvent("nl_jobGranjero:VertirLeche")
								exports['progressBars']:startUI(Config.TimeToProcessMilk, "Virtiendo leche...")
								--
								Citizen.Wait(Config.TimeToProcessMilk)
								--
								local payment = Config.Payment * (lecheEnCubo/10)
								TriggerServerEvent('nl_jobGranjero:DarPago', source, lecheEnCubo, payment)
								ESX.ShowNotification("¡Has procesado "..lecheEnCubo.." litros de leche!, Has ganado $"..payment.." dolares.")
								lecheEnCubo = 0
								tieneCubo = false
							else
								ESX.ShowNotification("¡La maquina no puede procesar tan poca leche! Ve a ordeñar más vacas")
							end
						else
							ESX.ShowNotification("¡Necesitas un cubo con leche para procesar leche! Ve a ordeñar vacas y obtendrás uno.")
						end
					else
						ESX.ShowNotification("¡Necesitas un cubo con leche para procesar leche! Ve a ordeñar vacas y obtendrás uno.")
					end
				else 
					ESX.ShowNotification("¡Hey ~r~no~w~ eres granjero, ~r~vete de aqui~w~!")
				end
			end	
		end			
	end
end)

RegisterNetEvent('nl_jobGranjero:BuscarAnim')
AddEventHandler('nl_jobGranjero:BuscarAnim', function()
	local ad = "anim@gangops@facility@servers@bodysearch@"
	loadAnimDict( ad )
	TaskPlayAnim( PlayerPedId(), ad, "player_search", 3.0, -8, -1, 63, 0, 0, 0, 0 )
end)

RegisterNetEvent('nl_jobGranjero:CrearSaco')
AddEventHandler('nl_jobGranjero:CrearSaco', function()
	local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
	if tieneComida == true then
		ESX.Game.SpawnObject(obj, {
		x = x+0.3,
		y = y-0.35,
		z = z-0.3
		}, function(obj)
			local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
			sacoDeComida = CreateObject(GetHashKey(sacoModel), x, y, z+0.2,  true,  true, true)
			TriggerEvent("nl_jobGranjero:CuboEnManoAnim")
			AttachEntityToEntity(sacoDeComida, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 60309), 0.025, -0.24, 0.355, -75.0, 470.0, 0.0, true, true, false, true, 1, true)
			comidaCant = 100
		end)
	end
end)

RegisterNetEvent('nl_jobGranjero:BotarAnim')
AddEventHandler('nl_jobGranjero:BotarAnim', function()
	local ad = "missfbi_s4mop"
	loadAnimDict( ad )
	TaskPlayAnim( PlayerPedId(), ad, "put_down_mop", 3.0, -8, -1, 63, 0, 0, 0, 0 )
end)


RegisterNetEvent('nl_jobGranjero:BorrarSaco')
AddEventHandler('nl_jobGranjero:BorrarSaco', function()
	DetachEntity(sacoDeComida, 1, 1)
	DeleteObject(sacoDeComida)
	ESX.Game.DeleteObject(sacoDeComida)
	tieneComida = false
	comidaCant = 0
	ClearPedTasks(GetPlayerPed(-1))
end)

RegisterNetEvent('nl_jobGranjero:PourAnim')
AddEventHandler('nl_jobGranjero:PourAnim', function()
	local ad = "creatures@crow@amb@world_crow_feeding@idle_a"
	loadAnimDict( ad )
	TaskPlayAnim( PlayerPedId(), ad, "idle_a", 3.0, -8, -1, 63, 0, 0, 0, 0 )
end)

--PIGS
Citizen.CreateThread(function()
	while true do
		Wait(0)
		if sacoDeComida and tieneComida then
			DrawText2Ds(0.45,0.9,"Presiona [~p~G~w~] para tirar al piso el saco")
			if IsControlJustReleased(0, Keys["G"]) then
				TriggerEvent("nl_jobGranjero:BotarAnim")
				Citizen.Wait(2000)
				TriggerEvent("nl_jobGranjero:BorrarSaco")
			end
		end
		local coords  = GetEntityCoords(GetPlayerPed(-1))
		if (GetDistanceBetweenCoords(coords, Config.Locations.FeedPoint.Barrel.x, Config.Locations.FeedPoint.Barrel.y, Config.Locations.FeedPoint.Barrel.z, true) <= 10.0) then
			DrawText3Ds(Config.Locations.FeedPoint.Barrel.x, Config.Locations.FeedPoint.Barrel.y,Config.Locations.FeedPoint.Barrel.z+0.7, "PRESIONA ~p~[E]~w~ PARA BUSCAR COMIDA DE CERDO")
			if (GetDistanceBetweenCoords(coords, Config.Locations.FeedPoint.Barrel.x, Config.Locations.FeedPoint.Barrel.y, Config.Locations.FeedPoint.Barrel.z, true) <= 1.2) then
				if IsControlJustReleased(0, Config.KeyToUse) then
					if ESX.GetPlayerData().job.name == Config.Job then
						if inService == true then
							if not tieneCubo then
								if tieneComida == false and comidaCant < 1 then
									--BUSCANDO COMIDA
									FreezeEntityPosition(GetPlayerPed(-1), true)
									TriggerEvent("nl_jobGranjero:BuscarAnim")
									exports['progressBars']:startUI(Config.TimeToSearchFood, "Buscando comida de cerdo...")
									--APUNTAR HACIA BARRIL
									Citizen.Wait(Config.TimeToSearchFood)
									FreezeEntityPosition(GetPlayerPed(-1), false)
									ClearPedTasks(GetPlayerPed(-1))
									tieneComida = true
									comidaCant  = Config.FoodToGive
									TriggerEvent("nl_jobGranjero:CrearSaco")
								else
									ESX.ShowNotification("¡Ya tienes un saco de comida en tus manos!, ¡Alimenta a los cerdos!")
								end
							else
								ESX.ShowNotification("¡No debes estar en proceso de ningun otro trabajo!")
							end
						else
							ESX.ShowNotification("¡~r~No estas de servicio~w~, ve en tu GPS donde esta el vestidor y cambiate de ropa!")
						end	
					else 
						ESX.ShowNotification("¡Hey ~r~no~w~ eres granjero, ~r~vete de aqui~w~!")
					end
				end
			end
		end

		--DAR COMIDA
		for _,info in pairs(Config.Locations.CerdosPoints) do
			if info.used == false then
				if (GetDistanceBetweenCoords(coords, info.x, info.y, info.z, true) <= 10.0) then
					DrawText3Ds(info.x, info.y, info.z+0.7, "~w~PRESIONA ~p~[E]~w~ PARA ALIMENTAR A LOS CERDOS")
					DrawMarker(21, info.x, info.y, info.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.4, 0.4, 0.4, 76, 42, 130, 120, true, true, 2, nil, nil, false)
					if (GetDistanceBetweenCoords(coords, info.x, info.y, info.z, true) <= 1.0) then
						if IsControlJustReleased(0, Config.KeyToUse) then
							if ESX.GetPlayerData().job.name == Config.Job then
								if inService == true then
									if tieneComida == true and comidaCant >= (Config.FoodToGive/4) then
										
											if comidaCant == (Config.FoodToGive/4) then
												info.used = true
												exports['progressBars']:startUI(Config.TimeToPourFood, "Alimentando a los cerdos...")
												FreezeEntityPosition(GetPlayerPed(-1), true)
												TriggerEvent("nl_jobGranjero:OrdenarAnim")
												Citizen.Wait(Config.TimeToPourFood)
												ESX.ShowNotification("¡Te has acabado el saco! Ve a buscar más.")
												TriggerEvent("nl_jobGranjero:BorrarSaco")
												ClearPedTasks(GetPlayerPed(-1))
												FreezeEntityPosition(GetPlayerPed(-1), false)
												comidaCant = 0
												tieneComida = false
												TriggerServerEvent("nl_jobGranjero:PayPigs", source)
												ESX.ShowNotification("¡Has alimentado a todos los cerdos! Has ganado ~g~$"..Config.PigsPayment)
												for _,inf in pairs(Config.Locations.CerdosPoints) do
													inf.used = false
												end
											else
												info.used = true
												exports['progressBars']:startUI(Config.TimeToPourFood, "Alimentando a los cerdos...")
												FreezeEntityPosition(GetPlayerPed(-1), true)
												TriggerEvent("nl_jobGranjero:OrdenarAnim")
												Citizen.Wait(Config.TimeToPourFood)
												comidaCant = comidaCant-(Config.FoodToGive/4)
												ClearPedTasks(GetPlayerPed(-1))
												FreezeEntityPosition(GetPlayerPed(-1), false)
											end
										
									else
										ESX.ShowNotification("¡Necesitas un saco de comida, ve a buscarlo!, ¡Alimenta a los cerdos!")
									end
								else
									ESX.ShowNotification("¡~r~No estas de servicio~w~, ve en tu GPS donde esta el vestidor y cambiate de ropa!")
								end	
							else 
								ESX.ShowNotification("¡Hey ~r~no~w~ eres granjero, ~r~vete de aqui~w~!")
							end
						end
					end
				end
			end
		end
	end
end)

AddEventHandler('onResourceStop', function (resourceName)
	if cuboEnManos then
		DetachEntity(cuboEnManos, 1, 1)
		DeleteObject(cuboEnManos)
		ESX.Game.DeleteObject(cuboEnManos)
	end
	if sacoDeComida then
		DetachEntity(sacoDeComida, 1, 1)
		DeleteObject(sacoDeComida)
		ESX.Game.DeleteObject(sacoDeComida)
	end
	if barrel then
		DetachEntity(barrel, 1, 1)
		DeleteObject(barrel)
		ESX.Game.DeleteObject(barrel)
	end
end)


AddEventHandler('onResourceStart', function (resourceName)
	if cuboEnManos then
		DetachEntity(cuboEnManos, 1, 1)
		DeleteObject(cuboEnManos)
		ESX.Game.DeleteObject(cuboEnManos)
	end
	if sacoDeComida then
		DetachEntity(sacoDeComida, 1, 1)
		DeleteObject(sacoDeComida)
		ESX.Game.DeleteObject(sacoDeComida)
	end
	if barrel then
		DetachEntity(barrel, 1, 1)
		DeleteObject(barrel)
		ESX.Game.DeleteObject(barrel)
	end
end)

--SPAWNING BLIPS
Citizen.CreateThread(function()
	for _, info in pairs(Config.Locations.Blips) do
		info.blip = AddBlipForCoord(info.x, info.y, info.z)
		SetBlipSprite(info.blip, info.id)
		SetBlipDisplay(info.blip, 4)
		SetBlipScale(info.blip, 0.7)
		SetBlipColour(info.blip, info.colour)
		SetBlipAsShortRange(info.blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(info.Title)
		EndTextCommandSetBlipName(info.blip)
	end
end)

function DrawText2Ds(x,y,text)
	SetTextFont(0)
    SetTextProportional(1)
    SetTextScale(0.0, 0.3)
    SetTextColour(255, 255, 255, 255)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextDropshadow(5,5,0,0,0,230)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 15, 15, 15, 170)
end

--SPAWNING COWS
Citizen.CreateThread(function()
	local ped_hash = GetHashKey(Config.Locations.Cloakroom.npcmodel)
	RequestModel(ped_hash)
	while not HasModelLoaded(ped_hash) do
		Wait(155)
	end
	jobNPC = CreatePed(0, ped_hash, Config.Locations.Cloakroom.npcx,Config.Locations.Cloakroom.npcy, Config.Locations.Cloakroom.npcz-1,Config.Locations.Cloakroom.npchead, false, true)
	SetBlockingOfNonTemporaryEvents(jobNPC, true)
	SetPedDiesWhenInjured(jobNPC, false)
	SetPedCanPlayAmbientAnims(jobNPC, true)
	SetPedCanRagdollFromPlayerImpact(jobNPC, false)
	SetEntityInvincible(jobNPC, true)
	FreezeEntityPosition(jobNPC, true)

	for _,info in pairs(Config.Locations.Vacas) do
		RequestModel(GetHashKey("a_c_cow"))
		while not HasModelLoaded(GetHashKey("a_c_cow")) do
			Wait(155)
		end
		local ped =  CreatePed(4, GetHashKey("a_c_cow"), info.x, info.y, info.z, info.head, false, true)
		FreezeEntityPosition(ped, true)
		SetEntityInvincible(ped, true)
		SetBlockingOfNonTemporaryEvents(ped, true)
	end
end)


--SPAWNING PIGS AND ITEM
Citizen.CreateThread(function()
	for _,info in pairs(Config.Locations.Cerdos) do
		RequestModel(GetHashKey("a_c_pig"))
		while not HasModelLoaded(GetHashKey("a_c_pig")) do
			Wait(155)
		end
		local ped =  CreatePed(4, GetHashKey("a_c_pig"), info.x, info.y, info.z, info.head, false, true)
		FreezeEntityPosition(ped, true)
		SetEntityInvincible(ped, true)
		SetBlockingOfNonTemporaryEvents(ped, true)
		--ANIMATION EATING
		local ad = "creatures@pig@amb@world_pig_grazing@base"
		loadAnimDict( ad )
		TaskPlayAnim( ped, ad, "base", 3.0, -8, -1, 63, 0, 0, 0, 0 )
	end
	RequestModel(GetHashKey(Config.Locations.FeedPoint.Barrel.model))
	while not HasModelLoaded(GetHashKey(Config.Locations.FeedPoint.Barrel.model)) do
		Wait(155)
	end
		
	local barrel = CreateObject(GetHashKey(Config.Locations.FeedPoint.Barrel.model), Config.Locations.FeedPoint.Barrel.x, Config.Locations.FeedPoint.Barrel.y, Config.Locations.FeedPoint.Barrel.z-1,  true,  true, true)
	FreezeEntityPosition(barrel, true)
	SetEntityInvincible(barrel, true)
	SetBlockingOfNonTemporaryEvents(barrel, true)
end)


function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(5)
	end
end

