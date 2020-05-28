module Codesplitting.Routes exposing (..)

import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode
import Url exposing (Url)


type Route
    = Home
    | Route1
    | Route2


fromUrl : Url -> Maybe Route
fromUrl =
    .path >> fromString


fromString : String -> Maybe Route
fromString string =
    case string of
        "/" ->
            Just Home

        "/route1" ->
            Just Route1

        "/route2" ->
            Just Route2

        _ ->
            Nothing


toString : Route -> String
toString route =
    case route of
        Home ->
            "/"

        Route1 ->
            "/route1"

        Route2 ->
            "/route2"


decode : Decode.Value -> Result Decode.Error (Maybe Route)
decode =
    Decode.decodeValue decoder


decoder : Decoder (Maybe Route)
decoder =
    Decode.string |> Decode.andThen (Decode.succeed << fromString)


encode : Route -> Encode.Value
encode =
    toString >> Encode.string
