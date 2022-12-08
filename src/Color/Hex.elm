module Color.Hex exposing (..)

import Bitwise
import Color.Internal exposing (Color(..), rgba255)
import Hex



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
    String.concat << List.map (String.padLeft 2 '0' << Hex.toString) << dropAlpha << toRgba255List


dropAlpha : List Int -> List Int
dropAlpha rgbas =
    case rgbas of
        r :: g :: b :: a :: [] ->
            if a == 0xFF then
                [ r, g, b ]

            else
                rgbas

        _ ->
            rgbas


toRgba255List : Color -> List Int
toRgba255List (Rgba r g b a) =
    [ round (r * 0xFF)
    , round (g * 0xFF)
    , round (b * 0xFF)
    , round (a * 0xFF)
    ]


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
