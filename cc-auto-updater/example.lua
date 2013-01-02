local updater = dofile("lib/updater.lua")

local function success()
	print("done")
end

updater.update(success, "Kolpa", "lol-pro-spectator") -- first argument is the function to be executed in case of an update second is the username and last is the repostery