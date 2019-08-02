iredata.skillFunctions = iredata.skillFunctions or {}
iredata.skills = iredata.skills or {}
iredata.skills.groups = iredata.skills.groups or {}
iredata.skillFunctions.miniskills = {}
iredata.skillFunctions.miniskills.Imperian = {
	'evasion'
}
iredata.skillFunctions.miniskills.Achaea = {
	'constitution',
	'thermology',
	'frost',
	'antidotes',
	'fitness',
	'galvanism',
	'philosophy',
}
iredata.skillFunctions.miniskills.Aetolia = {
	'constitution',
	'thermology',
	'frost',
	'antidotes',
	'fitness',
	'galvanism',
	'philosophy',
	'horsemanship',
	'refining',
	'psycombat'
}
iredata.skillFunctions.miniskills.Lusternia = {
	
}

function iredata.skillFunctions:grouplist()
  iredata.skills.groups = {}
	iredata.skills.groupsToCheck = {}
	iredata.skills.groupNames = {}
	iredata.skills.skillsToCheck = {}
  for _,skill in ipairs(gmcp.Char.Skills.Groups) do
	  local name = string.lower(skill.name)
	  iredata.skills.groups[name] = {}
		iredata.skills.groups[name]["rank"] = skill.rank
		table.insert(iredata.skills.groupNames, name)
		if not table.contains(iredata.skills.miniskills[iredata.game], name) then
		  table.insert(iredata.skills.groupsToCheck, string.format([[Char.Skills.Get {"group": "%s"}]], name))
		end
	end
	iredata:sendGMCP(table.remove(iredata.skills.groupsToCheck,1))
end

function iredata.skillFunctions:skilllist()
  if not iredata.skills.groupsToCheck then return end
  local skillList = gmcp.Char.Skills.List
	local group = skillList.group
	iredata.skills.groups[group].skills = {}
	for i,skillName in ipairs(skillList.list) do
	  skillName = string.lower(skillName)
	  table.insert(iredata.skills.skillsToCheck, string.format([[Char.Skills.Get {"group": "%s", "name": "%s"}]], group, skillName))
		local skill = {}
		skill.desc = skillList.descs[i]
		iredata.skills.groups[group]['skills'][skillName] = skill
	end
	if #iredata.skills.groupsToCheck > 0 then
    iredata:sendGMCP(table.remove(iredata.skills.groupsToCheck,1))
	else
	  iredata.skills.groupsToCheck = nil
	  iredata:sendGMCP(table.remove(iredata.skills.skillsToCheck,1))
	end
end

function iredata.skillFunctions:skillinfo()
  local info = gmcp.Char.Skills.Info
	local group = string.lower(info.group)
  local skill = string.lower(info.skill)
  iredata.skills.groups[group]['skills'][skill]['info'] = info.info
	if #iredata.skills.skillsToCheck > 0 then
	  iredata:sendGMCP(table.remove(iredata.skills.skillsToCheck,1))
	else
	  iredata.skills.skillsToCheck = nil
	end
end


if iredata.skillFunctions.eventHandlers then
  for _,handlerID in ipairs(iredata.skillFunctions.eventHandlers) do
	  killAnonymousEventHandler(handlerID)
	end
end
iredata.skillFunctions.eventHandlers = {}
table.insert(iredata.skillFunctions.eventHandlers, registerAnonymousEventHandler("gmcp.Char.Skills.Groups", "iredata.skillFunctions.grouplist"))
table.insert(iredata.skillFunctions.eventHandlers, registerAnonymousEventHandler("gmcp.Char.Skills.List", "iredata.skillFunctions.skilllist"))
table.insert(iredata.skillFunctions.eventHandlers, registerAnonymousEventHandler("gmcp.Char.Skills.Info", "iredata.skillFunctions.skillinfo"))
