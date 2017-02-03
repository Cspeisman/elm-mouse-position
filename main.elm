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
    { clock = 0, hellos = [] }


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
                             , (Animation.animation model.clock
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
        Html.div []
            [ Html.div
                [ style
                    [ ( "font-size", "24px" )
                    , ( "text-align", "center" )
                    , ( "text-decoration", "underline" )
                    ]
                ]
                [ Html.text "Click Anywhere" ]
            , Html.div [] elements
            ]


viewNode clock node =
    let
        ( text, coords, anim ) =
            node

        x =
            Animation.animate clock anim

        styles =
            style
                [ ( "position", "absolute" )
                , ( "top", (toString coords.y) ++ "px" )
                , ( "left", (toString x) ++ "px" )
                ]
    in
        Html.div [ styles ] [ Html.text text ]
