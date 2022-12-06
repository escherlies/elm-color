# elm-color

A general library to work with web colors.

# Example

You can now programmatically work with colors.

![](./docs/Example.png)

# Usage

Use one of the builders to create a color

```elm
colors : List Color
colors =
    [ hsl 194 0.49 0.14
    , fromHexUnsafe "#06A77D"
    , rgb 0.96 0.976 0.996
    , rgb255 122 137 194
    ]


green : Color
green =
    hsl 164 0.93 0.34


viewHtml : Html msg
viewHtml =
    Html.div
        [ style "background-color" (Color.toCssString green)
        ]
        [ Html.text (toCssString green) ]


{-| Elm-UI example

For elm-ui see <https://package.elm-lang.org/packages/mdgriffith/elm-ui/latest/>

-}
view : Element msg
view =
    el
        [ Element.Background.color (toElementColor green)
        ]
        (text (toCssString green))


{-| Helper to convert to elm-ui color
-}
toElementColor : Color -> Element.Color
toElementColor =
    Element.fromRgb << Color.toRgba
```

# Notes

## Drop in replacement for avh4/elm-color

This library is a new implementation but shares the same api as [avh4/elm-color](https://package.elm-lang.org/packages/avh4/elm-color/latest/). Since that library doesn't seem to be actively maintained anymore, you can use this lib as a drop-in replacement.

