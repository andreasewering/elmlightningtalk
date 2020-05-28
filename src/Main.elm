module Main exposing (main)

import Browser exposing (Document)
import Browser.Events
import Browser.Navigation
import Home
import Html exposing (Html, button, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import JSInterop
import Navbar
import Routes exposing (Route)
import Url exposing (Url)
import Viewport exposing (Viewport)


type alias Model =
    { viewPort : Viewport
    , key : Browser.Navigation.Key
    , currentRoute : Maybe Route
    , nextUrl : Maybe Url
    , jsInterop : JSInterop.Model
    }


type Msg
    = Resized Int Int
    | ContinuedNavigation Url
    | UrlRequested Browser.UrlRequest
    | UrlChanged Url
    | JSMessage JSInterop.Msg


init : Viewport -> Url -> Browser.Navigation.Key -> ( Model, Cmd Msg )
init viewPort url key =
    ( { viewPort = viewPort
      , key = key
      , currentRoute = Routes.fromUrl url
      , nextUrl = Nothing
      , jsInterop = JSInterop.init
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Resized x y ->
            ( { model | viewPort = { x = x, y = y } }, Cmd.none )

        UrlRequested urlRequest ->
            case urlRequest of
                Browser.Internal internalUrl ->
                    ( { model | nextUrl = Just internalUrl }, Cmd.none )

                Browser.External externalUrl ->
                    ( model, Browser.Navigation.load externalUrl )

        UrlChanged url ->
            ( { model | currentRoute = Routes.fromUrl url }, Cmd.none )

        ContinuedNavigation url ->
            ( { model | nextUrl = Nothing }, Url.toString url |> Browser.Navigation.pushUrl model.key )

        JSMessage jsMsg ->
            let
                ( jsInterop, command ) =
                    JSInterop.update jsMsg model.jsInterop
            in
            ( { model | jsInterop = jsInterop }, Cmd.map JSMessage command )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ Browser.Events.onResize Resized
        , JSInterop.subscriptions |> Sub.map JSMessage
        ]


view : Model -> Document Msg
view model =
    { title = "Elm App"
    , body =
        [ Navbar.view
        , Html.main_ [ class "content" ] <| [ viewRoute model ] ++ confirmNavigation model.nextUrl
        ]
    }


viewRoute : Model -> Html Msg
viewRoute model =
    case model.currentRoute of
        Just Routes.Home ->
            Home.view model.viewPort

        Just Routes.JSInterop ->
            JSInterop.view model.jsInterop |> Html.map JSMessage

        Nothing ->
            text "Page not found"


confirmNavigation : Maybe Url -> List (Html Msg)
confirmNavigation nextUrl =
    case nextUrl of
        Just url ->
            [ button
                [ onClick <| ContinuedNavigation url
                ]
                [ text <| "Continue going to " ++ url.path ]
            ]

        Nothing ->
            []


main : Program Viewport Model Msg
main =
    Browser.application
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        , onUrlRequest = UrlRequested
        , onUrlChange = UrlChanged
        }
