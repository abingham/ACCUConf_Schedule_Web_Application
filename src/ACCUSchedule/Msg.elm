module ACCUSchedule.Msg exposing (Msg(..))

import ACCUSchedule.Types as Types
import Browser
import Http
import Json.Encode
import Url


type Msg
    = FetchData
    | ProposalsResult (Result Http.Error (List Types.Proposal))
    | PresentersResult (Result Http.Error (List Types.Presenter))
    | RenderAsciidoc Types.ProposalId String
    | AsciidocConverted Json.Encode.Value
    | ToggleBookmark Types.ProposalId
    | RaiseProposal Bool Types.ProposalId
    | RaisePresenter Bool Types.PresenterId
    | SetSearchTerm String
    | LinkClicked Browser.UrlRequest
    | UrlChange Url.Url
    | WindowResized { width : Int, height : Int }
