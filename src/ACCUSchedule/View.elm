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
import ACCUSchedule.View.Card as Card
import ACCUSchedule.View.PresenterCard exposing (presenterCard)
import ACCUSchedule.View.Proposal exposing (proposalCard, proposalView)
import ACCUSchedule.View.Theme as Theme
import Browser
import Dict
import Element exposing (Attribute, Element, alignLeft, alignRight, centerX, column, el, fill, fillPortion, height, image, link, padding, paddingXY, paragraph, px, row, spacing, text, width, wrappedRow)
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


sessionView : Model.Model -> List Types.Proposal -> Sessions.Session -> Element.Element Msg.Msg
sessionView model props session =
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
    in
    case List.head proposals of
        Nothing ->
            row [] []

        Just prop ->
            let
                s =
                    Sessions.toString prop.session

                d =
                    Days.toString prop.day

                label =
                    d ++ ", " ++ s

                cards =
                    List.map (proposalCard model) proposals
            in
            column []
                [ text label
                , Card.columns model.view.windowSize cards
                ]


{-| Display all proposals for a particular day.
-}
dayView : Model.Model -> List Types.Proposal -> Days.Day -> Element.Element Msg.Msg
dayView model proposals day =
    let
        props =
            List.filter (.day >> (==) day) proposals

        sview =
            sessionView model props
    in
    List.map
        sview
        Sessions.conferenceSessions
        |> column [ centerX ]


{-| Display all "bookmarked" proposals, i.e. the users personal agenda.
-}
agendaView : Model.Model -> Element.Element Msg.Msg
agendaView model =
    model.proposals
        |> List.filter (\p -> List.member p.id model.bookmarks)
        >> List.sortBy (.session >> Sessions.ordinal)
        >> List.map (\p -> proposalCard model p)
        >> Card.columns model.view.windowSize


{-| Display a single presenter
-}
presenterView : Model.Model -> Types.Presenter -> Element.Element Msg.Msg
presenterView model presenter =
    paragraph []
        [ el [ alignLeft, padding 5 ] (presenterCard model presenter)
        , text presenter.bio
        ]


presentersView : Model.Model -> Element.Element Msg.Msg
presentersView model =
    model.presenters
        |> List.sortBy .name
        |> List.map (presenterCard model)
        |> Card.columns model.view.windowSize


searchView : String -> Model.Model -> Element.Element Msg.Msg
searchView term model =
    let
        proposalCards =
            Search.search term model
                |> List.map (proposalCard model)
                |> Card.columns model.view.windowSize
    in
    column [ width fill ]
        [ row [ width fill ]
            [ search []
                { onChange = Msg.SetSearchTerm
                , text = term
                , placeholder = Just (placeholder [] (text "Search proposals"))
                , label = labelHidden "Search proposals"
                }
            ]
        , row [ centerX ] [ proposalCards ]
        ]


notFoundView : Element.Element Msg.Msg
notFoundView =
    text "page not found :("


bodyRow : List (Attribute Msg.Msg) -> List (Element Msg.Msg) -> Element Msg.Msg
bodyRow attrs center =
    let
        defaultAttrs =
            [ width fill ]

        fullAttrs =
            defaultAttrs ++ attrs
    in
    row fullAttrs
        [ column [ width (fillPortion 2) ] []
        , column [ width (fillPortion 8), height fill ] center
        , column [ width (fillPortion 2) ] []
        ]


header : Element Msg.Msg
header =
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
        [ column [ width fill, spacing 20, paddingXY 0 20 ]
            [ row []
                [ image []
                    { src = "/img/accu-logo.png"
                    , description = "ACCU logo"
                    }
                ]
            , wrappedRow [ width fill, spacing 20 ] navLinks
            ]
        ]


body : Model.Model -> Element Msg.Msg
body model =
    let
        content =
            case Routing.urlToRoute model.url of
                Routing.Day day ->
                    dayView model model.proposals day

                Routing.Proposal id ->
                    case findProposal model id of
                        Just proposal ->
                            proposalView model proposal

                        Nothing ->
                            notFoundView

                Routing.Presenter id ->
                    case findPresenter model id of
                        Just presenter ->
                            presenterView model presenter

                        Nothing ->
                            notFoundView

                Routing.Presenters ->
                    presentersView model

                Routing.Agenda ->
                    agendaView model

                Routing.Search term ->
                    case term of
                        Just t ->
                            searchView t model

                        Nothing ->
                            searchView "" model

                _ ->
                    notFoundView
    in
    bodyRow [ paddingXY 0 20 ] [ content ]


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
        content =
            column [ width fill, height fill ] [ header, body model, footer ]
    in
    { title = "ACCU 2019"
    , body =
        [ Element.layout [ Element.Font.size (Theme.fontSize 1) ] content ]
    }
