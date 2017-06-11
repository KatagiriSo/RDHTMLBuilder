import RDHTMLBuilder
import RDHTMLBuilder_TAG


-- main = print "hello"
main = makeHTMLs inputs

--- cutomize

inputs = [start_html, lounge_html, tutorial_html, mypage_html]

--
start_html = ("start.html",  makeHTML "start" start)
lounge_html = ("lounge.html",  makeHTML "lounge" lounge)
tutorial_html = ("tutorial.html",  makeHTML "tutorial" tutorial)
mypage_html = ("mypage.html",  makeHTML "mypage" mypage)

--


start = ELEM {
               body = (makeBody "body") `addTAG` [div_header,(makeDoorBox "./e.gif")],
               css = [styleBody, styleHeader] ++ styleDoorBoxList
             }

lounge = ELEM {
    body = (makeBody "body") `addTAG` [div_header, makelaungeDoorBox "./e,gif"],
    css = [styleBody, styleHeader] ++ styleLoungeDoorBoxList
  }

tutorial = ELEM {
  body = (makeBody "body") `addTAG` [div_header, link_description],
  css =  [styleBody, styleHeader, styleDescription]
}

mypage = ELEM {
  body = (makeBody "body")
        `addTAG` [div_header]
        `addTAG` [makeDiv "wrapper"
            `addTAG` [div_blog]
            `addTAG` [div_menu]] ,
  css = [styleBody,styleHeader,styleMenu]
    ++ [styleWrapper ["wrapper"] "row" [p_margin_left "10px", p_margin_right "10px"]]
    ++ styleBlogs ++ styleProfiles ++ [styleLink]
  }


-- body

div_header = makeDiv "header"
makeDoorBox imgname = makeDiv "doorBox" `addTAG` [link, title] where
  link = makeImageLink "./lounge.html" imgname "doorlink"
  title = makeDiv "title" `addTAG` [Text "blog"]

makelaungeDoorBox imgname = makeDiv "doorBox" `addTAG` [link] where
  link = makeImageLink "./tutorial.html" imgname "doorlink"

div_blog = makeDiv "blog"
  `addTAG` [makeDiv "blogTitle" `addTAG` [Text "Think"]]
  `addTAG` [makeDiv "blogTextInput" `addTAG` [_textarea "input" [] []]]
  `addTAG` [makeDiv "blogButtons" `addTAG` [postbutton]] where
    postbutton =(makeButton "blogpost" "blogform" "button") `addText` "regist"

div_menu =  makeDiv "menu" `addTAG` [div_profile, link_agora]

div_profile = makeDiv "profile" `addTAG` [image_profile] where
  image_profile = makeImage "./e.gif" "imageprofile"

link_description = makeA "./mypage.html" "descriptionlink" `addText` "tutorial"
link_agora = makeA "./agora.html" "link" `addText` "list"

-- css

styleBody = makeStyleFullScreenBody ["body"] (
  [p_background_color "green"]++(makeFlex "column")
  )

styleWrapper classNames flex props = STYLECLASS classNames ((makeFlex flex) ++ (makeWH "100%" "100%") ++ props)

styleHeader = STYLECLASS [getClassName div_header]
  (makeWH "100%" "100px")

styleDoorBoxList = [styleDoorBox, (styleDoorLink "200px" "200px"), styleTitle]
styleLoungeDoorBoxList = [styleDoorBox, (styleDoorLink "300px" "300px")]

styleDoorBox = STYLECLASS [getClassName (makeDoorBox "")] (makeWH "100%" "calc(100% - 100px)")
 `addPROPERTY` [p_text_align "center"]

propBorder = makeBorder "thick" "solid" "white" "10px"

styleDoorLink width height = STYLECLASS [getClassName (makeDoorBox ""), "doorlink"]  (makeWH width height)
 `addPROPERTY` [p_display style_display_INLINE_BLOCK]
 `addPROPERTY` makeFontSize "1.5rem" "coral"
 `addPROPERTY` propBorder

styleTitle = STYLECLASS [getClassName (makeDoorBox ""), "title"] (makeFontSize "3.0rem" "white")
 `addPROPERTY` [p_margin_top "30px"]

styleDescription = STYLECLASS ["descriptionlink"] (makeWH "80%" "80%")
  `addPROPERTY` makeFontSize "10rem" "coral"

styleLink = STYLECLASS ["link:link"] (makeFontSize "1.0rem" "white")

styleBlogs = [styleBlog, styleBlogTitle] ++ styleBlogTextInputs ++ [styleBlogButtons] where
  styleBlog = STYLECLASS ["blog"] (makeWH "calc(80%)" "100%")
    `addPROPERTY` [p_margin_left "5px"]
    `addPROPERTY` [p_margin_right "5px"]
    `addPROPERTY` propBorder
  styleBlogTitle = STYLECLASS ["blogTitle"] (makeWH "100%" "50px")
    `addPROPERTY` (makeFontSize "2.0rem" "white")
    `addPROPERTY` [p_background_color "pink"]
  styleBlogTextInputs = [STYLECLASS ["blogTextInput"] (makeWH "100%" "calc(100% - 100px)")
                          `addPROPERTY` [p_background_color "red"],
                         STYLECLASS ["input"] (makeWH "100%" "100%")
                          `addPROPERTY` makeFontSize "1.5rem" "white"
                          `addPROPERTY` [p_background_color "green"]
                         ]
  styleBlogButtons = STYLECLASS ["blogButtons"] (makeFlex "row" ++ makeWH "100%" "50px" ++ [p_background_color "pink"])


styleMenu = STYLECLASS ["menu"] (makeWH "calc(20% - 10px)" "100%")
  `addPROPERTY` [p_margin_left "5px"]
  `addPROPERTY` [p_margin_left "5px"]
  `addPROPERTY` propBorder
  `addPROPERTY` makeFlex "column"


styleProfiles = [styleProfile, imageprofile] where
  styleProfile = STYLECLASS ["profile"] (makeWH "100px" "100px")
  imageprofile = STYLECLASS ["imageprofile"] (makeWH "100%" "100%")
