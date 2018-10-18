module GameCurses where

    import Game
    import UI.NCurses

    playGame :: IO ()
    playGame = runCurses $ do
        w <- newWindow rows collumns 0 0
        defaultColor <- newColorID ColorDefault ColorDefault 2
        let 
            initGame :: Window -> Curses ()
            initGame w = do
                setEcho False
                setCursorMode CursorInvisible
                let player = Player inithialPlayerRow inithialPlayerCollumn 0
                updatePlayer player
                updateWindow w $ drawGrid 0 0 defaultColor

            updatePlayer :: Player -> Curses()
            updatePlayer player = do
                updateWindow w $ drawPlayer player defaultColor
            
            jumpPlayer :: Player -> Curses()
            jumpPlayer player = do
                updatePlayer player
                
        initGame w
        render
        waitFor w (\ev -> ev == EventCharacter 'q' || ev == EventCharacter 'Q')

    drawGrid :: Integer -> Integer -> ColorID -> Update()
    drawGrid row collumn color = do
        setColor color
        moveCursor row collumn
        drawString gridTopBottom
        drawLines 1 0
        moveCursor (rows - 1) collumn
        drawString gridTopBottom
    
    drawLines :: Integer -> Integer -> Update()
    drawLines row collumn = drawLines' row collumn rows

    drawLines' :: Integer -> Integer -> Integer -> Update()
    drawLines' row collumn n
        | n < 2 = return()
        | otherwise = do
            moveCursor row collumn
            drawString gridMiddle
            moveCursor row (collumns - 2)
            drawString gridMiddle
            drawLines' (row + 1) collumn (n - 1)

    drawPlayer :: Player -> ColorID -> Update()
    drawPlayer player color = do
        setColor color
        moveCursor (row player) (collumn player)
        drawString playerHead
        moveCursor ((row player) + 1) (collumn player)
        drawString playerBody
        moveCursor ((row player) + 2) (collumn player)
        drawString playerLegs
    
    waitFor :: Window -> (Event -> Bool) -> Curses ()
    waitFor w p = loop where
        loop = do
            ev <- getEvent w Nothing
            case ev of
                Nothing -> loop
                Just ev' -> if p ev' then return () else loop