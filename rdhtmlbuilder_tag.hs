module RDHTMLBuilder_TAG where

import RDHTMLBuilder
import Data.List


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

makeBody = addClassName (makeTAG "body")
makeHead = addClassName (makeTAG "head")
makeDiv = addClassName (makeTAG "div")
makeP = addClassName (makeTAG "p")
makeA href = addClassName ((makeTAG "a") `addAttribute` [Attribute "href" (qua href)])
makeImage src = addClassName ((makeTAG "img") `addAttribute` [Attribute "src" (qua src)])
makeButton name formid = addClassName (makeTAG "button" `addAttribute` [Attribute "name" (qua name), Attribute "form" (qua formid)])

makeImageLink href src = \cn -> makeA href cn `addTAG` [makeImage src ""]



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

addWH style w h = addPROPERTY style (makeWH w h)

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
