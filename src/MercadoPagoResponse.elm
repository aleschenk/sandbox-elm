module BrowserDocument exposing (main)

import Browser
import Html exposing (Html, button, div, input, text, textarea)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import MercadoPagoJson exposing (..)
import Json.Decode as Dec exposing (Decoder, list, string)
import Json.Encode as Enc exposing (int, object)


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }

type Msg
    = Increment
    | SetJson String
    | ConvertJson
    | JsonCoverted (Maybe (Result Dec.Error Response))

type alias Model =
    { jsonToConvert : String
    , formatedJson : String
    , response : Maybe (Result Dec.Error Response)
    , errorMessage : String
    }

init : () -> ( Model, Cmd Msg )
init _ =
    ( Model "" "" Nothing ""
    , Cmd.none
    )

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

toJsonFormat : String -> String
toJsonFormat json =
    "[" ++ String.join "," (String.lines json) ++ "]"

decode : String -> Result Dec.Error Response
decode json =
  Dec.decodeString responseDecoder json

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of 

      SetJson json ->
        ( { model | jsonToConvert = json }, Cmd.none )

      ConvertJson ->
        let
          responseResult = decode (toJsonFormat model.jsonToConvert)
        in
          ( { model | response = Just responseResult }, Cmd.none )

      -- JsonCoverted (Ok response) ->
      --   ( { model | response = response }, Cmd.none )

      -- JsonCoverted (Err error) ->
      --   ( { model | errorMessage = "Error Parsin json" }, Cmd.none )

      _ ->
        ( model, Cmd.none )

showResponse: Maybe (Result Dec.Error Response) -> Html msg
showResponse maybeResult =
  case maybeResult of

    Just (Ok response) ->
      div [ ] [ ]

    Just (Err decError) ->
      div [ ] [ text (Dec.errorToString decError) ]

    Nothing  ->
      div [ ] [ ]

view : Model -> Browser.Document Msg
view model =
    { title = "Hello World"
    , body =
        [ div []
            [ textarea [ placeholder "JSON", onInput SetJson, value model.jsonToConvert ] [ ]
            , button [ id "convertButton", onClick ConvertJson ] [ text "Convertir" ]
            , textarea [ value model.formatedJson ] [ ]
            , showResponse model.response
            ]
        ]
    }
