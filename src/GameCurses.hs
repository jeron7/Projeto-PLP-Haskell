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
            initialPlayer = Player initialPlayerRow initialPlayerColumn 0
            currentPlatform = Platform initialPlatformRow initialPlatformColumn 1 1

            updatePlayer :: Player -> Curses()
            updatePlayer player = do
              updateWindow w $ drawPlayer player defaultColor

            updatePlatform :: Platform -> Curses()
            updatePlatform platform = do
              updateWindow w $ drawPlatform platform defaultColor

            updateGame :: Player -> Platform -> Integer -> Curses ()
            updateGame p pt s = do

                let player = movePlayer p
                let platform = movePlatform pt

                updateWindow w $ drawGrid 0 0 defaultColor
                updatePlayer p
                updatePlatform pt

                render
                ev <- getEvent w (Just 90)
                case ev of
                    Nothing -> updateGame player platform s-- Nenhuma tecla pressionada
                    Just ev'
                        | ev' == EventCharacter 'q' -> return ()
                        | ev' == EventCharacter ' ' -> updateGame (jumpPlayer p) pt s
                        | otherwise -> updateGame player platform s -- Nenhuma tecla válida pressionada

        updateGame initialPlayer currentPlatform 0

    drawGrid :: Integer -> Integer -> ColorID -> Update()
    drawGrid row column color = do
        setColor color
        moveCursor row column
        drawString gridTopBottom
        drawLines 1 0
        moveCursor (rows - 1) column
        drawString gridTopBottom

    drawLines :: Integer -> Integer -> Update()
    drawLines row column = drawLines' row column rows

    drawLines' :: Integer -> Integer -> Integer -> Update()
    drawLines' row column n
        | n < 2 = return()
        | otherwise = do
            moveCursor row column
            drawString gridMiddle
            drawLines' (row + 1) column (n - 1)

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
        moveCursor (row player) (column player)
        drawString head
        moveCursor ((row player) + 1) (column player)
        drawString body
        moveCursor ((row player) + 2) (column player)
        drawString playerLegs

    drawPlatform :: Platform -> ColorID -> Update()
    drawPlatform platform color = do
        setColor color
        moveCursor (platRow platform) (platColumn platform)
        drawString  Game.platformTile
