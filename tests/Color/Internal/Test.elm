module Color.Internal.Test exposing (..)

import Color.Internal exposing (Color(..), intFromColorString, rgb, rgba, rgba255)
import Color.Palette exposing (parsePalette)
import Expect
import Fuzz
import Hex
import Test exposing (..)


testPalette : String -> List String -> Test
testPalette s result =
    test s (\_ -> Expect.equal (Ok result) (parsePalette s))


suite : Test
suite =
    describe "Color Tests"
        [ describe "Parse palettes"
            [ testPalette
                "fffffc-00eb80--000000"
                [ "fffffc", "00eb80", "000000" ]
            , testPalette
                "https://huemint.com/website-monochrome/#palette=fffffc-00eb80"
                [ "fffffc", "00eb80" ]
            , testPalette
                "xxxxfffffc-00eb80x000000---"
                [ "fffffc", "00eb80", "000000" ]
            , testPalette
                """
                fffffc
                00eb80
                000000
                """
                [ "fffffc", "00eb80", "000000" ]
            , testPalette
                "https://coolors.co/40f99b-61707d"
                [ "40f99b", "61707d" ]
            , testPalette
                "https://huemint.com/website-1/#palette=faf2d7-131be0-f700bf&this-is-being-discarded"
                [ "faf2d7", "131be0", "f700bf" ]
            ]
        , describe "Converting"
            [ test "Convert color from int"
                (\_ ->
                    Expect.equal
                        (Color.Internal.rgba255 255 255 255 255)
                        (Color.Internal.fromInt 0xFFFFFFFF)
                )
            , test "Convert color from int 2"
                (\_ ->
                    Expect.equal
                        (rgba255 0 0 0 255)
                        (Color.Internal.fromInt 0xFF)
                )
            , test "Convert color from int 3"
                (\_ ->
                    Expect.equal
                        (rgba255 255 255 255 255)
                        (Color.Internal.fromInt 0xFFFFFFFF)
                )
            , test "Convert color from int 4"
                (\_ ->
                    Expect.equal
                        (rgb 1 1 1)
                        (Color.Internal.fromInt 0xFFFFFFFF)
                )
            , test "Convert color from int 6"
                (\_ ->
                    Expect.equal
                        (rgba 0 1 1 1)
                        (Color.Internal.fromInt 0x00FFFFFF)
                )
            , fuzz (Fuzz.intRange 0x0FFFFFFF 0xFFFFFFFF)
                --                ^^^^^^^^^^ we only want 8-digit hex values, since FFF gets converted to F0F0F0FF
                "Strip prefix and parse"
                (\int ->
                    Hex.toString int |> intFromColorString |> Expect.equal (Ok int)
                )
            , test "3-digit hex vales" (\_ -> Expect.equal (Just (Rgba 1 1 1 1)) (Color.Internal.fromHexString "#FFF"))
            , test "3-digit hex values 2" (\_ -> Expect.equal (Just (Rgba 1 0 1 1)) (Color.Internal.fromHexString "#F0F"))
            , test "6-digit hex vales" (\_ -> Expect.equal (Just (Rgba 1 1 1 1)) (Color.Internal.fromHexString "#FFFFFF"))
            , test "white" (\_ -> Expect.equal (Just (Rgba 1 1 1 1)) (Color.Internal.fromHexString "#FFFFFFFF"))
            , test "black" (\_ -> Expect.equal (Just (Rgba 0 0 0 1)) (Color.Internal.fromHexString "#000000FF"))
            , fuzz fuzzCssColor
                "Parsing and converting css hex color"
                (\cssColor ->
                    cssColor
                        |> Color.Internal.fromHexString
                        |> Maybe.map Color.Internal.toCssString
                        |> Expect.equal (Just cssColor)
                )
            ]
        ]


{-| Generate 8-digit css colors ie. #FFFFFFFF
-}
fuzzCssColor : Fuzz.Fuzzer String
fuzzCssColor =
    Fuzz.map4
        combineChannelsToCssHex
        fuzzColorChannelHex
        fuzzColorChannelHex
        fuzzColorChannelHex
        fuzzColorChannelHex


{-| Generates two digit hex color channels
-}
fuzzColorChannel : Fuzz.Fuzzer Int
fuzzColorChannel =
    Fuzz.intRange 0 0xFF


{-| Generates two digit hex color channels
-}
fuzzColorChannelHex : Fuzz.Fuzzer String
fuzzColorChannelHex =
    Fuzz.map toTwoDigitHex (Fuzz.intRange 0 0xFF)


combineChannelsToCssHex : String -> String -> String -> String -> String
combineChannelsToCssHex r g b a =
    "#" ++ r ++ g ++ b ++ a


toTwoDigitHex : Int -> String
toTwoDigitHex =
    String.padLeft 2 '0' << Hex.toString
