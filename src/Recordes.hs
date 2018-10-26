module Recordes (
  runRecordes,
  listaRecordes,
  writeRecordes
) where

    import GUI
    import Game
    import UI.NCurses
    import Data.List
    import System.IO
    import Data.List.Split
    import System.IO.Unsafe 

    
    runRecordes :: Curses()
    runRecordes = do
      w <- newWindow rows columns 0 0
      updateWindow w $ drawTab recordesBody
      render
      ev <- getEvent w (Just 90)
      case ev of
          Nothing -> runRecordes -- Nenhuma tecla pressionada
          Just ev'
              | (ev' == EventCharacter 'q') -> closeWindow w
              | otherwise -> runRecordes

    recordesBody :: [String]
    recordesBody = ["================",
                "=== RECORDES ===",
                "================"] ++ (recordes 0 listaRecordes [])

    recordes :: Int -> [[String]] -> [String] -> [String]
    recordes n lista result 
        | n > 9 = result
        | lista == [] = result
        | otherwise = recordes (n+1) (tail lista) (result ++ [cab ++ nome ++ (take vezes (repeat ' ')) ++ num])
          where num = (head lista) !! 0
                nome = (head lista) !! 1
                cab = (show (n+1)) ++ "."
                vezes = 16 - length cab - length num - length nome

    listaRecordes :: [[String]]
    listaRecordes = stringToList lerRecordes

    lerRecordes :: String
    lerRecordes = do
        h <- unsafePerformIO . readFile $ "recordes.txt"
        return h

    writeRecordes :: [[String]] -> IO ()
    writeRecordes lista = do
      handle <- openFile "teste.txt" WriteMode
      hPutStr handle $ unlines (listToString lista [])
      hClose handle 

    stringToList :: String -> [[String]]
    stringToList str = do
        let list = splitOn "\n" str
        result <- map stringToList' list
        return result
    
    stringToList' :: String -> [String] 
    stringToList' str = do
        list <- splitOn "," str
        return list

    listToString :: [[String]] -> [String] -> [String]
    listToString lista str 
      | lista == [] = str
      | otherwise = listToString novaLista novoString
      where nome = (head lista) !! 1
            num = (head lista) !! 0
            novoString = str ++ [num ++ "," ++ nome]
            novaLista = (tail lista)