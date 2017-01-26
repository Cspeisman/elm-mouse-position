module Main exposing (..)

import Html exposing (Html)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Time exposing (Time, millisecond, second, every)
import AnimationFrame
import Animation exposing (..)
import Ease
import Debug


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { clock : Time, activeAnimation : Maybe Animation }


init : ( Model, Cmd Msg )
init =
    ( { clock = 0, activeAnimation = Nothing }, Cmd.none )



-- UPDATE


type Msg
    = Tick Time
    | Animate


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick time ->
            ( { model | clock = time }, Cmd.none )

        Animate ->
            ( { model | activeAnimation = Just (Animation.animation model.clock |> from 0 |> to 200) }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    AnimationFrame.times Tick



-- AnimationFrame.diff
-- VIEW


view : Model -> Html Msg
view model =
    let
        x =
            case model.activeAnimation of
                Nothing ->
                    0

                Just a ->
                    Animation.animate model.clock a

        styles =
            style
                [ ( "left", (toString x) ++ "px" )
                , ( "position", "absolute" )
                , ( "background-color", "blue" )
                , ( "border-radius", "50%" )
                , ( "width", "100px" )
                , ( "height", "100px" )
                , ( "color", "white" )
                , ( "text-align", "center" )
                ]
    in
        Html.div [ onClick Animate, styles ]
            [ Html.text "Click to animate!" ]
