--[[==========================================================================
#     FileName: Target.lua
#         Desc: 
#       Author: zhangfa
#        Email: 
#     HomePage: 
#      Version: 0.0.1
#   LastChange: 2014-08-06 00:00:01
#      History:
=============================================================================]]


local Target = class("Target", function()
    return display.newNode()
end)

function Target:ctor()
    self.active = false
    math.randomseed(os.clock())
    local r = math.random()
    local g = math.random()
    local b = math.random()
    self.fillColor = cc.c4f(r, g, b, 1)
    r = math.random()
    g = math.random()
    b = math.random()
    self.borderColor = cc.c4f(r, g, b, 1)
    local drawNode = display.newDrawNode()
        :addTo(self)
    --local xywh = {x = -10, y = -10, w = 20, h = 20}
    --local params = {fillColor = self.fillColor, borderColor = self.borderColor, borderWidth = 1}
    --drawNode:drawRect(xywh, params)
    local params = {segments = 4, fillColor = self.fillColor, borderColor = self.borderColor, borderWidth = 3}
    drawNode:drawCircle(16, params)
    self.drawNode = drawNode
end

function Target:isActive()
    return self.active
end

function Target:setActive(active)
    self.active = active
end

return Target