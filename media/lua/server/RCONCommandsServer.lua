local RCONCommandsUtils = require 'RCONCommandsUtils'
RCONCommandsUtils.moduleName = "RCONCommandsServer"

local RCONCommandsServer = {};
RCONCommandsServer.history = {};
RCONCommandsServer.commands = {};

RCONCommandsServer.registerCustomCommand = function(command_name, callback_func)
    RCONCommandsUtils.moduleName = "RCONCommandsServer";
    RCONCommandsUtils.log.debug("Registering custom command " .. command_name);
    if not type(callback_func) == "function" then
        RCONCommandsUtils.log.error("Custom command " .. command_name .. " has an invalid callback function");
        return;
    end

    if not RCONCommandsServer.commands[command_name] then
        RCONCommandsServer.commands[command_name] = callback_func
        RCONCommandsUtils.log.info("Command: " .. command_name .. " registered successfully.")
        return
    end
    
    RCONCommandsUtils.log.debug("Command " .. command_name .. " already exists.")
end

RCONCommandsServer.addCommandRun = function(id, command)
    RCONCommandsUtils.log.debug("Looking for command id " .. id);
    if not RCONCommandsServer.history[id] then
        RCONCommandsUtils.log.debug("Command id " .. id .. " not found. Proceeding to add to the table.")
        RCONCommandsServer.history[id] = {
            command = command
        }
        RCONCommandsUtils.log.info("Command " .. command .. " with id " .. id .. " will be processed.");
        return true
    end

    RCONCommandsUtils.log.debug("Command id " .. id .. " already exists. Skipping it.");
    return false
end

RCONCommandsServer.handleClientCommand = function(moduleName, func, playerObj, args)
    if (moduleName == "RCONCommands" and func == "handleClientCommand") then
        if isClient() then
            RCONCommandsUtils.log.error("Command received from client side. Aborting");
            return;
        end

        local rawCommand = tostring(args[1])
        local commandSlash, commandId, commandArgs = rawCommand:match("^(%S+)%s+(%S+)%s+(.+)$");
        RCONCommandsUtils.log.debug("Command received: " .. rawCommand);

        if commandSlash then
            RCONCommandsUtils.log.debug("Checking if command exists: " .. commandSlash);
            if RCONCommandsServer.commands[commandSlash] then                
                RCONCommandsUtils.log.debug("Registering command id: " .. commandId);
                if RCONCommandsServer.addCommandRun(commandId, commandSlash .. " " .. commandArgs) then
                    RCONCommandsServer.commands[commandSlash](commandSlash, commandArgs);                    
                    RCONCommandsUtils.log.info("Command run completed.");
                end
            else
                RCONCommandsUtils.log.error("Unknown command " .. commandSlash);
            end
        else
            RCONCommandsUtils.log.error("Invalid command format " .. rawCommand);
        end
    end
end

RCONCommandsServer.initServer = function()
    RCONCommandsUtils.log.info("RCON Custom Commands Mod started.");

    Events.OnClientCommand.Add(RCONCommandsServer.handleClientCommand);
end

Events.OnServerStarted.Add(RCONCommandsServer.initServer)

return RCONCommandsServer