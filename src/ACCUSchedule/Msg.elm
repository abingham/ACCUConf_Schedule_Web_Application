module ACCUSchedule.Msg exposing (..)

import ACCUSchedule.Types as Types
import Browser
import Http
import Url


type Msg
    = FetchData
    | ProposalsResult (Result Http.Error (List Types.Proposal))
    | PresentersResult (Result Http.Error (List Types.Presenter))
    | VisitProposal Types.Proposal
    | VisitPresenter Types.Presenter
    | VisitSearch String
    | ToggleBookmark Types.ProposalId
    | RaiseProposal Bool Types.ProposalId
    | RaisePresenter Bool Types.PresenterId
    | Batch (List Msg)
    | LinkClicked Browser.UrlRequest
    | UrlChange Url.Url
