module ACCUSchedule.Model exposing
    ( Model
    , apiBaseUrl
    , bookmarks
    , initialModel
    , isBookmarked
    , key
    , presenterProposals
    , presenters
    , proposalPresenters
    , proposals
    , raisePresenter
    , raiseProposal
    , setBookmark
    , setPresenters
    , setProposals
    , setUrl
    , url
    )

{-| The overal application model.
-}

import ACCUSchedule.Msg as Msg
import ACCUSchedule.Types as Types
import Browser.Navigation as Nav
import Dict
import Html
import Set
import Url


type alias ViewModel =
    { raisedProposal : Maybe Types.ProposalId
    , raisedPresenter : Maybe Types.PresenterId
    }


type alias CoreModel =
    { proposals : List Types.Proposal
    , presenters : List Types.Presenter
    , apiBaseUrl : String
    , bookmarks : Set.Set Types.ProposalId
    , url : Url.Url
    , key : Nav.Key
    , view : ViewModel
    }


type Model
    = Model CoreModel


proposals : Model -> List Types.Proposal
proposals (Model model) =
    model.proposals


setProposals : List Types.Proposal -> Model -> Model
setProposals ps (Model model) =
    -- TODO: Filter bookmarks to only proposals in this list.
    Model { model | proposals = ps }


presenters : Model -> List Types.Presenter
presenters (Model model) =
    model.presenters


setPresenters : List Types.Presenter -> Model -> Model
setPresenters ps (Model model) =
    Model { model | presenters = ps }


apiBaseUrl : Model -> String
apiBaseUrl (Model model) =
    model.apiBaseUrl


bookmarks : Model -> List Types.Proposal
bookmarks (Model model) =
    List.filter
        (\p -> Set.member p.id model.bookmarks)
        model.proposals


isBookmarked : Types.ProposalId -> Model -> Bool
isBookmarked id (Model model) =
    Set.member id model.bookmarks


setBookmark : Types.ProposalId -> Model -> Bool -> Model
setBookmark id (Model model) value =
    let
        bmarks =
            if value then
                Set.insert id model.bookmarks

            else
                Set.remove id model.bookmarks
    in
    Model { model | bookmarks = bmarks }


url : Model -> Url.Url
url (Model model) =
    model.url


setUrl : Url.Url -> Model -> Model
setUrl navUrl (Model model) =
    Model { model | url = navUrl }


key : Model -> Nav.Key
key (Model model) =
    model.key


{-| Find the presenters for a proposal.
-}
proposalPresenters : Model -> Types.Proposal -> List Types.Presenter
proposalPresenters (Model model) proposal =
    List.filter (\pres -> List.member pres.id proposal.presenters) model.presenters


presenterProposals : Model -> Types.Presenter -> List Types.Proposal
presenterProposals (Model model) presenter =
    List.filter (\prop -> List.member presenter.id prop.presenters) model.proposals


raiseProposal : Bool -> Types.ProposalId -> Model -> Model
raiseProposal raised id (Model model) =
    let
        val =
            if raised then
                Just id

            else
                Nothing

        view =
            model.view
    in
    Model { model | view = { view | raisedProposal = val } }


raisePresenter : Bool -> Types.PresenterId -> Model -> Model
raisePresenter raised id (Model model) =
    let
        val =
            if raised then
                Just id

            else
                Nothing

        view =
            model.view
    in
    Model { model | view = { view | raisedPresenter = val } }


initialModel : String -> Set.Set Types.ProposalId -> Nav.Key -> Url.Url -> Int -> Int -> Model
initialModel apiUrl bmarks navKey initialUrl width height =
    Model
        { proposals = []
        , presenters = []
        , apiBaseUrl = apiUrl
        , bookmarks = bmarks
        , url = initialUrl
        , key = navKey
        , view =
            { raisedProposal = Nothing
            , raisedPresenter = Nothing
            }
        }
