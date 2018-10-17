module BrowserSandbox exposing (main)

import Browser exposing (UrlRequest)
import Browser.Navigation exposing (Key)
import Html exposing (Html, button, div, input, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Decode as Dec exposing (Decoder, list, string)
import Json.Encode as Enc exposing (int, object)
import Offering exposing (Offering)
import String exposing (fromInt)
import Url exposing (Url)


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }


type Msg
    = PostQuote
    | NewQuote (Result Http.Error Offering)
    | SetCarId String
    | SetCarYear String
    | SetPostalCode String
    | SetStateCode String
    | SetPersonAge String
    | SetIsOkm
    | SetHasGnc
    | SendQuote
    | LinkClicked UrlRequest
    | UrlChanged Url


type alias Model =
    { url : Url
    , key : Key
    , quoteForm : QuoteForm
    , offering : Maybe Offering
    }


type alias QuoteForm =
    { carId : String
    , carYear : String
    , postalCode : String
    , stateCode : String
    , personAge : Int
    , is0Km : Bool
    , hasGnc : Bool
    }


init : () -> Url -> Key -> ( Model, Cmd Msg )
init flags url key =
    ( Model url key (QuoteForm "320398" "2008" "1623" "ar-c" 33 False False) Nothing, Cmd.none )


setCarId : String -> QuoteForm -> QuoteForm
setCarId newCarId quoteForm =
    { quoteForm | carId = newCarId }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetCarId carId ->
            let
                quoteForm =
                    model.quoteForm

                newQuoteForm =
                    { quoteForm | carId = carId }
            in
            ( { model | quoteForm = newQuoteForm }, Cmd.none )

        SetCarYear carYear ->
            let
                quoteForm =
                    model.quoteForm

                newQuoteForm =
                    { quoteForm | carYear = carYear }
            in
            ( { model | quoteForm = newQuoteForm }, Cmd.none )

        SetPostalCode postalCode ->
            let
                quoteForm =
                    model.quoteForm

                newQuoteForm =
                    { quoteForm | postalCode = postalCode }
            in
            ( { model | quoteForm = newQuoteForm }, Cmd.none )

        SetStateCode stateCode ->
            let
                quoteForm =
                    model.quoteForm

                newQuoteForm =
                    { quoteForm | stateCode = stateCode }
            in
            ( { model | quoteForm = newQuoteForm }, Cmd.none )

        SetPersonAge personAge ->
            let
                quoteForm =
                    model.quoteForm

                newPersonAge =
                    Maybe.withDefault 0 (String.toInt personAge)

                newQuoteForm =
                    { quoteForm | personAge = newPersonAge }
            in
            ( { model | quoteForm = newQuoteForm }, Cmd.none )

        -- SetIsOkm isOkm ->
        --   let
        --     quoteForm = model.quoteForm
        --     newQuoteForm = { quoteForm | isOkm = isOkm }
        --   in
        --     ( { model | quoteForm = newQuoteForm }, Cmd.none )
        -- SetHasGnc ->
        --   let
        --     quoteForm = model.quoteForm
        --     newQuoteForm = { quoteForm | hasGnc = not hasGnc }
        --   in
        --     ( { model | quoteForm = newQuoteForm }, Cmd.none )
        SendQuote ->
            ( model, sendQuote model.quoteForm )

        NewQuote result ->
            case result of
                Ok newOffering ->
                    ( { model | offering = Just newOffering }, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )

        -- NewQuote (Ok newQuote) ->
        --   ( model, Cmd.none )
        -- NewQuote Err error ->
        --   ( model, Cmd.none )
        _ ->
            ( model, Cmd.none )


sendQuote : QuoteForm -> Cmd Msg
sendQuote quoteForm =
    Http.send NewQuote (postQuote quoteForm)


postQuote : QuoteForm -> Http.Request Offering
postQuote quoteForm =
    let
        body =
            quoteForm
                |> quoteEncoder
                |> toJsonBody
    in
    Http.post "https://api.iunigo.com/offerings" body Offering.decoder


quoteEncoder : QuoteForm -> Enc.Value
quoteEncoder quoteForm =
    object
        [ ( "car_year", Enc.string quoteForm.carYear )
        , ( "car_id", Enc.string quoteForm.carId )
        , ( "postal_code", Enc.string quoteForm.postalCode )
        , ( "state_code", Enc.string quoteForm.stateCode )
        , ( "person_age", Enc.int quoteForm.personAge )
        , ( "okm", Enc.bool False )
        , ( "gnc", Enc.bool False )
        ]


toJsonBody : Dec.Value -> Http.Body
toJsonBody value =
    Http.jsonBody value


viewOffering : Model -> Html Msg
viewOffering model =
    case model.offering of
        Just offerings ->
            div [] [ text offerings.id ]

        Nothing ->
            div [] [ text "Press send to get an offering." ]


view : Model -> Browser.Document Msg
view model =
    { title = "Quote"
    , body =
        [ div []
            [ input [ placeholder "Car Id", onInput SetCarId, value model.quoteForm.carId ] []
            , input [ placeholder "Car Year", onInput SetCarYear, value model.quoteForm.carYear ] []
            , input [ placeholder "Postal Code", onInput SetPostalCode, value model.quoteForm.postalCode ] []
            , input [ placeholder "State Code", onInput SetStateCode, value model.quoteForm.stateCode ] []
            , input [ placeholder "Person Age", onInput SetPersonAge, value (fromInt model.quoteForm.personAge) ] []
            , input [ type_ "checkbox", placeholder "Is 0km", onClick SetIsOkm ] []
            , input [ type_ "checkbox", placeholder "Has GNC", onClick SetHasGnc ] []
            , button [ id "sendButton", onClick SendQuote ] [ text "Send" ]
            , viewOffering model
            ]
        ]
    }
