module ACCUSchedule.Update exposing (update)

import ACCUSchedule.Comms as Comms
import ACCUSchedule.Model exposing (Model, raisePresenter, raiseProposal)
import ACCUSchedule.Msg as Msg
import ACCUSchedule.Storage as Storage
import Browser
import Browser.Navigation as Nav
-- import Dispatch
import Return exposing (command, map, singleton)
import Url


update : Msg.Msg -> Model -> ( Model, Cmd Msg.Msg )
update msg model =
    case msg of
        Msg.FetchData ->
            singleton model
                |> command (Comms.fetchProposals model)
                |> command (Comms.fetchPresenters model)

        Msg.ProposalsResult (Ok proposals) ->
            ({ model | proposals = proposals }, Cmd.none)

        Msg.ProposalsResult (Err errMsg) ->
            -- TODO: display error message or something...maybe a button for
            -- re-fetching the proposals.
            (model, Cmd.none)

        Msg.PresentersResult (Ok presenters) ->
            ({ model | presenters = presenters }, Cmd.none)

        Msg.PresentersResult (Err errMsg) ->
            -- TODO: display error message or something...
            (model, Cmd.none)

        Msg.ToggleBookmark id ->
            let
                bookmarks =
                    if List.member id model.bookmarks then
                        List.filter (\pid -> pid /= id) model.bookmarks

                    else
                        id :: model.bookmarks
            in
            ({ model | bookmarks = bookmarks }, Storage.store bookmarks)

        Msg.RaiseProposal raised id ->
            singleton model
                |> map (raiseProposal raised id)

        Msg.RaisePresenter raised id ->
            singleton model
                |> map (raisePresenter raised id)

        Msg.Batch msgs ->
            (model, Cmd.none) -- TODO [ Dispatch.forward msgs ]

        Msg.LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        Msg.UrlChange url ->
            ({ model | url = url }, Cmd.none)
