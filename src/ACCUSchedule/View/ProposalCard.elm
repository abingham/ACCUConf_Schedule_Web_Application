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
import Element exposing (paragraph, text)


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
                _ -> ""

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

        presenterLinks =
            Model.presenters model proposal
                |> List.map presenterLink

        proposalLink =
            Element.link []
                { url = Routing.proposalUrl proposal.id
                , label = text proposal.title
                }

        head =
            Card.head [] [ paragraph [] [ proposalLink ] ]

        timeSubhead = 
            Card.subhead [] [paragraph [] [dayLink, text (" " ++ time ++ " " ++ slot)]]

        roomSubhead =
            Card.subhead [] [paragraph [] [ text room ]]

        title =
            Card.title [] [ head, timeSubhead, roomSubhead ]

        body =
            List.map (\l -> Card.text [] [ l ]) presenterLinks

        content =
            title :: body
    in
    Card.view [] content
