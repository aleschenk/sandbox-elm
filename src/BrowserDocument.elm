-- Create an HTML document managed by Elm. This expands upon what element can do in that view now gives you control over the <title> and <body>.


module BrowserDocument exposing (main)

import Browser
import Html exposing (Html, button, div, input, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)


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


type alias Model =
    { num : Int }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model 1
    , Cmd.none
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


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
