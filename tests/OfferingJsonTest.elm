module OfferingJsonTest exposing (suite)

-- import OfferingFixtures as Fixture exposing (sample)

import Array exposing (Array)
import Expect exposing (..)
import Json.Decode
import Offering 
import Offering exposing (Type(..))
import Test exposing (..)


suite : Test
suite =
    describe "Offering Json decode encode"
        [ describe "encode request"
            [ test "a valid encode request" <|
                \_ ->
                    let
                        input =
                          """
                            {
                              "id": "44e5248b-9901-43f2-9351-128247c9922f",
                              "policy_initial_date": "2018-10-15",
                              "renewal_every": 3,
                              "package_recomended": "P1",
                              "insurance_amount": "152000",
                              "flat_model": "fmod_pricing_039",
                              "packages": [
                                {
                                  "id": "P1",
                                  "name": "simple",
                                  "description": "Terceros completo.",
                                  "long_description": "",
                                  "price": 2949.187,
                                  "products": [
                                    "LUBRIMOVIL"
                                  ]
                                }
                              ],
                              "products": [
                                {
                                  "id": "RC",
                                  "name": "Responsabilidad Civil",
                                  "description": "Cubrimos los daños...",
                                  "type": "coverage"
                                }
                              ]
                            }
                        """

                        decodedOutput =
                            Json.Decode.decodeString Offering.decoder input
                    in
                    Expect.equal decodedOutput
                        (Ok
                            { id = "44e5248b-9901-43f2-9351-128247c9922f"
                            , policyInitialDate = "2018-10-15"
                            , renewalEvery = 3
                            , packageRecomended = "P1"
                            , insuranceAmount = "152000"
                            , flatModel = "fmod_pricing_039"
                            , packages = Array.fromList [ Offering.Package "P1" "simple" "Terceros completo." "" 2949.187 (Array.fromList [ "LUBRIMOVIL" ]) ]
                            , products = Array.fromList [ Offering.Product "RC" "Responsabilidad Civil" "Cubrimos los daños..." Coverage Nothing Nothing ]
                            }
                        )
            ]
        ]
