module Color exposing
    ( Color
    , rgb, hsl, gray
    , fromHex, fromPalette, fromHexUnsafe
    , toCssString, toRgba, toHsla, toHexString, toRgba255
    , invertRgb, setAlpha
    , isLight, lightness
    , mapRgb, mapRed, mapGreen, mapBlue, mapAlpha
    , mapHue, mapLightness, mapSaturation
    , rgb255, rgba, hsla, rgba255, fromRgb, fromRgba, fromHsla, fromRgb255, fromHsl
    , black, white
    )

{-| An Elm package to work with web colors.

Example usage

    colors : List Color
    colors =
        [ hsl 194 0.49 0.14
        , fromHexUnsafe "#06A77D"
        , rgb 0.96 0.976 0.996
        , rgb255 122 137 194
        ]

    colorPalette : List Color
    colorPalette =
        fromPalette "https://coolors.co/40f99b-61707d"

    green : Color
    green =
        hsl 164 0.93 0.34

    fontColor : Color
    fontColor =
        if isLight green then
            black

        else
            white

    viewHtml : Html msg
    viewHtml =
        Html.div
            [ style "background-color" (Color.toCssString green)
            , style "color" (Color.toCssString fontColor)
            ]
            [ Html.text (toCssString green) ]


# Types

@docs Color


# Creating colors


## Standard way

@docs rgb, hsl, gray


## From strings

@docs fromHex, fromPalette, fromHexUnsafe


# Convert

@docs toCssString, toRgba, toHsla, toHexString, toRgba255


# Manipulate

@docs invertRgb, setAlpha


# Lightness

@docs isLight, lightness


# Transform


## Rgb

@docs mapRgb, mapRed, mapGreen, mapBlue, mapAlpha


## HSL

@docs mapHue, mapLightness, mapSaturation


# Variants

More constructors

@docs rgb255, rgba, hsla, rgba255, fromRgb, fromRgba, fromHsla, fromRgb255, fromHsl


# Helper colors

@docs black, white

-}

import Color.Hex
import Color.Hsl
import Color.Internal exposing (Color(..))
import Color.Lightness
import Color.Palette
import Color.Transform
import Color.Utils exposing (callTrice)


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
    --> List.filterMap Color.fromHex [ "fffffc", "00eb80" ] : List Color

    fromPalette """
                fffffc
                00eb80
                000000
                """
    --> List.filterMap Color.fromHex [ "fffffc", "00eb80", "000000" ] : List Color

    fromPalette "https://coolors.co/40f99b-61707d"
    --> List.filterMap Color.fromHex [ "40f99b", "61707d" ] : List Color

    -- Infact, it works with everything that has 6 digits hex values
    fromPalette "xxxxfffffc-00eb80x000000---"
    --> List.filterMap Color.fromHex [ "fffffc", "00eb80", "000000" ] : List Color

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
fromHsl hsl_ =
    Color.Hsl.hsla hsl_.hue hsl_.saturation hsl_.lightness 1


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
    Color.Hex.fromHexString


{-| Like fromHex, but uses transparent (`rgba 0 0 0 0`) as default value.
-}
fromHexUnsafe : String -> Color
fromHexUnsafe =
    Maybe.withDefault (rgba 0 0 0 0) << Color.Hex.fromHexString



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
    Color.Hex.toCssString


{-| Convert a color to an hex string. Use `toCssString` if you want a `#`-prefixed hex value.

    toHexString (rgb 0.5 0.5 0.5) --> "808080"

-}
toHexString : Color -> String
toHexString =
    Color.Hex.toHexString



-- Lightness


{-| Determine if a color is light, that is, if the lightness is over 50% (`L* > 0.5`). Using the L\* CIELAB color space for human percieved lightness.

Useful for example if you want to change font color based on the lightness of the color.

-}
isLight : Color -> Bool
isLight c =
    lightness c > 50


{-| Lightness is the **visual perception** of the luminance L of an object. It is the L\* component of a color in the CIELAB and CIELUV space.

For more information on this, take a look at the implementation details!

-}
lightness : Color -> Float
lightness =
    Color.Lightness.lightness



-- Manipulate


{-| Invert a color by flipping its r g b values
-}
invertRgb : Color -> Color
invertRgb =
    Color.Transform.mapRgb (\c -> 1 - c)


{-| Set the alpha of the color
-}
setAlpha : Float -> Color -> Color
setAlpha a =
    mapAlpha (always a)



-- Transform HSL


{-| Map the hue of the color in HSL space
-}
mapHue : (Float -> Float) -> Color -> Color
mapHue =
    Color.Transform.mapHue


{-| Map the saturation of the color in HSL space
-}
mapSaturation : (Float -> Float) -> Color -> Color
mapSaturation =
    Color.Transform.mapSaturation


{-| Map the lightness in the HSL space

    darken : Color -> Color
    darken =
        mapLightness ((*) 0.95)

-}
mapLightness : (Float -> Float) -> Color -> Color
mapLightness =
    Color.Transform.mapLightness



-- Transform RGB


{-| Map over rgb channels

    invertRgb : Color -> Color
    invertRgb =
        mapRgb (\c -> 1 - c)

-}
mapRgb : (Float -> Float) -> Color -> Color
mapRgb =
    Color.Transform.mapRgb


{-| -}
mapRed : (Float -> Float) -> Color -> Color
mapRed =
    Color.Transform.mapRed


{-| -}
mapGreen : (Float -> Float) -> Color -> Color
mapGreen =
    Color.Transform.mapGreen


{-| -}
mapBlue : (Float -> Float) -> Color -> Color
mapBlue =
    Color.Transform.mapBlue


{-| -}
mapAlpha : (Float -> Float) -> Color -> Color
mapAlpha =
    Color.Transform.mapAlpha



--


{-| Create a gray color. I.e. for a 50% gray: `gray 0.5`
-}
gray : Float -> Color
gray =
    callTrice rgb


{-| #000000
-}
black : Color
black =
    gray 0


{-| #FFFFFF
-}
white : Color
white =
    gray 1
