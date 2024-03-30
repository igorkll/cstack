local menu = require("libs/menu")

term.setBackgroundColor(colors.lightBlue)
term.setTextColor(colors.white)

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