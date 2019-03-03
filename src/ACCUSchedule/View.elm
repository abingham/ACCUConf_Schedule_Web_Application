module ACCUSchedule.View exposing (view)

import ACCUSchedule.Model as Model
import ACCUSchedule.Msg as Msg
import ACCUSchedule.Routing as Routing
import ACCUSchedule.Search as Search
import ACCUSchedule.Types as Types
import ACCUSchedule.Types.Days as Days
import ACCUSchedule.Types.QuickieSlots as QuickieSlots
import ACCUSchedule.Types.Rooms as Rooms
import ACCUSchedule.Types.Sessions as Sessions
import ACCUSchedule.View.Asciidoc exposing (renderAsciidoc)
import ACCUSchedule.View.Card as Card
import ACCUSchedule.View.PresenterCard exposing (presenterCard)
import ACCUSchedule.View.Proposal exposing (proposalCard, proposalView)
import ACCUSchedule.View.Theme as Theme
import Browser
import Dict
import Element exposing (Attribute, Element, alignLeft, alignRight, centerX, column, el, fill, fillPortion, height, image, link, padding, paddingXY, paragraph, px, row, shrink, spacing, text, width, wrappedRow)
import Element.Background
import Element.Font exposing (light)
import Element.Input exposing (labelHidden, placeholder, search)
import List exposing (append)


{-| Find a proposal based on a string representation of its id.

This is just convenience for parsing the route.

-}
findProposal : Model.Model -> Types.ProposalId -> Maybe Types.Proposal
findProposal model id =
    List.filter (\p -> p.id == id) model.proposals |> List.head


{-| Find a presenter based on a string representation of its id.

This is just convenience for parsing the route.

-}
findPresenter : Model.Model -> Types.PresenterId -> Maybe Types.Presenter
findPresenter model id =
    List.filter (\p -> p.id == id) model.presenters |> List.head


sessionView : List (Element.Attribute Msg.Msg) -> Model.Model -> List Types.Proposal -> Sessions.Session -> Element.Element Msg.Msg
sessionView attrs model props session =
    let
        room =
            .room >> Rooms.ordinal

        compareRooms p1 p2 =
            compare (room p1) (room p2)

        compareSlots p1 p2 =
            case ( p1.quickieSlot, p2.quickieSlot ) of
                ( Nothing, Nothing ) ->
                    EQ

                ( Nothing, _ ) ->
                    LT

                ( _, Nothing ) ->
                    GT

                ( Just s1, Just s2 ) ->
                    compare (QuickieSlots.ordinal s1) (QuickieSlots.ordinal s2)

        proposals =
            List.filter (.session >> (==) session) props
                |> List.sortWith compareSlots
                |> List.sortWith compareRooms

        elems =
            case List.head proposals of
                Nothing ->
                    []

                Just prop ->
                    let
                        s =
                            Sessions.toString prop.session

                        d =
                            Days.toString prop.day

                        label =
                            d ++ ", " ++ s

                        cards =
                            List.map (proposalCard [] model) proposals
                    in
                    [ text label
                    , Card.flow [] cards
                    ]
    in
    column attrs elems


{-| Display all proposals for a particular day.
-}
dayView : List (Element.Attribute Msg.Msg) -> Model.Model -> List Types.Proposal -> Days.Day -> Element.Element Msg.Msg
dayView attrs model proposals day =
    let
        props =
            List.filter (.day >> (==) day) proposals

        sview session =
            sessionView [ width fill ] model props session |> List.singleton >> row []
    in
    List.map
        sview
        Sessions.conferenceSessions
        |> column attrs


{-| Display all "bookmarked" proposals, i.e. the users personal agenda.
-}
agendaView : List (Element.Attribute Msg.Msg) -> Model.Model -> Element.Element Msg.Msg
agendaView attrs model =
    model.proposals
        |> List.filter (\p -> List.member p.id model.bookmarks)
        >> List.sortBy (.session >> Sessions.ordinal)
        >> List.map (\p -> proposalCard [] model p)
        >> Card.flow attrs


{-| Display a single presenter
-}
presenterView : List (Element.Attribute Msg.Msg) -> Model.Model -> Types.Presenter -> Element.Element Msg.Msg
presenterView attrs model presenter =
    paragraph attrs
        [ el [ alignRight, padding 5 ] (presenterCard model presenter)
        , renderAsciidoc [] presenter.bio
        ]


presentersView : List (Element.Attribute Msg.Msg) -> Model.Model -> Element.Element Msg.Msg
presentersView attrs model =
    model.presenters
        |> List.sortBy .name
        |> List.map (presenterCard model)
        |> Card.flow attrs


