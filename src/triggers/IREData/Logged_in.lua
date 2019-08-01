iredata.game = matches[2]
echo("This timer fired again!\n")
tempTimer(0.5, function()
  iredata.taskFunctions:initialize()
	iredata.invFunctions:initialize()
end)