module ACCUSchedule.Model
    exposing
        ( initialModel
        , Model
        , presenters
        , proposals
        , raiseProposal
        , raisePresenter
        )

{-| The overal application model.
-}

import ACCUSchedule.Msg as Msg
import ACCUSchedule.Routing as Routing
import ACCUSchedule.Types as Types
import Bootstrap.Navbar as Navbar
import Navigation


type alias ViewModel =
    { raisedProposal : Maybe Types.ProposalId
    , raisedPresenter : Maybe Types.PresenterId
    }


type alias Model =
    { proposals : List Types.Proposal
    , presenters : List Types.Presenter
    , apiBaseUrl : String
    , bookmarks : List Types.ProposalId
    , location : Routing.RoutePath
    , view : ViewModel
    , navbarState : Navbar.State
    }


{-| Find the presenters for a proposal.
-}
presenters : Model -> Types.Proposal -> List Types.Presenter
presenters model proposal =
    List.filter (\pres -> List.member pres.id proposal.presenters) model.presenters


proposals : Model -> Types.Presenter -> List Types.Proposal
proposals model presenter =
    List.filter (\prop -> List.member presenter.id prop.presenters) model.proposals


raiseProposal : Bool -> Types.ProposalId -> Model -> Model
raiseProposal raised id model =
    let
        val =
            if raised then
                Just id
            else
                Nothing

        view =
            model.view
    in
        { model | view = { view | raisedProposal = val } }


raisePresenter : Bool -> Types.PresenterId -> Model -> Model
raisePresenter raised id model =
    let
        val =
            if raised then
                Just id
            else
                Nothing

        view =
            model.view
    in
        { model | view = { view | raisedPresenter = val } }


initialModel : String -> List Types.ProposalId -> Navigation.Location -> (Model, Cmd Msg.Msg)
initialModel apiBaseUrl bookmarks location =
    let
        ( navbarState, navbarCmd ) =
            Navbar.initialState Msg.NavbarMsg
    in
        ({ proposals = []
         , presenters = []
         , apiBaseUrl = apiBaseUrl
         , bookmarks = bookmarks
         , location = Routing.parseLocation location
         , view = { raisedProposal = Nothing, raisedPresenter = Nothing }
         , navbarState = navbarState
         }
        , navbarCmd)