searchView : List (Element.Attribute Msg.Msg) -> Model.Model -> String -> Element.Element Msg.Msg
searchView attrs model term =
    let
        proposalCards =
            Search.search term model
                |> List.map (proposalCard [] model)
                |> Card.flow []
    in
    column attrs
        [ row [ width fill ]
            [ search []
                { onChange = Msg.SetSearchTerm
                , text = term
                , placeholder = Just (placeholder [] (text "Search proposals"))
                , label = labelHidden "Search proposals"
                }
            ]
        , proposalCards
        ]


notFoundView : List (Element.Attribute Msg.Msg) -> Element.Element Msg.Msg
notFoundView attrs =
    text "page not found :("
        |> List.singleton
        >> paragraph attrs


{-| A top-level row in the view.
-}
bodyRow : List (Attribute Msg.Msg) -> List (Element Msg.Msg) -> Element Msg.Msg
bodyRow attrs elements =
    let
        defaultAttrs =
            [ padding 10, width fill, height fill ]

        fullAttrs =
            defaultAttrs ++ attrs
    in
    row fullAttrs elements


header : String -> Element Msg.Msg
header title =
    let
        dayLink day =
            link []
                { url = Routing.dayUrl day
                , label = Days.toString day |> text
                }

        dayLinks =
            List.map dayLink Days.conferenceDays

        presentersLink =
            link [ alignRight ]
                { url = Routing.presentersUrl
                , label = text "Presenters"
                }

        agendaLink =
            link [ alignRight ]
                { url = Routing.agendaUrl
                , label = text "Favorites"
                }

        searchLink =
            link [ alignRight ]
                { url = Routing.searchUrl ""
                , label = text "Search"
                }

        navLinks =
            List.append dayLinks [ presentersLink, agendaLink, searchLink ]
    in
    bodyRow [ Element.Background.color Theme.background ]
        [ column [ width fill, spacing 20 ]
            [ wrappedRow [ spacing 20, width fill ]
                [ image [ width shrink ] { src = "/img/accu-logo.png", description = "ACCU logo" }
                , text title |> el [ centerX, Element.Font.size (Theme.fontSize 4) ]
                ]
            , wrappedRow
                [ width fill, spacing 20 ]
                navLinks
            ]
        ]


content : Model.Model -> ( String, Element Msg.Msg )
content model =
    let
        attrs =
            [ width fill ]

        ( title, contentElement ) =
            case Routing.urlToRoute model.url of
                Routing.Day day ->
                    ( Days.toString day, dayView attrs model model.proposals day )

                Routing.Proposal id ->
                    ( "Proposal"
                    , case findProposal model id of
                        Just proposal ->
                            proposalView attrs model proposal

                        Nothing ->
                            notFoundView []
                    )

                Routing.Presenter id ->
                    ( "Presenter"
                    , case findPresenter model id of
                        Just presenter ->
                            presenterView attrs model presenter

                        Nothing ->
                            notFoundView []
                    )

                Routing.Presenters ->
                    ( "Presenters", presentersView attrs model )

                Routing.Agenda ->
                    ( "Favorites", agendaView attrs model )

                Routing.Search term ->
                    ( "Search"
                    , searchView attrs model <|
                        case term of
                            Just t ->
                                t

                            Nothing ->
                                ""
                    )

                _ ->
                    ( "", notFoundView [] )
    in
    ( title, bodyRow [] [ contentElement ] )


footerLink : List (Element.Attribute Msg.Msg) -> { url : String, label : Element.Element Msg.Msg } -> Element.Element Msg.Msg
footerLink =
    append [ light ] >> link


footer : Element Msg.Msg
footer =
    bodyRow [ Element.Background.color Theme.background ]
        [ wrappedRow [ paddingXY 0 10, spacing 20, width fill ]
            [ text "ACCU 2019 Schedule"
            , footerLink []
                { url = "https://conference.accu.org/"
                , label = text "Conference"
                }
            , footerLink [ spacing 5 ]
                { url = "https://github.com/ACCUConf/Schedule_Web_Application"
                , label =
                    image [ height (px 32) ]
                        { src = "/img/GitHub-Mark-Light-32px.png"
                        , description = "Github project"
                        }
                }
            , footerLink [ alignRight ]
                { url = "https://sixty-north.com"
                , label =
                    row [ spacing 5 ]
                        [ text "© 2017-2019 Sixty North AS"
                        , image [ height (px 32) ]
                            { src = "/img/sixty-north-logo.png"
                            , description = "Sixty North AS"
                            }
                        ]
                }
            ]
        ]


view : Model.Model -> Browser.Document Msg.Msg
view model =
    let
        ( title, mainContent ) =
            content model

        fullBody =
            column [ width fill, height fill ] [ header title, mainContent, footer ]
    in
    { title = "ACCU 2019"
    , body =
        [ Element.layout [ Element.Font.size (Theme.fontSize 1) ] fullBody ]
    }
