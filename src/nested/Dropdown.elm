module Nested.Dropdown exposing 
    (Model, init, Msg, update, view)
{- a Dropdown component that manages its own state
-}
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onWithOptions)
import Json.Decode as Json

import Styles.Styles as Styles


-- MODEL

{- main model, opaque to ensure it can only be updated thru Msg and Update
-}
type alias Model =
    Model
        { selectedItem : Maybe String
        , isOpen : OpenState
        }


init : Model
init =
    Model
        { selectedItem = Nothing
        , isOpen = False
        }




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
        div [ style Styles.mainContainer ]
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
