module ACCUSchedule.View.PresenterCard exposing (presenterCard)

{-| Implements a card view for a single presenter.
-}

import ACCUSchedule.ISO3166 as ISO3166
import ACCUSchedule.Model as Model
import ACCUSchedule.Msg as Msg
import ACCUSchedule.Routing as Routing
import ACCUSchedule.Types as Types
import ACCUSchedule.View.Card as Card
import ACCUSchedule.View.Theme as Theme
import Element exposing (paragraph, centerX, Element, column, fill, link, padding, row, text, width)
import Element.Background
import Element.Border
import Element.Font


{-| A card view for a single presenter. The `controlGroup` argument is the first
element in the `Index` argument for MDL controls; use it to differentiate
presenter-card buttons from buttons in other parts of the view.

    div [] [ presenterCard 0 model presenter ]

-}
presenterCard : Model.Model -> Types.Presenter -> Element Msg.Msg
presenterCard model presenter =
    let
        proposals =
            Model.proposals model presenter

        proposalLink p =
            Card.text []
                [ Element.link []
                    { url = Routing.proposalUrl p.id
                    , label = paragraph [] [text p.title]
                    }
                ]

        proposalLinks =
            List.map proposalLink proposals

        country =
            case ISO3166.countryName presenter.country of
                Just name ->
                    name

                Nothing ->
                    presenter.country
    in
    Card.view [ Element.Border.width 1, Element.Border.color Theme.lightGray ]
        ([ Card.title [ Element.Background.color Theme.accent, Element.Font.color Theme.white ]
            [ Card.head [] [ text presenter.name ]
            , Card.subhead [ Element.Font.size (Theme.fontSize -1) ] [ text country ]
            ]
         ]
            ++ proposalLinks
        )
