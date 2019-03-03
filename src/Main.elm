module ACCUSchedule exposing (Flags, main, subscriptions)

import ACCUSchedule.Comms as Comms
import ACCUSchedule.Model exposing (Model, initialModel)
import ACCUSchedule.Msg exposing (Msg(..))
import ACCUSchedule.Types exposing (ProposalId)
import ACCUSchedule.Update exposing (update)
import ACCUSchedule.View exposing (view)
import Browser
import Browser.Events
import Platform.Sub


type alias Flags =
    { bookmarks : List ProposalId
    , apiBaseUrl : String
    , width : Int
    , height : Int
    }


main : Program Flags Model Msg
main =
    Browser.application
        { init =
            \flags url key ->
                let
                    model =
                        initialModel flags.apiBaseUrl flags.bookmarks key url flags.width flags.height
                in
                ( model
                , Cmd.batch
                    [ Comms.fetchProposals model
                    , Comms.fetchPresenters model
                    ]
                )
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChange
        , onUrlRequest = LinkClicked
        }


subscriptions : Model -> Sub Msg
subscriptions _ =
    Platform.Sub.none
