module Recordes (
  runRecordes
) where

    import GUI
    import UI.NCurses
    
    runRecordes :: Curses()
    runRecordes = do
      w <- newWindow rows columns 0 0
      updateWindow w $ drawTab recordesBody
      render
      ev <- getEvent w (Just 90)
      case ev of
          Nothing -> runRecordes -- Nenhuma tecla pressionada
          Just ev'
              | (ev' == EventCharacter '4') -> return ()
              | otherwise -> runRecordes

    recordesBody :: [String]
    recordesBody = ["================",
                "=== RECORDES ===",
                "================"]