module Color exposing
    ( Color
    , rgb, hsl, rgb255, gray
    , fromHex, fromPalette, fromHexUnsafe
    , toCssString, toRgba, toHsla, toHexString, toRgba255
    , invertRgb, setAlpha
    , getLightness
    , isLight
    , rgba, hsla, rgba255, fromRgb, fromRgba, fromHsla, fromRgb255, fromHsl
    )

{-| A general library to work with web colors.

Example usage

    colors : List Color
    colors =
        [ hsl 194 0.49 0.14
        , fromHexUnsafe "#06A77D"
        , rgb 0.96 0.976 0.996
        , rgb255 122 137 194
        ]

    green : Color
    green =
        hsl 164 0.93 0.34

    viewHtml : Html msg
    viewHtml =
        Html.div
            [ style "background-color" (Color.toCssString green)
            ]
            [ Html.text (toCssString green) ]


# Types

@docs Color


# Creating colors


## Standard way

@docs rgb, hsl, rgb255, gray


## From strings

@docs fromHex, fromPalette, fromHexUnsafe


# Convert

@docs toCssString, toRgba, toHsla, toHexString, toRgba255


# Manipulate

@docs invertRgb, setAlpha


# Extract

@docs getLightness


# Get info

@docs isLight


# Variants

More constructors

@docs rgba, hsla, rgba255, fromRgb, fromRgba, fromHsla, fromRgb255, fromHsl

-}

import Color.Hsl
import Color.Internal exposing (Color(..), mapRgb)
import Color.Palette


{-| The Color type representing a color in rgba space
-}
type alias Color =
    Color.Internal.Color



-- Build, Standards


{-| Provide the red, green, and blue channels for the color.

Each channel takes a value between 0 and 1.

-}
rgb : Float -> Float -> Float -> Color
rgb =
    Color.Internal.rgb


{-| Parses different palette formats

    fromPalette "https://huemint.com/website-monochrome/#palette=fffffc-00eb80"
    --> == List.filterMap Color.fromHex [ "fffffc", "00eb80" ] : List Color

    fromPalette """
                fffffc
                00eb80
                000000
                """
    --> == List.filterMap Color.fromHex [ "fffffc", "00eb80", "000000" ] : List Color

    fromPalette "https://coolors.co/40f99b-61707d"
    --> == List.filterMap Color.fromHex [ "40f99b", "61707d" ] : List Color

    -- Infact, it works with everything that has 6 digits hex values
    fromPalette "xxxxfffffc-00eb80x000000---"
    --> == List.filterMap Color.fromHex [ "fffffc", "00eb80", "000000" ] : List Color

-}
fromPalette : String -> List Color
fromPalette =
    Color.Palette.fromPalette



-- Build, convenience functions


{-| Provide the red, green, blue, and alpha channels for the color.

Each channel takes a value between 0 and 1.

-}
rgba : Float -> Float -> Float -> Float -> Color
rgba =
    Color.Internal.rgba


{-| Provide the red, green, and blue channels for the color.

Each channel takes a value between 0 and 255.

-}
rgb255 : Int -> Int -> Int -> Color
rgb255 =
    Color.Internal.rgb255


{-| Provide the red, green, blue and alpha channels for the color.

Each channel takes a value between 0 and 255.

-}
rgba255 : Int -> Int -> Int -> Int -> Color
rgba255 =
    Color.Internal.rgba255


{-| Provide the hue, saturation and lightness channels for the color.

Hue takes a value between 0 and 360.

Saturation and lightness take a value between 0 and 1.

-}
hsl : Float -> Float -> Float -> Color
hsl =
    Color.Hsl.hsl


{-| Provide the hue, saturation, lightness, and alpha channels for the color.

Hue takes a value between 0 and 360.

Saturation, lightness, and alpha take a value between 0 and 1.

-}
hsla : Float -> Float -> Float -> Float -> Color
hsla =
    Color.Hsl.hsla


{-| Create a color from an rgb record. Each channel takes a value between 0 and 1.
-}
fromRgb :
    { red : Float
    , green : Float
    , blue : Float
    }
    -> Color
