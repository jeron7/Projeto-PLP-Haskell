module Menu (
  runMenu
) where

    import GUI
    import UI.NCurses
    import System.Random

    runMenu :: IO Integer
    runMenu = runCurses $ do
        GUI.defaultInitialization
        w <- newWindow rows columns 0 0
        option <- getOption w
        return option

    getOption :: Window -> Curses Integer
    getOption w = do
      updateWindow w $ drawTab menuBody
      render
      ev <- getEvent w (Just 90)
      case ev of
          Nothing -> getOption w -- Nenhuma tecla pressionada
          Just ev'
            | ev' == EventCharacter '1' -> return 1
            | ev' == EventCharacter '2' -> return 2
            | ev' == EventCharacter '3' -> return 3
            | (ev' == EventCharacter '4') || (ev' == EventCharacter 'q') -> return 4
            | otherwise -> getOption w-- Nenhuma tecla válida pressionada

    menuBody :: [String]
    menuBody = ["   JumpMaster   ",
                "================",
                "      Menu      ",
                "================",
                " 1) Jogar       ",
                " 2) Recordes    ",
                " 3) Créditos    ",
                " 4) Sair        "]


  -- | ev' == EventCharacter '1' -> initTab w $ playGame g
  -- | ev' == EventCharacter '2' -> initTab w runRecordes
  -- | ev' == EventCharacter '3' -> runCreditos
  -- | (ev' == EventCharacter '4') || (ev' == EventCharacter 'q') -> return [[""]]
  -- | otherwise -> runMenu g -- Nenhuma tecla válida pressionada