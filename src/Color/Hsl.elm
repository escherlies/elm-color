module Color.Hsl exposing (..)

import Color.Internal exposing (Color(..), rgba)
import Color.Utils exposing (clamp01, fractionalModBy)


{-| From rgba color

Adapted from <https://de.wikipedia.org/wiki/HSV-Farbraum#Umrechnung_RGB_in_HSV/HSL>

-}
toHsla : Color -> { hue : Float, saturation : Float, lightness : Float, alpha : Float }
toHsla (Rgba red green blue alpha) =
    let
        colorMax =
            red
                |> max green
                |> max blue

        colorMin =
            red
                |> min green
                |> min blue

        chroma =
            colorMax - colorMin

        h =
            if colorMax == colorMin then
                0

            else if colorMax == red then
                60 * (0 + ((green - blue) / chroma))

            else if colorMax == green then
                60 * (2 + ((blue - red) / chroma))

            else if colorMax == blue then
                60 * (4 + ((red - green) / chroma))

            else
                0

        s =
            if colorMax == colorMin then
                0

            else
                chroma
                    / (1 - abs (colorMax + colorMin - 1))

        l =
            (colorMax + colorMin) / 2
    in
    { hue = h |> fractionalModBy 360
    , saturation = s
    , lightness = l
    , alpha = alpha
    }


{-| To Rgb

Adapted from <https://www.w3.org/TR/css-color-3/#hsl-color>

```js
    function hslToRgb (hue, sat, light) {
      hue = hue % 360;
      if (hue < 0) {
          hue += 360;
      }
      sat /= 100;
      light /= 100;
      function f(n) {
          let k = (n + hue/30) % 12;
          let a = sat * Math.min(light, 1 - light);
          return light - a * Math.max(-1, Math.min(k - 3, 9 - k, 1));
      }
      return [f(0), f(8), f(4)];
    }
```

-}
hsla : Float -> Float -> Float -> Float -> Color
hsla hue saturation lightness alpha =
    let
        h =
            hue |> fractionalModBy 360

        l =
            clamp01 lightness

        s =
            clamp01 saturation

        f n =
            let
                k =
                    (n + h / 30) |> fractionalModBy 12

                a =
                    s * min l (1 - l)
            in
            l - a * max -1 (min (k - 3) (min (9 - k) 1))
    in
    rgba
        (f 0)
        (f 8)
        (f 4)
        alpha



-- Convenience


fromHsla :
    { hue : Float
    , saturation : Float
    , lightness : Float
    , alpha : Float
    }
    -> Color
fromHsla { hue, saturation, lightness, alpha } =
    hsla hue saturation lightness alpha


hsl : Float -> Float -> Float -> Color
hsl h s l =
    hsla h s l 1
