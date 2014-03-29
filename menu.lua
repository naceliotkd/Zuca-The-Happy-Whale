local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local widget = require "widget"

local background
local playBtn

local function onPlayBtnRelease()
	storyboard.gotoScene( "inicio" )
	
	return true	
end

function scene:createScene( event )
	local group = self.view

	background = display.newImage( "images/background.jpg")
	background.anchorX = 0
	background.anchorY = 0
	
	local titleLogo = display.newText( "Zuca", 264, 42, "Marker Felt", 43 )
	titleLogo.x = display.contentWidth * 0.5
	titleLogo.y = 100
	
	playBtn = widget.newButton{
		label="Jogar",
		labelColor = { default={255}, over={128} },
		default="button.png",
		over="button-over.png",
		width=154, height=40,
		onRelease = onPlayBtnRelease
	}
	playBtn.x = display.contentWidth*0.5
	playBtn.y = display.contentHeight - 125
	
	group:insert( background )
	group:insert( titleLogo )
	group:insert( playBtn )
end

function scene:enterScene( event )
	local group = self.view
end

function scene:exitScene( event )
	local group = self.view
end

function scene:destroyScene( event )
	local group = self.view
	
	if playBtn then
		playBtn:removeSelf()
		playBtn = nil
	end
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

return scene