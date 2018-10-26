module Creditos (
  runCreditos
) where

    import GUI
    -- import GameCurses
    import UI.NCurses

    runCreditos :: Curses Integer
    runCreditos = do
      w <- newWindow rows columns 0 0
      drawCreditos w

    drawCreditos :: Window -> Curses Integer
    drawCreditos w = do
      updateWindow w $ drawTab credits
      render
      ev <- getEvent w (Just 90)
      case ev of
          Nothing -> drawCreditos w -- Nenhuma tecla pressionada
          Just ev'
              | (ev' == EventCharacter '1') -> return 0
              | (ev' == EventCharacter '2') -> return 4
              | otherwise -> drawCreditos w

    credits :: [String]
    credits = ["**** Créditos ****",
              " Rafael Pontes    ",
              " Henry Filho      ",
              " Junior Mendes    ",
              " Matheus Santana  ",
              " Jeronimo Jairo   ",
              "******************",
              " 1) Voltar        ",
              " 2) Sair          "]
