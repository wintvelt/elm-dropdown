module Styles exposing (..)
{- Css styles for dropdown, moved off to separate module
-}
-- styles for main container
dropdownContainer : List (String, String)
dropdownContainer =
    [ ("position","relative")
    , ("margin","16px")
    , ("width", "200px")
    , ("display", "inline-block")
    ]

-- styles for main input field
dropdownInput : List (String, String)
dropdownInput =
    [ ("padding","7px 0 6px 16px")
    , ("width", "200px")
    , ("margin","0")
    ]

-- styles for list container
dropdownList : List (String, String)
dropdownList =
    [ ("position", "absolute")
    , ("top", "0")
    , ("border-radius","4px")
    , ("box-shadow", "0 1px 2px rgba(0,0,0,.24)")
    , ("padding", "4px 8px")
    , ("margin", "0")
    , ("width", "200px")
    , ("background-color", "white")
    ]

-- styles for list items
dropdownListItem : List (String, String)
dropdownListItem =
    [ ("display", "block")
    , ("padding","4px 8px")
    ]