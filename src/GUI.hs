module GUI (
  runTab,
  defaultInitialization,
  drawTab,
  gridX,
  gridY,
  rows,
  columns
) where

  import UI.NCurses

-- 149 X final
-- 37 Y Final do terminal

  runTab :: Curses Integer -> IO Integer
  runTab tab = runCurses $ do
    GUI.defaultInitialization
    tab

  defaultInitialization :: Curses ()
  defaultInitialization = do
    setEcho False
    setCursorMode CursorInvisible
    render

  drawTab :: [String] -> Update ()
  drawTab body = drawTab' body 0

  drawTab' :: [String] -> Integer -> Update ()
  drawTab' [] _ = return ()
  drawTab' (x:xs) cont = do
    let
      tabY = (div rows 3)
      tabX = (div columns 2) - 6
    moveCursor (tabY + cont) tabX
    drawString x
    drawTab' xs (cont + 1)

  gridX :: Integer
  gridX = 0

  gridY :: Integer
  gridY = 0

  columns :: Integer
  columns = 62

  rows :: Integer
  rows = 35
