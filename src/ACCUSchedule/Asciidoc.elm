port module ACCUSchedule.Asciidoc exposing (convertAsciidoc, onAsciidocConverted, requestAsciidocConversion)

import ACCUSchedule.Types exposing (Proposal)
import Json.Encode


requestAsciidocConversion : Proposal -> Cmd msg
requestAsciidocConversion proposal =
    Json.Encode.object
        [ ( "raw_text", Json.Encode.string proposal.summary )
        , ( "id", Json.Encode.int proposal.id )
        ]
        |> convertAsciidoc


port convertAsciidoc : Json.Encode.Value -> Cmd msg


port onAsciidocConverted : (Json.Encode.Value -> msg) -> Sub msg
