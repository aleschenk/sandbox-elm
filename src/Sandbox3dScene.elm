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
import Html exposing (Html, div, text)
import Html.Attributes exposing (style, value)
import Json.Decode as Decode exposing (Decoder)
import Length exposing (Length, Meters)
import LineSegment3d
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

type alias CameraPosition =
    Point3d Meters WorldCoordinates

type alias FocalPoint =
    Point3d Meters WorldCoordinates


type Msg
    = KeyChanged Bool String
    | Tick Duration
    | Resized Int Int
    | VisibilityChanged E.Visibility
    | MouseDown
    | MouseUp
    | MouseMove (Quantity Float Pixels) (Quantity Float Pixels)

type alias Keys =
    { up : Bool
    , left : Bool
    , down : Bool
    , right : Bool
    , space : Bool
    , a : Bool
    , d : Bool
    , w : Bool
    , s : Bool
    }

type alias World =
    { cameraPosition : CameraPosition
    , cameraFocalPoint: FocalPoint
    }

type alias Model =
    { keys : Keys
    , world : World
    , width : Quantity Int Pixels
    , height : Quantity Int Pixels
    , mouseX : Quantity Float Pixels
    , mouseY : Quantity Float Pixels
    }

cameraInitXValue = 1
cameraInitYValue = -5
cameraInitZValue = 1

initWorld : World
initWorld =
    World (Point3d.meters cameraInitXValue cameraInitYValue cameraInitZValue) Point3d.origin


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

basePlane : Entity coordinates
basePlane =
  let
    p1 = Point3d.meters -1 -1 0
    p2 = Point3d.meters -1 1 0
    p3 = Point3d.meters 1 1 0
    p4 = Point3d.meters 1 -1 0
  in
    Scene3d.quad (Material.color Color.lightOrange) p1 p2 p3 p4

tile : Float -> Float -> Entity coorindates
tile x y =
  let
    width = 1
    hight = 1
    p1 = Point3d.meters -1 -1 0
    p2 = Point3d.meters -1 1 0
    p3 = Point3d.meters 1 1 0
    p4 = Point3d.meters 1 -1 0
  in
    Scene3d.quad (Material.color Color.lightOrange) p1 p2 p3 p4

gizmo : List (Entity coordinates)
gizmo =
  let
    materialX = Material.color Color.red
    materialY = Material.color Color.green
    materialZ = Material.color Color.blue
    startPoint = Point3d.meters 0 0 0
  in
    [ Scene3d.lineSegment materialX (LineSegment3d.from startPoint (Point3d.meters 1 0 0))
    , Scene3d.lineSegment materialY (LineSegment3d.from startPoint (Point3d.meters 0 1 0))
    , Scene3d.lineSegment materialZ (LineSegment3d.from startPoint (Point3d.meters 0 0 1))
    ]


