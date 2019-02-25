module ACCUSchedule.View.Theme exposing (..)

import Element exposing (modular, Color, rgb255)

background : Element.Color
background = lightGray


accent : Element.Color
accent = rgb255 169 1 247

white : Element.Color
white = rgb255 255 255 255

lightGray : Element.Color
lightGray = rgb255 238 238 238 

fontSize : Int -> Int
fontSize = modular 16 1.25 >> round