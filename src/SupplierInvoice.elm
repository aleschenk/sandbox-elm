module BrowserSandbox exposing (main)

import Browser exposing (UrlRequest)
import Browser.Navigation exposing (Key)
import Html exposing (Html, button, div, input, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Decode as Dec exposing (Decoder, list, string)
import Json.Encode as Enc exposing (int, object)
import Offering exposing (Offering)
import String exposing (fromInt)
import Url exposing (Url)
import Task
import Time

main : Program () Model Msg
main =
    Browser.application
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }

type Msg
    = SearchInputChange String
    | Search
    | Result
    | LinkClicked UrlRequest
    | UrlChanged Url

type alias Model =
    { url : Url
    , key : Key
    , supplierQuery : String
    }

message : msg -> Cmd msg
message x =
  Task.perform identity (Task.succeed x)

init : () -> Url -> Key -> ( Model, Cmd Msg )
init flags url key =
    ( Model url key "", Cmd.none )

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SearchInputChange newInput ->
            if String.length newInput >= 3 then 
                ( { model | supplierQuery = newInput }, message Search )
            else
                ( { model | supplierQuery = newInput }, Cmd.none )

        Search ->
            ( model, message Result )

        Result ->
            ( model, Cmd.none)

        _ ->
            ( model, Cmd.none )

view : Model -> Browser.Document Msg
view model =
    { title = "Quote"
    , body =
        [ div []
            [ input [ placeholder "Search Supplier", onInput SearchInputChange, value "" ] []
            , button [ id "searchButton", onClick Search ] [ text "Send" ]
            ]
        ]
    }
