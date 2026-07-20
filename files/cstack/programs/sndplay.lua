local speaker = peripheral.find("speaker")
if not speaker then
    return
end

local args = { ... }
local urlOrPath = args[1]

local streamOrError
if text.startwith(string, urlOrPath, "http:") or 
    text.startwith(string, urlOrPath, "https:") then
    print("Loading stream from url (" .. urlOrPath .. ")...")
    streamOrError = sndplay.loadStreamFromUrl(urlOrPath)
else
    print("Loading stream from disk (" .. urlOrPath .. ")...")
    streamOrError = sndplay.loadStreamFromDisk(urlOrPath)
end

if type(streamOrError) == "string" then
    print("Error: ", streamOrError)
    return
end

print("Starting playing...")
sndplay.playStream(speaker, streamOrError)
