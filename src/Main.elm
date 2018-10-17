import Browser
import Html exposing (Html, button, div, text, input)
import Html.Events exposing (onClick, onInput)
import Html.Attributes exposing (..)

main =
    Browser.sandbox { init = init, update = update, view = view }

type Msg 
    = Name String
    | Password String
    | PasswordAgain String
    | Increment
    | Decrement

type alias Model =
    { value : Int
    , name : String
    , password : String
    , passwordAgain : String
    }

update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            { model | value = 0 }

        Decrement ->
            { model | value = 1 }

        Name name ->
            { model | name = name }

        Password password ->
            { model | password = password }
        
        PasswordAgain password ->
            { model | passwordAgain = password }

init : Model
init =
    Model 0 "" "" ""

viewInput: String -> String -> String -> (String -> msg) -> Html msg
viewInput t p v toMsg =
    input [ type_ t, placeholder p, value v, onInput toMsg ] []

viewValidation : Model -> Html msg
viewValidation model =
    if model.password == model.passwordAgain then
        div [ style "color" "gree" ] [ text "OK" ]
    else
        div [ style "color" "red" ] [ text "Password do not match! " ]

viewForm : Model -> Html Msg
viewForm model = 
    div []
    [ viewInput "text" "Name" model.name Name
    , viewInput "password" "Password" model.password Password
    , viewInput "password" "Re-enter Password" model.passwordAgain PasswordAgain
    , viewValidation model
    ]

view : Model -> Html Msg
view model =
    viewForm model
    -- div []
    --     [ button [ onClick Decrement ] [ text "-" ]
    --     , div [] [ text (String.fromInt model.value) ]
    --     , button [ onClick Increment ] [ text "+" ]
    --     ]
