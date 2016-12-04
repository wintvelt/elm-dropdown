{- two dropdowns
with open/ close state
and blur when clicked outside
using a flat approach
importing a module that exposes config, context and view
-}
import Html exposing (..)
import Html.Attributes exposing (style)
import Dict exposing (Dict)
import Json.Decode as Json
import Mouse exposing (Position)

import Styles.Styles as Styles
import Flat.Dropdown as Dropdown

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
    { country : Maybe Country
    , city : Maybe City
    , openDropDown : OpenDropDown
    }

type OpenDropDown =
    AllClosed
    | CountryDropDown
    | CityDropDown


init : ( Model, Cmd Msg )
init =
    { country = Nothing
    , city = Nothing
    , openDropDown = AllClosed
    } ! []

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


countryConfig : Dropdown.Config Msg
countryConfig =
    { defaultText = "-- pick a country --"
    , clickedMsg = Toggle CountryDropDown 
    , itemPickedMsg = CountryPicked
    }

cityConfig : Dropdown.Config Msg
cityConfig =
    { defaultText = "-- pick a city --"
    , clickedMsg = Toggle CityDropDown 
    , itemPickedMsg = CityPicked
    }



-- UPDATE


type Msg =
    Toggle OpenDropDown
    | CountryPicked Country
    | CityPicked City
    | Blur Position


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Toggle dropdown ->
        let
            newOpenDropDown =
                if model.openDropDown == dropdown then
                    AllClosed
                else
                    dropdown

        in
            { model 
            | openDropDown = newOpenDropDown
            } ! []        

    CountryPicked pickedCountry ->
        let
            newCity =
                if model.country /= Just pickedCountry then
                    Nothing
                else
                    model.city

        in
            { model 
            | country = Just pickedCountry
            , city = newCity
            , openDropDown = AllClosed
            } ! []

    CityPicked pickedCity ->
        { model
        | city = Just pickedCity
        , openDropDown = AllClosed
        } ! []

    Blur _ ->
        { model
        | openDropDown = AllClosed
        } ! []



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.openDropDown of
        AllClosed ->
            Sub.none

        _ ->
            Mouse.clicks Blur



-- VIEW


view : Model -> Html Msg
view model =
    let
        countryContext =
            { selectedItem = model.country
            , isOpen = model.openDropDown == CountryDropDown
            }

        cityContext =
            { selectedItem = model.city
            , isOpen = model.openDropDown == CityDropDown
            }

        cities =
            model.country
            |> Maybe.andThen (\c -> Dict.get c allCities)
            |> Maybe.withDefault []

    in
        div [ style Styles.mainContainer ]
            [ Dropdown.view countryConfig countryContext countries
            , Dropdown.view cityConfig cityContext cities
            ]