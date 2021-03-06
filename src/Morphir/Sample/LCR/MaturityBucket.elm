module Morphir.Sample.LCR.MaturityBucket exposing (..)


-- See: https://www.federalreserve.gov/reportforms/forms/FR_2052a20190331_f.pdf
-- Appendix IV-a, Maturity Time Bucket Value List on page 75

import Date exposing (Date, Unit(..))
import Time exposing (Month(..))


type MaturityBucket 
    = Daily Int
    | DayRange Int Int
    | DayYear Int Int
    | Yearly Int Int
    | Residual


daysToMaturity fromDate maturityDate =
    Date.diff Days maturityDate fromDate


yearsToMaturity fromDate maturityDate =
    Date.diff Years maturityDate fromDate


{-| The Fed spec on maturity buckets -}
bucket fromDate maturityDate =
    let
        days = daysToMaturity fromDate maturityDate
        years = yearsToMaturity maturityDate fromDate
    in 
    if days <= 60 then
        Daily days
    else if days <= 67 then
        DayRange 61 67
    else if days <= 74 then
        DayRange 68 74
    else if days <= 82 then
        DayRange 75 82
    else if days <= 90 then
        DayRange 83 90
    else if days <= 120 then
        DayRange 92 120
    else if days <= 150 then
        DayRange 121 150
    else if days <= 180 then
        DayRange 151 180
    else if days <= 270 then
        DayYear 181 270
    else if years <= 1 then
        DayYear 271 1
    else if years <= 2 then
        Yearly 1 2
    else if years <= 3 then
        Yearly 2 3
    else if years <= 4 then
        Yearly 3 4
    else if years <= 5 then
        Yearly 4 5
    else 
        Residual
