module Sandbox3dScene exposing (..)

{-| Just about the simplest elm-3d-scene program! This example introduces
several fundamental concepts used in elm-3d-scene:

  - Creating an entity to draw
  - Defining a camera
  - Rendering a scene to create an HTML element

-}

import Angle exposing (Angle)
import Array
import Browser
import Browser.Events as E
import Camera3d exposing (Camera3d)
import Color
import Direction3d
import Duration exposing (Duration)
import Html exposing (Html, div, input, text)
import Html.Attributes exposing (style, type_, value)
import Html.Events exposing (onInput)
import Json.Decode as D
import Length exposing (Length, Meters)
import Parameter1d
import Pixels exposing (Pixels)
import Point3d exposing (Point3d)
import Quantity exposing (Quantity)
import Scene3d exposing (Background, Entity, transparentBackground)
import Scene3d.Material as Material
import Scene3d.Mesh as Mesh exposing (Mesh, Plain, points)
import TriangularMesh
import Vector3d
import Viewpoint3d exposing (Viewpoint3d)



-- from elm-units, see 'Installation'


{-| Declare a coordinate system type (many apps will only need a single
"world coordinates" type, but you can call it whatever you want)
-}
type WorldCoordinates
    = WorldCoordinates



--mesh : Plain coordinates
--mesh = Scene3d.Mesh.points { radius = Quantity 1 } [Point3d.meters 1 2 3]


points : List (Point3d.Point3d Meters coordinates)
points =
    Parameter1d.steps 5 <|
        Point3d.interpolateFrom (Point3d.meters 1 0 -1) (Point3d.meters -1 0 1)


pointEntities : List (Entity coordinates)
pointEntities =
    points
        |> List.map
            (\point ->
                Scene3d.point { radius = Pixels.float 5 } (Material.color Color.blue) point
            )


pyramidEntity =
    Scene3d.mesh (Material.matte Color.blue) pyramidMesh


pointEntities2 : List (Entity coordinates)
pointEntities2 =
    [ Scene3d.point { radius = Pixels.float 4 } (Material.color Color.black) (Point3d.meters 0 0 0)
    , Scene3d.point { radius = Pixels.float 4 } (Material.color Color.red) (Point3d.meters 0 0 1)
    , Scene3d.point { radius = Pixels.float 4 } (Material.color Color.yellow) (Point3d.meters 0 1 0)
    , Scene3d.point { radius = Pixels.float 4 } (Material.color Color.blue) (Point3d.meters 0 1 1)
    , Scene3d.point { radius = Pixels.float 4 } (Material.color Color.purple) (Point3d.meters 1 0 0)
    , Scene3d.point { radius = Pixels.float 4 } (Material.color Color.brown) (Point3d.meters 1 0 1)
    , Scene3d.point { radius = Pixels.float 4 } (Material.color Color.darkGray) (Point3d.meters 1 1 1)
    , Scene3d.point { radius = Pixels.float 4 } (Material.color Color.darkBlue) (Point3d.meters -1 -1 -1)
    ]


pyramidMesh : Mesh.Uniform WorldCoordinates
pyramidMesh =
    let
        -- Define the vertices of our pyramid
        frontLeft =
            Point3d.centimeters 10 10 0

        frontRight =
            Point3d.centimeters 10 -10 0

        backLeft =
            Point3d.centimeters -10 10 0

        backRight =
            Point3d.centimeters -10 -10 0

        tip =
            Point3d.centimeters 0 0 4

        -- Create a TriangularMesh value from an array of vertices and list
        -- of index triples defining faces (see https://package.elm-lang.org/packages/ianmackenzie/elm-triangular-mesh/latest/TriangularMesh#indexed)
        triangularMesh =
            TriangularMesh.indexed
                (Array.fromList
                    [ frontLeft -- 0
                    , frontRight -- 1
                    , backLeft -- 2
                    , backRight -- 3
                    , tip -- 4
                    ]
                )
                [ ( 1, 0, 4 ) -- front
                , ( 0, 2, 4 ) -- left
                , ( 2, 3, 4 ) -- back
                , ( 3, 1, 4 ) -- right
                , ( 1, 3, 0 ) -- bottom
                , ( 0, 3, 2 ) -- bottom
                ]
    in
    -- Create a elm-3d-scene Mesh value from the TriangularMesh; we use
    -- Mesh.indexedFacets so that normal vectors will be generated for each face
    Mesh.indexedFacets triangularMesh


type Msg
    = KeyChanged Bool String
    | Tick Duration
    | Resized Int Int
    | VisibilityChanged E.Visibility
    | UpdateSliderX String
    | UpdateSliderY String
    | UpdateSliderZ String



type alias Keys =
    { up : Bool
    , left : Bool
    , down : Bool
    , right : Bool
    , space : Bool
    }


updateKeys : Bool -> String -> Keys -> Keys
updateKeys isDown key keys =
    case key of
        " " ->
            { keys | space = isDown }

        "ArrowUp" ->
            { keys | up = isDown }

        "ArrowLeft" ->
            { keys | left = isDown }

        "ArrowDown" ->
            { keys | down = isDown }

        "ArrowRight" ->
            { keys | right = isDown }

        _ ->
            keys


setCamera : CameraPosition -> World -> World
setCamera newCameraPosition world =
    { world | cameraPosition = newCameraPosition }


--ff : CameraPosition -> CameraPosition
--ff cp =
    --Point3d.translateBy (Vector3d.fromMeters { x = 1, y = 2, z = 3 }) cp
    --Point3d.translateBy (Direction3d.from { x = 1, y = 2, z = 3 }) cp


updateWorld : Model -> World
updateWorld model =
    let
        xyz = Point3d.toMeters model.world.cameraPosition
        x = .x xyz + 1
        y = .y xyz + 1
        z = .y xyz + 1

        zoomOut =
            Point3d.translateBy (Vector3d.fromMeters { x = 0.1, y = 0, z = 0 }) model.world.cameraPosition

        zoomIn =
            Point3d.translateBy (Vector3d.fromMeters { x = -0.1, y = 0, z = 0 }) model.world.cameraPosition

        btPressed = (model.keys.up, model.keys.down)
    in
    case btPressed of
        (True, False) ->
            setCamera zoomOut model.world

        (False, True) ->
            setCamera zoomIn model.world
        _ ->
            model.world

toInt number defaultValue =
    case String.toInt number of
        Just value ->
            value

        Nothing ->
            defaultValue

update : Msg -> Model -> Model
update msg model =
    case msg of
        KeyChanged isDown key ->
            { model | keys = updateKeys isDown key model.keys }

        Tick dt ->
            { model | world = updateWorld model }

        Resized width height ->
            { model
                | width = Pixels.pixels width
                , height = Pixels.pixels height
            }

        VisibilityChanged _ ->
            { model | keys = noKeys }

        UpdateSliderX x ->
            let
              xyz = Point3d.toMeters model.world.cameraPosition
              newCameraXPosition = .x xyz + 1
            in
              { model | sliderX = (toInt x model.sliderX) }

        UpdateSliderY y ->
            { model | sliderY = (toInt y model.sliderY) }

        UpdateSliderZ z ->
            { model | sliderZ = (toInt z model.sliderZ) }



-- SUBSCRIPTIONS
-- Subscribe to animation frames and wrap each time step (a number of
-- milliseconds) into a Duration value and then into a Tick message


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ E.onResize (\width height -> Resized width height)
        , E.onKeyUp (D.map (KeyChanged False) (D.field "key" D.string))
        , E.onKeyDown (D.map (KeyChanged True) (D.field "key" D.string))
        , E.onAnimationFrameDelta (Duration.milliseconds >> Tick)
        , E.onVisibilityChange VisibilityChanged
        ]


