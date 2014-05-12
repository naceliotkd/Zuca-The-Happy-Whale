--------------------------------------------------------------------------------------------------------------------
-- inicio.lua
--------------------------------------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local score
local vidas
local tempo
local txt_counter
local vidasTxt
local scoreTxt

local coinSpriteData = require "resources.coinSpriteData"

local coinSprite = graphics.newImageSheet( 'images/coin-sprite.png', coinSpriteData )
local coinSpriteOptions = {
	{ name="default", start=1, count=10, time=600, loop=1 }
}


display.setStatusBar( display.HiddenStatusBar )
local jump = audio.loadStream( "sounds/jump.wav" )
local showCredits = {}

-- get our screen dimensions
local _W = display.contentWidth
local _H = display.contentHeight

--------------------------------------------------------------------------------------------------------------------
-- adicionando fisica ao jogo

local physics = require "physics"
physics.start()

--------------------------------------------------------------------------------------------------------------------

-- Musica de Fundo

local backgroundMusic = audio.loadStream("sounds/Bubble.mp3")
local backgroundMusicChannel = audio.play( backgroundMusic, {loops= -1}  )
-- -----------------------------------------------------------------------------------------------------------------


-- GLOBALS
local character
local background
local background1
local barra 


-- adicionando items a tela
--------------------------------------------------------------------------------------------------------------------

function scrollCity(self,event)
	if self.x < -955 then
		self.x = 960
	else
		self.x = self.x - self.speed
	end	
end

--------------------------------------------------------------------------------------------------------------------



----------------------------------------------------------------------------------------------------------------------

--ADD IMAGEM NO CHÃO

--local ground = display.newImage( "images/ground.png" )
--ground.x, ground.y = 240, 335 

--local groundShape = { -240,-20, 240,-20, 240,20, -240,20 }
--physics.addBody( ground, "static", { friction=3.0, density=1.0, bounce=0.0, shape=groundShape } )

---------------------------------------------------------------------------------------------------

local moedaSound = audio.loadStream( "sounds/moedas4.ogg" )

function onCollision(event)
	local other = event.other
	if other.tipo == 'moeda' then
		display.remove(event.other)
		audio.play(moedaSound) -- Adiciona som a colisao
		score.text= tostring(tonumber(score.text)+10)  --Adiciona os valores ao score
	elseif other.tipo == 'lixo' then
		if event.target.vidas == 1 then
		
			local options =
				{
					effect = "fade",
					time = 400,
					params = {
								score = score.text
							}
			}
		
			storyboard.gotoScene("gameover", options)
		end
		display.remove(other)
		audio.play(moedaSound) -- Adiciona som a colisao
		event.target.vidas = event.target.vidas - 1
		vidas.text= tostring(tonumber(event.target.vidas))  --remove vida
		
	end
	
end

--------------------------------------------------------------------------------------------------------------------



-- criando limites
--------------------------------------------------------------------------------------------------------------------

-- criação das paredes que servirão de limite
-- parede esquerda

--local leftWall = display.newRect(0, 0, 1, _H)
--leftWall.x = 0
--leftWall.y = _H/2
--physics.addBody( leftWall, "static", {density = 1.0, friction = 0.3, bounce = 0.2} )

-- parede direita
--local rightWall = display.newRect(0, 0, 1, _H)
--rightWall.x = _W
--rightWall.y = _H/2
--physics.addBody( rightWall, "static", {density = 1.0, friction = .6, bounce = 0.2} )
--------------------------------------------------------------------------------------------------------------------


-- Criar o objecto rectangular mesmo tamanho e colocá-lo na parte superior da tela
local topWall = display.newRect(0, 0, _W, 1)
topWall.x = _W / 2
topWall.y = 1
physics.addBody( topWall, "static", {density = 1.0, friction = 0.6, bounce = 0.2} )



local chao = display.newRect(_W/2, 0, _W, 1)
chao.y = _H
chao.x = _W/2
physics.addBody(chao, 'static', {bounce=0})
--------------------------------------------------------------------------------------------------------------------


-- Criando eventos de toque

local function charactertouch( event )
	if ( event.phase == "began" ) then
		character:applyForce( 0, -800, character.x, character.y )
		
	end
	return true
end

local function onScreenTouch( event )
	if event.phase == "began" then
		character:applyForce( 0, -1100, character.x, character.y )
		audio.play(jump)
	end

	return true
end



