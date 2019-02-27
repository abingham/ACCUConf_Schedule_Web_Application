module ACCUSchedule.Routing exposing (Route(..), agendaUrl, dayUrl, presenterUrl, presentersUrl, proposalUrl, urlToRoute)

import ACCUSchedule.Types as Types
import ACCUSchedule.Types.Days as Days
import Url
import Url.Parser exposing ((</>), (<?>), Parser, custom, int, map, oneOf, parse, s, top)
import Url.Parser.Query as Query


{-| All of the possible routes that we can display
-}
type Route
    = Day Days.Day
    | Proposal Types.ProposalId
    | Presenter Types.PresenterId
    | Presenters
    | Agenda
    | Search (Maybe String)
    | NotFound


dayUrl : Days.Day -> String
dayUrl day =
    let
        dayNum =
            Days.ordinal day |> String.fromInt
    in
    "/day/" ++ dayNum



-- agendaUrl : String
-- agendaUrl =
--     "#/agenda"


proposalUrl : Types.ProposalId -> String
proposalUrl proposalId =
    "/session/" ++ String.fromInt proposalId


presenterUrl : Types.PresenterId -> String
presenterUrl presenterId =
    "/presenter/" ++ String.fromInt presenterId


presentersUrl : String
presentersUrl =
    "/presenters"


agendaUrl : String
agendaUrl =
    "/agenda"



-- searchUrl : String -> String
-- searchUrl term =
--     "#/search/" ++ (Http.encodeUri term)


{-| Parse the string form of a day ordinal to a result.
-}
parseDay : String -> Maybe Days.Day
parseDay path =
    let
        matchDayOrd dayOrd rslt =
            if (dayOrd |> (Days.ordinal >> String.fromInt)) == path then
                Just dayOrd

            else
                rslt
    in
    List.foldl
        matchDayOrd
        Nothing
        Days.conferenceDays


{-| Location parser for days encoded as integers
-}
dayParser : Parser (Days.Day -> b) b
dayParser =
    custom "DAY" parseDay



--| Location parser for uri-encoded strings.
--}



-- uriEncoded : Parser (String -> b) b
-- uriEncoded =
--     let
--         decode x =
--             case Http.decodeUri x of
--                 Just dx ->
--                     Ok dx
--                 Nothing ->
--                     Err "Invalid URI-encoded string"
--     in
--         custom "URI_ENCODED" decode


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map (Day Days.Day1) top
        , map Day (s "day" </> dayParser)
        , map Proposal (s "session" </> int)
        , map Presenter (s "presenter" </> int)
        , map Presenters (s "presenters")
        , map Agenda (s "agenda")
        , map Search (s "search" <?> Query.string "term")
        ]


urlToRoute : Url.Url -> Route
urlToRoute url =
    Maybe.withDefault NotFound (parse matchers url)
