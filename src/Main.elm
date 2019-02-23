module ACCUSchedule exposing (..)

import ACCUSchedule.Comms as Comms
import ACCUSchedule.Model exposing (..)
import ACCUSchedule.Msg exposing (..)
import ACCUSchedule.Types exposing (ProposalId)
import ACCUSchedule.Update exposing (update)
import ACCUSchedule.View exposing (view)
import Browser


type alias Flags =
    { bookmarks : List ProposalId
    , apiBaseUrl : String
    }


main : Program Flags Model Msg
main =
    Browser.application
    { init =
            \flags url key ->
                let
                    model =
                        initialModel flags.apiBaseUrl flags.bookmarks key url 
                in
                    ( model
                    , Cmd.batch
                        [ Comms.fetchProposals model
                        , Comms.fetchPresenters model
                        ]
                    )
    , view = view
    , update = update
    , subscriptions = \_ = Sub.none
    , onUrlChange = UrlChanged
    , onUrlRequest = LinkClicked
    }
