local storyboard = require "storyboard"
local scene = storyboard.newScene()
local background
local btnMenu


-- get our screen dimensions
local _W = display.contentWidth

local function onMenuBtnRelease()
	storyboard.gotoScene ( "menu" )
	
	return true	
end

function scene:createScene( event )
	local group = self.view

	background = display.newImage( "images/BGCred.jpg")
	background.anchorX = 0
	background.anchorY = 0
	
	
	local btnMenu = display.newImage('images/BTVOLTAR1.png', 10, 287, 0, 0)
	
	btnMenu:addEventListener('tap', onMenuBtnRelease)
	
	group:insert( background )
	group:insert( btnMenu )
	
	
end

function scene:enterScene( event )
	local group = self.view
end

function scene:exitScene( event )
	local group = self.view
end

function scene:destroyScene( event )
	local group = self.view
	
	
end




scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene