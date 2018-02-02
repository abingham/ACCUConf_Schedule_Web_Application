module ACCUSchedule.View exposing (view)

import ACCUSchedule.Asciidoc as Asciidoc
import ACCUSchedule.Model as Model
import ACCUSchedule.Msg as Msg
import ACCUSchedule.Routing as Routing
import ACCUSchedule.Search as Search
import ACCUSchedule.Types as Types
import ACCUSchedule.Types.Days as Days
import ACCUSchedule.Types.QuickieSlots as QuickieSlots
import ACCUSchedule.Types.Rooms as Rooms
import ACCUSchedule.Types.Sessions as Sessions
import ACCUSchedule.View.PresenterCard exposing (presenterCard)
import ACCUSchedule.View.ProposalCard exposing (proposalCard)
import ACCUSchedule.View.Theme as Theme
import Bootstrap.Badge as Badge
import Bootstrap.Card as Card
import Bootstrap.CDN as CDN
import Bootstrap.Form.Input as Input
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Navbar as Navbar
import FeatherIcons
import Html exposing (a, br, div, h1, Html, img, p, text)
import Html.Attributes exposing (class, height, href, src)
import List.Extra exposing (stableSortWith)
import Markdown


{-| Find a proposal based on a string representation of its id.
This is just convenience for parsing the route.
-}
findProposal : Model.Model -> Types.ProposalId -> Maybe Types.Proposal
findProposal model id =
    (List.filter (\p -> p.id == id) model.proposals) |> List.head


{-| Find a presenter based on a string representation of its id.
This is just convenience for parsing the route.
-}
findPresenter : Model.Model -> Types.PresenterId -> Maybe Types.Presenter
findPresenter model id =
    (List.filter (\p -> p.id == id) model.presenters) |> List.head


sessionView : Model.Model -> List Types.Proposal -> Sessions.Session -> Html Msg.Msg
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
                |> stableSortWith compareSlots
                |> stableSortWith compareRooms
    in
        case List.head proposals of
            Nothing ->
                div [] []

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
                    Card.deck cards


{-| Display all proposals for a particular day.
-}
dayView : Model.Model -> List Types.Proposal -> Days.Day -> Html Msg.Msg
dayView model proposals day =
    let
        props =
            List.filter (.day >> (==) day) proposals

        sview =
            sessionView model props

        -- >> Options.styled div
        --     [ Options.css "margin-bottom" "10px" ]
    in
        div [] <|
            List.map
                sview
                Sessions.conferenceSessions


{-| Display all "bookmarked" proposals, i.e. the users personal agenda.
-}
agendaView : Model.Model -> Html Msg.Msg
agendaView model =
    let
        props =
            List.filter (\p -> List.member p.id model.bookmarks) model.proposals
                |> List.sortBy (.session >> Sessions.ordinal)

        dview day =
            [ Badge.badgeInfo [] [ a [ href <| Routing.dayUrl day ] [ text <| Days.toString day ] ]
            , List.filter (.day >> (==) day) props
                |> List.map (proposalCard model)
                |> Card.group
            ]
    in
        List.concatMap dview Days.conferenceDays
            |> div []


{-| Display a single proposal. This includes all of the details of the proposal,
including the full text of the abstract.
-}
proposalView : Model.Model -> Types.Proposal -> Html Msg.Msg
proposalView model proposal =
    let
        room =
            Rooms.toString proposal.room

        session =
            Sessions.toString proposal.session

        location =
            session ++ ", " ++ room
    in
        Grid.container
            []
            [ Grid.row
                []
                [ Grid.col
                    [ Col.xs4 ]
                    [ Card.view <| proposalCard model proposal ]
                , Grid.col
                    [ Col.xs8 ]
                    [ Asciidoc.toHtml [] proposal.text ]
                ]
            ]


{-| Display a single presenter
-}
presenterView : Model.Model -> Types.Presenter -> Html Msg.Msg
presenterView model presenter =
    Grid.container
        []
        [ Grid.row
            []
            [ Grid.col
                [ Col.xs4 ]
                [ Card.view <| presenterCard model presenter ]
            , Grid.col
                [ Col.xs8 ]
                [ Markdown.toHtml [] presenter.bio ]
            ]
        ]


presentersView : Model.Model -> Html Msg.Msg
presentersView model =
    model.presenters
        |> List.sortBy .lastName
        |> List.map (presenterCard model)
        |> Card.group


searchView : String -> Model.Model -> Html Msg.Msg
searchView term model =
    Search.search term model
        |> List.map (proposalCard model)
        |> Card.group


notFoundView : Html Msg.Msg
notFoundView =
    div []
        [ text "view not found :("
        ]


dropdownLink : String -> String -> Navbar.DropdownItem Msg.Msg
dropdownLink url linkText =
    Navbar.dropdownItem [ href url ] [ text linkText ]


dayLink : Days.Day -> Navbar.DropdownItem Msg.Msg
dayLink day =
    dropdownLink (Routing.dayUrl day) (Days.toString day)


agendaLink : Navbar.DropdownItem Msg.Msg
agendaLink =
    dropdownLink Routing.agendaUrl "Your agenda"


header : Model.Model -> Html.Html Msg.Msg
header model =
    let
        pageName =
            case model.location of
                Routing.Day day ->
                    Days.toString day

                Routing.Proposal id ->
                    ""

                Routing.Presenter id ->
                    ""

                Routing.Presenters ->
                    "Presenters"

                Routing.Agenda ->
                    "Your agenda"

                Routing.Search term ->
                    ""

                _ ->
                    ""
    in
        Navbar.config Msg.NavbarMsg
            |> Navbar.fixTop
            |> Navbar.withAnimation
            |> Navbar.lightCustom Theme.background
            |> Navbar.brand [ href "#" ] [ img [ src "./static/img/accu-logo.png", height 50 ] [] ]
            |> Navbar.items
                [ Navbar.dropdown
                    { id = "header-nav-dropdown"
                    , toggle = Navbar.dropdownToggle [] [ FeatherIcons.menu |> FeatherIcons.toHtml [] ]
                    , items =
                        List.concat
                            [ List.map dayLink Days.conferenceDays
                            , [ Navbar.dropdownDivider
                              , dropdownLink Routing.presentersUrl "Presenters"
                              , Navbar.dropdownDivider
                              , agendaLink
                              , Navbar.dropdownDivider
                              , Navbar.dropdownItem
                                    [-- Options.onClick <|
                                     --                                         Msg.Batch
                                     --                                             [ Msg.FetchData
                                     --                                             , Layout.toggleDrawer Msg.Mdl
                                     --                                             ]
                                    ]
                                    [ text "Refresh" ]
                              ]
                            ]
                    }
                ]
            |> Navbar.customItems
                [ Navbar.textItem [] [ text pageName ]
                , Navbar.formItem []
                    [ Input.search
                        [ Input.onInput Msg.VisitSearch
                        , Input.placeholder "Search"
                        ]
                    ]
                ]
            |> Navbar.view model.navbarState


footer : Model.Model -> Html.Html Msg.Msg
footer model =
    Navbar.config Msg.NavbarMsg
        |> Navbar.fixBottom
        |> Navbar.lightCustom Theme.background
        |> Navbar.brand [] [ text "ACCU 2017 Schedule" ]
        |> Navbar.items
            [ Navbar.itemLink [ href "https://conference.accu.org/site" ] [ text "Conference" ]
            , Navbar.itemLink [ href "https://github.com/ACCUConf/ACCUConf_Submission_Web_Application" ] [ img [ src "./static/img/GitHub-Mark-Light-32px.png" ] [] ]
            ]
        |> Navbar.customItems
            [ Navbar.customItem <|
                a [ href "https://sixty-north.com" ]
                    [ text "© 2017-2018 Sixty North AS "
                    , img [ class "footer-icon", src "./static/img/sixty-north-logo.png" ] []
                    ]
            ]
        |> Navbar.view model.footerState


view : Model.Model -> Html Msg.Msg
view model =
    let
        main =
            case model.location of
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

        searchString =
            case model.location of
                Routing.Search x ->
                    x

                _ ->
                    ""
    in
        Grid.container []
            [ CDN.stylesheet
            , header model
            , div [class "main-body"] [main]
            , footer model
            ]
