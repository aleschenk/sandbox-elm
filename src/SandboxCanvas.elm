module SandboxCanvas exposing (..)

import Browser
import Browser.Events exposing (onAnimationFrameDelta)
import Canvas exposing (Point, lineTo, path, rect, shapes)
import Canvas.Settings exposing (fill)
import Color
import Html exposing (Html, div, input)
import Html.Attributes exposing (class, style, type_, value)
import Html.Events exposing (onInput)


type alias Model =
    { count : Float }


type Msg
    = Frame Float



--| OnSliderChange String


main : Program () Model Msg
main =
    Browser.element
        { init = \() -> ( { count = 0 }, Cmd.none )
        , view = view
        , update =
            \msg model ->
                case msg of
                    Frame _ ->
                        ( { model | count = model.count + 0.5 }, Cmd.none )

        --OnSliderChange value ->
        --    ( { model | model.sliderValue String.toInt v |> Maybe.withDefault 0 }, Cmd.none )
        , subscriptions = \model -> onAnimationFrameDelta Frame
        }


width =
    400


height =
    400



--slider : Int -> Html Msg
--slider sliderValue =
--  input [ type_ "range", class "slider", Html.Attributes.min "1", Html.Attributes.max "10", value <| String.fromInt sliderValue, onInput OnSliderChange] []


view : Model -> Html Msg
view { count } =
    div
        [ style "display" "flex"
        , style "justify-content" "center"
        , style "align-items" "center"
        ]
        [ Canvas.toHtml
            ( width, height )
            [ style "border" "1px solid rgba(0,0,0,0.1)" ]
            [ shapes [ fill Color.white ] [ rect ( 0, 0 ) width height ]
            , renderALine
            ]
        ]


aRect =
    shapes []
        [ rect ( 10, 10 ) 100 10
        ]


renderALine =
    shapes []
        [ path ( 10, 10 ) [ lineTo ( 50, 50 ) ]
        ]


renderSquare =
    shapes [ fill (Color.rgba 0 0 0 1) ]
        [ rect ( 0, 0 ) 100 50 ]
