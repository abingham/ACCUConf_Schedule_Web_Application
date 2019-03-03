module ACCUSchedule.Comms exposing (fetchPresenters, fetchProposals)

{-| High-level API for talking to the schedule server.
-}

import ACCUSchedule.Json as Json
import ACCUSchedule.Model exposing (Model, apiBaseUrl)
import ACCUSchedule.Msg as Msg
import Http


fetchProposals : Model -> Cmd Msg.Msg
fetchProposals model =
    Http.get
        { url = apiBaseUrl model ++ "/sessions"
        , expect = Http.expectJson Msg.ProposalsResult Json.proposalsDecoder
        }


fetchPresenters : Model -> Cmd Msg.Msg
fetchPresenters model =
    Http.get
        { url = apiBaseUrl model ++ "/presenters"
        , expect = Http.expectJson Msg.PresentersResult Json.presentersDecoder
        }
