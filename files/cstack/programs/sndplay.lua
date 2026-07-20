local args = { ... }

local speakers = {}
local urlOrPath
if #args == 2 then
    speakers = {peripheral.wrap(args[1])}
    urlOrPath = args[2]
elseif #args == 1 then
    speakers = {peripheral.find("speaker")} --get all speakers
    urlOrPath = args[1]
else
    print("sndplay [speaker] <url>")
    return
end

if #speakers == 0 then
    print("Speaker not found!")
    return
end

local streamOrError
if text.startwith(string, urlOrPath, "http://") or 
    text.startwith(string, urlOrPath, "https://") then
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
sndplay.playStreamOnSeveralSpeakers(speakers, streamOrError)
