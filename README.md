# cstack
## my set of technologies for computercraft  
![preview](https://raw.githubusercontent.com/igorkll/cstack/refs/heads/main/screenshots/1.png)  
install: wget run https://raw.githubusercontent.com/igorkll/cstack/main/installer/installer.lua  

## features
* real background running of programs on external monitors (not multishell) via coroutine
* running multishell on external monitors (multiple multishell instances)
* music playback on speakers

## programs
* monitorbg <name> [program] [args...] - background start on an external monitor
* monitorfg <name> [program] [args...] - background start on an external monitor (selects a tab)
* monitoroff <name> - kills threads tied to the monitor and clear it
* sndplay [name] <urlOrPath> - it plays audio in PCM format. if the speaker name is not specified, it plays on all available speakers