fromRgb { red, green, blue } =
    Color.Internal.rgba red green blue 1


{-| Create a color from an rgba record. Each channel takes a value between 0 and 1.
-}
fromRgba :
    { red : Float
    , green : Float
    , blue : Float
    , alpha : Float
    }
    -> Color
fromRgba { red, green, blue, alpha } =
    Color.Internal.rgba red green blue alpha


{-| Create a color from an rgb record. Each channel takes a value between 0 and 255.
-}
fromRgb255 :
    { red : Int
    , green : Int
    , blue : Int
    }
    -> Color
fromRgb255 { red, green, blue } =
    Color.Internal.rgb255 red green blue


{-| Create a color from an HSL record

Hue takes a value between 0 and 360.

Saturation and lightness take a value between 0 and 1.

-}
fromHsl :
    { hue : Float
    , saturation : Float
    , lightness : Float
    }
    -> Color
fromHsl { hue, saturation, lightness } =
    Color.Hsl.hsla hue saturation lightness 1


{-| Create a color from an HSL(a) record

Hue takes a value between 0 and 360.

Saturation, lightness, and alpha take a value between 0 and 1.

-}
fromHsla :
    { hue : Float
    , saturation : Float
    , lightness : Float
    , alpha : Float
    }
    -> Color
fromHsla =
    Color.Hsl.fromHsla


{-| Create a gray color. I.e. for a 50% gray: `gray 0.5`
-}
gray : Float -> Color
gray f =
    rgb f f f



-- Parse


{-| Parse a hex string to a color

Can handle different formats:

    fromHex "#000"

    fromHex "#F0F0F0"

    fromHex "0xA0A0A0"

    fromHex "8F8F8F"

    fromHex "#C6C6C680"

-}
fromHex : String -> Maybe Color
fromHex =
    Color.Internal.fromHexString


{-| Like fromHex, but uses transparent (`rgba 0 0 0 0`) as default value.
-}
fromHexUnsafe : String -> Color
fromHexUnsafe =
    Maybe.withDefault (rgba 0 0 0 0) << Color.Internal.fromHexString



-- Convert


{-| Deconstruct a Color into its rgba channels.
-}
toRgba :
    Color
    ->
        { red : Float
        , green : Float
        , blue : Float
        , alpha : Float
        }
toRgba =
    Color.Internal.toRgba


{-| Deconstruct a Color into its hsla channels.
-}
toHsla :
    Color
    ->
        { hue : Float
        , saturation : Float
        , lightness : Float
        , alpha : Float
        }
toHsla =
    Color.Hsl.toHsla


{-| Deconstruct a Color into its rgba255 channels.
-}
toRgba255 :
    Color
    ->
        { red : Int
        , green : Int
        , blue : Int
        , alpha : Int
        }
toRgba255 =
    Color.Internal.toRgba255


{-| Convert a color to an hex string. Use `toHexString` to omit the `#`-prefix.

    toHexString (rgb 0.5 0.5 0.5) --> "#808080"

-}
toCssString : Color -> String
toCssString =
    Color.Internal.toCssString


{-| Convert a color to an hex string. Use `toCssString` if you want a `#`-prefixed hex value.

    toHexString (rgb 0.5 0.5 0.5) --> "808080"

-}
toHexString : Color -> String
toHexString =
    Color.Internal.toHexString



-- Extract


{-| Get the lightness value of an color if projected into the HSL space.
-}
getLightness : Color -> Float
getLightness =
    .lightness << toHsla


{-| Determine wether the color is a light color. Uses `lightness >= 0.5` of the color in HSL space.
-}
isLight : Color -> Bool
isLight =
    (\c -> c >= 0.5) << getLightness



-- Manipulate


{-| Invert a color by flipping its r g b values
-}
invertRgb : Color -> Color
invertRgb =
    mapRgb (\c -> 1 - c)


{-| Set the alpha of the color
-}
setAlpha : Float -> Color -> Color
setAlpha a (Rgba r g b _) =
    Rgba r g b a
