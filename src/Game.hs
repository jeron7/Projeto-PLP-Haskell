module Game(Player(..),
            Platform(..),
            playerHead,
            playerHeadAir,
            playerBody,
            playerBodyAir,
            playerLegs,
            onFloor,
            initialPlayerColumn,
            initialPlayerRow,
            initialPlatformColumn,
            initialPlatformRow,
            movePlayer,
            jumpPlayer,
            gravity,
            gridTopBottom,
            gridMiddle,
            platformTile,
            movePlatform
) where

import Data.Typeable
import GUI

initialPlayerColumn = ((quot columns 2) - 3)
initialPlayerRow     = (rows - 4)
initialPlatformColumn = 1
initialPlatformRow     = (rows - 2)
gravity               = 1

data Player   = Player { row :: Integer,
                         column :: Integer,
                         velocity :: Integer
                       } deriving (Show)
data Platform = Platform { platRow :: Integer,
                           platColumn :: Integer,
                           length :: Integer,
                           direction :: Integer
                         } deriving (Show)

onFloor :: Player -> Bool
onFloor player
    | (row player) >= (rows - 4) = True
    | otherwise = False

-- Muda velocidade do player para que o pulo ocorra
jumpPlayer :: Player -> Player
jumpPlayer player
        | (onFloor player) = Player (row player) (column player) (-3)
        | otherwise = player

-- Move player, de acordo com sua velocidade e gravidade do jogo
-- Caso alcance o solo, permanece parado.
movePlayer :: Player -> Player
movePlayer player
        | (onFloor player) && ((velocity player) >= 0) = Player (row player) (column player) 0
        | otherwise = Player ((row player) + (velocity player)) (column player) ((velocity player) + gravity)

-- Move a plataforma na sua direção
movePlatform :: Platform -> Platform
movePlatform platform
    | (reachPlatformPosition platform == False) = Platform (platRow platform) ((platColumn platform) + (direction platform)) (Game.length platform) (direction platform)
    | otherwise = platform

-- Se plataforma alcançou o centro do jogo, retorna True. C.C. False
reachPlatformPosition :: Platform -> Bool
reachPlatformPosition platform
            | ((platColumn platform) >= ((quot columns 2) - 3)) = True
            | otherwise = False

getScore :: Platform -> Integer
getScore platform = (platRow platform)

playerHead, playerBody, playerLegs :: String
playerHead = "(^~^)"
playerBody = "/|_|\\"
playerLegs = " / \\"

playerHeadAir, playerBodyAir :: String
playerHeadAir = "(^o^)"
playerBodyAir = "t|_|t"

gridTopBottom, gridMiddle :: String
gridTopBottom = "**********************************************************"
gridMiddle    = "*                                                        *"

platformTile :: String
platformTile = "======="
