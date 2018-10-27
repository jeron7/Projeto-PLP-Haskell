module Nome (
  runNome
) where

    import GUI
    import Recordes
    import UI.NCurses
    import Data.List.Split

    runNome :: Integer -> Curses [String]
    runNome 0 = return [""]
    runNome recorde = do
        w <- newWindow rows columns 0 0
        let 
            backspace :: String -> Curses String
            backspace nome
                | (Prelude.length nome) > 0 = readNome (init (nome))
                | otherwise = readNome nome

            readNome :: String -> Curses String
            readNome nome = do
                -- Clena o nome
                updateWindow w $ do
                    moveCursor 0 0
                    drawString $ credits nome
                render
                updateWindow w $ do
                    moveCursor 0 0
                    drawString $ credits $ take (Prelude.length nome) (repeat ' ')
                ev <- getEvent w (Just 90)
                case ev of
                    Nothing -> readNome nome
                    Just ev'
                        | (isChar ev') -> readNome ( nome ++ (extractValue ev'))
                        | ev' == EventCharacter '\n' -> return nome
                        | ev' == EventSpecialKey KeyBackspace -> backspace nome
                        | otherwise -> readNome nome

        nome <- (readNome "")
        return [(show recorde), nome]

    extractValue :: Event -> String
    extractValue ev = result
        where
            result = ((splitOn "'" (show ev)) !! 1)

    isChar :: Event -> Bool
    isChar ev
        | ev `elem` events = True
        | otherwise = False
        where
            chars = ['a'..'z'] ++ ['A'..'Z']
            events = (map EventCharacter chars)
        
    credits :: String -> String
    credits nome = "Digite seu nome: " ++ nome