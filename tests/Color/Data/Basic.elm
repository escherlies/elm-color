module Color.Data.Basic exposing (..)

{-| Basic Data Set
-}


{-| Basic data

    Rot 0° 100% 100% 0° 100% 50% 100% 0% 0%

-}
type alias Basic =
    { name : String
    , hsv : { h : Int, s : Int, v : Int }
    , hsl : { h : Int, s : Int, l : Int }
    , rgb : { r : Int, g : Int, b : Int }
    }


{-| Test Data

Source <https://de.wikipedia.org/wiki/HSV-Farbraum>

-}
basic : List Basic
basic =
    [ { name = "Rot", hsv = { h = 0, s = 100, v = 100 }, hsl = { h = 0, s = 100, l = 50 }, rgb = { r = 100, g = 0, b = 0 } }
    , { name = "Orangerot", hsv = { h = 15, s = 100, v = 100 }, hsl = { h = 15, s = 100, l = 50 }, rgb = { r = 100, g = 25, b = 0 } }
    , { name = "Orange", hsv = { h = 30, s = 100, v = 100 }, hsl = { h = 30, s = 100, l = 50 }, rgb = { r = 100, g = 50, b = 0 } }
    , { name = "Orangegelb", hsv = { h = 45, s = 100, v = 100 }, hsl = { h = 45, s = 100, l = 50 }, rgb = { r = 100, g = 75, b = 0 } }
    , { name = "Gelb", hsv = { h = 60, s = 100, v = 100 }, hsl = { h = 60, s = 100, l = 50 }, rgb = { r = 100, g = 100, b = 0 } }
    , { name = "Grüngelb", hsv = { h = 75, s = 100, v = 100 }, hsl = { h = 75, s = 100, l = 50 }, rgb = { r = 75, g = 100, b = 0 } }
    , { name = "Grasgrün", hsv = { h = 90, s = 100, v = 100 }, hsl = { h = 90, s = 100, l = 50 }, rgb = { r = 50, g = 100, b = 0 } }
    , { name = "Gelbgrün", hsv = { h = 105, s = 100, v = 100 }, hsl = { h = 105, s = 100, l = 50 }, rgb = { r = 25, g = 100, b = 0 } }
    , { name = "Hellgrün", hsv = { h = 120, s = 100, v = 100 }, hsl = { h = 120, s = 100, l = 50 }, rgb = { r = 0, g = 100, b = 0 } }
    , { name = "Leichtes_Blaugrün", hsv = { h = 135, s = 100, v = 100 }, hsl = { h = 135, s = 100, l = 50 }, rgb = { r = 0, g = 100, b = 25 } }
    , { name = "Frühlingsgrün", hsv = { h = 150, s = 100, v = 100 }, hsl = { h = 150, s = 100, l = 50 }, rgb = { r = 0, g = 100, b = 50 } }
    , { name = "Grüncyan", hsv = { h = 165, s = 100, v = 100 }, hsl = { h = 165, s = 100, l = 50 }, rgb = { r = 0, g = 100, b = 75 } }
    , { name = "Cyan", hsv = { h = 180, s = 100, v = 100 }, hsl = { h = 180, s = 100, l = 50 }, rgb = { r = 0, g = 100, b = 100 } }
    , { name = "Blaucyan", hsv = { h = 195, s = 100, v = 100 }, hsl = { h = 195, s = 100, l = 50 }, rgb = { r = 0, g = 75, b = 100 } }
    , { name = "Grünblau", hsv = { h = 210, s = 100, v = 100 }, hsl = { h = 210, s = 100, l = 50 }, rgb = { r = 0, g = 50, b = 100 } }
    , { name = "Leichtes_Grünblau", hsv = { h = 225, s = 100, v = 100 }, hsl = { h = 225, s = 100, l = 50 }, rgb = { r = 0, g = 25, b = 100 } }
    , { name = "Blau", hsv = { h = 240, s = 100, v = 100 }, hsl = { h = 240, s = 100, l = 50 }, rgb = { r = 0, g = 0, b = 100 } }
    , { name = "Indigo", hsv = { h = 255, s = 100, v = 100 }, hsl = { h = 255, s = 100, l = 50 }, rgb = { r = 25, g = 0, b = 100 } }
    , { name = "Violett", hsv = { h = 270, s = 100, v = 100 }, hsl = { h = 270, s = 100, l = 50 }, rgb = { r = 50, g = 0, b = 100 } }
    , { name = "Blaumagenta", hsv = { h = 285, s = 100, v = 100 }, hsl = { h = 285, s = 100, l = 50 }, rgb = { r = 75, g = 0, b = 100 } }
    , { name = "Magenta", hsv = { h = 300, s = 100, v = 100 }, hsl = { h = 300, s = 100, l = 50 }, rgb = { r = 100, g = 0, b = 100 } }
    , { name = "Rotmagenta", hsv = { h = 315, s = 100, v = 100 }, hsl = { h = 315, s = 100, l = 50 }, rgb = { r = 100, g = 0, b = 75 } }
    , { name = "Blaurot", hsv = { h = 330, s = 100, v = 100 }, hsl = { h = 330, s = 100, l = 50 }, rgb = { r = 100, g = 0, b = 50 } }
    , { name = "Leichtes_Blaurot", hsv = { h = 345, s = 100, v = 100 }, hsl = { h = 345, s = 100, l = 50 }, rgb = { r = 100, g = 0, b = 25 } }
    , { name = "Kastanie", hsv = { h = 0, s = 100, v = 50 }, hsl = { h = 0, s = 100, l = 25 }, rgb = { r = 50, g = 0, b = 0 } }
    , { name = "Oliv", hsv = { h = 60, s = 100, v = 50 }, hsl = { h = 60, s = 100, l = 25 }, rgb = { r = 50, g = 50, b = 0 } }
    , { name = "Grün", hsv = { h = 120, s = 100, v = 50 }, hsl = { h = 120, s = 100, l = 25 }, rgb = { r = 0, g = 50, b = 0 } }
    , { name = "Blaugrün", hsv = { h = 180, s = 100, v = 50 }, hsl = { h = 180, s = 100, l = 25 }, rgb = { r = 0, g = 50, b = 50 } }
    , { name = "Marineblau", hsv = { h = 240, s = 100, v = 50 }, hsl = { h = 240, s = 100, l = 25 }, rgb = { r = 0, g = 0, b = 50 } }
    , { name = "Purpur", hsv = { h = 300, s = 100, v = 50 }, hsl = { h = 300, s = 100, l = 25 }, rgb = { r = 50, g = 0, b = 50 } }
    , { name = "Weiß", hsv = { h = 0, s = 0, v = 100 }, hsl = { h = 0, s = 0, l = 100 }, rgb = { r = 100, g = 100, b = 100 } }
    , { name = "Grau", hsv = { h = 0, s = 0, v = 50 }, hsl = { h = 0, s = 0, l = 50 }, rgb = { r = 50, g = 50, b = 50 } }
    , { name = "Schwarz", hsv = { h = 0, s = 0, v = 0 }, hsl = { h = 0, s = 0, l = 0 }, rgb = { r = 0, g = 0, b = 0 } }
    ]
