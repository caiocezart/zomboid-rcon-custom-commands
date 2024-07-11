require 'RCONCommandsUtils'

RCONCommandsServer = {};
RCONCommandsServer.debug = true;
RCONCommandsServer.luanet = nil;
RCONCommandsServer.module = nil;
RCONCommandsServer.history = {};
RCONCommandsServer.commands = {};

RCONCommandsServer.registerCommandRun = function(id, playerId, command)
    if not RCONCommandsServer.history[id] then
        RCONCommandsServer.history[id] = {
            playerId = playerId,
            command = command
        }
        RCONCommandsUtils.printDebug("RCONCommandsServer", "registerCommandRun", "Command with ID: " .. id .. " added successfully");
        return true
    else
        RCONCommandsUtils.printDebug("RCONCommandsServer", "registerCommandRun", "Command with ID: " .. id .. " already exists. Skipping it.");
        return false
    end
end

RCONCommandsServer.commands.spawn_zombies = function(command)
    RCONCommandsUtils.printDebug("RCONCommandsServer", "spawn_zombies", "Running: " .. command);

    local id, x, y, z, zombies_qty = command:match("/spawn_zombies%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)")
    RCONCommandsUtils.printDebug("RCONCommandsServer","spawn_zombies", "id: " .. id);
    RCONCommandsUtils.printDebug("RCONCommandsServer","spawn_zombies", "x: " .. x);
    RCONCommandsUtils.printDebug("RCONCommandsServer","spawn_zombies", "y: " .. y);
    RCONCommandsUtils.printDebug("RCONCommandsServer","spawn_zombies", "z: " .. z);
    RCONCommandsUtils.printDebug("RCONCommandsServer","spawn_zombies", "zombies_qty: " .. zombies_qty);

    if RCONCommandsServer.registerCommandRun(id, "12345", command) then
        addZombiesInOutfit(tonumber(x), tonumber(y), tonumber(z), tonumber(zombies_qty), "Base", nil)
        RCONCommandsUtils.printDebug("RCONCommandsServer","spawn_zombies", "Spawn Zombies completed");
    end
end

RCONCommandsServer.commands.spawn_item = function(command)
    RCONCommandsUtils.printDebug("RCONCommandsServer", "spawn_item", "Running: " .. command);
    local id, itemName, x, y, z  = command:match("/spawn_item%s+(%d+)%s+([%w%.]+)%s+(%d+)%s+(%d+)%s+(%d+)")
    local sq = getCell():getGridSquare(tonumber(x), tonumber(y), tonumber(z))

    RCONCommandsUtils.printDebug("RCONCommandsServer","spawn_item", "id: " .. id);
    RCONCommandsUtils.printDebug("RCONCommandsServer","spawn_item", "x: " .. x);
    RCONCommandsUtils.printDebug("RCONCommandsServer","spawn_item", "y: " .. y);
    RCONCommandsUtils.printDebug("RCONCommandsServer","spawn_item", "z: " .. z);
    RCONCommandsUtils.printDebug("RCONCommandsServer","spawn_item", "itemName: " .. itemName);

    if RCONCommandsServer.registerCommandRun(id, "12345", command) then
        if (sq ~= nil) then
            sq:AddWorldInventoryItem(itemName, 0, 0, 0)
        end
        RCONCommandsUtils.printDebug("RCONCommandsServer","spawn_item", "Spawn Item completed");
    end
end

RCONCommandsServer.commands.rcon_history = function()
    RCONCommandsUtils.printDebug("RCONCommandsServer", "rcon_history", "RCON Commands execution history:");

end

RCONCommandsServer.commands.rcon_help = function()
    RCONCommandsUtils.printDebug("RCONCommandsServer", "rcon_help", "List of RCON commands available:");
    for cmd, handler in pairs(RCONCommandsServer.commands) do
        RCONCommandsUtils.printDebug("RCONCommandsServer", "rcon_help", "/" .. cmd);
    end
end

RCONCommandsServer.commands = {
    ["spawn_zombies"] = RCONCommandsServer.commands.spawn_zombies,
    ["spawn_item"] = RCONCommandsServer.commands.spawn_item,
    ["rcon_history"] = RCONCommandsServer.commands.rcon_history,
    ["rcon_help"] = RCONCommandsServer.commands.rcon_help,
};

RCONCommandsServer.handleClientCommand = function(moduleName, func, playerObj, args)
    if (moduleName == "RCONCommands" and func == "handleClientCommand") then
        if isClient() then
            RCONCommandsUtils.printDebug("RCONCommandsServer", "handleClientCommand", "Command received from client side. Aborting");
            return
        end
        -- Extract command from message (assuming format "/command args")
        local command = tostring(args[1])
        local slashCommand = command:match("^/([%w_]+)");

        RCONCommandsUtils.printDebug("RCONCommandsServer", "handleClientCommand", "Command received: " .. command);
        if slashCommand then
            RCONCommandsUtils.printDebug("RCONCommandsServer", "handleClientCommand", "Slash command: " .. slashCommand);
            if RCONCommandsServer.commands[slashCommand] then
                RCONCommandsServer.commands[slashCommand](command);
            else
                RCONCommandsUtils.printDebug("RCONCommandsServer", "handleClientCommand", "Unknown slash command /" .. slashCommand);
            end
        else
            RCONCommandsUtils.printDebug("RCONCommandsServer", "handleClientCommand", "Invalid command format " .. command);
        end
    end
end

RCONCommandsServer.initServer = function()
    RCONCommandsUtils.printDebug("RCONCommandsServer", "initServer", "Multiplayer mode");

    Events.OnClientCommand.Add(RCONCommandsServer.handleClientCommand);
end

Events.OnServerStarted.Add(RCONCommandsServer.initServer)