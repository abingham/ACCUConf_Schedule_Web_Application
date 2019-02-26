module ACCUSchedule.View.Theme exposing (accent, background, fontSize, gray, lightGray, white)

import Element


background : Element.Color
background =
    lightGray


accent : Element.Color
accent =
    Element.rgb255 169 1 247


white : Element.Color
white =
    Element.rgb255 255 255 255


lightGray : Element.Color
lightGray =
    Element.rgb255 238 238 238


gray : Element.Color
gray =
    Element.rgb255 126 126 126


fontSize : Int -> Int
fontSize =
    Element.modular 16 1.25 >> round
