module Color.Internal exposing (..)

import Color.Utils exposing (clamp01)


type Color
    = Rgba Float Float Float Float



-- Construct


rgba : Float -> Float -> Float -> Float -> Color
rgba r g b a =
    Rgba
        (clamp01 r)
        (clamp01 g)
        (clamp01 b)
        (clamp01 a)


rgb : Float -> Float -> Float -> Color
rgb r g b =
    rgba r g b 1.0



-- Converter Helpers


toRgba : Color -> { red : Float, green : Float, blue : Float, alpha : Float }
toRgba (Rgba r g b a) =
    { red = r, green = g, blue = b, alpha = a }


toRgba255 : Color -> { red : Int, green : Int, blue : Int, alpha : Int }
toRgba255 (Rgba r g b a) =
    { red = round (r * 0xFF)
    , green = round (g * 0xFF)
    , blue = round (b * 0xFF)
    , alpha = round (a * 0xFF)
    }



-- Constructor Helpers


rgb255 : Int -> Int -> Int -> Color
rgb255 r g b =
    rgba
        (toFloat r / 0xFF)
        (toFloat g / 0xFF)
        (toFloat b / 0xFF)
        1.0


rgba255 : Int -> Int -> Int -> Int -> Color
rgba255 r g b a =
    rgba
        (toFloat r / 0xFF)
        (toFloat g / 0xFF)
        (toFloat b / 0xFF)
        (toFloat a / 0xFF)
