module ACCUSchedule.View.Card exposing (actions, flow, head, subhead, text, title, view)

import ACCUSchedule.Msg as Msg
import ACCUSchedule.View.Theme as Theme
import Element exposing (Attribute, Element, alignTop, centerX, column, fill, padding, paragraph, px, row, spacing, width, wrappedRow)
import Element.Background
import Element.Border
import Element.Font


withDefaultAttrs : (List (Attribute Msg.Msg) -> List (Element Msg.Msg) -> Element Msg.Msg) -> List (Attribute Msg.Msg) -> List (Attribute Msg.Msg) -> List (Element Msg.Msg) -> Element Msg.Msg
withDefaultAttrs elemType defaults attrs =
    defaults ++ attrs |> elemType


view : List (Attribute Msg.Msg) -> List (Element Msg.Msg) -> Element Msg.Msg
view =
    withDefaultAttrs column
        [ width (px 300)
        , Element.Border.width 1
        , Element.Border.color Theme.lightGray
        , alignTop
        ]


title : List (Attribute Msg.Msg) -> List (Element Msg.Msg) -> Element Msg.Msg
title =
    withDefaultAttrs column
        [ width fill
        , spacing 10
        , padding 20
        , Element.Background.color Theme.accent
        , Element.Font.color Theme.white
        ]


head : List (Attribute Msg.Msg) -> List (Element Msg.Msg) -> Element Msg.Msg
head =
    withDefaultAttrs row [ width fill, Element.Font.size (Theme.fontSize 2) ]


subhead : List (Attribute Msg.Msg) -> List (Element Msg.Msg) -> Element Msg.Msg
subhead =
    withDefaultAttrs row
        [ width fill
        , Element.Font.light
        , Element.Font.size (Theme.fontSize -1)
        ]


text : List (Attribute Msg.Msg) -> List (Element Msg.Msg) -> Element Msg.Msg
text =
    withDefaultAttrs paragraph [ width fill, padding 10 ]


actions : List (Attribute Msg.Msg) -> List (Element Msg.Msg) -> Element Msg.Msg
actions =
    withDefaultAttrs row
        [ width fill
        , spacing 10
        , padding 20
        , Element.Background.color Theme.background
        , Element.Font.color Theme.gray
        ]


flow : List (Element.Attribute Msg.Msg) -> List (Element Msg.Msg) -> Element Msg.Msg
flow attrs =
    let
        defaultAttrs =
            [ padding 10, spacing 10 ]

        fullAttrs =
            defaultAttrs ++ attrs
    in
    wrappedRow fullAttrs
