display.setStatusBar(display.HiddenStatusBar)

-- 물리 설정
require("physics")
physics:start()
physics.setGravity(0, 45)    

-- 기초 변수
local st = -250
local ed = 50
local c1y = math.random(st, ed)
local c2y = math.random(st, ed)
local c3y = math.random(st, ed)
local isPause = false
local chimneyWidth = 90
local chimnetHeight = 480
local gap = chimnetHeight+140
local speed = 1
local score = 0


-- 배경 설정
local clouds = display.newImageRect( "clouds.png", display.contentWidth, display.contentHeight+100) 
clouds.x = display.contentWidth/2
clouds.y = display.contentHeight/2

-- 공 설정
local ball = display.newCircle(display.contentWidth/2*0.8, display.contentHeight/2, 16)
ball:setFillColor(255, 255, 0)
physics.addBody(ball, "dynamic", {density=1.6, friction=0.0, bounce=0.2, radius=20})

-- 굴뚝  설정
local chimney1u = display.newRect( 600, c1y, chimneyWidth, chimnetHeight )
local chimney1d = display.newRect( 600, c1y+gap, chimneyWidth, chimnetHeight )
local chimney2u = display.newRect( 900, c2y, chimneyWidth, chimnetHeight )
local chimney2d = display.newRect( 900, c2y+gap, chimneyWidth, chimnetHeight )
local chimney3u = display.newRect( 1200, c3y, chimneyWidth, chimnetHeight )
local chimney3d = display.newRect( 1200, c3y+gap, chimneyWidth, chimnetHeight )
chimney1u:setFillColor(0, 255, 0)
chimney1d:setFillColor(0, 255, 0)
chimney2u:setFillColor(0, 255, 0)
chimney2d:setFillColor(0, 255, 0)
chimney3u:setFillColor(0, 255, 0)
chimney3d:setFillColor(0, 255, 0)
physics.addBody(chimney1u, "static", {density=1.0, friction=0.3, bounce=0.2})
physics.addBody(chimney1d, "static", {density=1.0, friction=0.3, bounce=0.2})
physics.addBody(chimney2u, "static", {density=1.0, friction=0.3, bounce=0.2})
physics.addBody(chimney2d, "static", {density=1.0, friction=0.3, bounce=0.2})
physics.addBody(chimney3u, "static", {density=1.0, friction=0.3, bounce=0.2})
physics.addBody(chimney3d, "static", {density=1.0, friction=0.3, bounce=0.2})

-- 잔디 설정
local grass1 = display.newImageRect( "grass.png", 330, 40)
local grass2 = display.newImageRect( "grass.png", 330, 40)
grass1.x = display.contentWidth/2
grass1.y = display.contentHeight+30
grass2.x = display.contentWidth*1.5
grass2.y = display.contentHeight+30
physics.addBody(grass1, "static", {density=1.0, friction=0.3, bounce=0.2})
physics.addBody(grass2, "static", {density=1.0, friction=0.3, bounce=0.2})



-- 텍스트
local txtGameover = display.newText( "Game Over", display.contentWidth/2, 100, native.systemFont, 48 )
txtGameover.alpha = 0
local txtRestart = display.newText( "Restart", display.contentWidth/2, 150, native.systemFont, 24 )
txtRestart.alpha = 0

function update()
    if isPause == false then
        updateBackgrounds()
        if display.contentWidth/2-3 < chimney1u.x and chimney1u.x < display.contentWidth/2 + 3 then
            score = score + 1
        end
    end
end

function updateBackgrounds()
    chimney1u.x = chimney1u.x - (5 * speed)
    chimney1d.x = chimney1d.x - (5 * speed)
    chimney2u.x = chimney2u.x - (5 * speed)
    chimney2d.x = chimney2d.x - (5 * speed)
    chimney3u.x = chimney3u.x - (5 * speed)
    chimney3d.x = chimney3d.x - (5 * speed)

    grass1.x = grass1.x - (5 * speed)
    grass2.x = grass2.x - (5 * speed)

    if chimney1u.x < -300 then
        chimney1u.x = 600
        chimney1d.x = 600
        c1y = math.random(st, ed)
        chimney1u.y = c1y
        chimney1d.y = c1y+gap
    end

    if chimney2u.x < -300 then
        chimney2u.x = 600
        chimney2d.x = 600
        c2y = math.random(st, ed)
        chimney2u.y = c2y
        chimney2d.y = c2y+gap
    end    

    if chimney3u.x < -300 then
        chimney3u.x = 600
        chimney3d.x = 600
        c3y = math.random(st, ed)
        chimney3u.y = c3y
        chimney3d.y = c3y+gap
    end
 
    if grass1.x < -display.contentWidth/2 then
        grass1.x = display.contentWidth*1.5
    end
    if grass2.x < -display.contentWidth/2 then
        grass2.x = display.contentWidth*1.5
    end
end

function onTouch( event )
    if isPause then
        ball.x = display.contentWidth/2*0.8
        ball.y = display.contentHeight/2
        chimney1u.x, chimney1u.y = 600, c1y
        chimney1d.x, chimney1d.y = 600, c1y+gap
        chimney2u.x, chimney2u.y = 900, c2y
        chimney2d.x, chimney2d.y = 900, c2y+gap
        chimney3u.x, chimney3u.y = 1200, c3y
        chimney3d.x, chimney3d.y = 1200, c3y+gap
        txtGameover.alpha = 0
        txtRestart.alpha = 0
        physics:start()
        ball:setLinearVelocity( 0, 0 )
        ball:applyLinearImpulse( 0, 0, ball.x, ball.y )
        ball:resetMassData()

        isPause = false
        return false
    end

    if event.phase == "began" then
        ball:resetMassData()
        ball:setLinearVelocity( 0, 0 )
        ball:applyLinearImpulse( 0, -32, ball.x, ball.y )
    end

    return true
end

function circleCollision( event )
    print( 'collision !!!' )
    physics:stop()
    isPause = true
    txtGameover.alpha = 1
    txtRestart.alpha = 1
end


-- Main
Runtime:addEventListener("touch", onTouch )
Runtime:addEventListener("collision", circleCollision )

timer.performWithDelay(1, update, -1)