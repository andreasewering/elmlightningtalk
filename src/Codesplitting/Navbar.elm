module Codesplitting.Navbar exposing (..)

import Codesplitting.Routes as Route exposing (Route)
import Html exposing (Html, a, div, text)
import Html.Attributes exposing (href)


view : Html msg
view =
    div []
        [ link Route.Home "Home"
        , link Route.Route1 "Route1"
        , link Route.Route2 "Route2"
        ]


link : Route -> String -> Html msg
link route string =
    a [ href <| Route.toString route ] [ text string ]
