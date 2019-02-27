module ACCUSchedule.View.ProposalCard exposing (proposalCard)

import ACCUSchedule.Model as Model
import ACCUSchedule.Msg as Msg
import ACCUSchedule.Routing as Routing
import ACCUSchedule.Types as Types
import ACCUSchedule.Types.Days as Days
import ACCUSchedule.Types.QuickieSlots as QuickieSlots
import ACCUSchedule.Types.Rooms as Rooms
import ACCUSchedule.Types.Sessions as Sessions
import ACCUSchedule.View.Card as Card
import ACCUSchedule.View.Icon as Icon
import Element exposing (el, htmlAttribute, image, paragraph, text)
import Element.Events exposing (onClick)
import Element.Font as Font
import Html.Attributes exposing (style)


{-| A card-view of a single proposal. This displays the title, presenters,
location, and potentially other information about a proposal, though not the
full text of the abstract. This includes a clickable icon for "starring" a
propposal.
-}
proposalCard : Model.Model -> Types.Proposal -> Element.Element Msg.Msg
proposalCard model proposal =
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
            Model.presenters model proposal
                |> List.map presenterLink
                |> List.intersperse (text ", ")
                |> paragraph []
                |> List.singleton
                |> Card.subhead []

        proposalLink =
            Element.link []
                { url = Routing.proposalUrl proposal.id
                , label = text proposal.title
                }

        head =
            Card.head [] [ paragraph [] [ proposalLink ] ]

        timeSubhead =
            Card.subhead [] [ paragraph [] [ dayLink, text (" " ++ time ++ " " ++ slot) ] ]

        roomSubhead =
            Card.subhead [] [ paragraph [] [ text room ] ]

        title =
            Card.title [] [ head, presenterSubhead, timeSubhead, roomSubhead ]

        bookmarkAction =
            let
                name =
                    if List.member proposal.id model.bookmarks then
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
    Card.view [] [ title, actions ]
