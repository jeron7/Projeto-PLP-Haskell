module Creditos (
  runCreditos
) where

    import GUI
    import GameCurses
    import UI.NCurses
    runCreditos :: Curses()
    runCreditos = do
      w <- newWindow rows columns 0 0
      updateWindow w $ drawTab credits
      render
      ev <- getEvent w (Just 90)
      case ev of
          Nothing -> runCreditos -- Nenhuma tecla pressionada
          Just ev'
              -- | (ev' == EventCharacter '1') -> initTab w playGame
              | (ev' == EventCharacter '2') -> return ()
              | otherwise -> runCreditos

    credits :: [String]
    credits = [     "**** Créditos ****",
                    " Rafael Pontes    ",
                    " Henry Filho      ",
                    " Junior Mendes    ",
                    " Matheus Santana  ",
                    " Jeronimo Jairo   ",
                    "******************",
                    " 1) Jogar         ",
                    " 2) Sair          "]
