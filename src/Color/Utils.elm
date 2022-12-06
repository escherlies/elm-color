module Color.Utils exposing (..)

{-| Utils
-}


{-| Perform [modular arithmetic](https://en.wikipedia.org/wiki/Modular_arithmetic)
involving floating point numbers.

The sign of the result is the same as the sign of the `modulus` in `fractionalModBy modulus x`.

    fractionalModBy 2.5 5 --> 0

    fractionalModBy 2 4.5 == 0.5

    fractionalModBy 2 -4.5 == 1.5

    fractionalModBy -2 4.5 == -1.5

Source: <https://github.com/elm-community/basics-extra/blob/4.1.0/src/Basics/Extra.elm#L203>

-}
fractionalModBy : Float -> Float -> Float
fractionalModBy modulus x =
    x - modulus * toFloat (floor (x / modulus))
