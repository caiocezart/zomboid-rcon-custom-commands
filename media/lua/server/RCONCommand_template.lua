local RCONCommandsUtils = require 'RCONCommandsUtils'
RCONCommandsUtils.moduleName = "RCONCommandsServer"

local RCONCommandsServer = require 'RCONCommandsServer'

-- edit from here
local commandName = "/command";
local callback_func = function(commandName, commandArgs)
    RCONCommandsUtils.log.debug("Command received: " .. commandName .. " " .. commandArgs)

    -- custom logic
    -- extract command arguments 
    local id, x, y, z, zombies_qty = command:match("/spawn_zombies%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)")    

    RCONCommandsUtils.log.debug("Command args:");
    RCONCommandsUtils.log.debug("id: " .. id);
    RCONCommandsUtils.log.debug("pos_x: " .. x);
    RCONCommandsUtils.log.debug("pos_y: " .. y);
    RCONCommandsUtils.log.debug("pos_z: " .. z);
    RCONCommandsUtils.log.debug("zombies_qty: " .. zombies_qty);
    
    -- check if you are on server side in case your command needs to be there
    if isClient() then
        RCONCommandsUtils.log.error("Tried to execute command from client side.");
        return false
    end

    -- run the actual game commands
    addZombiesInOutfit(tonumber(x), tonumber(y), tonumber(z), tonumber(zombies_qty), "Base", nil)
end

-- uncomment line below to activate command registration
-- Events.OnServerStarted.Add(RCONCommandsServer.registerCustomCommand(commandName, callback_func))