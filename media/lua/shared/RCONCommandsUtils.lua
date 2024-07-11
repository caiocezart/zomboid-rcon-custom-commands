RCONCommandsUtils = {};

RCONCommandsUtils.printDebug = function(_module, _function, _string)
    if _module ~= nil and _string ~= nil then
        print("[" .. tostring(_module) .. "][" .. tostring(_function) .. "] " .. tostring(_string));
    elseif _module == nil and _string ~= nil then
        print("...NO MODULE RECEIVED..." .. tostring(_string));
    else
        print("...ERROR IN DEBUG...");
    end
end