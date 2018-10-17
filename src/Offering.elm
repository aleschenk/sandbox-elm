module Offering exposing
    ( Offering
    , Package
    , Product
    , Type (..)
    , decoder
    , encoder
    )

import Array exposing (Array)
import Json.Decode as Decode exposing (Decoder, array, float, int, nullable, string)
import Json.Decode.Pipeline exposing (hardcoded, optional, required)
import Json.Encode as Encode


type alias Offering =
    { id : String
    , policyInitialDate : String
    , renewalEvery : Int
    , packageRecomended : String
    , insuranceAmount : String
    , flatModel : String
    , packages : Array Package
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


decoder : Decoder Offering
decoder =
    Decode.succeed Offering
        |> required "id" string
        |> required "policy_initial_date" string
        |> required "renewal_every" int
        |> required "package_recomended" string
        |> required "insurance_amount" string
        |> required "flat_model" string
        |> required "packages" (array package)
        |> required "products" (array product)


package : Decoder Package
package =
    Decode.succeed Package
        |> required "id" string
        |> required "name" string
        |> required "description" string
        |> required "long_description" string
        |> required "price" float
        |> required "products" (array string)


product : Decoder Product
product =
    Decode.succeed Product
        |> required "id" string
        |> required "name" string
        |> required "description" string
        |> required "type" purpleType
        |> optional "excesses" (nullable (array excess)) Nothing
        |> optional "excess_recomended" (nullable string) Nothing


excess : Decoder Excess
excess =
    Decode.succeed Excess
        |> required "id" string
        |> required "value" string
        |> required "price" float


purpleType : Decode.Decoder Type
purpleType =
    Decode.string
        |> Decode.andThen
            (\str ->
                case str of
                    "coverage" ->
                        Decode.succeed Coverage

                    "extra" ->
                        Decode.succeed Extra

                    "parcial" ->
                        Decode.succeed Parcial

                    "service" ->
                        Decode.succeed Service

                    somethingElse ->
                        Decode.fail <| "Invalid Type: " ++ somethingElse
            )


encoder : Offering -> Encode.Value
encoder offering =
    Encode.object
        [ ( "id", Encode.string "d" )
        , ( "policy_initial_date", Encode.string offering.policyInitialDate )
        ]
