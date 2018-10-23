module Menu (
  runMenu
) where

    import GUI
    import GameCurses
    import UI.NCurses
    import System.Random

    runMenu :: Curses()
    runMenu = do
      -- w <- newWindow rows columns 0 0
      w <- defaultWindow
      -- redtext <- newColorID ColorGreen ColorDefault 9
      updateWindow w $ do
        -- setColor redtext
        moveCursor (gridY + (quot rows 4) + 0) (gridX + 2)
        drawString "                    "
        moveCursor (gridY + (quot rows 4) + 1) (gridX + 2)
        drawString "    JumpMaster   "
        moveCursor (gridY + (quot rows 4) + 2) (gridX + 2)
        drawString "                 "
        moveCursor (gridY + (quot rows 4) + 3) (gridX + 2)
        drawString "      Menu      "
        moveCursor (gridY + (quot rows 4) + 4) (gridX + 2)
        drawString "      ====      "
        moveCursor (gridY + (quot rows 4) + 5) (gridX + 2)
        drawString "                "
        moveCursor (gridY + (quot rows 4) + 6) (gridX + 2)
        drawString " 1) Jogar       "
        moveCursor (gridY + (quot rows 4) + 7) (gridX + 2)
        drawString " 2) Recordes       "
        moveCursor (gridY + (quot rows 4) + 8) (gridX + 2)
        drawString " 3) Créditos       "
        moveCursor (gridY + (quot rows 4) + 9) (gridX + 2)
        drawString " 4) Sair       "
        -- moveCursor (1) (20)
        -- drawString "XXXXXXXXXXXXXXX"

      render
      ev <- getEvent w (Just 90)
      case ev of
          Nothing -> runMenu -- Nenhuma tecla pressionada
          Just ev'
              | ev' == EventCharacter '1' -> playGame w
              -- | ev' == EventCharacter '2' -> runRecordes
              -- | ev' == EventCharacter '3' -> runCreditos
              | ev' == EventCharacter '4' -> return ()
              | otherwise -> runMenu -- Nenhuma tecla válida pressionada
