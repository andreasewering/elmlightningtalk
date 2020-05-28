module Navbar exposing (view)

import Html exposing (Html, a, li, nav, ol, text)
import Html.Attributes exposing (class, href)
import Routes


type alias Link =
    { route : Routes.Route
    , label : String
    }


links : List Link
links =
    [ { route = Routes.Home, label = "Home" }
    , { route = Routes.JSInterop, label = "Hello Javascript" }
    ]


view : Html msg
view =
    nav []
        [ ol [ class "nav-items" ] <| List.map (li [ class "nav-item" ] << List.singleton << navbarLink) links
        ]


navbarLink : Link -> Html msg
navbarLink { route, label } =
    a [ href <| Routes.toString route ] [ text label ]
