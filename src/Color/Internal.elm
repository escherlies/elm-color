module Color.Internal exposing (..)

import Bitwise
import Hex


type Color
    = Rgba Float Float Float Float


type alias Channels =
    { r : Float
    , g : Float
    , b : Float
    , a : Float
    }



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



-- Parse


fromHexString : String -> Maybe Color
fromHexString =
    Maybe.map fromInt << Result.toMaybe << intFromColorString



-- Convert


toCssString : Color -> String
toCssString s =
    "#" ++ toHexString s


toHexString : Color -> String
toHexString =
    String.concat << List.map (String.padLeft 2 '0' << Hex.toString) << toRgba255List



-- Parser Helpers


intFromColorString : String -> Result String Int
intFromColorString =
    Hex.fromString << String.toLower << normalizeCssFormatsFromString << stripPrefix


{-| Normalize to 8-digit hex strings
-}
normalizeCssFormatsFromString : String -> String
normalizeCssFormatsFromString s =
    String.fromList <|
        case String.toList s of
            -- Css shorties (#)FFF
            [ r, g, b ] ->
                [ r, r, g, g, b, b, 'F', 'F' ]

            -- Css without alpha (#)FFFFFF
            [ r1, r0, g1, g0, b1, b0 ] ->
                [ r1, r0, g1, g0, b1, b0, 'F', 'F' ]

            rest ->
                rest


stripPrefix : String -> String
stripPrefix s =
    (case String.toList s of
        -- Css colors #FFFFFF
        '#' :: rest ->
            rest

        -- Prefixed hex values 0xFFFFFF
        '0' :: 'x' :: rest ->
            rest

        -- Hex values FFFFFF
        other ->
            other
    )
        |> String.fromList



-- Formater Helpers


hexToString6 : Int -> String
hexToString6 =
    String.padLeft 6 '0' << String.slice 0 6 << Hex.toString


hexToString8 : Int -> String
hexToString8 =
    String.padLeft 8 '0' << String.slice 0 8 << Hex.toString



-- Converter Helpers


toRgba : Color -> { red : Float, green : Float, blue : Float, alpha : Float }
toRgba (Rgba r g b a) =
    { red = r, green = g, blue = b, alpha = a }


toRgbaList : Color -> List Float
toRgbaList (Rgba r g b a) =
    [ r, g, b, a ]


toRgba255 : Color -> { red : Int, green : Int, blue : Int, alpha : Int }
toRgba255 (Rgba r g b a) =
    { red = round (r * 0xFF)
    , green = round (g * 0xFF)
    , blue = round (b * 0xFF)
    , alpha = round (a * 0xFF)
    }


toRgba255List : Color -> List Int
toRgba255List (Rgba r g b a) =
    [ round (r * 0xFF)
    , round (g * 0xFF)
    , round (b * 0xFF)
    , round (a * 0xFF)
    ]



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


{-| An integer representation of a color hex value

Paired with `Hex.fromString` and `Hex.toString`

-}
fromInt : Int -> Color
fromInt hex =
    rgba255
        (Bitwise.and 0xFF000000 hex |> Bitwise.shiftRightZfBy 24)
        (Bitwise.and 0x00FF0000 hex |> Bitwise.shiftRightZfBy 16)
        (Bitwise.and 0xFF00 hex |> Bitwise.shiftRightZfBy 8)
        (Bitwise.and 0xFF hex)
