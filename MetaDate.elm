module MetaDate exposing (..)

import Date exposing (..)

isLeapYear : Int -> Bool
isLeapYear year =
  ((rem year 4) == 0) || ((rem year 100) /= 0 && (rem year 400) == 0)
  
      
dayMultiplyer : Month -> Int -> Float
dayMultiplyer month year =
  let divisor =
    case month of
    Jan -> 31.0
    Feb -> if (isLeapYear year) then 29.0 else 28.0
    Mar -> 31.0
    Apr -> 30.0
    May -> 31.0
    Jun -> 30.0
    Jul -> 31.0
    Aug -> 31.0
    Sep -> 30.0
    Oct -> 31.0
    Nov -> 31.0
    Dec -> 30.0
  in
    360.0 / divisor

monthInt : Month -> Int
monthInt month = 
  case month of
    Jan -> 1
    Feb -> 2
    Mar -> 3
    Apr -> 4
    May -> 5
    Jun -> 6
    Jul -> 7
    Aug -> 8
    Sep -> 9
    Oct -> 10
    Nov -> 11
    Dec -> 12
    
monthName : Month -> String
monthName month =
  case month of
    Jan -> "January"
    Feb -> "February"
    Mar -> "March"
    Apr -> "April"
    May -> "May"
    Jun -> "June"
    Jul -> "July"
    Aug -> "August"
    Sep -> "September"
    Oct -> "October"
    Nov -> "November"
    Dec -> "December"