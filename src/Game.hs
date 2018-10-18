module Game(Player(..),
            playerHead,
            playerBody,
            playerLegs,
            inithialPlayerCollumn,
            inithialPlayerRow,
            rows, 
            collumns,
            gridTopBottom,
            gridMiddle
) where

inithialPlayerCollumn = ((quot collumns 2) - 3)
inithialPlayerRow     = (rows - 4)
collumns              = 60
rows                  = 35

data Player = Player { row :: Integer,
                       collumn :: Integer,
                       points :: Integer
                     } deriving (Show)

playerHead, playerBody, playerLegs :: String
playerHead = "(^~^)"
playerBody = "/|_|\\"
playerLegs = " / \\"

gridTopBottom :: String
gridTopBottom = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
gridMiddle    = "X"