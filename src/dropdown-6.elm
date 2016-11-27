module Dropdown exposing (..)
{- Part 6, where we extract the dropdown from main
This is a simple dropdown with focus
and subscription to Mouse.clicks to close the dropdown
with some additional styling, imported from separate module
-}
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)

import Styles

main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- CONFIG
-- the static stuff, that does not change during the apps lifecycle
type alias Config a msg =
    { idFrom : (a -> ItemID)
    , selectedText : (Maybe ItemID -> String)
    , focusMsg : msg
    , itemMsg : (a -> msg)
    , itemText : (a -> String)
    }

-- DATA
-- the dynamic stuff the view
type alias Data a =
    { data : List a
    , isOpen : Bool
    , selected : Maybe ItemID
    }


-- simple types so we can read the code better
type alias ItemID = String


-- VIEW



view : Config a msg -> Data a -> Html msg
view config model =
    let
        itemText =
            config.selectedText data.selected
            |> flip String.append " ▾"

        displayStyle =
            if data.isOpen then
                ("display", "block")
            else
                ("display", "none")

        ulStyles = 
            displayStyle :: Styles.dropdownList

    in
        div [ style Styles.dropdownContainer ]
            [ p [ onClick focusMsg
                , style Styles.dropdownInput
                ] 
                [ text <| itemText ] 
            , ul [ style ulStyles ]
                (List.map (viewItem config data.selected) data.data)
            ]

viewItem : Config a msg -> Maybe ItemID -> a -> Html msg
viewItem config maybeSelected item =
    let
        itemStyles =
            case maybeSelected of
                Just selected ->
                    if selected == config.idFrom item then
                        ("background-color","rgba(50,100,200,.27)")
                        :: Styles.dropdownListItem
                    else
                        Styles.dropdownListItem

                Nothing ->
                    Styles.dropdownListItem
    in
        li 
            [ style itemStyles
            , onClick (config.itemMsg item)
            ]
            [ text <| config.itemText item ]