module Game(Player(..),
            Platform(..),
            Force(..),
            playerHead,
            playerHeadAir,
            playerBody,
            playerBodyAir,
            playerLegs,
            onAir,
            inithialPlayerCollumn,
            inithialPlayerRow,
            movePlayer,
            jumpPlayer,
            rows, 
            collumns,
            gravity,
            gridTopBottom,
            gridMiddle
) where

import Data.Typeable

inithialPlayerCollumn = ((quot collumns 2) - 3)
inithialPlayerRow     = (rows - 4)
collumns              = 62
rows                  = 35
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
data Force = Velocity | Gravity
            deriving (Eq, Show, Enum)

onAir :: Player -> Bool
onAir player
    | (row player) >= (rows - 4) = True
    | otherwise = False

jumpPlayer :: Player -> Player
jumpPlayer player
        | (onAir player) = Player (row player) (collumn player) (-3)
        | otherwise = player

movePlayer :: Player -> Player
movePlayer player
        | (onAir player) && ((velocity player) >= 0) = Player (row player) (collumn player) 0
        | otherwise = p
        where 
            p = Player ((row player) + (velocity player)) (collumn player) ((velocity player) + gravity)

getScore :: Platform -> Integer
getScore platform = (platRow platform)

playerHead, playerBody, playerLegs :: String
playerHead = "(^~^)"
playerBody = "/|_|\\"
playerLegs = " /.\\"

playerHeadAir, playerBodyAir :: String
playerHeadAir = "(^o^)"
playerBodyAir = "t|_|t"

gridTopBottom :: String
gridTopBottom = "*************************************************************"
gridMiddle    = "*  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  *"