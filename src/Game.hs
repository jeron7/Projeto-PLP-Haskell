module Game where

    import UI.NCurses

    playGame :: IO ()
    playGame = runCurses $ do
        setEcho False
        w <- defaultWindow
        defaultColor <- newColorID ColorBlue ColorDefault 1
        let
            drawPlayer :: Integer -> Integer -> Integer -> Update()
            drawPlayer y x score = do
                setColor defaultColor
                moveCursor y x
                drawString playerHead
                moveCursor (y + 1) x
                drawString playerBody
                moveCursor (y + 2) x
                drawString playerLegs
        updateWindow w $ drawPlayer 1 1 0
        render
        waitFor w (\ev -> ev == EventCharacter 'q' || ev == EventCharacter 'Q')

    waitFor :: Window -> (Event -> Bool) -> Curses ()
    waitFor w p = loop where
        loop = do
            ev <- getEvent w Nothing
            case ev of
                Nothing -> loop
                Just ev' -> if p ev' then return () else loop

    playerHead, playerBody, playerLegs :: String
    playerHead = "(^~^)"
    playerBody = "/|_|\\"
    playerLegs = " / \\"