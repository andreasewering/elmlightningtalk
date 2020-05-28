module Codesplitting.Route2 exposing (..)

import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)


type alias Model =
    Int


type Msg
    = Increment
    | Decrement


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment ->
            ( model + 3, Cmd.none )

        Decrement ->
            ( model - 3, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ text <| String.fromInt model
        , button [ onClick Increment ] [ text "Plus 3" ]
        , button [ onClick Decrement ] [ text "Minus 3" ]
        ]


main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> ( 0, Cmd.none )
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }
