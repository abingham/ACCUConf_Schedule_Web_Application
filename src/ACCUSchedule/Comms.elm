module ACCUSchedule.Comms exposing (..)

{-| High-level API for talking to the schedule server.

# Commands
@docs TODO
-}

import ACCUSchedule.Json as Json
import ACCUSchedule.Model  exposing (Model)
import ACCUSchedule.Msg as Msg
import Http


fetchProposals : Model -> Cmd Msg.Msg
fetchProposals model =
    Http.get {
        url = model.apiBaseUrl ++ "/sessions",
        expect = Http.expectJson Msg.ProposalsResult Json.proposalsDecoder
    }

fetchPresenters : Model -> Cmd Msg.Msg
fetchPresenters model =
    Http.get {
        url = model.apiBaseUrl ++ "/presenters",
        expect = Http.expectJson Msg.PresentersResult Json.presentersDecoder
    }
