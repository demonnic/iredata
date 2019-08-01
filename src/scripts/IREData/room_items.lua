iredata.room = iredata.room or {}
iredata.room.name = iredata.room.name or "No room information gained yet"
iredata.room.description = iredata.room.description or "No room information gained yet"
iredata.roomFunctions = iredata.roomFunctions or {}
function iredata.roomFunctions:addItem(item)
	local attribs = {}
	local aText = item.attrib
	if aText == nil then 
	  aText = 'm'
		if string.find(item.name, 'corpse') then 
		  aText = aText .. 't' 
		end
	end
  for i=1, #aText do
    attribs[i] = aText:sub(i, i)
  end
	table.insert(iredata.room.items.all, item)
	if table.contains(attribs, 'm') then
		if table.contains(attribs, 't') then
		  table.insert(iredata.room.items.items, item)
		else
		  table.insert(iredata.room.items.mobs, item)
		end
	else
	  table.insert(iredata.room.items.items, item)
	end
end

function iredata.roomFunctions:removeItem(item)
  for listType,items in pairs(iredata.room.items) do
	  local newList = {}
	  for index,itemToCheck in ipairs(items) do
		  if itemToCheck.id ~= item.id then
			  table.insert(newList, itemToCheck)
			end
		end
		iredata.room.items[listType] = table.deepcopy(newList)
	end
end

function iredata.roomFunctions:rilist()
  local list = gmcp.Char.Items.List
  if list.location == "room" then
    iredata.room.items = {}
		iredata.room.items.all = {}
		iredata.room.items.mobs = {}
		iredata.room.items.items = {}
    for _,item in ipairs(list.items) do
      iredata.roomFunctions:addItem(item)
    end
    raiseEvent("room.items updated")
  end
  if list.location == "inv" then
    return
  end
end

function iredata.roomFunctions:riadd()
  local item = gmcp.Char.Items.Add
  if item.location == "room" then 
    iredata.roomFunctions:addItem(item.item)
  end
	raiseEvent("room.items updated")
end

function iredata.roomFunctions:riremove()
  local item = gmcp.Char.Items.Remove
  if item.location == "room" then
    iredata.roomFunctions:removeItem(item.item)
  end
  raiseEvent("room.items updated")
end

function iredata.roomFunctions:info()
  local info = gmcp.Room.Info
  iredata.room.name = info.name
	iredata.room.description = info.desc
	iredata.room.environment = info.environment
	iredata.room.background = info.background
	iredata.room.area = info.area
	iredata.room.vnum = info.num
	iredata.room.coords = info.coords
	raiseEvent("room.info updated")
end

function iredata.roomFunctions:players()
  iredata.room.players = gmcp.Room.Players
	raiseEvent("room.players updated")
end

if iredata.roomFunctions.eventHandlers then
  for _,handlerID in ipairs(iredata.roomFunctions.eventHandlers) do
	  killAnonymousEventHandler(handlerID)
	end
end
iredata.roomFunctions.eventHandlers = {}
table.insert(iredata.roomFunctions.eventHandlers, registerAnonymousEventHandler("gmcp.Char.Items.List", "iredata.roomFunctions.rilist"))
table.insert(iredata.roomFunctions.eventHandlers, registerAnonymousEventHandler("gmcp.Char.Items.Add", "iredata.roomFunctions.riadd"))
table.insert(iredata.roomFunctions.eventHandlers, registerAnonymousEventHandler("gmcp.Char.Items.Remove", "iredata.roomFunctions.riremove"))
table.insert(iredata.roomFunctions.eventHandlers, registerAnonymousEventHandler("gmcp.Room.Info", "iredata.roomFunctions.info"))
table.insert(iredata.roomFunctions.eventHandlers, registerAnonymousEventHandler("gmcp.Room.Players", "iredata.roomFunctions.players"))