local function showFPS( event )
	--print( display.fps )
end

------------------------------------------------------------------------------------------------------
-- Bolhas


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
------------------------------------------------------------------------------------------------------

-- Moedas

local moedas = display.newGroup()
local velocidadeMoeda = 2
local yPos = {_H*0.2, _H*0.4, _H*0.6, _H*0.8}
local arrayMoeda = {'images/moeda.png', 'images/moeda2.png', 'images/moeda3.png'}

function criarMoedas()
	local moeda = display.newSprite( coinSprite, coinSpriteOptions ) --display.newImage(arrayMoeda[math.floor(math.random()*3)+1], _W, yPos[math.floor(math.random() * 4)+1])
	moeda.x, moeda.y = _W, yPos[math.floor(math.random() * 4)+1]
	physics.addBody(moeda, 'kinematic')
	moeda.isSensor = true
	moeda.tipo = 'moeda'
	moedas:insert(moeda)
	moeda:play()
end

function updateMoedas()
	if(moedas ~= nil)then
		for i = 1, moedas.numChildren do
			local moeda = moedas[i]
			moeda.x = moeda.x - velocidadeMoeda
		end
	end
end

local timerMoeda = timer.performWithDelay(1000, criarMoedas, 0)
------------------------------------------------------------------------------------------------------

-- lixo

local lixos = display.newGroup()
local velocidadeLixos = 2
local arrayLixo = {'images/pet.png', 'images/pneu.png', 'images/saco.png'}

local yPosLixo = {_H*0.3, _H*0.5, _H*0.7, _H*0.9}

function criarLixos()
	local lixo = display.newImage(arrayLixo[math.floor(math.random()*3)+1], _W, yPosLixo[math.floor(math.random() * 4)+1])
	physics.addBody(lixo, 'kinematic')
	lixo.isSensor = true
	lixo.tipo = 'lixo'
	lixos:insert(lixo)
end

function updateLixos()
	if(lixos ~= nil)then
		for i = 1, lixos.numChildren do
			local lixo = lixos[i]
			lixo.x = lixo.x - velocidadeLixos
		end
	end
end

local timerLixo = timer.performWithDelay(2000, criarLixos, 0)
------------------------------------------------------------------------------------------------------



-- Sprite

-- local options = {
   -- width = 32,
   -- height = 32,
   -- numFrames = 16
-- }

-- local sequenceData = {
   -- { name = "city0", start=1, count=1, time=0,   loopCount=1 },
   -- { name = "city01", start=1, count=2, time=100, loopCount=1 },
   -- { name = "city02", start=1, count=3, time=200, loopCount=1 },
   -- { name = "city03", start=1, count=4, time=300, loopCount=1 },
   -- { name = "city04", start=1, count=5, time=400, loopCount=1 },
   -- { name = "city05", start=1, count=6, time=500, loopCount=1 },
   -- { name = "city06", start=1, count=7, time=600, loopCount=1 },
   -- { name = "city07", start=1, count=8, time=700, loopCount=1 },
   -- { name = "city08", start=1, count=9, time=800, loopCount=1 },
   -- { name = "city09", start=1, count=10, time=900, loopCount=1 },
   -- { name = "city10", start=1, count=11, time=1000, loopCount=1 },
   -- { name = "city11", start=1, count=12, time=1100, loopCount=1 },
   -- { name = "city12", start=1, count=13, time=1200, loopCount=1 },
   -- { name = "city13", start=1, count=14, time=1300, loopCount=1 },
   -- { name = "city14", start=1, count=15, time=1400, loopCount=1 },
   -- { name = "city15", start=1, count=16, time=1500, loopCount=0 }, 
-- }

-- local runningSheet = graphics.newImageSheet( "/images/spritesheetRunning.png", options )
-- local runningSprite = display.newSprite( runningSheet, sequenceData )
-- runningSprite.isFixedRotation = true
-- runningSprite:setSequence( "city15" )
-- runningSprite:play()

-- runningSprite.x = 40
-- runningSprite.y = 280
-- physics.addBody( runningSprite, { friction=1.0, density=1.0, bounce=0.3, radius=0 } )

--------------------------------------------------------------------------------------------------------------------


--Runtime:addEventListener( "enterFrame", move )



