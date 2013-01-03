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
	local size = 0
	local query = "https://api.github.com/repos/"..user.."/"..repo.."/commits"
	local request = http.get(query).readAll()
	local data = JSON.decode(request)
	size = size + #data
	local sha = data[#data].sha
	repeat
		local query = "https://api.github.com/repos/"..user.."/"..repo.."/commits?sha="..sha
		local request = http.get(query).readAll()
		local data = JSON.decode(request)
		if #data ~= 1 then
			size = size + #data
			size = size - 1
		end
		sha = data[#data].sha
	until #data == 1
	return size
end

local function setLocal(ver)
	local file = fs.open("lib/.version", "w")
	file.write(ver)
	file.close()
end

function updater.update(funcToRun, user, repo)
	local onl = getOnline(user, repo)
	local loc = getLocal()
	print(onl)
	if onl > loc then
		funcToRun()
		setLocal(onl)
	end
end

return updater