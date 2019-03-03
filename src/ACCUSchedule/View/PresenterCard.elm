module ACCUSchedule.View.PresenterCard exposing (presenterCard)

{-| Implements a card view for a single presenter.
-}

import ACCUSchedule.ISO3166 as ISO3166
import ACCUSchedule.Model as Model
import ACCUSchedule.Msg as Msg
import ACCUSchedule.Routing as Routing
import ACCUSchedule.Types as Types
import ACCUSchedule.View.Card as Card
import ACCUSchedule.View.Proposal exposing (proposalLink)
import Element exposing (Element, fill, link, paragraph, text, width)


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

        proposalLinks =
            List.map
                (proposalLink []
                    >> List.singleton
                    >> Card.text []
                )
                proposals

        country =
            case ISO3166.countryName presenter.country of
                Just name ->
                    name

                Nothing ->
                    presenter.country

        presenterLink =
            Element.link [ width fill ]
                { url = Routing.presenterUrl presenter.id
                , label = paragraph [] [ text presenter.name ]
                }

        title =
            Card.title []
                [ Card.head [] [ presenterLink ]
                , Card.subhead [] [ text country ]
                ]

        content =
            title :: proposalLinks
    in
    Card.view [] content
