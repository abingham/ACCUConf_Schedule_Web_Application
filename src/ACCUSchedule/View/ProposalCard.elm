module ACCUSchedule.View.ProposalCard exposing (proposalCard)

import ACCUSchedule.Model as Model
import ACCUSchedule.Msg as Msg
import ACCUSchedule.Routing as Routing
import ACCUSchedule.Types as Types
import ACCUSchedule.Types.Days as Days
import ACCUSchedule.Types.QuickieSlots as QuickieSlots
import ACCUSchedule.Types.Rooms as Rooms
import ACCUSchedule.Types.Sessions as Sessions
import ACCUSchedule.View.Theme as Theme
import Bootstrap.Button as Button
import Bootstrap.Card as Card
import FeatherIcons
import Html exposing (a, br, div, h1, Html, img, p, text)
import Html.Attributes exposing (href)
import Svg.Attributes exposing (fill)


proposalInfoButton : Types.Proposal -> Html Msg.Msg
proposalInfoButton proposal =
    Button.linkButton
        []
        [ a [ href <| Routing.proposalUrl proposal.id ] [ text "details" ] ]


bookmarkButton : Model.Model -> Types.Proposal -> Html Msg.Msg
bookmarkButton model proposal =
    let
        fillStyle =
            if List.member proposal.id model.bookmarks then
                "solid"
            else
                "none"
    in
        Button.button
            [ Button.onClick <| Msg.ToggleBookmark proposal.id
            ]
            [ FeatherIcons.heart |> FeatherIcons.toHtml [ fill fillStyle ]
            ]


presenterInfoButton : Types.Presenter -> Html Msg.Msg
presenterInfoButton presenter =
    Button.linkButton
        []
        [ a [ href <| Routing.presenterUrl presenter.id ] [ text <| Types.fullName presenter ] ]


{-| A card-view of a single proposal. This displays the title, presenters,
location, and potentially other information about a proposal, though not the
full text of the abstract. This includes a clickable icon for "starring" a
propposal.
-}
proposalCard : Model.Model -> Types.Proposal -> Card.Config Msg.Msg
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
            a [ href (Routing.dayUrl proposal.day) ] [ text <| Days.toString proposal.day ]

    in
        Card.config [ Card.outlineInfo ]
            |> Card.block []
                [ Card.titleH2 [] [ text proposal.title ]
                , Card.titleH5 [] [ dayLink, text <| ", " ++ location ]
                , Card.titleH5 [] <| List.map presenterInfoButton (Model.presenters model proposal)
                ]
            |> Card.footer []
                [ proposalInfoButton proposal
                , bookmarkButton model proposal
                ]
