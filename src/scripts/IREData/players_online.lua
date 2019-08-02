iredata.whoFunctions = iredata.whoFunctions or {}
iredata.who = iredata.who or {}

function iredata.whoFunctions:players()
  iredata.who.all = {}
	iredata.who.groups = {}
	local players = gmcp.Comm.Channel.Players
	for _,player in ipairs(players) do
	  table.insert(iredata.who.all, player.name)
		if player.channels then
		  for _,channel in ipairs(player.channels) do
			  if iredata.who.groups[channel] == nil then iredata.who.groups[channel] = {} end
				table.insert(iredata.who.groups[channel], player.name)
			end
		end
	end
	table.sort(iredata.who.all)
	for _,group in ipairs(iredata.who.groups) do
	  table.sort(group)
	end
	raiseEvent('players.online updated')
end

function iredata.whoFunctions:initialize()
	if iredata.whoFunctions.eventHandlers then
	  for _,handlerID in ipairs(iredata.whoFunctions.eventHandlers) do
		  killAnonymousEventHandler(handlerID)
		end
	end
	iredata.whoFunctions.eventHandlers = {}
	table.insert(iredata.whoFunctions.eventHandlers, registerAnonymousEventHandler('gmcp.Comm.Channel.Players', 'iredata.whoFunctions.players'))
	gmod.enableModule('iredata', 'Comm.Channel')
	iredata:sendGMCP('Comm.Channel.Players')
end