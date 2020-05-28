port module JSInterop exposing (..)

import Element exposing (Element, centerX, fill, mouseOver, padding, rgb, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input
import Element.Region as Region
import Html exposing (Html, node, text)
import Html.Events
import Json.Decode as Decode


port toJs : Int -> Cmd msg


port fromJs : (Decode.Value -> msg) -> Sub msg


type alias Model =
    { sentToJs : List Int
    , receivedFromJs : List (Result Decode.Error Int)
    }


type Msg
    = ReceivedJS Decode.Value
    | SendToJS Int
    | Reset


init : Model
init =
    { sentToJs = [], receivedFromJs = [] }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ReceivedJS value ->
            ( { model | receivedFromJs = Decode.decodeValue Decode.int value :: model.receivedFromJs }, Cmd.none )

        SendToJS int ->
            ( { model | sentToJs = int :: model.sentToJs }, toJs int )

        Reset ->
            ( init, Cmd.none )


view : Model -> Html Msg
view { sentToJs, receivedFromJs } =
    Element.layout [] <|
        Element.column [ width fill ]
            [ Element.el [ Region.heading 1, centerX, padding 20 ] <| Element.text "Square some numbers using good ol' javascript!"
            , sendButtons 1 10
            , Element.row [ width fill ]
                [ viewSent sentToJs
                , viewReceived receivedFromJs
                ]
            , Element.html elmWriter
            ]


elmWriter : Html Msg
elmWriter =
    node "elm-sender" [ Html.Events.on "sendtoelm" <| Decode.succeed Reset ] [ text "Custom Reset!" ]


viewSent : List Int -> Element Msg
viewSent =
    Element.column
        [ width fill ]
        << List.map (String.fromInt >> Element.text >> Element.el [ centerX ])


viewReceived : List (Result Decode.Error Int) -> Element Msg
viewReceived =
    Element.column [ width fill ]
        << List.map viewSingleReceived


viewSingleReceived : Result Decode.Error Int -> Element Msg
viewSingleReceived result =
    Element.el [ centerX ] <|
        Element.text <|
            case result of
                Ok value ->
                    String.fromInt value

                Err error ->
                    Decode.errorToString error


sendButtons : Int -> Int -> Element Msg
sendButtons rangeStart rangeEnd =
    List.range rangeStart rangeEnd
        |> List.map sendButton
        |> Element.wrappedRow [ width fill ]


sendButton : Int -> Element Msg
sendButton int =
    Element.Input.button
        [ width fill
        , Font.center
        , padding 20
        , Border.width 1
        , Border.color (rgb 0.5 0.5 0.5)
        , mouseOver [ Background.color (rgb 0.2 0.2 0.2), Font.color (rgb 1 1 1) ]
        ]
        { onPress = Just <| SendToJS int
        , label = Element.text <| String.fromInt int
        }


subscriptions : Sub Msg
subscriptions =
    fromJs ReceivedJS
