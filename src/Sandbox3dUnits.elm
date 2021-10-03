module Sandbox3dUnits exposing (..)

import Browser
import Html exposing (Html, div, input, text)
import Html.Attributes exposing (style, type_, value)
import Html.Events exposing (onInput)
import Length exposing (Meters)
import Point3d
import Vector3d


dd : Point3d.Point3d Meters coordinates
dd =
    let
        origin =
            Point3d.origin

        displacement =
            Vector3d.meters 1 2 3
    in
    Point3d.translateBy displacement origin


type alias Model =
    { sliderX : Int
    , sliderY : Int
    , sliderZ : Int
    }


type Msg
    = UpdateSliderX String
    | UpdateSliderY String
    | UpdateSliderZ String


init : Model
init =
    Model 0 0 0


toInt number defaultValue =
    case String.toInt number of
        Just value ->
            value

        Nothing ->
            defaultValue


update : Msg -> Model -> Model
update message model =
    case message of
        UpdateSliderX x ->
            Model (toInt x model.sliderX) model.sliderY model.sliderZ

        UpdateSliderY y ->
            Model model.sliderX (toInt y model.sliderY) model.sliderZ

        UpdateSliderZ z ->
            Model model.sliderX model.sliderY (toInt z model.sliderZ)



--update : Msg -> Model -> Model
--update (UpdateSliderX v) model =
--    case String.toInt v of
--        Just x -> Model x y z
--        Nothing -> model


view : Model -> Html Msg
view model =
    div
        [ style "background-color" "white"
        , style "font" "20px monospace"
        ]
        [ text <| "X "
        , input [ type_ "range", Html.Attributes.min "0", Html.Attributes.max "20", value <| String.fromInt model.sliderX, onInput UpdateSliderX ] []
        , text <| "" ++ String.fromInt model.sliderX
        , Html.br [] []
        , text <| "Y "
        , input [ type_ "range", Html.Attributes.min "0", Html.Attributes.max "20", value <| String.fromInt model.sliderY, onInput UpdateSliderY ] []
        , text <| "" ++ String.fromInt model.sliderY
        , Html.br [] []
        , text <| "Z "
        , input [ type_ "range", Html.Attributes.min "0", Html.Attributes.max "20", value <| String.fromInt model.sliderZ, onInput UpdateSliderZ ] []
        , text <| String.fromInt model.sliderZ
        ]


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }



--let
--    xyz : { x : Float, y : Float, z : Float }
--    xyz =
--        Point3d.toMeters dd
--
--    x =
--        String.fromFloat <| .x xyz
--
--    y =
--        String.fromFloat <| .y xyz
--
--    z =
--        String.fromFloat <| .z xyz
--in
