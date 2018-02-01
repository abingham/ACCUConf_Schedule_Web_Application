module ACCUSchedule exposing (..)

import ACCUSchedule.Comms as Comms
import ACCUSchedule.Model exposing (..)
import ACCUSchedule.Msg exposing (..)
import ACCUSchedule.Types exposing (ProposalId)
import ACCUSchedule.Update exposing (update)
import ACCUSchedule.View exposing (view)
import Bootstrap.Navbar as Navbar
import Navigation
import Platform.Sub exposing (none)


type alias Flags =
    { bookmarks : List ProposalId
    , apiBaseUrl : String
    }


main : Program Flags Model Msg
main =
    Navigation.programWithFlags UrlChange
        { init =
            \flags loc ->
                let
                    (model, cmd) =
                        initialModel flags.apiBaseUrl flags.bookmarks loc
                in
                    ( model
                    , Cmd.batch
                        [ Comms.fetchProposals model
                        , Comms.fetchPresenters model
                        , cmd
                        ]
                    )
        , view = view
        , update = update
        , subscriptions = \model -> Navbar.subscriptions model.navbarState ACCUSchedule.Msg.NavbarMsg
        }
