module GameCurses where

    import Game
    import GUI
    import Nome
    import UI.NCurses
    import System.Random

    runGame :: IO [String]
    runGame = newStdGen >>= \g -> runCurses $ do
        GUI.defaultInitialization
        game g

    game :: StdGen -> Curses [String]
    game g = do
        w <- newWindow rows columns 0 0
        defaultColor <- newColorID ColorDefault ColorDefault 2
        white <- newColorID ColorWhite ColorWhite 1
        let
            initialPlayer = Player initialPlayerRow initialPlayerColumn 0
            currentPlatform = Platform initialPlatformRow initialPlatformColumn 8 (1)

            updatePlayer :: Player -> Integer -> Curses()
            updatePlayer p s = do
              updateWindow w $ do
                setColor defaultColor
                drawPlayer p s

            updatePlatform :: Platform -> Curses()
            updatePlatform platform = do
              updateWindow w $ do
                setColor white
                drawPlatform platform

            updateScore :: Integer -> Curses ()
            updateScore s = do
                updateWindow w $ do
                    setColor defaultColor
                    moveCursor 0 0
                    drawString $ "Pontuacao: " ++ (show s)

            initPersistence :: Curses [String] -> Curses [String]
            initPersistence tab = do
                closeWindow w
                tab

            updateGame :: Player -> Platform -> Integer ->  StdGen -> Curses Integer
            updateGame p pt s gen = do

                let player = movePlayer p s
                let platform = movePlatform pt
                let score = incrementScore p pt s

                updateWindow w $ drawGrid 1 0
                updatePlayer player score
                updatePlatform platform
                updateScore score
                render

                if (gameOver player platform) then
                    return score
                else do
                    ev <- getEvent w (Just 90)
                    case ev of
                        Nothing -> updateGame player platform score gen-- Nenhuma tecla pressionada
                        Just ev'
                            | ev' == EventCharacter 'q' -> return score
                            | ev' == EventCharacter ' ' -> updateGame (jumpPlayer player score) platform score gen
                            | ev' == EventCharacter 's' -> return s
                            | otherwise -> updateGame player platform score gen -- Nenhuma tecla válida pressionada
        
        score <- updateGame initialPlayer currentPlatform 0 g
        initPersistence $ runNome score

    drawGrid :: Integer -> Integer -> Update()
    drawGrid row column = do
        moveCursor row column
        drawString gridTopBottom
        drawLines (row + 1) column
        moveCursor (rows - 1) column
        drawString gridTopBottom

    drawLines :: Integer -> Integer -> Update()
    drawLines row column = drawLines' row column (rows - 1)

    drawLines' :: Integer -> Integer -> Integer -> Update()
    drawLines' row column n
        | n < 2 = return()
        | otherwise = do
            moveCursor row column
            drawString gridMiddle
            drawLines' (row + 1) column (n - 1)

    drawPlayer :: Player -> Integer -> Update()
    drawPlayer player score = do
        let
            head
                | onFloor player score = playerHead
                | otherwise    = playerHeadAir
            body
                | onFloor player score = playerBody
                | otherwise    = playerBodyAir
        moveCursor (row player) (column player)
        drawString playerLegs
        moveCursor ((row player) - 1) (column player)
        drawString body
        moveCursor ((row player) - 2) (column player)
        drawString head

    drawPlatform :: Platform -> Update()
    drawPlatform platform = do
        moveCursor (platRow platform) (platColumn platform)
        drawString  Game.platformTile