function createListeners() 
	character:addEventListener( "touch", charactertouch )

	-- trocar para toque na tela
	Runtime:addEventListener( "touch", onScreenTouch )

	Runtime:addEventListener( "enterFrame", showFPS )

	Runtime:addEventListener('enterFrame', subirBolhas)

	Runtime:addEventListener('enterFrame', updateMoedas)

	Runtime:addEventListener('enterFrame', updateLixos)
	
	background.enterFrame= scrollCity
	Runtime:addEventListener("enterFrame", background)	
	background1.enterFrame= scrollCity
	Runtime:addEventListener("enterFrame", background1)
end

function removeListeners() 
	character:removeEventListener( "touch", charactertouch )

	-- trocar para toque na tela
	Runtime:removeEventListener( "touch", onScreenTouch )

	Runtime:removeEventListener( "enterFrame", showFPS )

	Runtime:removeEventListener('enterFrame', subirBolhas)

	Runtime:removeEventListener('enterFrame', updateMoedas)

	Runtime:removeEventListener('enterFrame', updateLixos)
	
	background.enterFrame= scrollCity
	Runtime:removeEventListener("enterFrame", background)	
	background1.enterFrame= scrollCity
	Runtime:removeEventListener("enterFrame", background1)

	timer.cancel( timerMoeda )
	timerMoeda = nil

	timer.cancel( timerLixo )
	timerLixo = nil
end


function scene:createScene( event )
	local group = self.view
		

		-- Texto Score
	scoreTxt = display.newText("Score:    ", 20, 10, native.systemFont, 18)
	scoreTxt:setTextColor(96, 51, 43)
	scoreTxt.rotation = 0
	--scoreTxt.size = 20
	
	score = display.newText('0', 90,10, native.systemFont, 18)
	score:setTextColor(255,255,255)
	--score.size = 20
	--------------------------------------------------------------------------------------------------------------------
	-- Texto Vidas
	vidasTxt = display.newText("Lifes:    ", 200, 10, native.systemFont, 18)
	vidasTxt:setTextColor(96, 51, 43)
	vidasTxt.rotation = 0
	--vidasTxt.size = 20

	
	vidas = display.newText('0', 255,10, native.systemFont, 18)
	vidas:setTextColor(255,255,255)
	--vidas.size = 20
	--------------------------------------------------------------------------------------------------------------------

	--------------------------------------------------------------------------------------------------------------------	
		
		
	-- Texto Time
	 tempo = display.newText("Time:", 370, 10, native.systemFont, 18)
	tempo:setTextColor(96, 51, 43)
	tempo.rotation = 0
	--tempo.size = 20

	--------------------------------------------------------------------------------------------------------------------
	-- Time
	display.setStatusBar(display.HiddenStatusBar) _W = display.contentWidth _H = display.contentHeight number = 0
	 
	 txt_counter = display.newText( number, 0, 0, 'Marker Felt', 18 )
	txt_counter.x = 450
	txt_counter.y = 20
	txt_counter:setTextColor( 255, 255, 255 )
	function fn_counter()
	number = number + 1
	txt_counter.text = number
	end
	timer.performWithDelay(1000, fn_counter, 0)

	
		
	-- Rolando fundo da tela ---

	background = display.newImage('images/BG_Oficial.png')
	background:setReferencePoint(display.BottomLeftReferencePoint)
	background.x = 0
	background.y = 320
	background.speed = 0.5
		
	background1 = display.newImage('images/BG_Oficial.png')
	background1:setReferencePoint(display.BottomLeftReferencePoint)
	background1.x = 960
	background1.y = 320
	background1.speed = 0.5	
	
	-- Caracter Zuca
	character = display.newImage( "images/zuca.png" )
	character.x = 60
	character.y = 230
	physics.addBody( character, { friction=0.1, density=1, bounce=0.2, radius=35 } )
	character:addEventListener('collision', onCollision)
	character.vidas = 3
	vidas.text = character.vidas
	
	
	
	
	
	group:insert(background)
	group:insert(background1)
	group:insert(moedas)
	group:insert(lixos)
	group:insert(character)
	group:insert(txt_counter)
	group:insert(tempo)
	group:insert(vidas)
	group:insert(score)
	group:insert(vidasTxt)
	group:insert(scoreTxt)
end

function scene:enterScene( event )
	local group = self.view
	--moedas=display.newGroup()
	createListeners()
end

function scene:exitScene( event )
	local group = self.view

	removeListeners()
	audio.stop()
end

function scene:destroyScene( event )
	local group = self.view
	
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene