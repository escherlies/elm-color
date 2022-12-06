module Color.Hue.Test exposing (..)

import Color
import Color.Data.Basic exposing (Basic, basic)
import Color.Hsl
import Color.Internal exposing (Color(..))
import Color.Utils exposing (fractionalModBy)
import Expect
import Fuzz
import Test exposing (..)


equalFloat : Float -> Float -> Expect.Expectation
equalFloat =
    Expect.within
        -- Pico precision
        (Expect.Absolute 1.0e-6)


suite : Test
suite =
    describe "Color Tests"
        [ fuzz
            rgbfuzz
            "Fuzzy test conversion of Rgba -> Hsla -> Rgba"
            (\color ->
                let
                    (Rgba r1 g1 b1 a1) =
                        color
                in
                color
                    |> Color.Hsl.toHsla
                    |> Color.Hsl.fromHsla
                    |> (\color2 ->
                            let
                                (Rgba r2 g2 b2 a2) =
                                    color2
                            in
                            Expect.all
                                [ \_ -> r2 |> equalFloat r1
                                , \_ -> g2 |> equalFloat g1
                                , \_ -> b2 |> equalFloat b1
                                , \_ -> a2 |> equalFloat a1
                                ]
                                ()
                       )
            )
        , fuzz
            hslFuzz
            "Fuzzy test conversion of Hsla -> Rgba -> Hsla"
            (\hsl ->
                let
                    { h, s, l } =
                        hsl
                in
                Color.Hsl.hsl h s l
                    |> Color.Hsl.toHsla
                    |> (\hsl2 ->
                            let
                                { hue, saturation, lightness, alpha } =
                                    hsl2

                                hue_ =
                                    wrapHue hue

                                wrapHue hue1 =
                                    if hue1 > 359 then
                                        0

                                    else
                                        hue1
                            in
                            Expect.all
                                [ \_ -> hue_ |> equalFloat (wrapHue h)
                                , \_ -> saturation |> equalFloat s
                                , \_ -> lightness |> equalFloat l
                                , \_ -> alpha |> equalFloat 1
                                ]
                                ()
                       )
            )
        ]


rgbfuzz : Fuzz.Fuzzer Color
rgbfuzz =
    Fuzz.map4 Rgba
        (Fuzz.floatRange 0 1)
        (Fuzz.floatRange 0 1)
        (Fuzz.floatRange 0 1)
        (Fuzz.floatRange 0 1)


hslFuzz : Fuzz.Fuzzer { h : Float, s : Float, l : Float }
hslFuzz =
    Fuzz.map3
        (\h s l ->
            { h = h |> fractionalModBy 360
            , s = s
            , l = l
            }
                |> correctLightness
                |> correctSaturation
        )
        (Fuzz.floatRange 0 360)
        (Fuzz.floatRange 0 1)
        (Fuzz.floatRange 0 1)


correctSaturation : { h : Float, s : Float, l : Float } -> { h : Float, s : Float, l : Float }
correctSaturation hsl =
    if hsl.s < 1.0e-6 then
        { h = 0
        , s = 0
        , l = hsl.l
        }

    else
        hsl


correctLightness : { h : Float, s : Float, l : Float } -> { h : Float, s : Float, l : Float }
correctLightness hsl =
    if hsl.l < 1.0e-6 then
        { h = 0
        , s = 0
        , l = 0
        }

    else if hsl.l > 0.999999 then
        { h = 0
        , s = 0
        , l = 1
        }

    else
        hsl



-- Basic data set


basicHslToColor : Basic -> Expect.Expectation
basicHslToColor =
    \{ rgb, hsl } ->
        Color.Hsl.hsl
            (toFloat hsl.h)
            (toFloat hsl.s / 100)
            (toFloat hsl.l / 100)
            |> (\(Rgba r g b a) ->
                    Expect.all
                        [ \_ -> Expect.equal rgb.r (r * 100 |> round)
                        , \_ -> Expect.equal rgb.g (g * 100 |> round)
                        , \_ -> Expect.equal rgb.b (b * 100 |> round)
                        , \_ -> Expect.equal 1 a
                        ]
                        ()
               )


basicColorToHsl : Basic -> Expect.Expectation
basicColorToHsl =
    \{ rgb, hsl } ->
        Color.rgb
            (toFloat rgb.r / 100)
            (toFloat rgb.g / 100)
            (toFloat rgb.b / 100)
            |> Color.Hsl.toHsla
            |> (\hsl2 ->
                    Expect.all
                        [ \_ -> Expect.equal hsl.h (hsl2.hue |> round)
                        , \_ -> Expect.equal hsl.s (hsl2.saturation * 100 |> round)
                        , \_ -> Expect.equal hsl.l (hsl2.lightness * 100 |> round)
                        , \_ -> Expect.equal 1 hsl2.alpha
                        ]
                        ()
               )


basicTestSuite : Test
basicTestSuite =
    describe "Test basic data set" <|
        [ describe "basicColorToHsl" <|
            List.map (\d -> test d.name (\_ -> basicColorToHsl d)) basic
        , describe "basicHslToColor" <|
            List.map (\d -> test d.name (\_ -> basicHslToColor d)) basic
        ]
