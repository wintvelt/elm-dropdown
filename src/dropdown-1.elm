{- a simple dropdown with open/ close state
-}
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)

import Styles

main =
  Html.beginnerProgram
    { model = init
    , view = view
    , update = update
    }


-- MODEL

-- our main model, which will change as we use the app
type alias Model =
    { pickedCarBrand : Maybe CarBrand
    , isOpen : Bool
    }

-- simple types so we can read the code better
type alias CarBrand = String

-- global constants/ config
carBrands : List CarBrand
carBrands = 
    [ "Audi"
    , "BMW"
    , "Chevrolet"
    , "Daimler"
    , "Ford"
    ]



init : Model
init =
    { pickedCarBrand = Nothing
    , isOpen = False
    }



-- UPDATE


type Msg
    = CarBrandPicked CarBrand
    | DropDownClicked


update : Msg -> Model -> Model
update msg model =
  case msg of
    CarBrandPicked carBrand ->
        { model 
        | pickedCarBrand = Just carBrand 
        , isOpen = False
        }

    DropDownClicked ->
        { model | isOpen = not model.isOpen }




-- VIEW



view : Model -> Html Msg
view model =
    let
        selectedText =
            model.pickedCarBrand
            |> Maybe.withDefault "-- pick a car brand --" 

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
                (List.map viewCarBrand carBrands)
            ]

viewCarBrand : CarBrand -> Html Msg
viewCarBrand carBrand =
    li 
        [ style Styles.dropdownListItem
        , onClick <| CarBrandPicked carBrand 
        ]
        [ text carBrand ]