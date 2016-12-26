module Styles.Styles exposing (..)
{- Css styles for dropdown, moved off to separate module
-}
-- styles for main
mainContainer : List (String, String)
mainContainer =
    [ ("height","100%")
    , ("background-color","#fafafa")
    , ("padding","16px")
    ]

-- styles for dropdown container
dropdownContainer : List (String, String)
dropdownContainer =
    [ ("position","relative")
    , ("margin","16px")
    , ("width", "216px")
    , ("display", "inline-block")
    , ("fontFamily", "sans-serif")
    , ("fontSize", "16px")
    ]

-- styles for main input field
dropdownInput : List (String, String)
dropdownInput =
    [ ("padding","6px 12px 8px 15px")
    , ("margin","0")
    , ("border","1px solid rgba(0,0,0,.17)")
    , ("border-radius","4px")
    , ("background-color","white")
    , ("display","flex")
    , ("alignItems","center")
    ]

-- disabled style
dropdownDisabled : List (String, String)
dropdownDisabled =
    [ ("color","rgba(0,0,0,.54") ]


-- styles for the text of selected item
dropdownText : List (String, String)
dropdownText =
    [ ("flex","1 0 auto")]

-- styles for list container
dropdownList : List (String, String)
dropdownList =
    [ ("position", "absolute")
    , ("top", "36px")
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
    , ("padding","8px 8px")
    ]