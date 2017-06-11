module RDHTMLBuilder where

import Data.List

-- main = putStr (display html)
-- main = sequence $ map (\(filename,html) -> (writeFile filename html)) output

type FileName = String
type TagName = String
type ClassName = String
type PropertyName = String


-- main function

makeHTML::[(FileName, TAG)] -> IO [()]
makeHTML inputs = sequence $ map (\(filename,html) -> (writeFile filename (display html))) inputs

-- main data type

data TAG = TAG TagName ClassName [ATTRIBUTE] [TAG] |Text String deriving Show
data ATTRIBUTE = Attribute AttributeName String deriving Show
data STYLE = STYLECLASS [ClassName] [PROPERTY] | STYLETAG TagName [PROPERTY] | STYLEEMPTY
data PROPERTY = Property PropertyName String deriving Show

makeTAG tagName = TAG tagName "" [] []
addClassName (TAG t c as ts) cn = TAG t cn as ts

-- main class
class DISPLAY a where
  display:: a -> String

class GetClassName a where
  getClassName:: a -> String

class GetTags a where
  getTags:: a -> [TAG]

-- instance
instance DISPLAY TAG where
  display (TAG tagName className attributes tags) = tagatt tagName (map display ([Attribute "class" (qua className)]++attributes)) (intercalate "" (map display tags))
  display (Text txt) = txt

instance GetClassName TAG where
  getClassName (TAG _ className _ _) = className

instance GetTags TAG where
  getTags (TAG _ _ _ tags) = tags

instance DISPLAY ATTRIBUTE where
  display (Attribute name txt) = attr name txt

instance DISPLAY PROPERTY where
  display (Property name txt) = "\t " ++ name ++ ":" ++ txt ++ ";\n "

instance DISPLAY STYLE where
  display (STYLECLASS classnames props) = intercalate "" (map (" ."++) classnames) ++ "{\n " ++ (intercalate "" (map display props))  ++ "\n}\n"
  display (STYLETAG tagname props) = tagname ++ "{\n " ++ (intercalate "" (map display props))  ++ "\n }\n "
  display (STYLEEMPTY) = ""

--

addTAG::TAG->[TAG]->TAG
addTAG (TAG tagName className attributes tags) ts = TAG tagName className attributes (tags ++ ts)

addText::TAG->String->TAG
addText (TAG tagName className attributes tags) txt = TAG tagName className attributes (tags ++ [Text txt])


addAttribute::TAG->[ATTRIBUTE]->TAG
addAttribute (TAG tagName className attributes tags) as = TAG tagName className (attributes ++ as) tags

addPROPERTY::STYLE->[PROPERTY]->STYLE
addPROPERTY (STYLECLASS classnames props) ps = STYLECLASS classnames (props ++ ps)
addPROPERTY (STYLETAG tagname props) ps = STYLETAG tagname (props ++ ps)
addPROPERTY STYLEEMPTY prop = STYLEEMPTY

-- html tag function

tag::TagName -> String -> String
tag name txt = "\n <"++name++">\n " ++ txt ++ "\n</"++name++">\n "

type AttributeName = String
type AttributeString = String
attr::AttributeName -> String -> AttributeString
attr name txt = name ++ "=" ++ txt

tagatt::TagName -> [AttributeString] -> String -> String
tagatt name att txt = "\n <" ++ name ++ " " ++ attstr ++ ">\n " ++ txt ++ "\n </"++name++">\n " where
  attstr = intercalate "" att

----- utility

qua::String->String
qua txt = "'" ++ txt ++ "'"
