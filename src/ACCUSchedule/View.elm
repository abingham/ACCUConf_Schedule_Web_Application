module ACCUSchedule.View exposing (view)

import ACCUSchedule.Model as Model
import ACCUSchedule.Msg as Msg
import ACCUSchedule.Routing as Routing
import ACCUSchedule.Types as Types
import ACCUSchedule.Types.Days as Days
import ACCUSchedule.Types.QuickieSlots as QuickieSlots
import ACCUSchedule.Types.Rooms as Rooms
import ACCUSchedule.Types.Sessions as Sessions
import ACCUSchedule.View.Card as Card
import ACCUSchedule.View.PresenterCard exposing (presenterCard)
import ACCUSchedule.View.ProposalCard exposing (proposalCard)
import ACCUSchedule.View.Theme as Theme
import Browser
import Element exposing (Attribute, Element, alignLeft, alignRight, centerX, column, el, fill, fillPortion, height, image, link, padding, paragraph, px, row, shrink, spacing, text, width, wrappedRow)
import Element.Background
import Element.Font exposing (light)
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
    -- TODO: The ordering of cards should be reviewed.
    -- TODO: Should we split them out by days?
    model.proposals
        |> List.filter (\p -> List.member p.id model.bookmarks)
        >> List.sortBy (.session >> Sessions.ordinal)
        >> List.map (\p -> proposalCard model p)
        >> Card.columns model.view.windowSize


{-| Display a single proposal. This includes all of the details of the proposal,
including the full text of the abstract.
-}
proposalView : Model.Model -> Types.Proposal -> Element.Element Msg.Msg
proposalView model proposal =
    paragraph []
        [ el [ alignLeft, padding 5 ] (proposalCard model proposal)
        , text proposal.summary -- TODO: asciidoc
        ]


{-| Display a single presenter
-}
presenterView : Model.Model -> Types.Presenter -> Element.Element Msg.Msg
presenterView model presenter =
    paragraph []
        [ el [ alignLeft, padding 5 ] (presenterCard model presenter)
        , text presenter.bio -- TODO: Markdown / asciidoc?
        ]


presentersView : Model.Model -> Element.Element Msg.Msg
presentersView model =
    model.presenters
        |> List.sortBy .name
        |> List.map (presenterCard model)
        |> Card.columns model.view.windowSize


searchView : String -> Model.Model -> Element.Element Msg.Msg
searchView term model =
    text "search view"



--     -- Search.search term model
--     |> List.map (proposalCard proposalCardGroup model)
--     |> flowView


notFoundView : Element.Element Msg.Msg
notFoundView =
    text "page not found :("



-- drawerLink : String -> String -> Html Msg.Msg
-- drawerLink url linkText =
--     text "drawer link"
--     -- Layout.link
--     [ Layout.href url
--     , Options.onClick <| Layout.toggleDrawer Msg.Mdl
--     ]
--     [ text linkText ]
-- dayLink : Days.Day -> Html Msg.Msg
-- dayLink day =
--     text "day link"
--     -- drawerLink (Routing.dayUrl day) (Days.toString day)
-- agendaLink : Html Msg.Msg
-- agendaLink =
--     text "agenda link"
--     -- drawerLink Routing.agendaUrl "Your agenda"


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
            link []
                { url = Routing.presentersUrl
                , label = text "Presenters"
                }

        agendaLink =
            link []
                { url = Routing.agendaUrl
                , label = text "Agenda"
                }

        navLinks =
            List.append dayLinks [ presentersLink, agendaLink ]
    in
    bodyRow [ Element.Background.color Theme.background ]
        [ column [ spacing 20, padding 20 ]
            [ row []
                [ image []
                    { src = "/img/accu-logo.png"
                    , description = "ACCU logo"
                    }
                ]
            , wrappedRow [ spacing 20 ] navLinks
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
                    searchView term model

                _ ->
                    notFoundView
    in
    bodyRow [ padding 20 ] [ content ]


footerLink : List (Element.Attribute Msg.Msg) -> { url : String, label : Element.Element Msg.Msg } -> Element.Element Msg.Msg
footerLink =
    append [ light ] >> link


footer : Element Msg.Msg
footer =
    -- TODO: Items in footer should stack if the view is narrow. Can paragraph to this?
    -- TODO: Sticky footer?
    bodyRow [ Element.Background.color Theme.background ]
        [ wrappedRow [ padding 10, spacing 20, width fill ]
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



-- let
--     main =
--         case model.location of
--             Routing.Day day ->
--                 dayView model model.proposals day
--             Routing.Proposal id ->
--                 case findProposal model id of
--                     Just proposal ->
--                         [ proposalView model proposal ]
--                     Nothing ->
--                         [ notFoundView ]
--             Routing.Presenter id ->
--                 case findPresenter model id of
--                     Just presenter ->
--                         [ presenterView model presenter ]
--                     Nothing ->
--                         [ notFoundView ]
--             Routing.Presenters ->
--                 [ presentersView model ]
--             Routing.Agenda ->
--                 agendaView model
--             Routing.Search term ->
--                 [ searchView term model ]
--             _ ->
--                 [ notFoundView ]
--     pageName =
--         case model.location of
--             Routing.Day day ->
--                 Days.toString day
--             Routing.Proposal id ->
--                 ""
--             Routing.Presenter id ->
--                 ""
--             Routing.Presenters ->
--                 "Presenters"
--             Routing.Agenda ->
--                 "Your agenda"
--             Routing.Search term ->
--                 ""
--             _ ->
--                 ""
--     searchString =
--         case model.location of
--             Routing.Search x ->
--                 x
--             _ ->
--                 ""
-- in
--     div
--         []
--         [ Layout.render Msg.Mdl
--             model.mdl
--             [ Layout.fixedHeader
--             ]
--             { header =
--                 [ Layout.row
--                     [ Color.background Theme.background ]
--                     [ img [ src "./static/img/accu-logo.png", height 50 ] []
--                     , Layout.spacer
--                     , Layout.title
--                         [ Typo.title ]
--                         [ text pageName ]
--                     , Layout.spacer
--                     , Layout.title
--                         [ Typo.title
--                         , Options.onInput Msg.VisitSearch
--                         ]
--                         [ Textfield.render Msg.Mdl
--                             [ searchFieldControlGroup ]
--                             model.mdl
--                             [ Textfield.label "Search"
--                             , Textfield.floatingLabel
--                             , Textfield.value searchString
--                             , Textfield.expandable "search-field"
--                             , Textfield.expandableIcon "search"
--                             ]
--                             []
--                         ]
--                     ]
--                 ]
--             , drawer =
--                 [ Layout.title [] [ text "ACCU 2018" ]
--                 , Layout.navigation [] <|
--                     List.concat
--                         [ List.map
--                             dayLink
--                             Days.conferenceDays
--                         , [ Html.hr [] []
--                           , drawerLink Routing.presentersUrl "Presenters"
--                           , Html.hr [] []
--                           , agendaLink
--                           , Layout.spacer
--                           , Layout.link
--                                 [ Options.onClick <|
--                                     Msg.Batch
--                                         [ Msg.FetchData
--                                         , Layout.toggleDrawer Msg.Mdl
--                                         ]
--                                 ]
--                                 [ text "Refresh"
--                                 ]
--                           ]
--                         ]
--                 ]
--             , tabs = ( [], [] )
--             , main =
--                 [ Options.styled div
--                     [ Options.css "margin-left" "10px"
--                     , Options.css "margin-top" "10px"
--                     , Options.css "margin-bottom" "10px"
--                     ]
--                     main
--                 , footer
--                 ]
--             }
--         ]
