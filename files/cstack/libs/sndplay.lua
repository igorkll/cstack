local sndplay = {}

function sndplay.playAudioStreamFromUrl(speaker, url, chunkSize, yield)
    local response = http.get(url, nil, true)
    if not response then
        return -1
    end

    if response.getResponseCode() ~= 200 then
        local errCode = response.getResponseCode()
        response.close()
        return errCode
    end

    if not chunkSize then
        chunkSize = 16 * 1024
    end

    while true do
        local chunk = response.read(chunkSize)
        if not chunk then
            break
        end

        local buffer = {}
        for i = 1, #chunk do
            buffer[i] = string.byte(chunk, i) - 128
        end

        while not speaker.playAudio(buffer) do
            os.pullEvent("speaker_audio_empty")
        end

        if yield then
            yield()
        end
    end

    response.close()
end

return sndplay