module Main where

import GameCurses
import UI.NCurses
import Menu
import GUI

init :: Curses ()
init = do
    setEcho False
    setCursorMode CursorInvisible
    render

main :: IO ()
main = runCurses $ do
  Main.init
  runMenu
