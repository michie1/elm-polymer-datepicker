port module Main exposing (..)

import Html exposing (node, div, text)
import Html.Attributes exposing (attribute)
import Date exposing (Date, fromString)

main =
    Html.program
        { init = init
        , view = view
        , update = update 
        , subscriptions = subscriptions
        }

type alias Model = 
    { maybeDate: Maybe Date
    }

init : (Model, Cmd Msg)
init =
    ( Model (fromString "2017/01/01" |> Result.toMaybe), Cmd.none) 

type Msg
    = SetDate String

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        SetDate dateString -> 
            let
                nextMaybeDate = Date.fromString dateString
            in
                ( { model | maybeDate = nextMaybeDate |> Result.toMaybe } , Cmd.none)

port datepicker : (String -> msg) -> Sub msg

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ datepicker SetDate ]

leadingZero : Int -> String
leadingZero num =
    if num > 0 && num < 10 then
        "0" ++ toString num
    else
        toString num

monthNumLeadingZero : Date.Month -> String
monthNumLeadingZero month =
    case month of
        Date.Jan -> "01"
        Date.Feb -> "02"
        Date.Mar -> "03"
        Date.Apr -> "04"
        Date.May -> "05"
        Date.Jun -> "06"
        Date.Jul -> "07"
        Date.Aug -> "08"
        Date.Sep -> "09"
        Date.Oct -> "10"
        Date.Nov -> "11"
        Date.Dec -> "12"
        
view : Model -> Html.Html Msg
view model =
    case model.maybeDate of
        Just date ->
            let
                inputDate = 
                    (toString (Date.year date)) ++ "/" ++
                    monthNumLeadingZero (Date.month date) ++ "/" ++
                    leadingZero (Date.day date)
            in
                div 
                    [] 
                    [ div [] [ text <| toString date ]
                    , div [] [ text <| inputDate ]
                    , node "app-datepicker" 
                        [ attribute "input-date" inputDate
                        , attribute "auto-update-date" "true"
                        ]
                        []
                    ]

        Nothing ->
            div [] [ text "No date" ]

