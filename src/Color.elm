module Color exposing
    ( Color
    , fromHex
    , fromHsla
    , fromRgb
    , fromRgb255
    , fromRgba
    , hsl
    , hsla
    , invertRgb
    , rgb
    , rgb255
    , rgba
    , rgba255
    , setAlpha
    , toCssString
    , toHexString
    , toHsla
    , toRgba
    , toRgba255
    )

import Color.Hsl
import Color.Internal exposing (Color(..), mapRgb)


type alias Color =
    Color.Internal.Color



-- Build


rgb : Float -> Float -> Float -> Color
rgb =
    Color.Internal.rgb


rgba : Float -> Float -> Float -> Float -> Color
rgba =
    Color.Internal.rgba


rgb255 : Int -> Int -> Int -> Color
rgb255 =
    Color.Internal.rgb255


rgba255 : Int -> Int -> Int -> Int -> Color
rgba255 =
    Color.Internal.rgba255


hsl : Float -> Float -> Float -> Color
hsl =
    Color.Hsl.hsl


hsla : Float -> Float -> Float -> Float -> Color
hsla =
    Color.Hsl.hsla


fromRgba :
    { red : Float
    , green : Float
    , blue : Float
    , alpha : Float
    }
    -> Color
fromRgba { red, green, blue, alpha } =
    Color.Internal.rgba red green blue alpha


fromRgb :
    { red : Float
    , green : Float
    , blue : Float
    }
    -> Color
fromRgb { red, green, blue } =
    Color.Internal.rgba red green blue 1


fromRgb255 :
    { red : Int
    , green : Int
    , blue : Int
    }
    -> Color
fromRgb255 { red, green, blue } =
    Color.Internal.rgb255 red green blue


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


fromHex : String -> Maybe Color
fromHex =
    Color.Internal.fromHexString



-- Convert


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


toCssString : Color -> String
toCssString =
    Color.Internal.toCssString


toHexString : Color -> String
toHexString =
    Color.Internal.toHexString



-- Manipulate


invertRgb : Color -> Color
invertRgb =
    mapRgb (\c -> 1 - c)


setAlpha : Float -> Color -> Color
setAlpha a (Rgba r g b _) =
    Rgba r g b a
