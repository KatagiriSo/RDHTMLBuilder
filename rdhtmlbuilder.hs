
import Data.List


-- main = putStr (display html)
main = sequence $ map (\(filename,html) -> (writeFile filename html)) output




type ClassName = String



type TagName = String
tag::TagName -> String -> String
tag name txt = "\n <"++name++">\n " ++ txt ++ "\n</"++name++">\n "

type AttributeName = String
type AttributeString = String
attr::AttributeName -> String -> AttributeString
attr name txt = name ++ "=" ++ txt


tagatt::TagName -> [AttributeString] -> String -> String
tagatt name att txt = "\n <" ++ name ++ " " ++ attstr ++ ">\n " ++ txt ++ "\n </"++name++">\n " where
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

class GetClassName a where
  getClassName:: a -> String

class GetTags a where
  getTags:: a -> [TAG]

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


-----


html title css body =  htmlcommon (htmlblock (title,css,body))

htmlcommon = _html "" [Attribute "lang" (qua "ja")]
metacommon = _meta "" [Attribute "charset" (qua "UTF-8")] []
htmlblock = \(title, css, body) -> [headtag title (style css) , body]

_meta = TAG "meta"
_html = TAG "html"
_head = TAG "head"
_body = TAG "body"
_div = TAG "div"
_p = TAG "p"
_a href = \className -> TAG "a" className  [Attribute "href" (qua href)]
_title = TAG "title"
_img src = \className -> TAG "img" className [Attribute "src" (qua src)]
_textarea = TAG "textarea"
_button className name formid = TAG className "button" [Attribute "name" (qua name), Attribute "form" (qua formid)]

style::[STYLE] -> TAG
style css = TAG "style" "" [] (map Text (map display css))


p_background_color = Property "background-color"
p_position = Property "position"
p_display = Property "display"
p_justify_content = Property "justify-content"
p_align_items = Property "align-items"
p_width = Property "width"
p_height = Property "height"
p_text_align = Property "text-align"
p_top = Property "top"
p_z_index = Property "z-index"
p_font_size = Property "font-size"
p_color = Property "color"
p_border thick solid color = Property "border" (intercalate " " [thick, solid,color])
p_border_radius = Property "border-radius"
p_margin_top = Property "margin-top"
p_margin_left = Property "margin-left"
p_margin_right = Property "margin-right"
p_flex_direction = Property "flex-direction"


makeStyleFullScreenBody::[String] -> [PROPERTY] ->  STYLE
makeStyleFullScreenBody classNames props = STYLECLASS classNames (makeWH "100%" "100%" ++ props)

makeWH::String -> String -> [PROPERTY]
makeWH width height = [p_width width, p_height height]

makeFlex::String -> [PROPERTY]
makeFlex direction = [p_display "flex",p_flex_direction direction]

makeFontSize fontsize color = [p_font_size fontsize, p_color color]

makeBorder::String->String->String->String->[PROPERTY]
makeBorder thick solid color radius = [p_border thick solid color, p_border_radius radius]

style_display_INLINE_BLOCK = "inline-block"


-- template
templatehtml title css bodytag = htmlcommon [headtag title (style css), bodytag]

-- emptyhtml
emptyhtml = templatehtml "title" [STYLEEMPTY]  (_body "" [] [])



-- head
headtag title style = _head "" [] [metacommon,style, (_title "" [] [Text title])]



--- cutomize

output = [start_html, lounge_html, tutorial_html, mypage_html]


start_html = ("start.html", display (html "start" start_css start_body))
lounge_html = ("lounge.html", display (html "lounge" lounge_css lounge_body))
tutorial_html = ("tutorial.html", display (html "tutorial" tutorial_css tutorial_body))
mypage_html = ("mypage.html", display (html "mypage" mypage_css mypage_body))

start_body = _body "body" [] [div_header,(div_doorBox "./e.gif")]
start_css = [styleBody, styleHeader] ++ styleDoorBoxList

lounge_body = _body "body" [] [div_header, div_laungeDoorBox "./e,gif"]
lounge_css = [styleBody, styleHeader] ++ styleLoungeDoorBoxList

tutorial_body = _body "body" [] [div_header, link_description]
tutorial_css = [styleBody, styleHeader, styleDescription]

mypage_body = _body "body" [] [div_header, div_wrapper] where
  div_wrapper = _div "wrapper" [] [div_blog, div_menu]

mypage_css = [styleBody,styleHeader,styleMenu]
  ++ [styleWrapper ["wrapper"] "row" [p_margin_left "10px", p_margin_right "10px"]]
  ++ styleBlogs ++ styleProfiles ++ [styleLink]

-- body

div_header = _div "header" [] []
div_doorBox imgname = _div "doorBox" [] [link, title] where
  link = _a "./lounge.html" "doorlink" [image] where
    image = _img imgname "" []
  title = _div "title" [] [Text "blog"]

div_laungeDoorBox imgname = _div "doorBox" [] [link] where
  link = _a "./tutorial.html" "doorlink" [image] where
    image = _img imgname "" []

div_blog = _div "blog" [] [div_blogTitle, div_blogTextInput, div_blogButtons]
div_blogTitle = _div "blogTitle" [] [Text "Think"]
div_blogTextInput = _div "blogTextInput" [] [_textarea "input" [] []]
div_blogButtons = _div "blogButtons" [] [div_blogPostButton]
div_menu = _div "menu" [] [div_profile, link_agora]

div_profile = _div "profile" [] [image_profile] where
  image_profile = _img "./e.gif" "imageprofile" []

div_blogPostButton =(_button "button" "blogpost" "blogform") [Text "post"]


link_description = _a "./mypage.html" "descriptionlink" [Text text] where
  text = "tutorial"

link_agora = _a "./agora.html" "link" [Text text] where
  text = "list"

-- css

styleBody = makeStyleFullScreenBody ["body"] (
  [p_background_color "green"]++(makeFlex "column")
  )

styleWrapper classNames flex props = STYLECLASS classNames ((makeFlex flex) ++ (makeWH "100%" "100%") ++ props)

styleHeader = STYLECLASS [getClassName div_header]
  (makeWH "100%" "100px")

styleDoorBoxList = [styleDoorBox, (styleDoorLink "200px" "200px"), styleTitle]
styleLoungeDoorBoxList = [styleDoorBox, (styleDoorLink "300px" "300px")]

styleDoorBox = STYLECLASS [getClassName (div_doorBox "")]
 ((makeWH "100%" "calc(100% - 100px)")
 ++ [p_text_align "center"])

propBorder = makeBorder "thick" "solid" "white" "10px"

styleDoorLink width height = STYLECLASS [getClassName (div_doorBox ""), "doorlink"]
 ([p_display style_display_INLINE_BLOCK]
 ++ (makeFontSize "1.5rem" "coral")
 ++ (makeWH width height)
 ++ propBorder)

styleTitle = STYLECLASS [getClassName (div_doorBox ""), "title"]
  ((makeFontSize "3.0rem" "white")
  ++ [p_margin_top "30px"])

styleDescription = STYLECLASS ["descriptionlink"]
  ((makeWH "80%" "80%")
  ++ (makeFontSize "10rem" "coral"))

styleLink = STYLECLASS ["link:link"] (makeFontSize "1.0rem" "white")

styleBlogs = [styleBlog, styleBlogTitle] ++ styleBlogTextInputs ++ [styleBlogButtons] where
  styleBlog = STYLECLASS ["blog"] ((makeWH "calc(80%)" "100%")  ++ [p_margin_left "5px"]  ++ [p_margin_right "5px"]  ++ propBorder)
  styleBlogTitle = STYLECLASS [getClassName div_blogTitle] ((makeFontSize "2.0rem" "white")  ++ (makeWH "100%" "50px") ++ [p_background_color "pink"])
  styleBlogTextInputs = [STYLECLASS [getClassName div_blogTextInput] ((makeWH "100%" "calc(100% - 100px)") ++ [p_background_color "red"]),
                         STYLECLASS ["input"] (makeWH "100%" "100%" ++ (makeFontSize "1.5rem" "white") ++ [p_background_color "green"])
                         ]
  styleBlogButtons = STYLECLASS [getClassName div_blogButtons] (makeFlex "row" ++ makeWH "100%" "50px" ++ [p_background_color "pink"])



styleMenu = STYLECLASS ["menu"] (
  (makeWH "calc(20% - 10px)" "100%")
  ++ [p_margin_left "5px"]
  ++ [p_margin_right "5px"]
  ++ propBorder
  ++ makeFlex "column"
  )

styleProfiles = [styleProfile, imageprofile] where
  styleProfile = STYLECLASS ["profile"] (
    (makeWH "100px" "100px")
    )
  imageprofile = STYLECLASS ["imageprofile"] (
    (makeWH "100%" "100%")
    )
