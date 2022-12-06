module Color.Palette exposing (fromPalette, parsePalette)

import Char
import Color
import Color.Internal exposing (Color(..))
import Parser exposing ((|.), (|=), Parser, Step(..), chompWhile, end, getChompedString, oneOf, run, succeed)


fromPalette : String -> List Color
fromPalette =
    List.filterMap Color.fromHex << Result.withDefault [] << parsePalette


{-| Parses different palette formats

    parsePalette "https://huemint.com/website-monochrome/#palette=fffffc-00eb80"
    --> Ok [ "fffffc", "00eb80" ]

    parsePalette """
                fffffc
                00eb80
                000000
                """
    --> Ok [ "fffffc", "00eb80", "000000" ]

    parsePalette "https://coolors.co/40f99b-61707d"
    --> Ok [ "40f99b", "61707d" ]

    -- Infact, it works with everything that has 6 digits hex values
    parsePalette "xxxxfffffc-00eb80x000000---"
    --> Ok [ "fffffc", "00eb80", "000000" ]

-}
parsePalette : String -> Result (List Parser.DeadEnd) (List String)
parsePalette =
    run parseHexDigitsList


{-| Parse a string of hex values, i.e. faf2d7-131be0-f700bf
-}
parseHexDigitsList : Parser (List String)
parseHexDigitsList =
    parseHexDigitsListRec []


{-| Recursively parse a string of hex values, i.e. faf2d7-131be0-f700bf
-}
parseHexDigitsListRec : List String -> Parser (List String)
parseHexDigitsListRec from =
    oneOf
        [ succeed (List.reverse from) |. end
        , getHexDigits
            |> Parser.andThen
                (\s ->
                    if s == "" then
                        -- Since chompWhile always succeeds,
                        -- indicate a problem here to use the next of oneOf
                        Parser.problem ""

                    else if String.length s == 6 then
                        -- Only keep 6-digit hex values
                        parseHexDigitsListRec (s :: from)

                    else
                        -- Discard other values and carry on
                        parseHexDigitsListRec from
                )
        , chompWhile (not << Char.isHexDigit)
            |> Parser.andThen
                (\_ -> parseHexDigitsListRec from)
        ]


getHexDigits : Parser String
getHexDigits =
    getChompedString
        (chompWhile Char.isHexDigit)
