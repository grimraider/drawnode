--[[==========================================================================
#     FileName: GameScene.lua
#         Desc: 
#       Author: zhangfa
#        Email: 
#     HomePage: 
#      Version: 0.0.1
#   LastChange: 2014-08-04 00:00:01
#      History:
=============================================================================]]

require("app.GameDef")
require("app.resDef.ResData")

local Ball = import("app.models.Ball")
local Target = import("app.models.Target")

local GameScene = class("GameScene",function()
    return display.newScene("GameScene")
end)

function GameScene:ctor()
    self:createLayers()
    self:createMap()
    self:createScoreLbl()
    self:initData()
    
    self:drawMarkCircle(self.centerX, self.centerY)
end

function GameScene:initData()
    self.enabled = true
    self.bIncrease = false
    self.centerX = display.cx
    self.centerY = CIRCLE_CENTER_Y
    self.minRadius = GAME_MARK_CIRCLE_RADIUS[1]
    self.maxRadius = GAME_MARK_CIRCLE_RADIUS[#GAME_MARK_CIRCLE_RADIUS]
    self.pathRadius = self.minRadius
    self.speed = 2
    self.level = 1
    self.ball = Ball.new()
    self.gameLayer:addChild(self.ball)
    self.ballLineSpeed = 4
    self.ballDirect = 1
    self.ballRadian = 0
    self.ballPosX = self.centerX + self.pathRadius * math.cos(self.ballRadian)
    self.ballPosY = self.centerY + self.pathRadius * math.sin(self.ballRadian)
    self.ball:pos(self.ballPosX, self.ballPosY)
    
    self.target = Target.new()
    self.gameLayer:addChild(self.target)
    self:resetTarget()
    local actionRepeat = CCRepeatForever:create( CCRotateBy:create(2, -360) );
    self.target:runAction(actionRepeat)
    
    self.minDisSquare = 500
    
    self.score = 0
end

function GameScene:onEnter()
    self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(dt) self:tick(dt) end)
    self:scheduleUpdate_()
end

function GameScene:onExit()
end

function GameScene:tick(dt)
    if self.enabled then
        self:updateGame(dt)
        self:drawGame(dt)
    end
end

function GameScene:updateGame(dt)
    -- update path
    if self.bIncrease then
        self.pathRadius = self.pathRadius + self.speed
        if self.pathRadius > self.maxRadius then
            self.pathRadius = self.maxRadius
        end
    else
        self.pathRadius = self.pathRadius - self.speed
        if self.pathRadius < self.minRadius then
            self.pathRadius = self.minRadius
        end
    end
    -- update ball
    local radian = self.ballLineSpeed / self.pathRadius
    self.ballRadian = self.ballRadian + radian * self.ballDirect
    if self.ballRadian > 2*math.pi then
        self.ballRadian = self.ballRadian - 2*math.pi
    elseif self.ballRadian < 0 then
        self.ballRadian = self.ballRadian + 2*math.pi
    end
    self.ballPosX = self.centerX + self.pathRadius * math.cos(self.ballRadian)
    self.ballPosY = self.centerY + self.pathRadius * math.sin(self.ballRadian)
    self.ball:pos(self.ballPosX, self.ballPosY)
    -- update collection
    if self.target:isActive() then
        local dis = (self.ballPosX - self.targetPosX)^2 + (self.ballPosY - self.targetPosY)^2
        if dis < self.minDisSquare then
            self.score = self.score + 1
            self:setScore(self.score)
            self.target:setActive(false)
            self:resetTarget()
            self.ballDirect = self.ballDirect * (-1)
        end
    end
end

function GameScene:drawGame(dt)
    self.pathNode:clear()
    local params = {fillColor = cc.c4f(0, 0, 0, 0), borderColor = cc.c4f(0, 0, 1, 1), borderWidth = 3, pos = {self.centerX, self.centerY}}
    self.pathNode:drawCircle(self.pathRadius, params)
end

function GameScene:createLayers()
    self.layer = display.newLayer()
        :addTo(self)
    self.gameLayer = display.newLayer()
        :addTo(self.layer)
    self.uiLayer = TouchGroup:create()
        :addTo(self.layer)
    self.touchLayer = display.newLayer()
        :addTo(self.layer)
    self.touchLayer:setTouchEnabled(true)
    self.touchLayer:setTouchSwallowEnabled(false)
    self.touchLayer:addNodeEventListener(cc.NODE_TOUCH_EVENT,function(event)
            self:onTouch(event)
            return true
        end)
end

function GameScene:onTouch(event)
    if event.name == "began" then
        self.bIncrease = true
    elseif event.name == "moved" then
         
    elseif event.name == "ended" or event.name == "canceled" then
        self.bIncrease = false
    end
end

function GameScene:createMap()
    self.markNode = display.newDrawNode()
        :addTo(self.gameLayer)
    
    self.pathNode = display.newDrawNode()
        :addTo(self.gameLayer)
end

function GameScene:drawDashedCircle(radius, color, x, y)
    local segments_ = 40
    local angle = 360 / segments_
    local radian = math.rad(angle)
    for i=1, segments_, 2 do
        local startRadian = radian*i
        local from = {x+radius*math.cos(startRadian), y+radius * math.sin(startRadian)}
        local endRadian = radian*(i+1)
        local to = {x+radius*math.cos(endRadian), y+radius * math.sin(endRadian)}
        self.markNode:drawLine(from, to, 2, color)
    end
end

function GameScene:drawMarkCircle(x, y)
    for k,v in ipairs(GAME_MARK_CIRCLE_RADIUS) do
        self:drawDashedCircle(v, cc.c4f(0, 1, 0, 1), x, y)
    end
end

function GameScene:createScoreLbl()
    self.scoreLbl = ui.newTTFLabel({text = "Score: 0", size = 64, align = ui.TEXT_ALIGN_CENTER})
        :pos(display.cx, display.height - 100)
        :addTo(self.uiLayer)
end

function GameScene:setScore(score)
    self.scoreLbl:setString("Score:" .. score)
end

function GameScene:resetTarget()
    local radius = GAME_MARK_CIRCLE_RADIUS[math.random(1, #GAME_MARK_CIRCLE_RADIUS)]
    local radian = math.random() * 2 * math.pi
    self.targetPosX = self.centerX + radius * math.cos(radian)
    self.targetPosY = self.centerY + radius * math.sin(radian)
    self.target:pos(self.targetPosX, self.targetPosY)
    self.target:setActive(true)
end

return GameScene