TriggerEvent('es:addCommand', 'togglehud', function(source, args)
	if not args then 
		TriggerClientEvent('chatMessage', source, "[Hentari_UI]", {255, 0, 0}, "/togglehud [on/off]") 
	else
	local a = tostring(args[1])
		if a == "off" then
			TriggerClientEvent('hentari_ui:toggle', source,false)
		elseif a == "on" then
			TriggerClientEvent('hentari_ui:toggle', source,true)
		else
			TriggerClientEvent('chatMessage', source, "[Hentari_UI]", {255, 0, 0}, "/togglehud [on/off]") 
		end
	end
end, {help = "Włącza i wyłącza hud"})

