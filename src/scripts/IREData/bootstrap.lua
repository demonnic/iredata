iredata = iredata or {}
iredata.gmcpItems = iredata.gmcpItems or {}
function iredata:deleteNextPrompt()
  tempPromptTrigger(function() deleteLine() end, 1)
end

function iredata:sendGMCP(gmcpString)
  table.insert(iredata.gmcpItems, gmcpString)
end

function iredata:doGMCP()
  local unique = {}
  for _,gmcpString in ipairs(iredata.gmcpItems) do
    if not table.contains(unique, gmcpString) then
      table.insert(unique, gmcpString)
    end
  end
  iredata.gmcpItems = {}
  for _,gmcpString in ipairs(unique) do
    sendGMCP(gmcpString)
  end
  if #unique > 0 then
    iredata:deleteNextPrompt()
    send("\n", false)
  end
end

function table.keys(tbl)
  local keyset={}
  local n=0
  
  for k,v in pairs(tbl) do
    n=n+1
    keyset[n]=k
  end
  return keyset
end

function iredata:getValueAt(accessString)
  local tempTable = accessString:split("%.")
  local accessTable = {}
  for i,v in ipairs(tempTable) do
    if tonumber(v) then
      accessTable[i] = tonumber(v)
    else
      accessTable[i] = v
    end
  end
  return iredata:digForValue(_G, accessTable)
  
end

function iredata:digForValue(dataFrom, tableTo)
  if table.size(tableTo) == 0 then
    return dataFrom
  else
    newData = dataFrom[tableTo[1]]
    table.remove(tableTo, 1)
    return iredata:digForValue(newData, tableTo)
  end
end