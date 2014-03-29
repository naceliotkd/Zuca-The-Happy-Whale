local character = display.newImage( "images/character.png" )
character.x = 0
character.y = 230
physics.addBody( character, { friction=0.1, density=0.6, bounce=0.1, radius=35, shape={ 0,-35, 37,30, -37,30 } } )
character.isFixedRotation = true

return character