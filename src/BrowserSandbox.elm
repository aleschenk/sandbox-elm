-- Create a “sandboxed” program that cannot communicate with the outside world


module BrowserSandbox exposing (main)

import Browser
import Html exposing (Html, button, div, input, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }


type Msg
    = Increment


type alias Model =
    Int


init : Model
init =
    0


update : Msg -> Model -> Model
update msg model =
    model


view : Model -> Html Msg
view model =
    div []
        [ input [ placeholder "Car Id", value "" ] []
        , input [ placeholder "Car Year" ] []
        , input [ placeholder "Postal Code" ] []
        , input [ placeholder "State Code" ] []
        , input [ placeholder "Person Age" ] []
        , input [ placeholder "Is 0km " ] []
        , input [ placeholder "Has GNC " ] []
        , button [ id "sendButton" ] [ text "Send" ]
        ]
