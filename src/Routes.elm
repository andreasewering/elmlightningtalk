module Routes exposing (Route(..), fromUrl, toString)

import Url exposing (Url)


type Route
    = Home
    | JSInterop


fromUrl : Url -> Maybe Route
fromUrl url =
    case url.path of
        "/" ->
            Just Home

        "/js" ->
            Just JSInterop

        _ ->
            Nothing


toString : Route -> String
toString route =
    case route of
        Home ->
            "/"

        JSInterop ->
            "/js"
