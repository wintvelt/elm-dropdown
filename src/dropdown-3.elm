{- two dropdowns
with open/ close state
and blur when clicked outside
-}
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onWithOptions)
import Dict exposing (Dict)
import Json.Decode as Json
import Mouse exposing (Position)

import Styles

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
    { carBrand : Maybe CarBrand
    , carModel : Maybe CarModel
    , isOpen : OpenState
    }

type OpenState = AllClosed | BrandOpen | CarModelOpen

-- simple types so we can read the code better
type alias CarBrand = String
type alias CarModel = String

-- global constants/ config
allCars : Dict CarBrand (List CarModel)
allCars =
    Dict.fromList
        [ ("Audi",["A3","A4","A5","TT"])
        , ("BMW",["316i","525i","X3"])
        , ("Chevrolet",["Bolt","Camaro","Spark","Volt"])
        , ("Ford",["Focus","Kia","Mondeo"])
        ]

carBrands : List CarBrand
carBrands = 
    Dict.keys allCars


init : ( Model, Cmd Msg )
init =
    { carBrand = Nothing
    , carModel = Nothing
    , isOpen = AllClosed
    } ! []



-- UPDATE


type Msg
    = BrandPicked CarBrand
    | CarModelPicked CarModel
    | BrandToggled
    | CarModelToggled
    | Blur Position


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    BrandPicked carBrand ->
        { model 
        | carBrand = Just carBrand
        , carModel =
            if model.carBrand /= Just carBrand then
                Nothing
            else
                model.carModel
        , isOpen = AllClosed
        } ! []

    CarModelPicked carModel ->
        { model 
        | carModel = Just carModel
        , isOpen = AllClosed
        } ! []

    BrandToggled ->
        { model 
        | isOpen = 
            case model.isOpen of
                BrandOpen -> 
                    AllClosed
                _ -> 
                    BrandOpen
        } ! []

    CarModelToggled ->
        { model 
        | isOpen = 
            case model.isOpen of
                CarModelOpen -> 
                    AllClosed
                _ -> 
                    CarModelOpen
        } ! []

    Blur _ ->
        { model | isOpen = AllClosed } ! []



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.isOpen of
        AllClosed ->
            Sub.none
        _ ->
            Mouse.clicks Blur




-- VIEW



view : Model -> Html Msg
view model =
    let
        brandText =
            model.carBrand
            |> Maybe.withDefault "-- pick a car brand --" 

        carModelText =
            model.carModel
            |> Maybe.withDefault "-- pick a model --" 

        brandDisplayStyle =
            case model.isOpen of
                BrandOpen ->
                    ("display", "block")
                _ ->
                    ("display", "none")

        carModelDisplayStyle =
            case model.isOpen of
                CarModelOpen ->
                    ("display", "block")
                _ ->
                    ("display", "none")

        carModels =
            model.carBrand
            |> Maybe.andThen (\b -> Dict.get b allCars)
            |> Maybe.withDefault []

        carModelsAttr =
            case carModels of
                [] -> 
                    [ style <| Styles.dropdownDisabled ++ Styles.dropdownInput
                    ] 

                _ ->
                    [ style Styles.dropdownInput
                    , onClick CarModelToggled 
                    ] 

    in
        div []
            [ div 
                [ style Styles.dropdownContainer ]
                [ p 
                    [ style Styles.dropdownInput
                    , onClick BrandToggled 
                    ] 
                    [ span [ style Styles.dropdownText ] [ text <| brandText ] 
                    , span [] [ text " ▾" ]
                    ]
                , ul 
                    [ style <| brandDisplayStyle :: Styles.dropdownList ]
                    (List.map viewCarBrand carBrands)
                ]
            , div 
                [ style Styles.dropdownContainer ]
                [ p 
                    carModelsAttr
                    [ span [ style Styles.dropdownText ] [ text <| carModelText ] 
                    , span [] [ text "▾" ]
                    ]
                , ul 
                    [ style <| carModelDisplayStyle :: Styles.dropdownList ]
                    (List.map viewCarModel carModels)
                ]
            ]
    
viewCarBrand : CarBrand -> Html Msg
viewCarBrand carBrand =
    li 
        [ style Styles.dropdownListItem
        , onClick <| BrandPicked carBrand 
        ]
        [ text carBrand ]

viewCarModel : CarModel -> Html Msg
viewCarModel carModel =
    li 
        [ style Styles.dropdownListItem
        , onClick <| CarModelPicked carModel 
        ]
        [ text carModel ]


-- helper to cancel click anywhere
onClick : msg -> Attribute msg
onClick message =
    onWithOptions 
        "click" 
        { stopPropagation = True
        , preventDefault = False
        }
        (Json.succeed message)
