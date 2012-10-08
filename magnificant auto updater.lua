function loadscreen(parts,done,text)
  clearscreen()
  
  print(text.."\n")
  
  local size = 48 / parts
  
  write("[")
  
  local steps = size * done
  local rest = 48 - steps
  
  for x=1,steps do
    write("-")
  end
  for y=1,rest do
    write(" ")
  end
  
  write("]\n")
end

function tblc(st,tb)
  if tb == nil then
    return false
  else
    for x=1,#tb do
      if tb[x] == st then return true end
    end
   	return false
  end
end
function clearscreen()
	term.clear()
	term.setCursorPos(1,1)
end

loadscreen(2,0,"Welcome to the CommuteOS Installer loading now ... \n\n")

local dec = http.get("http://regex.info/code/JSON.lua")
local JSON = loadstring(dec:readAll())()

loadscreen(2,1,"Welcome to the CommuteOS Installer loading now ... \n\n")

local repo = http.get("https://api.github.com/repos/CommuteOS/CommuteOS/contents")
local raw = JSON:decode(repo:readAll())

loadscreen(2,2,"Welcome to the CommuteOS Installer loading now ... \n\n")

clearscreen()

loadscreen(3,0,"Prepearing Data ... \n\n")
local dirs = {}
local y = 1
local files = {}
local filename = {}
for x=1,#raw do
  if raw[x].type == "dir" then
    table.insert(dirs,raw[x]._links.self)
  end
end

loadscreen(3,1,"Prepearing Data ... \n\n")

while y <= #dirs do
  local teme = http.get(dirs[y])
  local data = JSON:decode(teme:readAll())
    for z=1,#data do
      if data[z].type == "dir" then
        table.insert(dirs,data[z]._links.self)
      end
    end
  y=y+1
end

table.insert(dirs,"https://api.github.com/repos/CommuteOS/CommuteOS/contents")

loadscreen(3,2,"Prepearing Data ... \n\n")

for w=1,#dirs do
  local teme2 = http.get(dirs[w])
  local data2 = JSON:decode(teme2:readAll())
    for v=1,#data2 do
	  if data2[v].type == "file" then
	    local url = data2[v]._links.html:gsub("blob","raw")
	    table.insert(files,url)
		table.insert(filename,data2[v].name)
	  end
	end
end

fs.makeDir("Download")

loadscreen(3,3,"Prepearing Data ... \n\n")

loadscreen(#files,0,"Downloading files ... \n\n")
for u=1,#files do
  local fname = filename[u]
  local filex = http.get(files[u]):readAll()
  local file = fs.open("Download/"..fname,"w")
  file.write(filex)
  file.close()
  loadscreen(#files,u,"Downloading files ... \n\n")
end
