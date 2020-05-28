port module Codesplitting.Main exposing (main)

import Browser exposing (Document)
import Browser.Navigation
import Codesplitting.Navbar as Nav
import Codesplitting.Routes as Route exposing (Route)
import Html exposing (Html, div, text)
import Html.Attributes exposing (id)
import Json.Decode as Decode
import Url exposing (Url)


port changeRoute : Decode.Value -> Cmd msg


port reactToRoute : (Decode.Value -> msg) -> Sub msg


type alias Model =
    { key : Browser.Navigation.Key
    , currentRoute : Maybe Route
    }


type Msg
    = UrlRequested Browser.UrlRequest
    | UrlChanged Url
    | ReactToRoute (Maybe Route)
    | NoOp


init : () -> Url -> Browser.Navigation.Key -> ( Model, Cmd Msg )
init () url key =
    let
        ( route, cmd ) =
            updateRoute url
    in
    ( { key = key
      , currentRoute = route
      }
    , cmd
    )


updateRoute : Url -> ( Maybe Route, Cmd Msg )
updateRoute url =
    let
        maybeRoute =
            Route.fromUrl url

        cmd =
            case maybeRoute of
                Just route ->
                    changeRoute <| Route.encode route

                Nothing ->
                    Cmd.none
    in
    ( maybeRoute, cmd )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlRequested urlRequest ->
            case urlRequest of
                Browser.Internal internalUrl ->
                    ( model, Browser.Navigation.pushUrl model.key (Url.toString internalUrl) )

                Browser.External externalUrl ->
                    ( model, Browser.Navigation.load externalUrl )

        UrlChanged url ->
            Tuple.mapFirst (\route -> { model | currentRoute = route }) <| updateRoute url

        NoOp ->
            ( model, Cmd.none )

        ReactToRoute maybeRoute ->
            case maybeRoute of
                Just route ->
                    ( { model | currentRoute = maybeRoute }, changeRoute <| Route.encode route )

                Nothing ->
                    ( { model | currentRoute = maybeRoute }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    reactToRoute
        (\val ->
            case Route.decode val of
                Ok route ->
                    ReactToRoute route

                Err _ ->
                    NoOp
        )


view : Model -> Document Msg
view model =
    { title = "Elm App"
    , body =
        [ Nav.view
        , Html.main_ [ id "content" ] [ div [] <| viewRoute model ]
        ]
    }


viewRoute : Model -> List (Html msg)
viewRoute model =
    case model.currentRoute of
        Just _ ->
            []

        Nothing ->
            [ text "Page not found" ]


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        , onUrlRequest = UrlRequested
        , onUrlChange = UrlChanged
        }
