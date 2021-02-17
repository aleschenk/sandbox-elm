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
    = SearchSupplier
    | SetQuery String
    | LinkClicked UrlRequest
    | UrlChanged Url


type alias Model =
    { url : Url
    , key : Key
    , query : String
    , result: String
    }

init : () -> Url -> Key -> ( Model, Cmd Msg )
init flags url key =
    ( Model url key "" "", Cmd.none )

message : msg -> Cmd msg
message x =
  Task.perform identity (Task.succeed x)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetQuery newQuery ->
            let
                command = if String.length newQuery > 3 then message SearchSupplier else Cmd.none
            in
              ( { model | query = newQuery }, command )

        SearchSupplier ->
            ( { model | result = model.query }, Cmd.none )

        _ ->
            ( model, Cmd.none )

viewResult : Model -> Html Msg
viewResult model =
  div [ ] [ text model.result ]

view : Model -> Browser.Document Msg
view model =
    { title = "Quote"
    , body =
        [ div []
            [ input [ placeholder "Supplier", onInput SetQuery, value model.query ] []
            , button [ id "sendButton", onClick SearchSupplier ] [ text "Send" ]
            , viewResult model
            ]
        ]
    }
