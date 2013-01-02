local JSON = dofile("lib/dkjson.lua")

local updater = {}

local function getLocal()
	if fs.exists("lib/.version") then
		local file = fs.open("lib/.version", "r")
		local ver = file.readAll()
		file.close()
		return tonumber(ver)
	else
		return 0
	end
end

local function getOnline(user, repo)
	local query = "https://api.github.com/repos/"..user.."/"..repo.."/commits?per_page=100"
	local request = http.get(query).readAll()
	local data = JSON.decode(request)
	return #data
end

local function setLocal(ver)
	local file = fs.open("lib/.version", "w")
	file.write(ver)
	file.close()
end

function updater.update(funcToRun, user, repo)
	local onl = getOnline(user, repo)
	local loc = getLocal()
	if onl > loc then
		funcToRun()
		setLocal(onl)
	end
end

return updater