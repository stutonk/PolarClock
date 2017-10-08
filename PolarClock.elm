module PolarClock exposing (arc)

import Html exposing (Html)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Date exposing (..)
import String exposing (join)
import Time exposing (Time, second)
import Tuple as Tup exposing (first, second)

import MetaDate exposing (..)

main = Html.program
  { init = init
  , update = update
  , view = view
  , subscriptions = subscriptions
  }

-- Model

type alias Model = Time

init : (Model, Cmd Msg)
init = (0, Cmd.none)

-- Update

type Msg = Tick Time

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Tick newTime ->
      (newTime, Cmd.none)

-- Subscriptions

subscriptions : Model -> Sub Msg
subscriptions model = Time.every Time.second Tick

-- View

dims = {x = "575", y = "400"}
origin = {x = 200.0, y = 200.0, r = 25.0}
font = {x ="425", size = "25"}

arc : Float -> Float -> String
arc r deg =
  let 
    r2 = r + origin.r
    theta = degrees (deg - 90.0)
    p1 = (origin.x, origin.y - r)
    p2 = (origin.x + r * (cos theta), origin.y + r * (sin theta))
    p3 = (origin.x + r2 * (cos theta), origin.y + r2 * (sin theta))
    p4 = (origin.x, origin.y - r2)
  in
    join " "
      [ join " " ["M", toString (Tup.first p1), toString (Tup.second p1)]
      , join " " 
        [ "A"
        , toString r
        , toString r
        , "0"
        , if deg > 180.0 then "1" else "0"
        , "1"
        , toString (Tup.first p2)
        , toString (Tup.second p2)
        ]
      , join " " ["L", toString (Tup.first p3), toString (Tup.second p3)] 
      , join " " 
        [ "A"
        , toString r2
        , toString r2
        , "0"
        , if deg > 180.0 then "1" else "0"
        , "0"
        , toString (Tup.first p4)
        , toString (Tup.second p4)
        ]
      , "Z"
      ]

view : Model -> Html Msg
view model =
  let
    epsilon = 0.001
    makeClockSegment rMult deg colorStr = 
      if (deg < epsilon)
      then circle 
        [ cx (toString origin.x)
        , cy (toString origin.y)
        , r (toString <| origin.r * (rMult + 1.0))
        , fill colorStr] []
      else Svg.path [d <| arc (origin.r * rMult) deg, fill colorStr] []
      
    makeText py color content =
      text_ 
        [ x font.x
        , y (toString py)
        , fontSize font.size
        , fill color
        ] [text content]
    
    date = Date.fromTime model
    
    -- Seconds
    sec = Date.second date
    secDeg = (toFloat sec) * 6.0
    
    -- Minutes
    min = Date.minute date
    minDeg = (toFloat min) * 6.0
    
    -- Hours
    hr = Date.hour date
    hrDeg = (toFloat hr) * 15.0
    
    -- Month
    mnt = Date.month date
    mntDeg = (toFloat <| monthInt mnt) * 30.0
    
    -- Year
    yr = Date.year date
    ym = 360.0 / 1000.0
    modYear = rem yr 1000
    yrDeg = (toFloat modYear) * ym
    
    -- Day
    day = Date.day date
    dm = dayMultiplyer mnt yr
    dayDeg = (toFloat day) * dm
  in
    svg [width dims.x, height dims.y]
      [ rect [width dims.x, height dims.y] [] -- Black background
      -- N.B. Order IS for the paths and circles due to Painter's Algorithm
      , makeClockSegment 6.0 yrDeg "#ff00ff"
      , makeClockSegment 5.0 mntDeg "#4B0082"
      , makeClockSegment 4.0 dayDeg "blue"
      , makeClockSegment 3.0 hrDeg "green"
      , makeClockSegment 2.0 minDeg "#FFEF00"
      , makeClockSegment 1.0 secDeg "orange"
      , circle 
        [ cx (toString <| origin.x)
        , cy (toString <| origin.y)
        , r (toString origin.r)
        , fill "red"
        ] []
      -- Order no longer important
      , makeText 50 "#ff00ff" <| toString yr
      , makeText 75 "#4b0082" <| monthName mnt
      , makeText 100 "blue" <| toString day
      , makeText 125 "green" <| toString hr
      , makeText 150 "#ffef00" <| toString min
      , makeText 175 "orange" <| toString sec
      ]