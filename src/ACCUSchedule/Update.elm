module ACCUSchedule.Update exposing (update)

import ACCUSchedule.Comms as Comms
import ACCUSchedule.Model exposing (Model, raisePresenter, raiseProposal)
import ACCUSchedule.Msg as Msg
import ACCUSchedule.Routing as Routing
import ACCUSchedule.Storage as Storage
import ACCUSchedule.Types as Types
import Browser
import Browser.Navigation as Nav
import Dict
import Html
import Html.Parser
import Html.Parser.Util
import Json.Decode
import Json.Encode
import Platform.Cmd exposing (batch)
import Return exposing (command, map, singleton)
import Url
import Url.Parser exposing ((</>), int, s)


update : Msg.Msg -> Model -> ( Model, Cmd Msg.Msg )
update msg model =
    case msg of
        Msg.FetchData ->
            singleton model
                |> command (Comms.fetchProposals model)
                |> command (Comms.fetchPresenters model)

        Msg.ProposalsResult (Ok proposals) ->
            ( { model | proposals = proposals }, Cmd.none )

        Msg.ProposalsResult (Err _) ->
            ( model, Cmd.none )

        Msg.PresentersResult (Ok presenters) ->
            ( { model | presenters = presenters }, Cmd.none )

        Msg.PresentersResult (Err _) ->
            ( model, Cmd.none )

        Msg.ToggleBookmark id ->
            let
                bookmarks =
                    if List.member id model.bookmarks then
                        List.filter (\pid -> pid /= id) model.bookmarks

                    else
                        id :: model.bookmarks
            in
            ( { model | bookmarks = bookmarks }, Storage.store bookmarks )

        Msg.RaiseProposal raised id ->
            singleton model
                |> map (raiseProposal raised id)

        Msg.RaisePresenter raised id ->
            singleton model
                |> map (raisePresenter raised id)

        Msg.SetSearchTerm term ->
            ( model, Nav.replaceUrl model.key (Routing.searchUrl term) )

        Msg.LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        Msg.UrlChange url ->
            ( { model | url = url }, Cmd.none )
