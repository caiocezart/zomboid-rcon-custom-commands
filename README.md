# Zomboid RCON Custom Commands

The Project Zomboid Game does not expose its backend functionalities for creating custom server/admin commands through its Lua scripts modding tooling, making the only other way to achieve similar results patching the game Java files.

This project is an attempt to provide a way for dedicated server administrators to remotely run custom commands towards their servers.

# Features

- Allows server administrators to define and run custom commands.
- No need to modify the game's Java files.
- Utilizes Lua scripting to extend the game's functionalities.

# How it works

- Using the `/servermsg` admin command through RCON, you will send a broadcast message to all users online
- The mod will be "listening" for `OnAddMessages` event. This event is triggered when a message will be printed to the users chat.
- The mod will filter the messages looking just for the custom commands

# Limitations

Unfortunately, the Event being used to triggered the commands is a Client event. Therefore, you will need at least one player online at your server for the command to be triggered.

It doesn't have any dependencies on the player itself, literally just need a player online.

# Running Commands

Send commands via RCON:

Use your preferred RCON client to send commands to the server.

## Commands available (WIP):

- `servermsg "/spawn_zombies <command_id> <pos_x> <pos_y> <pos_z> <zombie_qty>"`
  - i.e `servermsg "/spawn_zombies 1 100 200 0 50"`

- `servermsg "/spawn_item <command_id> <item_name> <pos_x> <pos_y> <pos_z>"`
  - i.e `servermsg "/spawn_item Base.Axe 1 100 200 0"`