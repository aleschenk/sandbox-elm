module TM exposing (main)

import Browser
import Html exposing (Html, button, div, input, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)


type P box = Empty
            | Left box
            | Right box
            | Flip box
            | Loop

type alias State = List String

type alias Model = String

type Msg = None


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }
