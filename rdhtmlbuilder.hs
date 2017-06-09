import Data.List

main = putStr (display html)

type ClassName = String



type TagName = String
tag::TagName -> String -> String
tag name txt = "\n<"++name++">\n" ++ txt ++ "</"++name++">\n"

type AttributeName = String
type AttributeString = String
attr::AttributeName -> String -> AttributeString
attr name txt = name ++ "=" ++ txt


tagatt::TagName -> [AttributeString] -> String -> String
tagatt name att txt = "\n<" ++ name ++ " " ++ attstr ++ ">\n" ++ txt ++ "</"++name++">\n" where
  attstr = intercalate "" att

qua::String->String
qua txt = "'" ++ txt ++ "'"

data TAG = TAG TagName ClassName [ATTRIBUTE] [TAG] |Text String deriving Show
data ATTRIBUTE = Attribute AttributeName String deriving Show

type PropertyName = String
data STYLE = STYLECLASS [ClassName] [PROPERTY] | STYLETAG TagName [PROPERTY] | STYLEEMPTY
data PROPERTY = Property PropertyName String deriving Show

class DISPLAY a where
  display:: a -> String

instance DISPLAY TAG where
  display (TAG tagName className attributes tags) = tagatt tagName (map display ([Attribute "class" (qua className)]++attributes)) (intercalate "" (map display tags))
  display (Text txt) = txt

instance DISPLAY ATTRIBUTE where
  display (Attribute name txt) = attr name txt

instance DISPLAY PROPERTY where
  display (Property name txt) = "\t" ++ name ++ ":" ++ txt ++ ";\n"

instance DISPLAY STYLE where
  display (STYLECLASS classnames props) = intercalate "" (map (" ."++) classnames) ++ "{\n" ++ (intercalate "" (map display props))  ++ "\n}\n"
  display (STYLETAG tagname props) = tagname ++ "{\n" ++ (intercalate "" (map display props))  ++ "\n}\n"
  display (STYLEEMPTY) = ""


-----

html = htmlcommon htmlall

htmlcommon = _html "" [Attribute "lang" (qua "ja")]
metacommon = _meta "" [Attribute "charset" (qua "UTF-8")] []
htmlall = [headtag "title" (style css) , body]

_meta = TAG "meta"
_html = TAG "html"
_head = TAG "head"
_body = TAG "body"
_div = TAG "div"
_p = TAG "p"
_a href= \className -> TAG "a" className  [Attribute "href" (qua href)]
_title = TAG "title"

style css = TAG "style" "" [] [Text (display css)]

-- head
headtag title style = _head "" [] [metacommon,style, (_title "" [] [Text title])]

-- body
body = _body "hoge" [] [_div "box" [] [Text "Hello", _a "https://yahoo.co.jp" "" [Text "link"]]]

-- css
css = STYLECLASS ["hoge"] [Property "background-color" "green"]

-- template
templatehtml title css bodytag = htmlcommon [headtag title (style css), bodytag]

-- emptyhtml
emptyhtml = templatehtml "title" STYLEEMPTY (_body "" [] [])
