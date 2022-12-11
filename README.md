# CC_Proximity_Chat (ComputerCraft Proximity Chat)

ComputerCraft proximity chat using Noisy Pocket Computer (Pocket Computer with Speakers)

This programs work in conjunction with [CCAudio Discord Bot](https://github.com/Shiranuit/CCAudio_Discord_Bot) which is a bot that can join discord voice channels and listen to what people are saying.

## How it works

People join a voice channel and use the command `/joinvocal` that forces the bot to join the voice channel where the current user is.
Then the bot start listening to what peoples are saying.
The bot then opens a Websocket Server where clients can ask to receive the Audio of someone by providing the `GuildId` where the bot is currently in along with the `UserId` of the user from whom we want to receive the Audio Stream.
The bot then uses Opus to decode Audio to 16Bit PCM then converts it to unsigned 8Bit PCM format which is directly usable by the ComputerCraft Speakers

The `proximityChat.lua` program connects to the websocket endpoint provided and listen to the Audio Stream received from the given UserId inside the a specific Discord Server.
The programs retrieve the Audio Stream and then plays the Audio on the PocketComputer speaker.
People around including the one possessing the PocketComputer will then hear its voice ingame through the ComputerCraft speakers.

If every people in the Discord Channel mutes each other, and each one of them owns a Noisy Pocket Computer with the program configured to listen to their own voice then this would behave like a real proximity chat since speakers have a range of 16 Blocks by default.
