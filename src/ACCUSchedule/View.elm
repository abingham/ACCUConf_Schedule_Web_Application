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
-- import ACCUSchedule.View.Theme as Theme
import Browser
import Html exposing (a, br, div, h1, Html, img, p, text)
import Html.Attributes exposing (height, href, src)
-- import List.Extra exposing (stableSortWith)


proposalCardGroup : Int
proposalCardGroup =
    0


presenterCardGroup : Int
presenterCardGroup =
    1


searchFieldControlGroup : Int
searchFieldControlGroup =
    2


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


-- flowView : List (Html Msg.Msg) -> Html Msg.Msg
-- flowView elems =
--     Options.div
--         [ Options.css "display" "flex"
--         , Options.css "flex-flow" "row wrap"
--         ]
--         elems


sessionView : Model.Model -> List Types.Proposal -> Sessions.Session -> List (Html Msg.Msg)
sessionView model props session =
    [text "session view"]
    -- let
    --     room =
    --         .room >> Rooms.ordinal

    --     compareRooms p1 p2 =
    --         compare (room p1) (room p2)

    --     compareSlots p1 p2 =
    --         case ( p1.quickieSlot, p2.quickieSlot ) of
    --             ( Nothing, Nothing ) ->
    --                 EQ

    --             ( Nothing, _ ) ->
    --                 LT

    --             ( _, Nothing ) ->
    --                 GT

    --             ( Just s1, Just s2 ) ->
    --                 compare (QuickieSlots.ordinal s1) (QuickieSlots.ordinal s2)

    --     proposals =
    --         List.filter (.session >> (==) session) props
    --             |> stableSortWith compareSlots
    --             |> stableSortWith compareRooms
    -- in
    --     case List.head proposals of
    --         Nothing ->
    --             []

    --         Just prop ->
    --             let
    --                 s =
    --                     Sessions.toString prop.session

    --                 d =
    --                     Days.toString prop.day

    --                 label =
    --                     d ++ ", " ++ s

    --                 cards =
    --                     List.map (proposalCard proposalCardGroup model) proposals
    --             in
    --                 [ Chip.span [ Options.css "margin-bottom" "5px" ]
    --                     [ Chip.content []
    --                         [ text label ]
    --                     ]
    --                 , flowView cards
    --                 ]


{-| Display all proposals for a particular day.
-}
dayView : Model.Model -> List Types.Proposal -> Days.Day -> List (Html Msg.Msg)
dayView model proposals day =
    [text "dayView"]
    -- let
    --     props =
    --         List.filter (.day >> (==) day) proposals

    --     sview =
    --         sessionView model props
    --             >> Options.styled div
    --                 [ Options.css "margin-bottom" "10px" ]
    -- in
    --     List.map
    --         sview
    --         Sessions.conferenceSessions


{-| Display all "bookmarked" proposals, i.e. the users personal agenda.
-}
agendaView : Model.Model -> List (Html Msg.Msg)
agendaView model =
    [text "agenda view"]
    -- let
    --     props =
    --         List.filter (\p -> List.member p.id model.bookmarks) model.proposals
    --             |> List.sortBy (.session >> Sessions.ordinal)

    --     dview day =
    --         [ Chip.span
    --             [ Options.css "margin-bottom" "5px"
    --             , Elevation.e2
    --             ]
    --             [ Chip.content []
    --                 [ Layout.link
    --                     [ Layout.href <| Routing.dayUrl day ]
    --                     [ text <| Days.toString day ]
    --                 ]
    --             ]
    --         , List.filter (.day >> (==) day) props
    --             |> List.map (proposalCard proposalCardGroup model)
    --             |> flowView
    --         ]
    -- in
    --     List.concatMap dview Days.conferenceDays


