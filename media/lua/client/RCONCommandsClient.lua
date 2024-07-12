local RCONCommandsUtils = require 'RCONCommandsUtils'
RCONCommandsUtils.moduleName = "RCONCommandsClient"

local handleAddMessage = function(message)
    -- Check if this is a servermsg / ServerAlert
    if message:isServerAlert() then
        local command = message:getText();
        -- Check if the message starts with a '/'
        if message:getText():sub(1, 1) == "/" then
            RCONCommandsUtils.log.debug("/servermsg received: " .. command);

            -- If gets to this point, we suppress the message from the client and handle the command
            -- remove the ServerAlert flag (big red message)
            -- set the text content to blank
            -- set showInChat to false (that doesn't seem to do anything)
            -- set setOverHeadSpeech to false
            -- the game will still create a blank line on client chat
            message:setServerAlert(false);
            message:setText("");
            message:setShowInChat(false);
            message:setOverHeadSpeech(false);            
            RCONCommandsUtils.log.debug("Sending command to the server");
            sendClientCommand("RCONCommands", "handleClientCommand", { command });
        end
    end
end

Events.OnAddMessage.Add(handleAddMessage)