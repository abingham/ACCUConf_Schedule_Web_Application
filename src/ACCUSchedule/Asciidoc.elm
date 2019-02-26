module ACCUSchedule.Asciidoc exposing (toHtml)

import Html exposing (Attribute, Html, text)

toHtml : List (Attribute msg) -> String -> Html msg
toHtml _ string =
    text string
    -- Native.Asciidoc.toHtml attrs string
