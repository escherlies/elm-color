module Main exposing (..)

import Browser
import Color exposing (fromHexUnsafe, hsl, hsla, rgb, rgb255, toCssString, toHsla)
import Element exposing (alpha, centerX, centerY, column, el, fill, height, layout, padding, paragraph, px, row, spacing, text, width)
import Element.Background
import Element.Font
import Html exposing (Html)


main : Program () () ()
main =
    Browser.sandbox
        { init = ()
        , view = view
        , update = always always ()
        }


toElementColor : Color.Color -> Element.Color
toElementColor =
    Element.fromRgb << Color.toRgba


view : () -> Html ()
view _ =
    layout
        [ width fill
        , height fill
        , Element.Font.size 12
        , Element.Font.family [ Element.Font.monospace ]
        ]
        (column
            [ centerX
            , centerY
            , spacing 20
            ]
            [ el [ Element.Font.bold, Element.Font.size 15 ] <| text "elm-color examples"
            , row
                [ spacing 20
                ]
                [ shadesAnnotation
                , viewShades "hsl 194 0.49 0.14" (hsl 194 0.49 0.14)
                , viewShades "fromHex \"#06A77D\"" (fromHexUnsafe "#06A77D")
                , viewShades "rgb 0.96 0.976 0.996" (rgb 0.96 0.976 0.996)
                , viewShades "rgb255 122 137 194" (rgb255 122 137 194)
                ]
            , row [ width fill ]
                (List.map
                    (\c ->
                        el
                            [ width fill
                            , height (px 20)
                            , Element.Background.color (toElementColor c)
                            ]
                            Element.none
                    )
                    (List.map
                        (\r ->
                            hsl 0 0 (toFloat r / 20)
                        )
                        (List.range 0 20)
                    )
                )
            ]
        )


viewShades : String -> Color.Color -> Element.Element ()
viewShades s color =
    column [ spacing 20 ]
        [ paragraph [ Element.Font.size 12 ] [ text s ]
        , shades color
        ]


shades : Color.Color -> Element.Element ()
shades color =
    let
        { hue, saturation, lightness, alpha } =
            toHsla color
    in
    column [ centerX, centerY ] <|
        List.map
            (\range ->
                let
                    c =
                        hsla hue saturation (lightness + toFloat range / 10) alpha
                in
                el
                    [ Element.Background.color (toElementColor c)
                    , width (px 170)
                    , height (px 50)
                    , Element.Font.center
                    , Element.inFront
                        (el
                            [ width fill
                            , height fill
                            , Element.Font.color
                                (if Color.isLight c then
                                    toElementColor (rgb 0 0 0)

                                 else
                                    toElementColor (rgb 1 1 1)
                                )
                            , Element.alpha 0
                            , Element.mouseOver
                                [ Element.alpha 1
                                ]
                            ]
                         <|
                            (el [ centerX, centerY ] <| text (toCssString c))
                        )
                    ]
                    Element.none
            )
            (List.reverse <| List.range -1 1)


shadesAnnotation : Element.Element ()
shadesAnnotation =
    column [ height fill, spacing 20 ]
        [ text "Lightness"
        , column [ centerX, centerY, spacing 10, height fill ] <|
            List.map
                (\range ->
                    el
                        [ padding 0
                        , Element.Font.center
                        , height fill
                        ]
                        (el [ centerY ] <|
                            text
                                ((if range >= 0 then
                                    "+"

                                  else
                                    ""
                                 )
                                    ++ String.fromInt (range * 10)
                                    ++ "%"
                                )
                        )
                )
                (List.reverse <| List.range -1 1)
        ]



--
