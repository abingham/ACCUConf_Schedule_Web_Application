module ACCUSchedule.View.Card exposing (head, subhead, text, title, view)

import ACCUSchedule.Msg as Msg
import Element exposing (Attribute, Element, column, fill, padding, row, spacing, width)
import Element.Border
import Element.Font


withDefaultAttrs : (List (Attribute Msg.Msg) -> List (Element Msg.Msg) -> Element Msg.Msg) -> List (Attribute Msg.Msg) -> List (Attribute Msg.Msg) -> List (Element Msg.Msg) -> Element Msg.Msg
withDefaultAttrs elemType defaults attrs =
    defaults ++ attrs |> elemType 


view : List (Attribute Msg.Msg) -> List (Element Msg.Msg) -> Element Msg.Msg
view =
    withDefaultAttrs column [ width fill ]


title : List (Attribute Msg.Msg) -> List (Element Msg.Msg) -> Element Msg.Msg
title =
    withDefaultAttrs column [ width fill, padding 2 ]


head : List (Attribute Msg.Msg) -> List (Element Msg.Msg) -> Element Msg.Msg
head =
    withDefaultAttrs row [ width fill, Element.Font.bold ]


subhead : List (Attribute Msg.Msg) -> List (Element Msg.Msg) -> Element Msg.Msg
subhead =
    withDefaultAttrs row [ width fill, Element.Font.light ]


text : List (Attribute Msg.Msg) -> List (Element Msg.Msg) -> Element Msg.Msg
text =
    withDefaultAttrs row [ width fill, padding 2 ]
