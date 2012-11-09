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

function save(url)
	repeat
		temp = http.get(url.."?client_id=51c669aba2c0fa9a0fd6&client_secret=d39a4a86a8b55fae2295b971b0abd7edeb61daf8")
	until temp ~= nil
	return temp:readAll()
end

loadscreen(2,0,"Welcome to the Github Downloader loading now ... \n\n")

JSON = (loadfile "json.txt")()

loadscreen(2,1,"Welcome to the Github Downloader loading now ... \n\n")

local repo = save("https://api.github.com/repos/Kolpa/PhpCode/contents")
local raw = JSON:decode(repo)

loadscreen(2,2,"Welcome to the Github Downloader loading now ... \n\n")

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
  local teme = save(dirs[y])
  local data = JSON:decode(teme)
    for z=1,#data do
      if data[z].type == "dir" then
        table.insert(dirs,data[z]._links.self)
      end
    end
  y=y+1
end

table.insert(dirs,"https://api.github.com/repos/Kolpa/PhpCode/contents")

loadscreen(3,2,"Prepearing Data ... \n\n")

for w=1,#dirs do
  local teme2 = save(dirs[w])
  local data2 = JSON:decode(teme2)
    for v=1,#data2 do
	  if data2[v].type == "file" then
	    local url = data2[v]._links.html:gsub("blob","raw")
	    table.insert(files,url)
		table.insert(filename,data2[v].path)
	  end
	end
end

loadscreen(3,3,"Prepearing Data ... \n\n")

loadscreen(#files,0,"Downloading files ... \n\n")
for u=1,#files do
  fname = filename[u]
  filex = save(files[u])
  dir = fs.combine(fname, "..")
  if fs.isDir(dir) then
  else
    fs.makeDir(dir)
  end
  file = fs.open(fname,"w")
  file.write(filex)
  file.close()
  loadscreen(#files,u,"Downloading files ... \n\n")
end
