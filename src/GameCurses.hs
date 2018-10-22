module GameCurses where

    import Game
    import UI.NCurses
    import System.Random

    playGame :: IO()
    playGame = runCurses $ do
        w <- newWindow rows collumns 0 0
        defaultColor <- newColorID ColorDefault ColorDefault 2
        let
            inithialPlayer = Player inithialPlayerRow inithialPlayerCollumn 0
            init :: Curses ()
            init = do
                setEcho False
                setCursorMode CursorInvisible
                render

            updatePlayer :: Player -> Curses()
            updatePlayer player = do
                updateWindow w $ drawPlayer player defaultColor

            updateScreen :: Player -> Integer -> Curses ()
            updateScreen p s = do
                let
                    plat = Platform (rows - 1) collumns 100 (-1) 
                    player = movePlayer p
                updateWindow w $ drawGrid 0 0 defaultColor
                updatePlayer player
                render
                ev <- getEvent w (Just 90)
                case ev of
                    Nothing -> updateScreen player s-- Nenhuma tecla pressionada
                    Just ev'
                        | ev' == EventCharacter 'q' -> return ()
                        | ev' == EventCharacter ' ' -> updateScreen (jumpPlayer player) s
                        | otherwise -> updateScreen player s -- Nenhuma tecla válida pressionada
        init
        updateScreen inithialPlayer 0

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
            drawLines' (row + 1) collumn (n - 1)

    drawPlayer :: Player -> ColorID -> Update()
    drawPlayer player color = do
        let
            head
                | onAir player = playerHead
                | otherwise    = playerHeadAir
            body
                | onAir player = playerBody
                | otherwise    = playerBodyAir
        setColor color
        moveCursor (row player) (collumn player)
        drawString head
        moveCursor ((row player) + 1) (collumn player)
        drawString body
        moveCursor ((row player) + 2) (collumn player)
        drawString playerLegs