module Recordes (
  runRecordes,
  writeRecorde,
  readRecordes
) where

    import GUI
    import UI.NCurses
    import Data.List
    import System.IO
    import System.IO.Unsafe
    import Data.List.Split
    
    runRecordes :: [String] -> Curses Integer
    runRecordes recordes = do
      w <- newWindow rows columns 0 0
      drawRecordes w recordes
    
    drawRecordes :: Window -> [String] -> Curses Integer
    drawRecordes w recordes = do
      updateWindow w $ do
        let bodyTab = recordesTop ++ recordes ++ recordesBottom 
        drawTab bodyTab
      render
      ev <- getEvent w (Just 90)
      case ev of
          Nothing -> drawRecordes w recordes-- Nenhuma tecla pressionada
          Just ev'
              | (ev' == EventCharacter '1') -> return 0
              | (ev' == EventCharacter '2') -> return 4
              | otherwise -> drawRecordes w recordes

    -- O antigo método tava dando problema quando tinha uma linha vazia
    -- Isso ocorria pelo fato do writeRecordes deixar um \n depois de inserir 
    readRecordes :: IO [String]
    readRecordes = do
        handle <- openFile "recordes.txt" ReadMode
        contents <- hGetContents handle
        -- hClose handle
        return $ lines contents

    splitOnComma :: [String] -> [[String]]
    splitOnComma list = splitOnComma' list [[]] 

    splitOnComma' :: [String] -> [[String]] -> [[String]]
    splitOnComma' [] aux = aux
    splitOnComma' (x:xs) aux = splitOnComma' (xs) result
        where
            result = aux ++ (map (splitOn ",") [x])

    writeRecorde :: [String] -> IO ()
    writeRecorde lista = do
        handle <- openFile "recordes.txt" AppendMode
        hPutStr handle $ (head lista) ++", "++ (last lista) ++ "\n" 
        hClose handle
    
    recordesTop, recordesBottom :: [String]
    recordesTop    = ["==================",
                      "==== RECORDES ====",
                      "=================="]
    recordesBottom = ["==================",
                      "1) Voltar         ",
                      "2) Sair           "]