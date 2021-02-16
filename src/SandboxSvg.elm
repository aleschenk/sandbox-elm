module SandboxSvg exposing (..)

import Browser
import Dict exposing (Dict)
import Html exposing (Html, div, text)
import Json.Decode
import Svg exposing (Svg)
import Svg.Attributes
import Svg.Events


type alias Id =
    String


type alias Object =
    Svg Msg


type alias Position =
    { x : Int
    , y : Int
    }


type alias ObjectCollection =
    Dict Id Object


type alias Model =
    { position : Position
    , mouseStatus : String
    , isSelectedObject : Bool
    , selectedObject : Maybe Object
    , objects : ObjectCollection
    }



--getObjectId : Svg Msg -> Id
--getObjectId object =
--    object.


init : Model
init =
    { position = Position 0 0
    , mouseStatus = ""
    , isSelectedObject = False
    , selectedObject = Nothing
    , objects = initialObject
    }


type Msg
    = MouseUp
    | MouseDown Position
    | MouseMove Position


newCircle : Position -> Svg Msg
newCircle position =
    Svg.rect
        [ Svg.Attributes.x <| String.fromInt position.x
        , Svg.Attributes.y <| String.fromInt position.y
        , Svg.Attributes.width "60"
        , Svg.Attributes.height "60"
        , Svg.Attributes.rx "15"
        , Svg.Attributes.ry "15"
        , onMouseDown MouseDown
        ]
        []


newId : Dict Id Object -> Id
newId dict =
    String.fromInt <| Dict.size dict


addObject : Model -> Object -> Model
addObject model object =
    { model | objects = Dict.insert (newId model.objects) object model.objects }



--listToDict : (a -> comparable) -> [a] -> Dict.Dict comparable a
--listToDict getKey values = Dict.fromList (Dict.map (\v -> (getKey v, v)) values)


initialListOfObjects : List Object -> ObjectCollection
initialListOfObjects listOfObjects =
    Dict.fromList (toAssociationList listOfObjects)


toAssociationList : List Object -> List ( Id, Object )
toAssociationList objects =
    List.map (\o -> ( o.id, o )) objects


fToTuple : Object -> { b | id : c } -> ( c, { b | id : c } )
fToTuple object =
    \o -> ( o.id, o )


toTuple object =
    ( object.id, object )


initialObject : List Object
initialObject =
    [ newCircle (Position 1 2)
    , newCircle (Position 10 20)
    ]


coordinateDecoder : Json.Decode.Decoder Position
coordinateDecoder =
    Json.Decode.map2 Position
        (Json.Decode.field "clientX" Json.Decode.int)
        (Json.Decode.field "clientY" Json.Decode.int)


onMouseDown : (Position -> Msg) -> Svg.Attribute Msg
onMouseDown tagger =
    Svg.Events.on "mousedown" <|
        Json.Decode.map tagger coordinateDecoder


onMouseUp : Msg -> Svg.Attribute Msg
onMouseUp =
    Svg.Events.onMouseUp


update : Msg -> Model -> Model
update msg model =
    case msg of
        MouseUp ->
            { model | mouseStatus = "Up", isSelectedObject = False }

        MouseMove newPosition ->
            if model.isSelectedObject == True then
                { model | position = newPosition }

            else
                model

        MouseDown position ->
            { model | mouseStatus = "Down", isSelectedObject = True }


viewPosition model =
    Html.text <|
        String.join ", "
            [ String.fromInt model.position.x
            , String.fromInt model.position.y
            ]


view : Model -> Html Msg
view model =
    div []
        [ div []
            [ viewPosition model
            , text model.mouseStatus
            ]
        , Svg.svg
            [ Svg.Attributes.width "640"
            , Svg.Attributes.height "480"
            , Svg.Attributes.viewBox "0 0 640 480"
            , Svg.Events.onMouseUp MouseUp
            , Svg.Events.on "mousemove" <|
                Json.Decode.map MouseMove coordinateDecoder
            ]
          <|
            renderObjects model
        ]


renderObjects : Model -> List (Svg Msg)
renderObjects model =
    Dict.values model.objects



--    [ Svg.rect
--        [ Svg.Attributes.x <| String.fromInt model.position.x
--        , Svg.Attributes.y <| String.fromInt model.position.y
--        , Svg.Attributes.width "60"
--        , Svg.Attributes.height "60"
--        , Svg.Attributes.rx "15"
--        , Svg.Attributes.ry "15"
--        , onMouseDown MouseDown
--        ]
--        []
--    ]


poly : Svg msg
poly =
    Svg.polyline
        [ Svg.Attributes.fill "none"
        , Svg.Attributes.stroke "black"
        , Svg.Attributes.points "20,100 40,60 70,80 100,20"
        ]
        []


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }
