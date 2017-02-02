module Main exposing (..)

import Html
import Html.Attributes exposing (style)
import Time exposing (Time, millisecond, second, every)
import Animation exposing (..)
import Mouse
import Debug
import AnimationFrame


main =
    Html.program { init = ( model, Cmd.none ), view = view, update = update, subscriptions = subscriptions }


type alias Model =
    { clock : Time, activeAnimation : Maybe Animation, hello : List String }


model =
    { clock = 0, hellos = [ ( "Hello World", { x = 0, y = 0 } ) ], activeAnimation = Nothing }


type Msg
    = NoOp
    | Tick Time
    | Click Mouse.Position
    | Animate


update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        Click position ->
            ( { model | hellos = model.hellos ++ [ ( "Hello World", position ) ] }, Cmd.none )

        Tick time ->
            ( { model | clock = time }, Cmd.none )

        Animate ->
            ( { model | activeAnimation = Just (Animation.animation model.clock |> from 0 |> to 200) }, Cmd.none )


subscriptions model =
    Sub.batch
        [ Mouse.clicks Click
        , AnimationFrame.times Tick
        ]


view model =
    let
        x =
            case model.activeAnimation of
                Nothing ->
                    0

                Just a ->
                    Animation.animate model.clock a

        elements =
            List.map (viewNode model.activeAnimation) model.hellos
    in
        Debug.log (toString x)
            Html.div
            []
            elements


viewNode activeAnimation node =
    let
        x =
            case activeAnimation of
                Nothing ->
                    0

                Just a ->
                    Animation.animate model.clock a

        ( text, coords ) =
            node

        styles =
            style
                [ ( "position", "absolute" )
                , ( "top", (toString coords.y) ++ "px" )
                , ( "left", (toString coords.x) ++ "px" )
                ]
    in
        Html.div [ styles ] [ Html.text text ]
