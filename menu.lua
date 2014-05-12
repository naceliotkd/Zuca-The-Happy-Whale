local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local widget = require "widget"


local background
local playBtn
local CreditsBtn

local backgroundMusic = audio.loadStream("sounds/Bubble.mp3")
local backgroundMusicChannel = audio.play( backgroundMusic, { channel=1, loops=-1, fadein=5000 }  )


local function onPlayBtnRelease()
	storyboard.gotoScene ( "inicio", { effect = "fade"} )
	
	return true	
end

local function onCreditsBtnRelease()
	storyboard.gotoScene ( "creditos" )
	
	return true	
end

function scene:createScene( event )
	local group = self.view

	background = display.newImage( "images/bgmenu.jpg")
	background.anchorX = 0
	background.anchorY = 0
	
		
	local btnEntrar = display.newImage('images/BTPLAY1.png', 380, 150, 0, 0)
	local btnCredits = display.newImage('images/BTCREDITS1.png', 370, 190, 0, 0)
	
	
	btnCredits:addEventListener('tap', onCreditsBtnRelease)
	btnEntrar:addEventListener('tap', onPlayBtnRelease)
	
	group:insert( background )
	group:insert( btnEntrar )
	group:insert( btnCredits )
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

-----------------------------------------------------------------------------------------

return scene