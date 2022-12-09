module Color.Transform exposing (..)

import Color.Hsl
import Color.Internal exposing (Color(..))



-- Transform


mapRgb : (Float -> Float) -> Color -> Color
mapRgb fn (Rgba r g b a) =
    Rgba (fn r) (fn g) (fn b) a


mapRed : (Float -> Float) -> Color -> Color
mapRed fn (Rgba r g b a) =
    Rgba (fn r) g b a


mapGreen : (Float -> Float) -> Color -> Color
mapGreen fn (Rgba r g b a) =
    Rgba r (fn g) b a


mapBlue : (Float -> Float) -> Color -> Color
mapBlue fn (Rgba r g b a) =
    Rgba r g (fn b) a


mapAlpha : (Float -> Float) -> Color -> Color
mapAlpha fn (Rgba r g b a) =
    Rgba r g b (fn a)



-- HSL Mappers


mapHue : (Float -> Float) -> Color -> Color
mapHue fn =
    mapHueHsl fn << Color.Hsl.toHsla


mapSaturation : (Float -> Float) -> Color -> Color
mapSaturation fn =
    mapSaturationHsl fn << Color.Hsl.toHsla


mapLightness : (Float -> Float) -> Color -> Color
mapLightness fn =
    mapLightnessHsl fn << Color.Hsl.toHsla



-- Map HSL


mapHueHsl : (Float -> Float) -> { hsl | hue : Float, saturation : Float, lightness : Float, alpha : Float } -> Color
mapHueHsl fn hsl =
    Color.Hsl.hsla
        (fn hsl.hue)
        hsl.saturation
        hsl.lightness
        hsl.alpha


mapSaturationHsl : (Float -> Float) -> { hsl | hue : Float, saturation : Float, lightness : Float, alpha : Float } -> Color
mapSaturationHsl fn hsl =
    Color.Hsl.hsla
        hsl.hue
        (fn hsl.saturation)
        hsl.lightness
        hsl.alpha


mapLightnessHsl : (Float -> Float) -> { hsl | hue : Float, saturation : Float, lightness : Float, alpha : Float } -> Color
mapLightnessHsl fn hsl =
    Color.Hsl.hsla
        hsl.hue
        hsl.saturation
        (fn hsl.lightness)
        hsl.alpha
