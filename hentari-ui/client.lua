local Keys = {
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

ESX = nil
local isTalking = false
local inVehicle = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end	
	--Updates the UI on start
	NetworkSetTalkerProximity(10.0)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if isTalking == false then
			if NetworkIsPlayerTalking(PlayerId()) then
				isTalking = true
				SendNUIMessage({action = "setTalking", value = true})
			end
		else
			if NetworkIsPlayerTalking(PlayerId()) == false then
				isTalking = false
				SendNUIMessage({action = "setTalking", value = false})
			end
		end
	end
end)


-- Voice

local prox = 26.0 -- Sets the Default Voice Distance
local allowProximityChange = true -- Set to True to allow Changing Voice Distance | False to not allow Changing Voice Distance

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsControlJustPressed(1, 166) and allowProximityChange then
			local vprox
			if prox <= 2.0 then
				prox = 10.0
				vprox = "normal"
			elseif prox == 10.0 then
				prox = 26.0
				vprox = "shout"
			elseif prox >= 26.0 then
				prox = 2.0
				vprox = "whisper"
			end
			NetworkSetTalkerProximity(prox)
			SendNUIMessage({action = "setProximity", value = vprox})
		end
		if IsControlPressed(1, 166) then
			local posPlayer = GetEntityCoords(GetPlayerPed(-1))
			DrawMarker(1, posPlayer.x, posPlayer.y, posPlayer.z - 1, 0, 0, 0, 0, 0, 0, prox * 2, prox * 2, 0.8001, 0, 75, 255, 165, 0,0, 0,0)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
	  Citizen.Wait(10)
	   local ped = GetPlayerPed(-1)
	   local health = GetEntityHealth(ped)
	   local armor = GetPedArmour(ped)
	   SendNUIMessage({
		   heal = health,
		   armor = armor
	   });
	  --SendNUIMessage({heal,})
	end
  end)

---Możliwość włączenia / wyłączenia HUDu
RegisterNetEvent('hentari_ui:toggle')
AddEventHandler('hentari_ui:toggle', function(show)

	SendNUIMessage({action = "toggle", show = show})

end)

RegisterNetEvent('hentari_ui:updateStatus')
AddEventHandler('hentari_ui:updateStatus', function(status)
	SendNUIMessage({action = "updateStatus", status = status})
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)

		if IsPauseMenuActive() and not IsPaused then
			IsPaused = true
			TriggerEvent('hentari_ui:toggle', 0,0)
		elseif not IsPauseMenuActive() and IsPaused then
			IsPaused = false
			TriggerEvent('hentari_ui:toggle', 1,0)
		end
	end
end)
