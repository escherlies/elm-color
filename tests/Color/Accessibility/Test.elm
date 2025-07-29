module Color.Accessibility.Test exposing (..)

import Color.Accessibility exposing (..)
import Color.Internal exposing (Color(..), rgb, rgba)
import Color.Test.Utils exposing (equalFloat)
import Expect
import Fuzz
import Test exposing (..)


suite : Test
suite =
    describe "Color.Accessibility Tests"
        [ describe "contrastRatio"
            [ test "Black on white should have maximum contrast (21:1)" <|
                \_ ->
                    contrastRatio (rgb 0 0 0) (rgb 1 1 1)
                        |> equalFloat 21.0
            , test "White on black should have maximum contrast (21:1)" <|
                \_ ->
                    contrastRatio (rgb 1 1 1) (rgb 0 0 0)
                        |> equalFloat 21.0
            , test "Same colors should have minimum contrast (1:1)" <|
                \_ ->
                    contrastRatio (rgb 0.5 0.5 0.5) (rgb 0.5 0.5 0.5)
                        |> equalFloat 1.0
            , test "Gray on white should have expected contrast" <|
                \_ ->
                    contrastRatio (rgb 0.5 0.5 0.5) (rgb 1 1 1)
                        |> Expect.within (Expect.Absolute 0.01) 3.98
            , test "Dark gray on white should have higher contrast" <|
                \_ ->
                    contrastRatio (rgb 0.3 0.3 0.3) (rgb 1 1 1)
                        |> Expect.within (Expect.Absolute 0.01) 8.52
            , fuzz fuzzColorPair
                "Contrast ratio should be symmetric"
                (\( color1, color2 ) ->
                    let
                        ratio1 =
                            contrastRatio color1 color2

                        ratio2 =
                            contrastRatio color2 color1
                    in
                    ratio1 |> equalFloat ratio2
                )
            , fuzz fuzzColorPair
                "Contrast ratio should be at least 1:1"
                (\( color1, color2 ) ->
                    contrastRatio color1 color2
                        |> Expect.atLeast 1.0
                )
            , fuzz fuzzColorPair
                "Contrast ratio should be at most 21:1"
                (\( color1, color2 ) ->
                    contrastRatio color1 color2
                        |> Expect.atMost 21.0
                )
            , test "Blue on yellow should have specific contrast" <|
                \_ ->
                    let
                        -- A tricky pair, as blue is dark but has low luminance weight
                        blue =
                            rgb 0 0 1

                        yellow =
                            rgb 1 1 0
                    in
                    -- The actual ratio is ~8.00:1
                    contrastRatio blue yellow
                        |> Expect.within (Expect.Absolute 0.01) 8.0
            , test "Red on white should have expected contrast" <|
                \_ ->
                    let
                        red =
                            rgb 1 0 0

                        white =
                            rgb 1 1 1
                    in
                    -- Red has relatively low luminance due to the weighting formula
                    contrastRatio red white
                        |> Expect.within (Expect.Absolute 0.01) 3.99
            ]
        , describe "wcagLevel"
            [ test "Black on white should be AAA for both text sizes" <|
                \_ ->
                    wcagLevel (rgb 0 0 0) (rgb 1 1 1)
                        |> Expect.equal { normal = AAA, large = AAA }
            , test "Medium gray on white should be NotCompliant for normal, AA for large" <|
                \_ ->
                    wcagLevel (rgb 0.5 0.5 0.5) (rgb 1 1 1)
                        |> Expect.equal { normal = NotCompliant, large = AA }
            , test "Light gray on white should not be compliant" <|
                \_ ->
                    wcagLevel (rgb 0.8 0.8 0.8) (rgb 1 1 1)
                        |> Expect.equal { normal = NotCompliant, large = NotCompliant }
            , test "Dark gray on white should be AAA for both" <|
                \_ ->
                    wcagLevel (rgb 0.3 0.3 0.3) (rgb 1 1 1)
                        |> Expect.equal { normal = AAA, large = AAA }
            , test "Borderline AA normal text (4.5:1)" <|
                \_ ->
                    -- rgb(0.46, 0.46, 0.46) on white gives a ratio of ~4.54:1
                    -- This should pass the >= 4.5:1 check for AA normal text
                    wcagLevel (rgb 0.46 0.46 0.46) (rgb 1 1 1)
                        |> .normal
                        |> Expect.equal AA
            , test "Just below AA normal text threshold" <|
                \_ ->
                    -- rgb(0.47, 0.47, 0.47) on white gives a ratio of ~4.4:1
                    -- This should fail the >= 4.5:1 check for AA normal text
                    wcagLevel (rgb 0.47 0.47 0.47) (rgb 1 1 1)
                        |> .normal
                        |> Expect.equal NotCompliant
            , test "Borderline AAA normal text (7:1)" <|
                \_ ->
                    -- rgb(0.28, 0.28, 0.28) on white gives a ratio of ~7.0:1
                    -- This should pass the >= 7.0:1 check for AAA normal text
                    wcagLevel (rgb 0.28 0.28 0.28) (rgb 1 1 1)
                        |> .normal
                        |> Expect.equal AAA
            , test "Borderline AA large text (3:1)" <|
                \_ ->
                    -- rgb(0.55, 0.55, 0.55) on white gives a ratio of ~3.0:1
                    -- This should pass the >= 3.0:1 check for AA large text
                    wcagLevel (rgb 0.55 0.55 0.55) (rgb 1 1 1)
                        |> .large
                        |> Expect.equal AA
            ]
        , describe "meetsWcgAA"
            [ test "Black on white meets AA for normal text" <|
                \_ ->
                    meetsWcgAA Normal (rgb 0 0 0) (rgb 1 1 1)
                        |> Expect.equal True
            , test "Black on white meets AA for large text" <|
                \_ ->
                    meetsWcgAA Large (rgb 0 0 0) (rgb 1 1 1)
                        |> Expect.equal True
            , test "Light gray on white does not meet AA for normal text" <|
                \_ ->
                    meetsWcgAA Normal (rgb 0.7 0.7 0.7) (rgb 1 1 1)
                        |> Expect.equal False
            , test "Light gray on white does not meet AA for large text either" <|
                \_ ->
                    meetsWcgAA Large (rgb 0.7 0.7 0.7) (rgb 1 1 1)
                        |> Expect.equal False
            , test "Very light gray on white does not meet AA for any text size" <|
                \_ ->
                    let
                        veryLightGray =
                            rgb 0.9 0.9 0.9

                        white =
                            rgb 1 1 1
                    in
                    Expect.all
                        [ \_ -> meetsWcgAA Normal veryLightGray white |> Expect.equal False
                        , \_ -> meetsWcgAA Large veryLightGray white |> Expect.equal False
                        ]
                        ()
            ]
        , describe "meetsWcgAAA"
            [ test "Black on white meets AAA for normal text" <|
                \_ ->
                    meetsWcgAAA Normal (rgb 0 0 0) (rgb 1 1 1)
                        |> Expect.equal True
            , test "Black on white meets AAA for large text" <|
                \_ ->
                    meetsWcgAAA Large (rgb 0 0 0) (rgb 1 1 1)
                        |> Expect.equal True
            , test "Medium gray on white does not meet AAA for normal text" <|
                \_ ->
                    meetsWcgAAA Normal (rgb 0.5 0.5 0.5) (rgb 1 1 1)
                        |> Expect.equal False
            , test "Medium gray on white does not meet AAA for large text either" <|
                \_ ->
                    meetsWcgAAA Large (rgb 0.5 0.5 0.5) (rgb 1 1 1)
                        |> Expect.equal False
            , test "Dark gray on white meets AAA for both text sizes" <|
                \_ ->
                    let
                        darkGray =
                            rgb 0.3 0.3 0.3

                        white =
                            rgb 1 1 1
                    in
                    Expect.all
                        [ \_ -> meetsWcgAAA Normal darkGray white |> Expect.equal True
                        , \_ -> meetsWcgAAA Large darkGray white |> Expect.equal True
                        ]
                        ()
            ]
        , describe "formatContrastRatio"
            [ test "Format whole number ratio" <|
                \_ ->
                    formatContrastRatio 21.0
                        |> Expect.equal "21:1"
            , test "Format decimal ratio" <|
                \_ ->
                    formatContrastRatio 4.5
                        |> Expect.equal "4.5:1"
            , test "Format ratio with many decimals (should round to 2 places)" <|
                \_ ->
                    formatContrastRatio 5.743829
                        |> Expect.equal "5.74:1"
            , test "Format minimum ratio" <|
                \_ ->
                    formatContrastRatio 1.0
                        |> Expect.equal "1:1"
            , test "Format ratio close to whole number" <|
                \_ ->
                    formatContrastRatio 4.999
                        |> Expect.equal "5:1"
            ]
        , describe "WcagLevel and TextSize types"
            [ test "WcagLevel equality" <|
                \_ ->
                    Expect.all
                        [ \_ -> Expect.equal AA AA
                        , \_ -> Expect.equal AAA AAA
                        , \_ -> Expect.equal NotCompliant NotCompliant
                        , \_ -> Expect.notEqual AA AAA
                        , \_ -> Expect.notEqual AA NotCompliant
                        , \_ -> Expect.notEqual AAA NotCompliant
                        ]
                        ()
            , test "TextSize equality" <|
                \_ ->
                    Expect.all
                        [ \_ -> Expect.equal Normal Normal
                        , \_ -> Expect.equal Large Large
                        , \_ -> Expect.notEqual Normal Large
                        ]
                        ()
            ]
        , describe "Edge cases and integration"
            [ test "Alpha channel should be blended before contrast calculation" <|
                \_ ->
                    let
                        -- rgba(0, 0, 0, 0.5) on a white background becomes rgb(0.5, 0.5, 0.5)
                        -- The contrast should be between that resulting gray and the white background
                        semiTransparentBlackOnWhite =
                            rgb 0.5 0.5 0.5

                        white =
                            rgb 1 1 1

                        -- This is the expected contrast for 50% gray on white (~3.98:1)
                        expectedRatio =
                            3.98
                    in
                    -- The implementation should handle the blending internally
                    contrastRatio (rgba 0 0 0 0.5) white
                        |> Expect.within (Expect.Absolute 0.01) expectedRatio
            , fuzz fuzzColor
                "Any color should have 1:1 contrast with itself"
                (\color ->
                    contrastRatio color color
                        |> equalFloat 1.0
                )
            , fuzz fuzzColor
                "wcagLevel should be consistent with individual meetsWcgAA/AAA functions"
                (\foreground ->
                    let
                        background =
                            rgb 1 1 1

                        -- white background
                        levels =
                            wcagLevel foreground background

                        normalAA =
                            meetsWcgAA Normal foreground background

                        normalAAA =
                            meetsWcgAAA Normal foreground background

                        largeAA =
                            meetsWcgAA Large foreground background

                        largeAAA =
                            meetsWcgAAA Large foreground background
                    in
                    Expect.all
                        [ \_ ->
                            case levels.normal of
                                AAA ->
                                    Expect.equal True normalAAA

                                AA ->
                                    Expect.all
                                        [ \_ -> Expect.equal True normalAA
                                        , \_ -> Expect.equal False normalAAA
                                        ]
                                        ()

                                NotCompliant ->
                                    Expect.equal False normalAA
                        , \_ ->
                            case levels.large of
                                AAA ->
                                    Expect.equal True largeAAA

                                AA ->
                                    Expect.all
                                        [ \_ -> Expect.equal True largeAA
                                        , \_ -> Expect.equal False largeAAA
                                        ]
                                        ()

                                NotCompliant ->
                                    Expect.equal False largeAA
                        ]
                        ()
                )
            ]
        ]



-- Fuzz generators


fuzzColor : Fuzz.Fuzzer Color
fuzzColor =
    Fuzz.map3 rgb
        (Fuzz.floatRange 0 1)
        (Fuzz.floatRange 0 1)
        (Fuzz.floatRange 0 1)


fuzzColorPair : Fuzz.Fuzzer ( Color, Color )
fuzzColorPair =
    Fuzz.map2 Tuple.pair fuzzColor fuzzColor
