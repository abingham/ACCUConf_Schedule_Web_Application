port module ACCUSchedule.Asciidoc exposing (convertAsciidoc, onAsciidocConverted)

import Json.Encode


port convertAsciidoc : Json.Encode.Value -> Cmd msg


port onAsciidocConverted : (Json.Encode.Value -> msg) -> Sub msg
