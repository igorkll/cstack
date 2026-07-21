local sndplay = {}

function sndplay.loadStreamFromUrl(url, chunkSize)
    local response = http.get(url, nil, true)
    if not response then
        return "failed to load stream"
    end

    if response.getResponseCode() ~= 200 then
        local errCode = response.getResponseCode()
        response.close()
        return errCode
    end

    if not chunkSize then
        chunkSize = 16 * 1024
    end

    local ended = false
    local stream
    stream = {
        getBuffer = function()
            if ended then return end

            local chunk = response.read(chunkSize)
            if not chunk then
                stream.close()
                return
            end

            local buffer = {}
            for i = 1, #chunk do
                buffer[i] = string.byte(chunk, i) - 128
            end

            return buffer
        end,
        reopen = function()
            return sndplay.loadStreamFromUrl(url, chunkSize)
        end,
        close = function()
            if ended then return false end
            response.close()
            ended = true
            return true
        end,
        isEnded = function()
            return ended
        end
    }

    return stream
end

function sndplay.loadStreamFromDisk(url, chunkSize)

end

function sndplay.waitIfNeedAndPlayBuffer(speaker, buffer)
    while not speaker.playAudio(buffer) do
        local speakerName = peripheral.getName(speaker)
        while true do
            local eventData = {os.pullEvent("speaker_audio_empty")}
            if eventData[2] == speakerName then break end
        end
    end
end

function sndplay.waitIfNeedAndPlayBufferOnSeveralSpeakers(speakers, buffer)
    sndplay.waitIfNeedAndPlayBuffer(speakers[1], buffer)
    for i = 2, #speakers do
        speakers[i].playAudio(buffer)
    end
end

function sndplay.playStream(speaker, stream, loop)
    while true do
        local buffer = stream.getBuffer()
        if buffer then
            sndplay.waitIfNeedAndPlayBuffer(speaker, buffer)
        else
            if loop then
                stream = stream.reopen()
            else
                return
            end
        end
    end
end

function sndplay.playStreamOnSeveralSpeakers(speakers, stream, loop)
    while true do
        local buffer = stream.getBuffer()
        if buffer then
            sndplay.waitIfNeedAndPlayBuffer(speakers[1], buffer)
            for i = 2, #speakers do
                speakers[i].playAudio(buffer)
            end
        else
            if loop then
                stream = stream.reopen()
            else
                return
            end
        end
    end
end

return sndplay