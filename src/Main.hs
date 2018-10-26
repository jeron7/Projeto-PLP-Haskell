module Main where

import Menu
import UI.NCurses
import System.Random

init :: Curses ()
init = do
    setEcho False
    setCursorMode CursorInvisible
    render

main :: IO ()
main =  newStdGen >>= \g -> runCurses $ do
  Main.init
  Menu.runMenu g
