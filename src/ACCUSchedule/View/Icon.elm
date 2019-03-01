module ACCUSchedule.View.Icon exposing (icon)

import ACCUSchedule.Msg as Msg
import Element exposing (Attribute, Element, el, htmlAttribute, text)
import Element.Font as Font
import Html.Attributes exposing (style)


icon : List (Attribute Msg.Msg) -> String -> Element Msg.Msg
icon attrs =
    let
        defaultAttrs =
            [ Font.family [ Font.typeface "Material Icons" ]
            , htmlAttribute (style "cursor" "default")
            ]

        fullAttrs =
            defaultAttrs ++ attrs
    in
    text >> el fullAttrs
