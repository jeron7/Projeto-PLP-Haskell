module Main where

import Menu
import UI.NCurses

init :: Curses ()
init = do
    setEcho False
    setCursorMode CursorInvisible
    render

main :: IO ()
main = runCurses $ do
  Main.init
  runMenu
