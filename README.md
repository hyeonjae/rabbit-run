# rabbit-run


Scene 전환 방법

```lua
// main.lua
local storyboard = require "storyboard"

storyboard.gotoScene( "menuScene" )
```

```lua
// menuScene
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local screen = nil

function initializeGame()
  require 'init_buttons'

  math.randomseed( os.time() )
end

function scene:createScene( event )
  screen = self.view

  local loadingImage = display.newImageRect( "images/splash_screen.png", 480, 320 )
  loadingImage.x = display.contentWidth/2
  loadingImage.y = display.contentHeight/2
  screen:insert(loadingImage)

  local gotoMainMenu = function()
    storyboard.gotoScene( "menu" )
  end

  initializeGame()

  local loadMenuTimer = timer.performWithDelay( 1000, gotoMainMenu, 1 )
end

function scene:enterScene( event )
  print("Loading screen loaded...")

  storyboard.removeAll()
end

function scene:exitScene( event )
end

function scene:destroyScene( event )
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene
```
