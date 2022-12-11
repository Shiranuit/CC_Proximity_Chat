local serverIP = "" -- Server IP that provides the Websocket connection for retrieving the Audio
local guildId = "" -- Discord Server ID where the player is speaking
local userId = "" -- ID of the player speaking

local speaker = peripheral.wrap("back") -- Speaker

local ws, err = http.websocket("ws://"..serverIP, {
    guildId = guildId,
    userId = userId,
    encoding = "raw"
})

if not ws then
     printError(err)
    return
end

print("Connected")

local queue = {}

local function listen()
    while true do
        local success, message = pcall(ws.receive, 1)
        if not success then
            print("Connection closed")
            break
        end
        if success and message then
            local buffer = { message:byte(1, #message) }
            -- The buffer bytes are signed 8bit integer
            for i=1, #buffer do
                buffer[i] = buffer[i] - 128
            end

            table.insert(queue, buffer)
        else
            sleep(0.01)
        end
    end
end

local function playback()
    while true do
        -- Swap the queue with an empty one
        local buffers = queue
        queue = {}

        local concatBuffer = {}
        local index = 0

        -- ComputerCraft speakers can play PCM buffer up to 128 * 1024 bytes
        local limit = math.min(#buffers, 128)
        local i = 1

        -- Try to concat as much bytes as possible in one single buffer
        while i <= limit and index + #buffers[i] <= 128*1024 do
            for j=1, #buffers[i] do
                index = index + 1
                concatBuffer[index] = buffers[i][j]
            end
            i = i + 1
        end

        -- Enqueue buffers that cannot be played during this frame
        for i=1, #buffers - i do
            queue[i] = buffers[i]
        end

        if #concatBuffer > 0 then
            -- Try to play the audio buffer
            while not speaker.playAudio(concatBuffer) do
                -- Wait for the audio speaker to be empty before retrying
                os.pullEvent("speaker_audio_empty")
            end
        else
            sleep(0.01)
        end
    end
end

parallel.waitForAny(listen, playback)
