module GameCurses where

    import Game
    import GUI
    import UI.NCurses
    import System.Random

    playGame :: Curses ()
    playGame = do
        w <- newWindow rows columns 0 0
        defaultColor <- newColorID ColorDefault ColorDefault 2
        let
            inithialPlayer = Player inithialPlayerRow inithialPlayerCollumn 0

            updatePlayer :: Player -> Curses()
            updatePlayer player = do
                updateWindow w $ drawPlayer player defaultColor

            updateGame :: Player -> Integer -> Curses ()
            updateGame p s = do
                let player = movePlayer p
                updateWindow w $ drawGrid 0 0 defaultColor
                updatePlayer p
                render
                ev <- getEvent w (Just 90)
                case ev of
                    Nothing -> updateGame player s-- Nenhuma tecla pressionada
                    Just ev'
                        | ev' == EventCharacter 'q' -> return ()
                        | ev' == EventCharacter ' ' -> updateGame (jumpPlayer p) s
                        | otherwise -> updateGame player s -- Nenhuma tecla válida pressionada

        updateGame inithialPlayer 0

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
                | onFloor player = playerHead
                | otherwise    = playerHeadAir
            body
                | onFloor player = playerBody
                | otherwise    = playerBodyAir
        setColor color
        moveCursor (row player) (collumn player)
        drawString head
        moveCursor ((row player) + 1) (collumn player)
        drawString body
        moveCursor ((row player) + 2) (collumn player)
        drawString playerLegs

    printStringNTimes 0 = return ()
    printStringNTimes n =
     do
      drawString platformTile
      printStringNTimes (n-1)

    main = printStringNTimes 10
    drawPlatforms :: Player -> ColorID -> Update()
    drawPlatforms platforms color = do
        setColor color
        moveCursor (row platform) (collumn platform)
        drawString  platformTile
        moveCursor ((row player) + 1) (collumn player)
        drawString body
        moveCursor ((row player) + 2) (collumn player)
        drawString playerLegs
