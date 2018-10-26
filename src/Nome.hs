module Nome (
  runNome
) where

    import GUI
    import Recordes
    import GameCurses
    import UI.NCurses
    import System.IO

    runNome :: Int -> Curses()
    runNome recorde = do
        w <- newWindow rows columns 0 0
        updateWindow w $ drawTab credits
        render
        --nome <- (show entrada) IO de dados no Ncurses
        let  nomes = inserirRecorde "nome" recorde listaRecordes []
        --writeRecordes nomes []
        closeWindow w
        
        
    credits :: [String]
    credits = ["Digite seu nome:"]

    inserirRecorde :: String -> Int -> [[String]] -> [[String]] -> [[String]]
    inserirRecorde nome recorde lista result
        | lista == [] = result ++ [[(show recorde), nome]]
        | recorde >= e = result ++ [[(show recorde), nome]] ++ lista
        | otherwise = inserirRecorde nome recorde (tail lista) (result ++ [(head lista)])
        where e = read $ (head lista) !! 0

    entrada :: IO String
    entrada = getLine