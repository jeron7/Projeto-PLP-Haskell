module Menu (
  runMenu
) where

    import GUI
    import GameCurses
    import Recordes
    import UI.NCurses

    runMenu :: Curses()
    runMenu = do
      w <- newWindow rows columns 0 0
      updateWindow w $ drawTab menuBody
      render
      ev <- getEvent w (Just 90)
      case ev of
          Nothing -> runMenu -- Nenhuma tecla pressionada
          Just ev'
              | ev' == EventCharacter '1' -> initTab w playGame
              | ev' == EventCharacter '2' -> initTab w runRecordes
              -- | ev' == EventCharacter '3' -> runCreditos
              | (ev' == EventCharacter '4') || (ev' == EventCharacter 'q') -> return ()
              | otherwise -> runMenu -- Nenhuma tecla válida pressionada

    menuBody :: [String]
    menuBody = ["   JumpMaster   ",
                "================",
                "      Menu      ",
                "================",
                " 1) Jogar       ",
                " 2) Recordes    ",
                " 3) Créditos    ",
                " 4) Sair        "]