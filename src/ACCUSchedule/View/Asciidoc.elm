module ACCUSchedule.View.Asciidoc exposing (renderAsciidoc)

import Element
import Html
import List


{-| Render an asciidoc string in HTML.
-}
renderAsciidoc : String -> Element.Element msg
renderAsciidoc =
    Html.text
        >> List.singleton
        >> Html.node "render-asciidoc" []
        >> Element.html
