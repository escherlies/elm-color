module Color.Lightness exposing (lightness, luminance)

import Color.Internal exposing (Color(..))


{-| Lightness is the **visual perception** of the luminance L of an object. It is the L\* component of a color in the CIELAB and CIELUV space.

See actual function implementations for info about every step with the source.

Thanks to <https://stackoverflow.com/a/56678483> for clarifying everything!

-}
lightness : Color -> Float
lightness =
    normalize << lStar << luminance


{-| Normalize to values between 0 and 1
-}
normalize : Float -> Float
normalize x =
    x / 100


{-| Relative luminance (ignores alpha)

    0.2126 * r_lin + 0.7152 * g_lin + 0.0722 * b_lin
    --       ^^^^^            ^^^^^            ^^^^^ these are gamma corrected values!

Source <https://en.wikipedia.org/wiki/Relative_luminance>

-}
luminance : Color -> Float
luminance (Rgba r g b _) =
    0.2126 * linear r + 0.7152 * linear g + 0.0722 * linear b


{-| Convert gamma-encoded sRGB to gamma corrected linear color

The sRGB component values are in the range 0 to 1.

Source <https://en.wikipedia.org/wiki/SRGB#From_sRGB_to_CIE_XYZ>

-}
linear : Float -> Float
linear c =
    if c <= 0.04045 then
        c / 12.92

    else
        ((c + 0.055) / 1.055) ^ 2.4


{-| Convert relative luminance (L or Y) to percieved luminance L\* (Lstar). Return value is in range 0 100

Source <https://en.wikipedia.org/wiki/Lightness#1976>


# Relative luminance and perceptual spaces

Y is linear to light, but human perception has a non-linear response to lightness/darkness/brightness.

For L\*a\*b and L\*u\*v component is perceptual lightness (also known as "Lstar" and not to be confused with L luminance).
L∗ is intended to be linear to human perception of lightness/darkness, and since human perception of light is non-linear, L\* is a nonlinear function of relative luminance Y.

Source <https://en.wikipedia.org/wiki/Relative_luminance#Relative_luminance_and_perceptual_spaces>

-}
lStar : Float -> Float
lStar c =
    -- t > (6 / 29) ^ 3 <=> t > 0.008856451679035631
    if c > 0.008856451679035631 then
        c ^ (1 / 3) * 116 - 16

    else
        --     (1 / 3 * (29 / 6) ^ 2 * t + 4 / 29) * 116 - 16
        -- <=> 1 / 3 * (29 / 6) ^ 2 * t * 116
        -- <=> 116 * (29 / 6) ^ 2 * 1 / 3 * t
        -- <=> 116 * (29 / 6) * (29 / 6) * 1 / 3 * t
        -- <=> 97556 / 108
        --  == 903.2962962962963
        903.2962962962963 * c
