module ACCUSchedule.View.Asciidoc exposing (renderAsciidoc)

import Element
import Html
import List


{-| Render an asciidoc string in HTML.
-}
renderAsciidoc : List (Element.Attribute msg) -> String -> Element.Element msg
renderAsciidoc attrs =
    Html.text
        >> List.singleton
        >> Html.node "render-asciidoc" []
        >> Element.html
        >> Element.el attrs