{-| Display a single proposal. This includes all of the details of the proposal,
including the full text of the abstract.
-}
proposalView : Model.Model -> Types.Proposal -> Html Msg.Msg
proposalView model proposal =
    text "proposal view"
    -- let
    --     room =
    --         Rooms.toString proposal.room

    --     session =
    --         Sessions.toString proposal.session

    --     location =
    --         session ++ ", " ++ room
    -- in
    --     Options.div
    --         [ Options.css "display" "flex"
    --         , Options.css "flex-flow" "row wrap"
    --           -- , Options.css "justify" "center"
    --         , Options.css "justify-content" "flex-start"
    --         , Options.css "align-items" "flex-start"
    --         ]
    --         [ Options.styled p
    --             []
    --             [ proposalCard proposalCardGroup model proposal ]
    --         , Options.styled p
    --             [ Typo.body1
    --             , Options.css "width" "30em"
    --             , Options.css "margin-left" "10px"
    --             ]
    --             [ Asciidoc.toHtml [] proposal.summary ]
    --         ]


{-| Display a single presenter
-}
presenterView : Model.Model -> Types.Presenter -> Html Msg.Msg
presenterView model presenter =
    text "presenter view"
    -- Options.div
    --     [ Options.css "display" "flex"
    --     , Options.css "flex-flow" "row wrap"
    --       -- , Options.css "justify" "center"
    --     , Options.css "justify-content" "flex-start"
    --     , Options.css "align-items" "flex-start"
    --     ]
    --     [ Options.styled p
    --         []
    --         [ presenterCard presenterCardGroup model presenter ]
    --     , Options.styled p
    --         [ Typo.body1
    --         , Options.css "width" "30em"
    --         , Options.css "margin-left" "10px"
    --         ]
    --         [ Markdown.toHtml [] presenter.bio ]
    --     ]


presentersView : Model.Model -> Html Msg.Msg
presentersView model =
    text "presenters view"
    -- model.presenters
    --     |> List.sortBy .name
    --     |> List.map (presenterCard presenterCardGroup model)
    --     |> flowView


searchView : String -> Model.Model -> Html Msg.Msg
searchView term model =
    text "search view"
    -- Search.search term model
    --     |> List.map (proposalCard proposalCardGroup model)
    --     |> flowView


notFoundView : Html Msg.Msg
notFoundView =
    div []
        [ text "view not found :("
        ]


drawerLink : String -> String -> Html Msg.Msg
drawerLink url linkText =
    text "drawer link"
    -- Layout.link
    --     [ Layout.href url
    --     , Options.onClick <| Layout.toggleDrawer Msg.Mdl
    --     ]
    --     [ text linkText ]


dayLink : Days.Day -> Html Msg.Msg
dayLink day =
    text "day link"
    -- drawerLink (Routing.dayUrl day) (Days.toString day)


agendaLink : Html Msg.Msg
agendaLink =
    text "agenda link"
    -- drawerLink Routing.agendaUrl "Your agenda"


footer : Html Msg.Msg
footer =
    text "footer"
    -- Footer.mini []
    --     { left =
    --         Footer.left []
    --             [ Footer.logo [] [ Footer.html <| text "ACCU 2018 Schedule" ]
    --             , Footer.links []
    --                 [ Footer.linkItem
    --                     [ Footer.href "https://conference.accu.org/" ]
    --                     [ Footer.html <| text "Conference" ]
    --                 , Footer.linkItem
    --                     [ Footer.href "https://github.com/ACCUConf/ACCUConf_Schedule_Web_Application" ]
    --                     [ Footer.html <| img [ src "./static/img/GitHub-Mark-Light-32px.png" ] [] ]
    --                 ]
    --             ]
    --     , right =
    --         Footer.right []
    --             [ Footer.links []
    --                 [ Footer.linkItem
    --                     [ Footer.href "https://sixty-north.com" ]
    --                     [ Footer.html <| text "© 2017 Sixty North AS "
    --                     , Footer.html <|
    --                         Options.img
    --                             [ Options.css "height" "20px" ]
    --                             [ src "static/img/sixty-north-logo.png" ]
    --                     ]
    --                 ]
    --             ]
    --     }


view : Model.Model -> Browser.Document Msg.Msg
view model =
    { title = "ACCU 2019"
    , body = [text "view"]
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
