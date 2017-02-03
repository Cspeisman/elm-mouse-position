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
    { clock : Time, hello : List String }


model =
    { clock = 0, hellos = [ ( "Hello World", { x = 0, y = 0 }, Nothing ) ] }


type Msg
    = NoOp
    | Tick Time
    | Click Mouse.Position


update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        Click position ->
            ( { model
                | hellos =
                    model.hellos
                        ++ [ ( "Hello World"
                             , position
                             , Just
                                (Animation.animation model.clock
                                    |> from (toFloat position.x)
                                    |> to ((position.x |> toFloat) + 200)
                                )
                             )
                           ]
              }
            , Cmd.none
            )

        Tick time ->
            ( { model | clock = time }, Cmd.none )


subscriptions model =
    Sub.batch
        [ Mouse.clicks Click
        , AnimationFrame.times Tick
        ]


view model =
    let
        elements =
            List.map (viewNode model.clock) model.hellos
    in
        Html.div [] elements


viewNode clock node =
    let
        ( text, coords, anim ) =
            node

        x =
            case anim of
                Nothing ->
                    0

                Just a ->
                    Animation.animate clock a

        styles =
            style
                [ ( "position", "absolute" )
                , ( "top", (toString coords.y) ++ "px" )
                , ( "left", (toString x) ++ "px" )
                ]
    in
        Html.div [ styles ] [ Html.text text ]
