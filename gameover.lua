local storyboard = require "storyboard"
local scene = storyboard.newScene()
local btnEntrar
local btnRestart 


local function onPlayBtnRelease()
	storyboard.gotoScene ( "menu")
	
	return true	
end

local function onRestartBtnRelease()
	storyboard.gotoScene ( "inicio" )
	
	return true	
end



local lose
-- DIMENÇÕES
local _W = display.contentWidth

function scene:createScene( event )
	

	group = self.view 
	
	local background = display.newImage( "images/gameover.jpg")
	
	
	local params = event.params
	
	
	lose = display.newText("Score: " .. params.score, 175, 90, nil, 36)
	lose:setTextColor(255,255,255)
	
	local bolhasHeight = 210
	local bolhas = display.newImage('images/bolhas.png', 200, _H)
	local bolhas2 = display.newImage('images/bolhas.png', 5, _H)
	local bolhas3 = display.newImage('images/bolhas.png', 250, _H)

	local bolhasArray = { bolhas, bolhas2, bolhas3 }

	--Velocidade das bolhas
	local velBolha1, velBolha2, velBolha3 = 0.3, 1, 0.7

	local function subirBolhas() 
		bolhas.y, bolhas2.y, bolhas3.y = bolhas.y - velBolha1, bolhas2.y - velBolha2, bolhas3.y - velBolha3

		for i=1, 3 do
			if bolhasArray[i].y < -bolhasHeight then
				bolhasArray[i].x = math.random(_W)		
				bolhasArray[i].y = _H
			end
		end
	end


	
	local btnEntrar = display.newImage('images/BTMENU1.png', 380, 295, 0, 0)
	local btnRestart = display.newImage('images/BTRESTART1.png', 30, 295, 0, 0)
	
	
	btnRestart:addEventListener('tap', onRestartBtnRelease)
	btnEntrar:addEventListener('tap', onPlayBtnRelease)
	
	group:insert( background )
	group:insert( btnEntrar )
	group:insert( btnRestart )
	
	

	Runtime:addEventListener('enterFrame', subirBolhas)

	

end

function scene:enterScene( event )
	local group = self.view
	storyboard.removeScene('inicio')
end

function scene:exitScene( event )
	local group = self.view
	lose:removeSelf()
	--removeListeners()
end

function scene:destroyScene( event )
	local group = self.view
	
	
end




scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene