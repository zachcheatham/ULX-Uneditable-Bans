local EDITABLE_TIMELIMIT = 600 -- 10 minutes

local function isBanEditable(steamID)
	local ban = ULib.bans[steamID]
	if ban and (os.time() - ban.time) > EDITABLE_TIMELIMIT then
		return false
	end
	
	return true
end

local function banid(calling_ply, steamid, minutes, reason)
	if IsValid(calling_ply) and not calling_ply:query("ulx modifybans") and not isBanEditable(steamid) then
		ULib.tsayError(calling_ply, "That player is already banned!", true)
		
		if minutes < 60 then
			ULib.tsayError(_, calling_ply:SteamID() .. " attempted to unban someone by banning them for a minute. This is abuse.", true)
		end
	else
		ulx.banid(calling_ply, steamid, minutes, reason)
	end
end

ULib.ucl.registerAccess("ulx modifybans", ULib.ACCESS_SUPERADMIN, "Allows admins to modify existing bans.", "Other")

local function overrideCommands()
	ULib.cmds.translatedCmds["ulx banid"].fn = banid
end
hook.Add("Initialize", "UneditableBansOverrides", overrideCommands)