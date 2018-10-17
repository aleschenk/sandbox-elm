module BrowserApplication exposing (main)

import Browser exposing (UrlRequest)
import Browser.Navigation as Nav exposing (Key)
import Html exposing (Html, button, div, input, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Url exposing (Url)
import Url.Parser exposing (Parser, (</>), int, map, oneOf, s, string)


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }


type Msg
    = Increment
    | LinkClicked UrlRequest
    | UrlChanged Url


type alias Model =
    { url : Url
    , key : Key
    }


init : () -> Url -> Key -> ( Model, Cmd Msg )
init flags url key =
    ( Model url key, Cmd.none )


onUrlChange : Url -> Msg
onUrlChange url =
    UrlChanged url


onUrlRequest : UrlRequest -> Msg
onUrlRequest urlRequest =
    LinkClicked urlRequest


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment ->
            ( model, Cmd.none )

        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            ( { model | url = url }
            , Cmd.none
            )


view : Model -> Browser.Document Msg
view model =
    { title = "Hello World"
    , body =
        [ div []
            [ input [ placeholder "Car Id", value "" ] []
            , input [ placeholder "Car Year" ] []
            , input [ placeholder "Postal Code" ] []
            , input [ placeholder "State Code" ] []
            , input [ placeholder "Person Age" ] []
            , input [ placeholder "Is 0km " ] []
            , input [ placeholder "Has GNC " ] []
            , button [ id "sendButton" ] [ text "Send" ]
            ]
        ]
    }
