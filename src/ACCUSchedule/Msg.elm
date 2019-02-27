module ACCUSchedule.Msg exposing (Msg(..))

import ACCUSchedule.Types as Types
import Browser
import Http
import Url


type Msg
    = FetchData
    | ProposalsResult (Result Http.Error (List Types.Proposal))
    | PresentersResult (Result Http.Error (List Types.Presenter))
    | ToggleBookmark Types.ProposalId
    | RaiseProposal Bool Types.ProposalId
    | RaisePresenter Bool Types.PresenterId
    | LinkClicked Browser.UrlRequest
    | UrlChange Url.Url
    | WindowResized { width : Int, height : Int }
