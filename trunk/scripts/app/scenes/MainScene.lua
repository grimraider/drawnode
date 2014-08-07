--[[==========================================================================
#     FileName: MainScene.lua
#         Desc: 
#       Author: zhangfa
#        Email: 
#     HomePage: 
#      Version: 0.0.1
#   LastChange: 2014-08-04 00:00:01
#      History:
=============================================================================]]

local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
--    self:createTitle()
--    self:loadMainUI()
    self:createMainMenu()
end

function MainScene:onEnter()
end

function MainScene:onExit()
end

function MainScene:loadMainUI()
    self.layer = display.newLayer()
    self:addChild(self.layer)
    self.uiLayer = TouchGroup:create()
    self.layer:addChild(self.uiLayer)
    self.uiLayer:setTouchEnabled(true)
end

function MainScene:createTitle()
    ui.newTTFLabel({text = "Hello, World", size = 64, align = ui.TEXT_ALIGN_CENTER})
        :pos(display.cx, display.cy)
        :addTo(self)
end

function MainScene:createMainMenu()
    local y = display.height / (MAIN_MENU_ITEM_COUNT+1)
    local itemPlay = ui.newTTFLabelMenuItem({text = "Play", listener = function(tag)
    self:menuClicked(tag)
    end, tag = MAIN_MENU_ITEM_PLAY})
        :pos(0, y*2)
    local itemExit = ui.newTTFLabelMenuItem({text = "Exit", listener = function(tag)
    self:menuClicked(tag)
    end, tag = MAIN_MENU_ITEM_EXIT})
        :pos(0, y)
    local menu = ui.newMenu({itemPlay, itemExit})
            :pos(display.cx, 0)
            :addTo(self)
end

function MainScene:menuClicked(tag)
    if tag == MAIN_MENU_ITEM_PLAY then
        self:play()
    elseif tag == MAIN_MENU_ITEM_EXIT then
        self:exit()
    end
end

function MainScene:play()
    app:enterGameScene()
end

function MainScene:exit()
    os.exit()
end


return MainScene
