module ACCUSchedule.Model exposing
    ( Model
    , initialModel
    , presenters
    , proposals
    , raisePresenter
    , raiseProposal
    )

{-| The overal application model.
-}

import ACCUSchedule.Types as Types
import Browser.Navigation as Nav
import Url


type alias ViewModel =
    { raisedProposal : Maybe Types.ProposalId
    , raisedPresenter : Maybe Types.PresenterId
    , windowSize :
        { width : Int
        , height : Int
        }
    }


type alias Model =
    { proposals : List Types.Proposal
    , presenters : List Types.Presenter
    , apiBaseUrl : String
    , bookmarks : List Types.ProposalId
    , url : Url.Url
    , key : Nav.Key
    , view : ViewModel
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


initialModel : String -> List Types.ProposalId -> Nav.Key -> Url.Url -> Int -> Int -> Model
initialModel apiBaseUrl bookmarks key url width height =
    { proposals = []
    , presenters = []
    , apiBaseUrl = apiBaseUrl
    , bookmarks = bookmarks
    , url = url
    , key = key
    , view =
        { raisedProposal = Nothing
        , raisedPresenter = Nothing
        , windowSize =
            { width = width
            , height = height
            }
        }
    }
