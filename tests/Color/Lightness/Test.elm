module Color.Lightness.Test exposing (..)

import Color exposing (isLight)
import Color.Internal exposing (rgb, rgb255)
import Color.Lightness exposing (lightness)
import Color.Test.Utils exposing (equalFloat)
import Color.Utils exposing (callTrice)
import Expect
import Fuzz
import Test exposing (..)


suite : Test
suite =
    describe "Lightness"
        [ fuzz
            fuzzRgb
            "Lightness values should be between 0 and 1"
            (\rgb ->
                lightness rgb
                    |> Expect.all
                        [ Expect.atLeast 0
                        , Expect.atMost 1
                        ]
            )

        -- https://en.wikipedia.org/wiki/Middle_gray
        , test "Middle Gray (percieved)" <|
            \_ ->
                lightness (callTrice rgb255 119)
                    |> equalFloat 0.5003443879253823
        , test "Middle Gray (percieved) + 1 should be light" <|
            \_ ->
                isLight (callTrice rgb255 120)
                    |> Expect.equal True
        , test "Middle Gray (percieved) - 1 should not be light" <|
            \_ ->
                isLight (callTrice rgb255 118)
                    |> Expect.equal False
        ]


fuzzRgb : Fuzz.Fuzzer Color.Internal.Color
fuzzRgb =
    Fuzz.map3 rgb
        (Fuzz.floatRange 0 1)
        (Fuzz.floatRange 0 1)
        (Fuzz.floatRange 0 1)
