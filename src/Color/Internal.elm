module Color.Internal exposing (..)


type Color
    = Rgba Float Float Float Float



-- Construct


rgba : Float -> Float -> Float -> Float -> Color
rgba =
    Rgba


rgb : Float -> Float -> Float -> Color
rgb r g b =
    Rgba r g b 1.0



-- Transform


mapRgb : (Float -> Float) -> Color -> Color
mapRgb fn (Rgba r g b a) =
    Rgba (fn r) (fn g) (fn b) a



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
    Rgba
        (toFloat r / 0xFF)
        (toFloat g / 0xFF)
        (toFloat b / 0xFF)
        1.0


rgba255 : Int -> Int -> Int -> Int -> Color
rgba255 r g b a =
    Rgba
        (toFloat r / 0xFF)
        (toFloat g / 0xFF)
        (toFloat b / 0xFF)
        (toFloat a / 0xFF)
