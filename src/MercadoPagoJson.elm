module MercadoPagoJson exposing
    ( Response
    , responseDecoder
    , Card
    , Identification
    , Cardholder
    )

import Json.Decode as Jdec
import Json.Encode as Jenc
import Json.Decode.Pipeline as Jpipe
import Dict exposing (Dict, map, toList)
import Array exposing (Array, map)

type alias Identification =
  { number: String }

type alias Cardholder =
  { name: String
  , identification: Identification
  }

type alias Card =
  { firstSixDigits : String
  , lastFourDigits : String
  , expirationMonth : String
  , expirationYear : String
  , cardholder : Cardholder
  }

type alias Response =
    { issuerId : String
    , paymentMethodId : String
    , paymentTypeId : String
    , card : Card
    }

identificationDecoder : Jdec.Decoder Identification
identificationDecoder =
    Jdec.succeed Identification
      |> Jpipe.required "number" Jdec.string

cardholderDecoder : Jdec.Decoder Cardholder
cardholderDecoder =
    Jdec.succeed Cardholder
      |> Jpipe.required "name" Jdec.string
      |> Jpipe.required "identification" identificationDecoder

cardDecoder : Jdec.Decoder Card
cardDecoder =
    Jdec.succeed Card
      |> Jpipe.required "first_six_digits" Jdec.string
      |> Jpipe.required "last_four_digits" Jdec.string
      |> Jpipe.required "expiration_month" Jdec.string
      |> Jpipe.required "expiration_year" Jdec.string
      |> Jpipe.required "cardholder" cardholderDecoder

responseDecoder : Jdec.Decoder Response
responseDecoder =
    Jdec.succeed Response
        |> Jpipe.required "issuer_id" Jdec.string
        |> Jpipe.required "payment_method_id" Jdec.string
        |> Jpipe.required "payment_type_id" Jdec.string
        |> Jpipe.required "card" cardDecoder

responseListDecoder : Jdec.Decoder (List Response)
responseListDecoder = 
      Jdec.array []