module Color.Test.Utils exposing (..)

import Color.Internal exposing (Color(..))
import Expect
import Test exposing (..)


equalFloat : Float -> Float -> Expect.Expectation
equalFloat =
    Expect.within pico



-- Pico precision


pico : Expect.FloatingPointTolerance
pico =
    Expect.Absolute 1.0e-12
