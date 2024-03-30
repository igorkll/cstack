local menu = require("libs/menu")

menu.defaultColors()

menu.menu("test", {
    "test1",
    "test2",
    "worm"
}, {
    function ()
        
    end,
    function ()
        
    end,
    function ()
        shell.run("worm")
    end,
})