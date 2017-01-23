module Main exposing (..)

import Html
import Html.Attributes exposing (style)
import Mouse
import Debug


main =
    Html.program { init = ( model, Cmd.none ), view = view, update = update, subscriptions = subscriptions }


model =
    [ ( "Hello World", { x = 0, y = 0 } ) ]


type Msg
    = NoOp
    | Click Mouse.Position


update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        Click position ->
            ( model ++ [ ( "Hello World", position ) ], Cmd.none )


subscriptions model =
    Mouse.clicks Click


view model =
    let
        elements =
            List.map viewNode model
    in
        Html.div [] elements


viewNode node =
    let
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
