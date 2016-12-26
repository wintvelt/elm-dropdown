{- a dropdown 
with open/ close state
and blur when clicked outside
-}
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onWithOptions)
import Dict exposing (Dict)
import Json.Decode as Json
import Mouse

import Styles.Styles as Styles

main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- MODEL

-- our main model, which will change as we use the app
type alias Model =
    { pickedCountry : Maybe Country
    , isOpen : Bool
    }

-- simple types so we can read the code better
type alias Country = String
type alias City = String

-- global constants/ config
allCities : Dict Country (List City)
allCities =
    Dict.fromList
        [ ("Spain",["Barcelona","Madrid","Alicante","Valencia"])
        , ("Germany",["Berlin","München","Bonn","Leipzig"])
        , ("France",["Paris","Lyon","Marseille","Dijon"])
        , ("Italy",["Florence","Rome","Milan"])
        ]

countries : List Country
countries = 
    Dict.keys allCities


init : ( Model, Cmd Msg )
init =
    { pickedCountry = Nothing
    , isOpen = False
    } ! []



-- UPDATE


type Msg
    = CountryPicked Country
    | DropDownClicked
    | Blur


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    CountryPicked country ->
        { model 
        | pickedCountry = Just country 
        , isOpen = False
        } ! []

    DropDownClicked ->
        { model | isOpen = not model.isOpen } ! []

    Blur ->
        { model | isOpen = False } ! []



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    if model.isOpen then
        Mouse.clicks (always Blur)
    else
        Sub.none




-- VIEW



view : Model -> Html Msg
view model =
    let
        selectedText =
            model.pickedCountry
            |> Maybe.withDefault "-- pick a country --" 

        displayStyle =
            if model.isOpen then
                ("display", "block")
            else
                ("display", "none")

    in
        div [ style Styles.dropdownContainer ]
            [ p 
                [ style Styles.dropdownInput
                , onClick DropDownClicked 
                ] 
                [ span [ style Styles.dropdownText ] [ text <| selectedText ] 
                , span [] [ text " ▾" ]
                ]
            , ul 
                [ style <| displayStyle :: Styles.dropdownList ]
                (List.map viewCountry countries)
            ]

viewCountry : Country -> Html Msg
viewCountry country =
    li 
        [ style Styles.dropdownListItem
        , onClick <| CountryPicked country 
        ]
        [ text country ]


-- helper to cancel click anywhere
onClick : msg -> Attribute msg
onClick message =
    onWithOptions 
        "click" 
        { stopPropagation = True
        , preventDefault = False
        }
        (Json.succeed message)
