module Color.Accessibility exposing (..)

{-| WCAG accessibility functions for color contrast analysis.

This module provides functions to calculate contrast ratios and check WCAG compliance
for color combinations, helping ensure your color choices meet accessibility standards.


# Types

@docs WcagLevel, TextSize


# Contrast

@docs contrastRatio


# WCAG Compliance

@docs meetsWcag, wcagLevel


# Formatting

@docs formatContrastRatio

-}

import Color.Internal exposing (Color(..))
import Color.Lightness


{-| WCAG compliance levels for accessibility standards.

  - `AA`: Standard level (4.5:1 for normal text, 3:1 for large text)
  - `AAA`: Enhanced level (7:1 for normal text, 4.5:1 for large text)
  - `NotCompliant`: Does not meet any WCAG contrast requirements

-}
type WcagLevel
    = AA
    | AAA
    | NotCompliant


{-| Text size categories that affect contrast requirements.

  - `Normal`: Regular text size (requires higher contrast ratios)
  - `Large`: Large text (18pt+ or 14pt+ bold, requires lower contrast ratios)

-}
type TextSize
    = Normal
    | Large


{-| Calculate the contrast ratio between two colors according to WCAG guidelines.

The contrast ratio ranges from 1:1 (no contrast) to 21:1 (maximum contrast).
It's calculated using the formula: (L1 + 0.05) / (L2 + 0.05) where L1 is the
lighter color's relative luminance and L2 is the darker color's relative luminance.

For semi-transparent colors, they are first blended with the background color
before calculating the contrast ratio, as per WCAG guidelines.

    contrastRatio (rgb 0 0 0) (rgb 1 1 1) --> 21.0 (black on white)

    contrastRatio (rgb 0.5 0.5 0.5) (rgb 1 1 1) --> ~3.98 (gray on white)

    contrastRatio (rgba 0 0 0 0.5) (rgb 1 1 1) --> ~3.98 (50% black blended with white)

-}
contrastRatio : Color -> Color -> Float
contrastRatio foreground background =
    let
        -- Blend the foreground with the background if it has transparency
        blendedForeground =
            blendWithBackground foreground background

        l1 =
            Color.Lightness.luminance blendedForeground

        l2 =
            Color.Lightness.luminance background

        lighter =
            max l1 l2

        darker =
            min l1 l2
    in
    (lighter + 0.05) / (darker + 0.05)


{-| Blend a potentially transparent foreground color with an opaque background color.
This implements alpha compositing using the "over" operator.

For a semi-transparent foreground color with alpha A over an opaque background:

  - result\_r = foreground\_r \* A + background\_r \* (1 - A)
  - result\_g = foreground\_g \* A + background\_g \* (1 - A)
  - result\_b = foreground\_b \* A + background\_b \* (1 - A)
  - result\_a = 1.0 (fully opaque)

-}
blendWithBackground : Color -> Color -> Color
blendWithBackground (Rgba fr fg fb fa) (Rgba br bg bb _) =
    let
        -- Alpha compositing: result = foreground * alpha + background * (1 - alpha)
        blendedR =
            fr * fa + br * (1 - fa)

        blendedG =
            fg * fa + bg * (1 - fa)

        blendedB =
            fb * fa + bb * (1 - fa)
    in
    -- Result is always fully opaque
    Rgba blendedR blendedG blendedB 1.0


{-| Get the highest WCAG compliance level that two colors meet for both normal and large text sizes.

Returns a record with the compliance levels for both text sizes.

    wcagLevel (rgb 0 0 0) (rgb 1 1 1)
    --> { normal = AAA, large = AAA }

    wcagLevel (rgb 0.5 0.5 0.5) (rgb 1 1 1)
    --> { normal = AA, large = AAA }

    wcagLevel (rgb 0.8 0.8 0.8) (rgb 1 1 1)
    --> { normal = NotCompliant, large = NotCompliant }

-}
wcagLevel : Color -> Color -> { normal : WcagLevel, large : WcagLevel }
wcagLevel foreground background =
    let
        ratio =
            contrastRatio foreground background

        normalLevel =
            if ratio >= 7.0 then
                AAA

            else if ratio >= 4.5 then
                AA

            else
                NotCompliant

        largeLevel =
            if ratio >= 4.5 then
                AAA

            else if ratio >= 3.0 then
                AA

            else
                NotCompliant
    in
    { normal = normalLevel, large = largeLevel }


{-| Check if two colors meet WCAG AA contrast requirements for a given text size.

        meetsWcgAA Normal (rgb 0 0 0) (rgb 1 1 1) --> True (21:1 > 4.5:1)
        meetsWcgAA Normal (rgb 0.7 0.7 0.7) (rgb 1 1 1) --> False (~2.8:1 < 4.5:1)
        meetsWcgAA Large (rgb 0.7 0.7 0.7) (rgb 1 1 1) --> True (~2.8:1 > 3:1)

-}
meetsWcgAA : TextSize -> Color -> Color -> Bool
meetsWcgAA textSize foreground background =
    let
        ratio =
            contrastRatio foreground background

        threshold =
            case textSize of
                Normal ->
                    4.5

                Large ->
                    3.0
    in
    ratio >= threshold


{-| Check if two colors meet WCAG AAA contrast requirements for a given text size.

        meetsWcgAAA Normal (rgb 0 0 0) (rgb 1 1 1) --> True (21:1 > 7:1)
        meetsWcgAAA Normal (rgb 0.7 0.7 0.7) (rgb 1 1 1) --> False (~2.8:1 < 7:1)
        meetsWcgAAA Large (rgb 0.3 0.3 0.3) (rgb 1 1 1) --> True (~5.7:1 > 4.5:1)

-}
meetsWcgAAA : TextSize -> Color -> Color -> Bool
meetsWcgAAA textSize foreground background =
    let
        ratio =
            contrastRatio foreground background

        threshold =
            case textSize of
                Normal ->
                    7.0

                Large ->
                    4.5
    in
    ratio >= threshold


{-| Format a contrast ratio as a string with ratio notation.

        formatContrastRatio 4.5 --> "4.5:1"
        formatContrastRatio 21.0 --> "21:1"

-}
formatContrastRatio : Float -> String
formatContrastRatio ratio =
    String.fromFloat (toFloat (round (ratio * 100)) / 100) ++ ":1"
