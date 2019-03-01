module ACCUSchedule.Types exposing (Presenter, PresenterId, Proposal, ProposalId)

import ACCUSchedule.Types.Days exposing (Day)
import ACCUSchedule.Types.QuickieSlots exposing (QuickieSlot)
import ACCUSchedule.Types.Rooms exposing (Room)
import ACCUSchedule.Types.Sessions exposing (Session)


type alias PresenterId =
    Int


type alias ProposalId =
    Int


type alias Presenter =
    { id : PresenterId
    , name : String
    , bio : String
    , country : String
    }


type alias Proposal =
    { id : ProposalId
    , title : String
    , summary : String
    , presenters : List PresenterId
    , day : Day
    , session : Session
    , quickieSlot : Maybe QuickieSlot
    , room : Room
    }
