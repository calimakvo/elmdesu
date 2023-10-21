module Main exposing (..)

import Browser
import Task
import Time
import Html exposing (Html, button, div, text, p)
import Html.Events exposing (onClick)

main : Program () Model Msg
main =
  Browser.element
    { init = init
    , update = update
    , view = view
    , subscriptions = subscriptions
    }
      
type alias Model = 
  { cnt : Int
  , msg : String
  , zone : Time.Zone
  , time : Time.Posix
  }

type Msg
  = Increment
  | Decrement
  | Tick Time.Posix
  | AdjustTimeZone Time.Zone

init : () -> (Model, Cmd Msg)
init _ =
  ( Model 0 "" (Time.utc) (Time.millisToPosix 0)
  , Task.perform AdjustTimeZone Time.here
  )

subscriptions : Model -> Sub Msg
subscriptions model =
  Time.every 1000 Tick

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Increment ->
      ( { model | cnt = model.cnt + 1 }
      , Cmd.none
      )

    Decrement ->
      ( { model | cnt = model.cnt - 1 }
      , Cmd.none
      )

    Tick nowTime ->
      ( { model | time = nowTime }
      , Cmd.none
      )

    AdjustTimeZone newZone ->
      ( { model | zone = newZone }
      , Cmd.none
      )

view : Model -> Html Msg
view model =
  div []
    [ button [ onClick Decrement ] [ text "こっちか?" ]
    , div [] [ text (String.fromInt model.cnt) ]
    , button [ onClick Increment ] [ text "そっちか?" ]
    , p [] [ text (putTime model) ]
    ]

putTime : Model -> String
putTime model =
  let
    hour =
      String.fromInt (Time.toHour model.zone model.time)
    minute =
      String.fromInt (Time.toMinute model.zone model.time)
    second =
      String.fromInt (Time.toSecond model.zone model.time)
  in
    hour ++ ":" ++ minute ++ ":" ++ second
