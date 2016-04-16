-- EtchASketch
-- (c) by jack0088@me.com

function setup()
    --supportedOrientations(LANDSCAPE_ANY)
    displayMode(FULLSCREEN)
    
    pen    = vec2(WIDTH*.5, HEIGHT*.5)
    canvas = image(WIDTH, HEIGHT)
    setContext(canvas)
    spriteMode(CORNER)
    sprite("Dropbox:iron filings", 0, 0, WIDTH, HEIGHT)
    setContext()
    
    print("* Drag to etch.")
    print("* Press Home and Power buttons simultaniously to save your sketch. - Use native 'Photos' app to share your creation.")
    print("* Shake to start over.")
end

function draw()
    if CurrentOrientation == PORTRAIT or CurrentOrientation == PORTRAIT_UPSIDE_DOWN then
        background(118, 130, 138, 255)
        fill(165, 176, 184, 255)
        textWrapWidth(WIDTH/2)
        textMode(CENTER)
        textAlign(CENTER)
        text("* Drag to etch.\n\n* Press Home and Power buttons simultaniously to save your sketch. - Use native 'Photos' app to share your creation.\n\n* Shake to start over.", WIDTH/2, HEIGHT/2)
        --text("Turn your Device by 90deg.", WIDTH/2, HEIGHT/2)
        return
    end
    
    background(31, 31, 31, 255)
    noSmooth()
    pushStyle()
    
    --Etch-A-Sketch to an image
    if joystick then
        setContext(canvas)
        blendMode(ZERO, ONE, ZERO, ONE_MINUS_SRC_ALPHA)
        canvas.premultiplied = false
        
        local point = {
            x1 = pen.x,
            y1 = pen.y,
            x2 = pen.x + joystick.dx,
            y2 = pen.y + joystick.dy
        }
        pen = vec2(point.x2, point.y2)
        if pen.x < 0 then pen.x = 0 end
        if pen.x > WIDTH then pen.x = WIDTH end
        if pen.y < 0 then pen.y = 0 end
        if pen.y > HEIGHT then pen.y = HEIGHT end
        
        stroke(0, 0, 0, 200)
        strokeWidth(20)
        lineCapMode(PROJECT)
        line(point.x1, point.y1, point.x2, point.y2)
        ellipse(pen.x, pen.y, strokeWidth())
        blendMode(NORMAL)
        setContext()
    end
    
    -- Display image
    tint(170, 170, 170, 255)
    sprite("Dropbox:ybar", pen.x-6, 0, 12, WIDTH)
    sprite("Dropbox:xbar", 0, pen.y-6, WIDTH, 12)
    spriteMode(CENTER)
    sprite("Dropbox:scraper", pen.x, pen.y)
    
    popStyle()
    sprite(canvas)
    
    --HUD
    if joystick then
        -- Lazy Mouse
        fill(224, 224, 224, 255)
        ellipse(pen.x, pen.y, 3)
        
        local offset = 200
        local point = vec2(joystick.dx, joystick.dy):normalize() * offset + vec2(pen.x, pen.y)
        stroke(131, 106, 155, 255)
        stroke(26, 77, 148, 255)
        strokeWidth(1)
        line(pen.x, pen.y, point.x, point.y)
        
        -- Joystick
        offset = (joystick.size or 0)
        point = vec2(joystick.dx, joystick.dy):normalize() * offset + vec2(joystick.cx, joystick.cy)
        noFill()
        ellipse(joystick.cx, joystick.cy, joystick.size)
        popStyle()
    end
end

function touched(touch)
    if touch.state == BEGAN then
        if not joystick then
            joystick = {
                id = touch.id,
                size = 10,
                cx = touch.x,
                cy = touch.y,
                x = touch.x,
                y = touch.y,
                dx = 0,
                dy = 0
        }
        end
    end
    
    if touch.state == ENDED then
        if joystick and joystick.id == touch.id then
            joystick = nil
        end
    end
    
    if touch.state == MOVING then
        if joystick and joystick.id == touch.id then
            joystick.dist = math.ceil(vec2(touch.x, touch.y):dist(vec2(joystick.cx, joystick.cy)))
            local dx = (touch.x - joystick.cx) * .004
            local dy = (touch.y - joystick.cy) * .004
            
            joystick.x, joystick.y = touch.x, touch.y
            joystick.dx, joystick.dy = dx, dy
        end
    end
end