-- Create an HTML element managed by Elm. The resulting elements are easy to embed in a larger JavaScript projects,
-- and lots of companies that use Elm started with this approach! Try it out on something small. If it works, great, do more! If not, revert, no big deal.
-- Create a “sandboxed” program that cannot communicate with the outside world


module BrowserElement exposing (main)

import Browser
import Html exposing (Html, button, div, input, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)


main : Program () Model Msg
main =
    Browser.element
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
