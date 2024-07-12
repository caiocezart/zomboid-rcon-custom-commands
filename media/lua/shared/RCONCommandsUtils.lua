local RCONCommandsUtils = {};
RCONCommandsUtils.moduleName = "";
RCONCommandsUtils.LOG_LEVELS = {
    ERROR = 1,
    INFO = 2,
    DEBUG = 3
};
RCONCommandsUtils.logLevel = RCONCommandsUtils.LOG_LEVELS.INFO;
RCONCommandsUtils.log = {};

RCONCommandsUtils.log.info = function(message)
    if RCONCommandsUtils.logLevel >= RCONCommandsUtils.LOG_LEVELS.INFO then
        print("[INFO][" .. RCONCommandsUtils.moduleName .. "] " .. message);
    end
end

RCONCommandsUtils.log.debug = function(message)
    if RCONCommandsUtils.logLevel >= RCONCommandsUtils.LOG_LEVELS.DEBUG then
        print("[DEBUG][" .. RCONCommandsUtils.moduleName .. "] " .. message);
    end
end

RCONCommandsUtils.log.error = function(message)
    if RCONCommandsUtils.logLevel >= RCONCommandsUtils.LOG_LEVELS.ERROR then
        print("[ERROR][" .. RCONCommandsUtils.moduleName .. "] " .. message);
    end
end

return RCONCommandsUtils