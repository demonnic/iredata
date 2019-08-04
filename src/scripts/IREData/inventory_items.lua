iredata.inv = iredata.inv or {}
iredata.invFunctions = iredata.invFunctions or {}

function iredata.invFunctions:invitems()
  local items = gmcp.Char.Items.List
  if items.location == "inv" then
    iredata.inv.items = {}
    iredata.inv.items.other = {}
    iredata.inv.items.worn = {}
    iredata.inv.items.wielded = {}
    iredata.inv.items.all = {}
    for _,item in ipairs(items.items) do
      iredata.invFunctions:addItem(item)
    end
  elseif items.location == "room" then
    -- do nothing, handled by the Room section
  else -- we're getting container contents, look through all our items and if one of them matches, add these items to it
    local containerID = string.sub(items.location, 4)
    local containerItems = items.items
    for _,category in pairs(iredata.inv.items) do
      for _,itemToCheck in ipairs(category) do
        if itemToCheck.id == containerID then
          itemToCheck.contents = containerItems
          break
        end
      end
    end
  end
end

function iredata.invFunctions:addItem(item)
  local attribs = {}
  local aText = item.attrib
  if aText == nil then aText = '' end
  for i=1, #aText do
    attribs[i] = aText:sub(i, i)
  end
  if table.contains(attribs, 'l') or table.contains(attribs, 'L') then
    table.insert(iredata.inv.items.wielded, item)
  elseif table.contains(attribs, 'w') then
    table.insert(iredata.inv.items.worn, item)
  else
    table.insert(iredata.inv.items.other, item)
  end
  table.insert(iredata.inv.items.all, item)
  if table.contains(attribs, 'c') then
    iredata:sendGMCP("Char.Items.Contents " .. item.id)
  end
end

function iredata.invFunctions:recheck(event)
  local data = iredata:getValueAt(event)
  if (data.location and data.location ~= "room") then iredata:sendGMCP("Char.Items.Inv") end
end

function iredata.invFunctions:initialize()
  if iredata.invFunctions.eventHandlers then
    for _,handlerID in ipairs(iredata.invFunctions.eventHandlers) do
      killAnonymousEventHandler(handlerID)
    end
  end
  iredata.invFunctions.eventHandlers = {}
  table.insert(iredata.invFunctions.eventHandlers, registerAnonymousEventHandler("gmcp.Char.Items.List", iredata.invFunctions.invitems))
  table.insert(iredata.invFunctions.eventHandlers, registerAnonymousEventHandler("gmcp.Char.Items.Add", iredata.invFunctions.recheck))
  table.insert(iredata.invFunctions.eventHandlers, registerAnonymousEventHandler("gmcp.Char.Items.Remove", iredata.invFunctions.recheck))
  table.insert(iredata.invFunctions.eventHandlers, registerAnonymousEventHandler("gmcp.Char.Items.Update", iredata.invFunctions.recheck))
  iredata:sendGMCP("Char.Items.Inv")
end