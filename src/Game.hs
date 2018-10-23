module Game(Player(..),
            Platform(..),
            playerHead,
            playerHeadAir,
            playerBody,
            playerBodyAir,
            playerLegs,
            onFloor,
            inithialPlayerCollumn,
            inithialPlayerRow,
            movePlayer,
            jumpPlayer,
            gravity,
            gridTopBottom,
            gridMiddle
) where

import Data.Typeable
import GUI

inithialPlayerCollumn = ((quot columns 2) - 3)
inithialPlayerRow     = (rows - 4)
gravity               = 1

data Player   = Player { row :: Integer,
                         collumn :: Integer,
                         velocity :: Integer
                       } deriving (Show)
data Platform = Platform { platRow :: Integer,
                           platCollumn :: Integer,
                           lenght :: Integer,
                           direction :: Integer
                         } deriving (Show)

onFloor :: Player -> Bool
onFloor player
    | (row player) >= (rows - 4) = True
    | otherwise = False

jumpPlayer :: Player -> Player
jumpPlayer player
        | (onFloor player) = Player (row player) (collumn player) (-3)
        | otherwise = player

movePlayer :: Player -> Player
movePlayer player
        | (onFloor player) && ((velocity player) >= 0) = Player (row player) (collumn player) 0
        | otherwise = p
        where
            p = Player ((row player) + (velocity player)) (collumn player) ((velocity player) + gravity)

getScore :: Platform -> Integer
getScore platform = (platRow platform)

playerHead, playerBody, playerLegs :: String
playerHead = "(^~^)"
playerBody = "/|_|\\"
playerLegs = " / \\"

playerHeadAir, playerBodyAir :: String
playerHeadAir = "(^o^)"
playerBodyAir = "t|_|t"

gridTopBottom :: String
gridTopBottom = "**********************************************************"
gridMiddle    = "*                                                        *"
