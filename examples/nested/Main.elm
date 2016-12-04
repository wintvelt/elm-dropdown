{- two dropdowns
with open/ close state
and blur when clicked outside
using a nested approach
importing a module that manages its own state
-}
import Html exposing (..)
import Html.Attributes exposing (style)
import Dict exposing (Dict)
import Json.Decode as Json
import Mouse exposing (Position)

import Styles.Styles as Styles
import Nested.Dropdown as Dropdown

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
    { country : Dropdown.Model
    , city : Dropdown.Model
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
    { country = Dropdown.init
    , city = Dropdown.init
    } ! []



-- UPDATE


type Msg =
    CountryMsg Dropdown.Msg
    | CityMsg Dropdown.Msg
    | Blur Position


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    CountryMsg countryMsg ->
        let
            oldCountry = 
                Dropdown.selectedFrom model.country
            
            (newCountry, newSelectedCountry) =
                Dropdown.update countryMsg model.country

            (newCity, _) =
                if newSelectedCountry /= Nothing && newSelectedCountry /= oldCountry then
                    Dropdown.update (Dropdown.ItemPicked Nothing) model.city
                else
                    (model.city, Nothing)

            (closedNewCity, _) =
                Dropdown.update (Dropdown.SetOpenState False) newCity


        in
            { model 
            | country = newCountry
            , city = closedNewCity
            } ! []

    CityMsg cityMsg ->
        let
            (newCity, _) =
                Dropdown.update cityMsg model.city

            (closedCountry, _) =
                Dropdown.update (Dropdown.SetOpenState False) model.country

        in
            { model
            | country = closedCountry
            , city = newCity
            } ! []

    Blur _ ->
        let
            (closedCountry, _) =
                Dropdown.update (Dropdown.SetOpenState False) model.country

            (closedCity, _) =
                Dropdown.update (Dropdown.SetOpenState False) model.city

        in
            { model
            | country = closedCountry
            , city = closedCity
            } ! []



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    if Dropdown.openState model.country || Dropdown.openState model.city then
        Mouse.clicks Blur
    else
        Sub.none




-- VIEW



view : Model -> Html Msg
view model =
    let
        countryText =
            Dropdown.selectedFrom model.country
            |> Maybe.withDefault "-- pick a country --" 

        cityText =
            Dropdown.selectedFrom model.city
            |> Maybe.withDefault "-- pick a city --" 

        countryDisplayStyle =
            if Dropdown.openState model.country then
                ("display", "block")
            else
                ("display", "none")

        cityDisplayStyle =
            if Dropdown.openState model.city then
                ("display", "block")
            else
                ("display", "none")

        cities =
            Dropdown.selectedFrom model.country
            |> Maybe.andThen (\c -> Dict.get c allCities)
            |> Maybe.withDefault []

    in
        div [ style Styles.mainContainer ]
            [ Html.map CountryMsg <| Dropdown.view countryText model.country countries
            , Html.map CityMsg <| Dropdown.view cityText model.city cities
            ]