module ACCUSchedule.View.Card exposing (head, subhead, text, title, view)

import ACCUSchedule.Msg as Msg
import Element exposing (Attribute, Element, column, fill, padding, row, spacing, width)
import Element.Border
import Element.Font


view : List (Attribute Msg.Msg) -> List (Element Msg.Msg) -> Element Msg.Msg
view attrs elems =
    let
        defaultAttrs =
            [ width fill ]

        fullAttrs =
            defaultAttrs ++ attrs
    in
    column fullAttrs elems


title : List (Attribute Msg.Msg) -> List (Element Msg.Msg) -> Element Msg.Msg
title attrs elems =
    let
        defaultAttrs =
            [ width fill, padding 2 ]

        fullAttrs =
            defaultAttrs ++ attrs
    in
    column fullAttrs elems


head : List (Attribute Msg.Msg) -> List (Element Msg.Msg) -> Element Msg.Msg
head attrs elems =
    let
        defaultAttrs =
            [ width fill, Element.Font.bold ]

        fullAttrs =
            defaultAttrs ++ attrs
    in
    row fullAttrs elems


subhead : List (Attribute Msg.Msg) -> List (Element Msg.Msg) -> Element Msg.Msg
subhead attrs elems =
    let
        defaultAttrs =
            [ width fill, Element.Font.light ]

        fullAttrs =
            defaultAttrs ++ attrs
    in
    row fullAttrs elems


text : List (Attribute Msg.Msg) -> List (Element Msg.Msg) -> Element Msg.Msg
text attrs elems =
    let
        defaultAttrs =
            [ width fill, padding 2 ]

        fullAttrs =
            defaultAttrs ++ attrs
    in
    row fullAttrs elems
