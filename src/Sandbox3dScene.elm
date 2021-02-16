module Sandbox3dScene exposing (..)

{-| Just about the simplest elm-3d-scene program! This example introduces
several fundamental concepts used in elm-3d-scene:

  - Creating an entity to draw
  - Defining a camera
  - Rendering a scene to create an HTML element

-}

import Angle exposing (Angle)
import Array
import Camera3d exposing (Camera3d)
import Color
import Direction3d
import Html exposing (Html)
import Length exposing (Length, Meters)
import Parameter1d
import Pixels exposing (Pixels)
import Point3d
import Scene3d exposing (Background, Entity, transparentBackground)
import Scene3d.Material as Material
import Scene3d.Mesh as Mesh exposing (Mesh, Plain, points)
import TriangularMesh
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


camera : Camera3d Meters coordinates
camera =
    Camera3d.perspective
        { viewpoint =
            Viewpoint3d.lookAt
                { focalPoint = Point3d.origin
                , eyePoint = Point3d.centimeters 40 20 30
                , upDirection = Direction3d.positiveZ
                }
        , verticalFieldOfView = Angle.degrees 20
        }


type Msg
    = KeyChanged Bool String


type alias Model =
    { keys : Keys
    }


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


update : Msg -> Model -> Model
update msg model =
    case msg of
        KeyChanged isDown key ->
            { model | keys = updateKeys isDown key model.keys }


main : Html msg
main =
    Scene3d.unlit
        { dimensions = ( Pixels.pixels 1024, Pixels.pixels 768 )
        , camera = camera
        , clipDepth = Length.centimeters 5
        , background = transparentBackground
        , entities = [ pyramidEntity ]
        }
