import Browser
import Html exposing (..)
import Html.Events exposing (..)
import Random
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Dict exposing (..)

-- MAIN

image =
  svg
    [ width "120"
    , height "120"
    , viewBox "0 0 120 120"
    ]
    [ rect
        [ x "0"
        , y "0"
        , width "100"
        , height "100"
        , rx "15"
        , ry "15"
        , fill "#fff"
        , stroke "#000"
        ]
        []
    , circle
        [ cx "50"
        , cy "50"
        , r "10"
        ]
        []
    ]

dieList = Dict.fromList
    [ 
        (1, "1")
        , (2, "2")
        , (3, "3")
        , (4, "4")
        , (5, "5")
        , (6, "6")
    ]

mapDieNumber : Int -> Maybe String
mapDieNumber number =
    Dict.get number dieList

main =
  Browser.element
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }



-- MODEL


type alias Model =
  { dieFace : Int
  }


init : () -> (Model, Cmd Msg)
init _ =
  ( Model 1
  , Random.generate NewFace (Random.int 1 6)
  )



-- UPDATE


type Msg
  = Roll
  | NewFace Int

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Roll ->
      ( model
      , Random.generate NewFace (Random.int 1 6)
      )

    NewFace newFace ->
      ( Model newFace
      , Cmd.none
      )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ h1 [] [ Html.text (String.fromInt model.dieFace) ]
    , button [ onClick Roll ] [ Html.text "Roll" ]
    , div [] [ image ]
    ]