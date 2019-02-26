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
import ACCUSchedule.View.Theme as Theme
import Element exposing (Element, paragraph, text)
import Element.Background
import Element.Border
import Element.Font


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

        location =
            String.join ", " <|
                case proposal.quickieSlot of
                    Just slot ->
                        [ time, QuickieSlots.toString slot, room ]

                    _ ->
                        [ time, room ]

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

        subhead =
            Card.subhead [] [ paragraph [] [ dayLink ] ]

        title =
            Card.title [] [ head, subhead ]

        body =
            List.map (\l -> Card.text [] [ l ]) presenterLinks
    in
    title
        :: body
        |> Card.view []
