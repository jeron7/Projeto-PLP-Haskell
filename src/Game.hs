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
            movePlatform,
            gameOver,
            incrementScore
) where

import Data.Typeable
import GUI

initialPlayerColumn = ((quot columns 2) - 3)
initialPlayerRow     = (rows - 2)
-- Caso a direção de construção da plataforma seja negativa,
-- deve iniciar collums - length - 1 

-- initialPlatformColumn = (columns - 11)
initialPlatformColumn = 1
initialPlatformRow    = (rows - 2)
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

onFloor :: Player -> Integer -> Bool
onFloor p s
    | (row p) >= floor = True
    | otherwise = False
    where
        floor = (rows - 2 - s)

-- Muda velocidade do player para que o pulo ocorra
jumpPlayer :: Player -> Integer -> Player
jumpPlayer p s
        | (onFloor p s) = Player (row p) (column p) (-3)
        | otherwise = p

-- Move player, de acordo com sua velocidade e gravidade do jogo
-- Caso alcance o solo, permanece parado.
movePlayer :: Player-> Integer -> Player
movePlayer p s
        | (onFloor p s) && ((velocity p) >= 0) = Player (rows - 2 - s) (column p) 0
        | otherwise = Player ((row p) + (velocity p)) (column p) ((velocity p) + gravity)

-- Move a plataforma na sua direção
movePlatform :: Platform -> Platform
movePlatform pt
    | (reachPlatformPosition pt == False) = Platform (platRow pt) ((platColumn pt) + (direction pt)) (Game.length pt) (direction pt)
    | otherwise = pt

-- Se plataforma alcançou o centro do jogo, retorna True. C.C. False
reachPlatformPosition :: Platform -> Bool
reachPlatformPosition pt
            | (direction pt) > 0 && ((platColumn pt) >= ((quot columns 2) - 3)) = True
            | (direction pt) < 0 && ((platColumn pt) <= ((quot columns 2) - 6)) = True
            | otherwise = False

gameOver :: Player -> Platform -> Bool
gameOver p pt
    | (row p)  == (platRow pt) = result
    | otherwise = False
    where
        platSize = (platColumn pt) + (Game.length pt)
        result
            | (direction pt) > 0 && (column p) == platSize = True
            | (direction pt) < 0 && (column p) + 3 == (platColumn pt) = True
            | otherwise = False


-- Só incrementa quando a linha da plataforma é igual a linha do chão (rows - 2 - s) e
-- o player estiver no ar
incrementScore :: Player -> Platform -> Integer -> Integer
incrementScore p pt s
    | floor == (platRow pt) && (row p) <= (platRow pt) = result
    | otherwise = s
    where
        floor = (rows - 2 - s)
        result
            | (direction pt) > 0 && (column p) < ((platColumn pt) + (Game.length pt)) = s + 1
            | (direction pt) < 0 && ((column p) + 3) > ((platColumn pt)) = s + 1
            | otherwise = s

playerHead, playerBody, playerLegs :: String
playerHead = "(^~^)"
playerBody = "/|_|\\"
playerLegs = " / \\"

playerHeadAir, playerBodyAir :: String
playerHeadAir = "(^o^)"
playerBodyAir = "t|_|t"

gridTopBottom, gridMiddle :: String
gridTopBottom = "*************************************************************"
gridMiddle    = "*                                                           *"

platformTile :: String
platformTile = "=========="
