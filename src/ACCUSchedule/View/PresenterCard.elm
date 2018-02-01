module ACCUSchedule.View.PresenterCard exposing (presenterCard)

{-| Implements a card view for a single presenter.
-}

import ACCUSchedule.ISO3166 as ISO3166
import ACCUSchedule.Model as Model
import ACCUSchedule.Msg as Msg
import ACCUSchedule.Routing as Routing
import ACCUSchedule.Types as Types
import ACCUSchedule.View.Theme as Theme
import Bootstrap.Button as Button
import Bootstrap.Card as Card
import Bootstrap.ListGroup as ListGroup
import Html exposing (a, br, div, h1, Html, img, p, text)
import Html.Attributes exposing (href)


{-| A card view for a single presenter. The `controlGroup` argument is the first
element in the `Index` argument for MDL controls; use it to differentiate
presenter-card buttons from buttons in other parts of the view.

    div [] [presenterCard 0 model presenter]

-}
presenterCard : Model.Model -> Types.Presenter -> Card.Config Msg.Msg
presenterCard model presenter =
    let
        proposalLink proposal =
            [ a [ href <| Routing.proposalUrl proposal.id ] [ text <| proposal.title ] ]

        country =
            case ISO3166.countryName presenter.country of
                Just name ->
                    name

                Nothing ->
                    presenter.country

        detailsButton =
            Button.linkButton []
                [ a [ href <| Routing.presenterUrl presenter.id ] [ text "details" ] ]
    in
        Card.config [ Card.outlineInfo ]
            |> Card.block []
                [ Card.titleH2 [] [ text <| Types.fullName presenter ]
                , Card.titleH5 [] [ text country ]
                ]
            |> Card.listGroup
                (List.map (proposalLink >> ListGroup.li []) (Model.proposals model presenter))
            |> Card.footer []
                [ detailsButton ]
