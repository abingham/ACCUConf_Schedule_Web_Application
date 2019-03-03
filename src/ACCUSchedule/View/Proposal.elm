module ACCUSchedule.View.Proposal exposing (proposalCard, proposalLink, proposalView)

import ACCUSchedule.Model as Model
import ACCUSchedule.Msg as Msg
import ACCUSchedule.Routing as Routing
import ACCUSchedule.Types as Types
import ACCUSchedule.Types.Days as Days
import ACCUSchedule.Types.QuickieSlots as QuickieSlots
import ACCUSchedule.Types.Rooms as Rooms
import ACCUSchedule.Types.Sessions as Sessions
import ACCUSchedule.View.Asciidoc exposing (renderAsciidoc)
import ACCUSchedule.View.Card as Card
import ACCUSchedule.View.Icon as Icon
import Dict
import Element exposing (alignLeft, alignRight, el, htmlAttribute, padding, paragraph, spacing, text)
import Element.Events exposing (onClick)
import Html
import Html.Attributes exposing (style)


{-| Display a single proposal. This includes all of the details of the proposal,
including the full text of the abstract.
-}
proposalView : List (Element.Attribute Msg.Msg) -> Model.Model -> Types.Proposal -> Element.Element Msg.Msg
proposalView attrs model proposal =
    paragraph attrs
        [ el [ alignRight, padding 5 ] (proposalCard [] model proposal)
        , renderAsciidoc [] proposal.summary
        ]


proposalLink : List (Element.Attribute Msg.Msg) -> Types.Proposal -> Element.Element Msg.Msg
proposalLink attrs proposal =
    Element.link attrs
        { url = Routing.proposalUrl proposal.id
        , label = paragraph [] [ text proposal.title ]
        }


{-| A card-view of a single proposal. This displays the title, presenters,
location, and potentially other information about a proposal, though not the
full text of the abstract. This includes a clickable icon for "starring" a
propposal.
-}
proposalCard : List (Element.Attribute Msg.Msg) -> Model.Model -> Types.Proposal -> Element.Element Msg.Msg
proposalCard attrs model proposal =
    let
        room =
            Rooms.toString proposal.room

        time =
            Sessions.toString proposal.session

        slot =
            case proposal.quickieSlot of
                Just s ->
                    "(" ++ QuickieSlots.toString s ++ ")"

                _ ->
                    ""

        dayLink =
            Element.link []
                { url = Routing.dayUrl proposal.day
                , label = text (Days.toString proposal.day)
                }

        presenterLink p =
            Element.link []
                { url = Routing.presenterUrl p.id
                , label = text p.name
                }

        presenterSubhead =
            Model.proposalPresenters model proposal
                |> List.map presenterLink
                |> List.intersperse (text ", ")
                |> paragraph []
                |> List.singleton
                |> Card.subhead []

        head =
            Card.head [] [ paragraph [] [ proposalLink [] proposal ] ]

        timeSubhead =
            Card.subhead [] [ paragraph [] [ dayLink, text (" " ++ time ++ " " ++ slot) ] ]

        roomSubhead =
            Card.subhead [] [ paragraph [] [ text room ] ]

        title =
            Card.title [] [ head, presenterSubhead, timeSubhead, roomSubhead ]

        bookmarkAction =
            let
                name =
                    if Model.isBookmarked proposal.id model then
                        "favorite"

                    else
                        "favorite_border"
            in
            Icon.icon
                [ onClick (Msg.ToggleBookmark proposal.id)
                , htmlAttribute (style "cursor" "pointer")
                ]
                name

        actions =
            Card.actions [] [ bookmarkAction ]
    in
    Card.view attrs [ title, actions ]
