module OfferingJson exposing
    ( Offering
    , offeringDecoder
    , Package
    , Product
    , Excess
    , Type(..)
    )

import Json.Decode as Jdec
import Json.Encode as Jenc
import Json.Decode.Pipeline as Jpipe
import Dict exposing (Dict, map, toList)
import Array exposing (Array, map)

type alias Offering =
    { id : String
    , policyInitialDate : String
    , renewalEvery : Int
    , packageRecomended : String
    , packages : Array Package
    , insuranceAmount : String
    , flatModel : String
    , products : Array Product
    }

type alias Package =
    { id : String
    , name : String
    , description : String
    , longDescription : String
    , price : Float
    , products : Array String
    }

type alias Product =
    { id : String
    , name : String
    , description : String
    , productType : Type
    , excesses : Maybe (Array Excess)
    , excessRecomended : Maybe String
    }

type alias Excess =
    { id : String
    , value : String
    , price : Float
    }

type Type
    = Coverage
    | Extra
    | Parcial
    | Service

offeringDecoder : Jdec.Decoder Offering
offeringDecoder =
    Jdec.succeed Offering
        |> Jpipe.required "id" Jdec.string
        |> Jpipe.required "policy_initial_date" Jdec.string
        |> Jpipe.required "renewal_every" Jdec.int
        |> Jpipe.required "package_recomended" Jdec.string
        |> Jpipe.required "packages" (Jdec.array package)
        |> Jpipe.required "insurance_amount" Jdec.string
        |> Jpipe.required "flat_model" Jdec.string
        |> Jpipe.required "products" (Jdec.array product)

package : Jdec.Decoder Package
package =
    Jdec.succeed Package
        |> Jpipe.required "id" Jdec.string
        |> Jpipe.required "name" Jdec.string
        |> Jpipe.required "description" Jdec.string
        |> Jpipe.required "long_description" Jdec.string
        |> Jpipe.required "price" Jdec.float
        |> Jpipe.required "products" (Jdec.array Jdec.string)

product : Jdec.Decoder Product
product =
    Jdec.succeed Product
        |> Jpipe.required "id" Jdec.string
        |> Jpipe.required "name" Jdec.string
        |> Jpipe.required "description" Jdec.string
        |> Jpipe.required "type" purpleType
        |> Jpipe.optional "excesses" (Jdec.nullable (Jdec.array excess)) Nothing
        |> Jpipe.optional "excess_recomended" (Jdec.nullable Jdec.string) Nothing

excess : Jdec.Decoder Excess
excess =
    Jdec.succeed Excess
        |> Jpipe.required "id" Jdec.string
        |> Jpipe.required "value" Jdec.string
        |> Jpipe.required "price" Jdec.float

encodeExcess : Excess -> Jenc.Value
encodeExcess x =
    Jenc.object
        [ ("id", Jenc.string x.id)
        , ("value", Jenc.string x.value)
        , ("price", Jenc.float x.price)
        ]

purpleType : Jdec.Decoder Type
purpleType =
    Jdec.string
        |> Jdec.andThen (\str ->
            case str of
                "coverage" -> Jdec.succeed Coverage
                "extra" -> Jdec.succeed Extra
                "parcial" -> Jdec.succeed Parcial
                "service" -> Jdec.succeed Service
                somethingElse -> Jdec.fail <| "Invalid Type: " ++ somethingElse
        )

encodeType : Type -> Jenc.Value
encodeType x = case x of
    Coverage -> Jenc.string "coverage"
    Extra -> Jenc.string "extra"
    Parcial -> Jenc.string "parcial"
    Service -> Jenc.string "service"
