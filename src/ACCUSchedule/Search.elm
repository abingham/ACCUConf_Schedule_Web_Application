module ACCUSchedule.Search exposing (search)

import ACCUSchedule.Model exposing (Model, apiBaseUrl, proposalPresenters, proposals)
import ACCUSchedule.Types exposing (Proposal)


lcontains : String -> String -> Bool
lcontains term text =
    String.contains (String.toLower term) (String.toLower text)


presentersMatch : String -> Model -> Proposal -> Bool
presentersMatch term model proposal =
    let
        pmatch p =
            lcontains term p.name
    in
    List.any pmatch (proposalPresenters model proposal)


search : String -> Model -> List Proposal
search term model =
    let
        matches p =
            lcontains term p.summary
                || lcontains term p.title
                || presentersMatch term model p
    in
    proposals model
        |> List.filter
            matches