noKeys : Keys
noKeys =
    Keys False False False False False


type alias CameraPosition =
    Point3d Meters WorldCoordinates


type alias World =
    { cameraPosition : CameraPosition
    }


type alias Model =
    { keys : Keys
    , world : World
    , width : Quantity Int Pixels
    , height : Quantity Int Pixels
    , sliderX : Int
    , sliderY : Int
    , sliderZ : Int
    }


camera : CameraPosition -> Camera3d Meters WorldCoordinates
camera cp =
    Camera3d.perspective
        { viewpoint =
            Viewpoint3d.lookAt
                { focalPoint = Point3d.origin
                , eyePoint = cp
                , upDirection = Direction3d.positiveZ
                }
        , verticalFieldOfView = Angle.degrees 20
        }

cameraInitXValue = 40
cameraInitYValue = 20
cameraInitZValue = 30

initWorld : World
initWorld =
    World (Point3d.centimeters 40 20 30)

init : () -> ( Model, Cmd Msg )
init _ =
    ( { keys = noKeys
      , world = initWorld
      , width = Pixels.pixels 1024
      , height = Pixels.pixels 768
      , sliderX = cameraInitXValue
      , sliderY = cameraInitYValue
      , sliderZ = cameraInitZValue
      }
    , Cmd.none
    )



--, Cmd.batch
--    [ Task.attempt GotTexture (Texture.load "https://elm-lang.org/images/wood-crate.jpg")
--    , Task.perform (\{ viewport } -> Resized viewport.width viewport.height) Dom.getViewport
--    ]
--)
-- VIEW

viewToolBox : Model -> Html Msg
viewToolBox model =
    div
        [ style "background-color" "white"
        , style "font" "20px monospace"
        ]
        [ text <| "X "
        , input [ type_ "range", Html.Attributes.min "0", Html.Attributes.max "100", value <| String.fromInt model.sliderX, onInput UpdateSliderX ] []
        , text <| "" ++ String.fromInt model.sliderX
        , Html.br [] []
        , text <| "Y "
        , input [ type_ "range", Html.Attributes.min "0", Html.Attributes.max "100", value <| String.fromInt model.sliderY, onInput UpdateSliderY ] []
        , text <| "" ++ String.fromInt model.sliderY
        , Html.br [] []
        , text <| "Z "
        , input [ type_ "range", Html.Attributes.min "0", Html.Attributes.max "100", value <| String.fromInt model.sliderZ, onInput UpdateSliderZ ] []
        , text <| String.fromInt model.sliderZ
        ]


view : Model -> Html Msg
view model =
    div [] [
      viewToolBox model
      , Scene3d.unlit
        { dimensions = ( model.width, model.height )
        , camera = camera model.world.cameraPosition
        , clipDepth = Length.centimeters 5
        , background = transparentBackground
        --, background = backgroundColor (Color.rgb 50 50 50)
        , entities = [ pyramidEntity ]
        --, entities = pointEntities2
        }
      ]


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = \msg model -> ( update msg model, Cmd.none )
        , subscriptions = subscriptions
        }



--main : Html msg
--main =
--    Scene3d.unlit
--        { dimensions = ( Pixels.pixels 1024, Pixels.pixels 768 )
--        , camera = camera
--        , clipDepth = Length.centimeters 5
--        , background = transparentBackground
--        , entities = [ pyramidEntity ]
--        }
