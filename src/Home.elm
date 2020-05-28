module Home exposing (view)

import Css exposing (backgroundColor, fontSize, padding, px, rem, rgb)
import Html exposing (Html)
import Html.Styled exposing (div, text, toUnstyled)
import Html.Styled.Attributes exposing (css)
import Viewport exposing (Viewport)


view : Viewport -> Html msg
view { x, y } =
    infoBox
        [ text <|
            "Current browser viewport is width: "
                ++ String.fromInt x
                ++ ", height: "
                ++ String.fromInt y
        ]


infoBox : List (Html.Styled.Html msg) -> Html msg
infoBox content =
    toUnstyled <| div [ css [ backgroundColor (rgb 220 192 44), padding (px 20), fontSize (rem 2) ] ] content
