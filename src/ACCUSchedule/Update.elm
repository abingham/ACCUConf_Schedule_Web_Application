module ACCUSchedule.Update exposing (update)

import ACCUSchedule.Comms as Comms
import ACCUSchedule.Model exposing (Model, raisePresenter, raiseProposal)
import ACCUSchedule.Msg as Msg
import ACCUSchedule.Routing as Routing
import ACCUSchedule.Storage as Storage
import Browser.Navigation as Nav
import Dispatch
import Material
import Return exposing (command, map, singleton)


update : Msg.Msg -> Model -> ( Model, Cmd Msg.Msg )
update msg model =
    case msg of
        Msg.FetchData ->
            singleton model
                |> command (Comms.fetchProposals model)
                |> command (Comms.fetchPresenters model)

        Msg.ProposalsResult (Ok proposals) ->
            { model | proposals = proposals } ! []

        Msg.ProposalsResult (Err msg) ->
            -- TODO: display error message or something...maybe a button for
            -- re-fetching the proposals.
            model ! []

        Msg.PresentersResult (Ok presenters) ->
            { model | presenters = presenters } ! []

        Msg.PresentersResult (Err msg) ->
            -- TODO: display error message or something...
            model ! []

        Msg.VisitProposal proposal ->
            ( model, Navigation.newUrl (Routing.proposalUrl proposal.id) )

        Msg.VisitPresenter presenter ->
            ( model, Navigation.newUrl (Routing.presenterUrl presenter.id) )

        Msg.VisitSearch term ->
            ( model, Navigation.modifyUrl (Routing.searchUrl term) )

        Msg.ToggleBookmark id ->
            let
                bookmarks =
                    if List.member id model.bookmarks then
                        List.filter (\pid -> pid /= id) model.bookmarks

                    else
                        id :: model.bookmarks
            in
            { model | bookmarks = bookmarks } ! [ Storage.store bookmarks ]

        Msg.RaiseProposal raised id ->
            singleton model
                |> map (raiseProposal raised id)

        Msg.RaisePresenter raised id ->
            singleton model
                |> map (raisePresenter raised id)

        Msg.Batch msgs ->
            model ! [ Dispatch.forward msgs ]

        Msg.LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        Msg.UrlChange location ->
            { model | url = url } ! []
