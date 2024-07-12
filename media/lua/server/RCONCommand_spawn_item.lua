local RCONCommandsUtils = require 'RCONCommandsUtils'
RCONCommandsUtils.moduleName = "RCONCommandsServer"

local RCONCommandsServer = require 'RCONCommandsServer'

-- edit from here
local commandName = "/spawn_item";
local callback_func = function(commandName, commandArgs)
    RCONCommandsUtils.log.debug("Command received: " .. commandName .. " " .. commandArgs)

    local itemName, x, y, z  = commandArgs:match("([%w%.]+)%s+(%d+)%s+(%d+)%s+(%d+)")
    local sq = getCell():getGridSquare(tonumber(x), tonumber(y), tonumber(z))

    RCONCommandsUtils.log.debug("RCONCommandsServer","spawn_item", "itemName: " .. itemName);
    RCONCommandsUtils.log.debug("RCONCommandsServer","spawn_item", "x: " .. x);
    RCONCommandsUtils.log.debug("RCONCommandsServer","spawn_item", "y: " .. y);
    RCONCommandsUtils.log.debug("RCONCommandsServer","spawn_item", "z: " .. z);
    
    if (sq ~= nil) then
        sq:AddWorldInventoryItem(itemName, 0, 0, 0)
    end
end

Events.OnServerStarted.Add(RCONCommandsServer.registerCustomCommand(commandName, callback_func))
