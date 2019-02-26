module ACCUSchedule.View.Card exposing (deck, head, subhead, text, title, view)

import ACCUSchedule.Msg as Msg
import Element exposing (paragraph, Attribute, Element, column, fill, fillPortion, padding, row, spacing, width, px, alignTop)
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
    withDefaultAttrs column [ width fill, padding 10 ]


head : List (Attribute Msg.Msg) -> List (Element Msg.Msg) -> Element Msg.Msg
head =
    withDefaultAttrs row [ width fill, Element.Font.bold ]


subhead : List (Attribute Msg.Msg) -> List (Element Msg.Msg) -> Element Msg.Msg
subhead =
    withDefaultAttrs row [ width fill, Element.Font.light ]


text : List (Attribute Msg.Msg) -> List (Element Msg.Msg) -> Element Msg.Msg
text =
    withDefaultAttrs paragraph [ width fill, padding 10 ]


intoChunks : Int -> List a -> List (List a)
intoChunks size xs =
    if List.length xs <= size then
        [ xs ]

    else
        [ List.take size xs ] ++ intoChunks size (List.drop size xs)


deck : {width: Int, height: Int} -> List (Element.Attribute Msg.Msg) -> List (Element Msg.Msg) -> Element Msg.Msg
deck windowSize attrs cards =
    let
        device =
            Element.classifyDevice windowSize

        numCols =
            case device.class of
                Element.Phone ->
                    1

                Element.Tablet ->
                    1

                Element.Desktop ->
                    3

                Element.BigDesktop ->
                    3

        chunkSize =
            (List.length cards // numCols) + 1

        chunks =
            intoChunks chunkSize cards

        -- TODO: this hardcoded 300 is a mess. Can we instead calculate something?
        columns = List.map (column [alignTop, spacing 10, width (px 300)]) chunks
    in
    row attrs columns
