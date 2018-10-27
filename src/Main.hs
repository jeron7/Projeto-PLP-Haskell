module Main where

import Menu
import UI.NCurses
import System.Random

import GUI
import Creditos
import GameCurses
import Recordes

main :: IO ()
main = do
    initMenu

initOption :: Integer -> IO ()
initOption option = do
    case option of
        0 -> initMenu
        1 -> initGame
        2 -> do
            recordes <- readRecordes
            opt <- runTab $ runRecordes recordes
            initOption opt
        3 -> do
            opt <- runTab runCreditos
            initOption opt
        4 -> return ()

initMenu :: IO ()
initMenu = do
    option <- runMenu
    initOption option

initGame :: IO ()
initGame = do
    nomes <- runGame
    if (Prelude.length (head nomes)) > 0 then
        writeRecorde nomes
    else
        return ()