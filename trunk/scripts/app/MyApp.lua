
require("config")
require("framework.init")
require("app.GameDef")

local MyApp = class("MyApp", cc.mvc.AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)
end

function MyApp:run()
    self:setSys()
    self:addSearchPath()
    self:enterMainScene()
end

function MyApp:setSys()
    
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)
    
    CCDirector:sharedDirector():setAnimationInterval(1/GAME_FRAME_PER_SECOND)
    
end

function MyApp:addSearchPath()
    CCFileUtils:sharedFileUtils():addSearchPath("res/")
end

function MyApp:enterMainScene()
    self:enterScene("MainScene", nil, "fade", 0.6, display.COLOR_WHITE)
end

function MyApp:enterGameScene()
    self:enterScene("GameScene", nil, "fade", 0.6, display.COLOR_WHITE)
end

return MyApp