camera : CameraPosition -> FocalPoint -> Camera3d Meters WorldCoordinates
camera cp fp =
    Camera3d.perspective
        { viewpoint =
            Viewpoint3d.lookAt
                { focalPoint = fp
                , eyePoint = cp
                , upDirection = Direction3d.positiveZ
                }
        , verticalFieldOfView = Angle.degrees 20
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

        "a" ->
            { keys | a = isDown }

        "d" ->
            { keys | d = isDown }

        "w" ->
            { keys | w = isDown }

        "s" ->
            { keys | s = isDown }

        _ ->
            keys


setCamera : CameraPosition -> FocalPoint -> World -> World
setCamera newCameraPosition fp world =
    { world | cameraPosition = newCameraPosition, cameraFocalPoint = fp }


--ff : CameraPosition -> CameraPosition
--ff cp =
    --Point3d.translateBy (Vector3d.fromMeters { x = 1, y = 2, z = 3 }) cp
    --Point3d.translateBy (Direction3d.from { x = 1, y = 2, z = 3 }) cp

incX : CameraPosition -> CameraPosition
incX cameraPosition =
  Point3d.translateBy (Vector3d.meters 0.1 0 0) cameraPosition

decX : CameraPosition -> CameraPosition
decX cameraPosition =
  Point3d.translateBy (Vector3d.meters -0.1 0 0) cameraPosition

incY : CameraPosition -> CameraPosition
incY cameraPosition =
  Point3d.translateBy (Vector3d.meters 0 0.1 0) cameraPosition

decY : CameraPosition -> CameraPosition
decY cameraPosition =
  Point3d.translateBy (Vector3d.meters 0 -0.1 0) cameraPosition

incZ : CameraPosition -> CameraPosition
incZ cameraPosition =
  Point3d.translateBy (Vector3d.meters 0 0 0.1) cameraPosition

decZ : CameraPosition -> CameraPosition
decZ cameraPosition =
  Point3d.translateBy (Vector3d.meters 0 0 -0.1) cameraPosition

updateWorld : Model -> World
updateWorld model =
    let
        btPressed = [model.keys.up, model.keys.down, model.keys.left, model.keys.right, model.keys.a, model.keys.d, model.keys.w, model.keys.s]
    in
    case btPressed of
        -- up
        [True, False, False, False, False, False, False, False] ->
            setCamera (incY model.world.cameraPosition) model.world.cameraFocalPoint model.world
        -- down
        [False, True, False, False, False, False, False, False] ->
            setCamera (decY model.world.cameraPosition) model.world.cameraFocalPoint model.world
        -- left
        [False, False, True, False, False, False, False, False] ->
            setCamera (decX model.world.cameraPosition) model.world.cameraFocalPoint model.world
        --  right
        [False, False, False, True, False, False, False, False] ->
            setCamera (incX model.world.cameraPosition) model.world.cameraFocalPoint model.world
        --  a
        [False, False, False, False, True, False, False, False] ->
            setCamera model.world.cameraPosition (decX model.world.cameraFocalPoint) model.world
        --  d
        [False, False, False, False, False, True, False, False] ->
            setCamera model.world.cameraPosition (incX model.world.cameraFocalPoint) model.world

        --  w
        [False, False, False, False, False, False, True, False] ->
            setCamera model.world.cameraPosition (incY model.world.cameraFocalPoint) model.world

        --  s
        [False, False, False, False, False, False, False, True] ->
            setCamera model.world.cameraPosition (decY model.world.cameraFocalPoint) model.world

        _ ->
            model.world

toInt number defaultValue =
    case String.toInt number of
        Just value ->
            value

        Nothing ->
            defaultValue

noKeys : Keys
noKeys =
    Keys False False False False False False False False False

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

        MouseMove dx dy ->
          { model | mouseX = dx, mouseY = dy }

        VisibilityChanged _ ->
            { model | keys = noKeys }

        _ ->
          model


{-| Use movementX and movementY for simplicity (don't need to store initial
mouse position in the model) - not supported in Internet Explorer though
-}
decodeMouseMove : Decoder Msg
decodeMouseMove =
    Decode.map2 MouseMove
        (Decode.field "movementX" (Decode.map Pixels.float Decode.float))
        (Decode.field "movementY" (Decode.map Pixels.float Decode.float))

-- SUBSCRIPTIONS
-- Subscribe to animation frames and wrap each time step (a number of
-- milliseconds) into a Duration value and then into a Tick message


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ E.onResize (\width height -> Resized width height)
        , E.onKeyUp (Decode.map (KeyChanged False) (Decode.field "key" Decode.string))
        , E.onKeyDown (Decode.map (KeyChanged True) (Decode.field "key" Decode.string))
        , E.onAnimationFrameDelta (Duration.milliseconds >> Tick)
        , E.onVisibilityChange VisibilityChanged
        , E.onMouseMove decodeMouseMove
        ]

init : () -> ( Model, Cmd Msg )
init _ =
    ( { keys = noKeys
      , world = initWorld
      , width = Pixels.pixels 1024
      , height = Pixels.pixels 768
      , mouseX = Pixels.float 0
      , mouseY = Pixels.float 0
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
        [ text <| "Mouse X: " ++ String.fromFloat (Pixels.toFloat model.mouseX)
        , Html.br [] []
        , text <| "Mouse Y: " ++ String.fromFloat (Pixels.toFloat model.mouseY)
        , Html.br [] []
        , text <| "Eye X: " ++ String.fromFloat (.x (Point3d.toMeters model.world.cameraPosition))
        , Html.br [] []
        , text <| "Eye Y: " ++ String.fromFloat (.y (Point3d.toMeters model.world.cameraPosition))
        , Html.br [] []
        , text <| "Eye Z: " ++ String.fromFloat (.z (Point3d.toMeters model.world.cameraPosition))
        , Html.br [] []
        , text <| "Fp X: " ++ String.fromFloat (.x (Point3d.toMeters model.world.cameraFocalPoint))
        , Html.br [] []
        , text <| "Fp Y: " ++ String.fromFloat (.y (Point3d.toMeters model.world.cameraFocalPoint))
        , Html.br [] []
        , text <| "Fp Z: " ++ String.fromFloat (.z (Point3d.toMeters model.world.cameraFocalPoint))
        ]

view : Model -> Html Msg
view model =
    div [] [
      viewToolBox model
      , Scene3d.unlit
        { dimensions = ( model.width, model.height )
        , camera = camera model.world.cameraPosition model.world.cameraFocalPoint
        , clipDepth = Length.centimeters 5
        , background = transparentBackground
        --, background = backgroundColor (Color.rgb 50 50 50)
        , entities = [ basePlane ] ++ gizmo
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
