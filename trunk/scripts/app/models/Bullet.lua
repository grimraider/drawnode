--[[==========================================================================
#     FileName: Bullet.lua
#         Desc: 
#       Author: zhangfa
#        Email: 
#     HomePage: 
#      Version: 0.0.1
#   LastChange: 2014-08-06 00:00:01
#      History:
=============================================================================]]


local Ball = class("Ball", function()
    return display.newNode()
end)

function Ball:ctor()
    math.randomseed(os.clock())
    local r = math.random()
    local g = math.random()
    local b = math.random()
    print("ball r g b", r, g, b)
    self.color = cc.c4f(r, g, b, 1)
    self.radius = 16
    local drawNode = display.newDrawNode()
        :addTo(self)
    drawNode:drawDot(cc.p(0, 0), self.radius, self.color)
end

return Ball