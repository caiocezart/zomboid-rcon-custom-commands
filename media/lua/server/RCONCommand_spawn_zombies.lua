local RCONCommandsUtils = require 'RCONCommandsUtils'
RCONCommandsUtils.moduleName = "RCONCommandLoader"

local RCONCommandsServer = require 'RCONCommandsServer'

local commandName = "/spawn_zombies";
local callback_func = function(commandName, commandArgs)    
    RCONCommandsUtils.log.debug("Command received: " .. commandName .. " " .. commandArgs)

    local x, y, z, zombies_qty = commandArgs:match("(%d+)%s+(%d+)%s+(%d+)%s+(%d+)")    
    RCONCommandsUtils.log.debug("Command args:");
    RCONCommandsUtils.log.debug("pos_x: " .. x);
    RCONCommandsUtils.log.debug("pos_y: " .. y);
    RCONCommandsUtils.log.debug("pos_z: " .. z);
    RCONCommandsUtils.log.debug("zombies_qty: " .. zombies_qty);
    
    if isClient() then
        RCONCommandsUtils.log.error("Tried to execute command from client side. Aborting");
        return false
    end

    addZombiesInOutfit(tonumber(x), tonumber(y), tonumber(z), tonumber(zombies_qty), "Base", nil)
end

Events.OnServerStarted.Add(RCONCommandsServer.registerCustomCommand(commandName, callback_func))