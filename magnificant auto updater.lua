local function loadscreen(parts,done,text)
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


local function clearscreen()
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

loadscreen(0,#raw,"Downloading Files \n\n")

for x=1,#raw do

  if raw[x].type == "file" then
  
    local dl = http.get(raw[x]._links.html:gsub("blob","raw")):readAll()
	local tmp = fs.open(raw[x].path,"w")
	tmp.write(dl)
	tmp.close()
	
  end
  
  loadscreen(x,#raw,"Downloading Files \n\n")
end