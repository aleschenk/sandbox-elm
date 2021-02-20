module Sandbox3dUnits exposing (..)

import Html exposing (Html, div, text)
import Html.Attributes exposing (style)
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


main : Html msg
main =
    let
      xyz : { x : Float, y : Float, z : Float }
      xyz = Point3d.toMeters dd

      x = String.fromFloat <| .x xyz
      y = String.fromFloat <| .y xyz
      z = String.fromFloat <| .z xyz
     in
            div
                [ style "background-color" "white"
                , style "font" "20px monospace"
                ]
                [ text <| "X: " ++ x
                , Html.br [] []
                , text <| "Y: " ++ y
                , Html.br [] []
                , text <| "Z: " ++ z
                ]
