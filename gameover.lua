local storyboard = require "storyboard"
local scene = storyboard.newScene()

function scene:createScene( event )
	local params = event.params
	local lose = display.newText("Game over", 145, 130, nil, 36)
	lose:setTextColor(255,255,255)
	
	local lose = display.newText("Score: " .. params.score, 145, 190, nil, 36)
	lose:setTextColor(255,255,255)
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