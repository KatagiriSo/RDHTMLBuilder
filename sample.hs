import RDHTMLBuilder
import RDHTMLBuilder_TAG


-- main = print "hello"
main = makeHTMLs inputs

--- cutomize

inputs = [start_html, lounge_html, tutorial_html, mypage_html]

-- setting
start_html = ("start.html",  makeHTML "start" start)
lounge_html = ("lounge.html",  makeHTML "lounge" lounge)
tutorial_html = ("tutorial.html",  makeHTML "tutorial" tutorial)
mypage_html = ("mypage.html",  makeHTML "mypage" mypage)

-- page

start = bodybase
  `addElem` header
  `addElem` doorBox

lounge = bodybase
   `addElem` header
   `addElem` loungeDoorBox

tutorial = bodybase
 `addElem` header
 `addElem` description

mypage = bodybase
  `addElem` header
  `addElem` ((wrapper { css = [styleWrapper ["wrapper"] "row" [p_margin_left "10px", p_margin_right "10px"]]})
        `addElem` blog
        `addElem` menu
      )

-- elem parts

bodybase = ELEM {
  body = makeBody "body",
  css =  [styleBody]
}

header = ELEM {
  body = div_header,
  css = [styleHeader]
}

doorBox = ELEM {
  body = makeDoorBox "./e.gif",
  css =  styleDoorBoxList
}

loungeDoorBox = ELEM {
  body = makelaungeDoorBox "./e,gif",
  css = styleLoungeDoorBoxList

}

wrapper = ELEM {
  body = makeDiv "wrapper",
  css = []
}

blog = ELEM {
  body = makeDiv "blog",
  css = [styleBlog]
}
 `addElem` blogTitle
 `addElem` blogTextInput
 `addElem` blogButtons

menu = ELEM {
  body = makeDiv "menu" ,
  css = [styleMenu]
}
  `addElem` profile
  `addElem` ELEM { body = link_agora, css = []}

profile = ELEM {
  body = div_profile,
  css = styleProfiles
}

description = ELEM {
  body = link_description,
  css = [styleDescription]
}

-- body

div_header = makeDiv "header"
makeDoorBox imgname = makeDiv "doorBox" `addTAG` [link, title] where
  link = makeImageLink "./lounge.html" imgname "doorlink"
  title = makeDiv "title" `addTAG` [Text "blog"]

makelaungeDoorBox imgname = makeDiv "doorBox" `addTAG` [link] where
  link = makeImageLink "./tutorial.html" imgname "doorlink"


blogTitle = ELEM {
  body = makeDiv "blogTitle" `addTAG` [Text "Think"],
  css =  [styleBlogTitle]
}

blogTextInput = ELEM {
  body = makeDiv "blogTextInput" `addTAG` [_textarea "input" [] []],
  css = styleBlogTextInputs
}

blogButtons = ELEM {
  body = makeDiv "blogButtons" `addTAG` [postbutton],
  css = [styleBlogButtons]
} where {
  postbutton =(makeButton "blogpost" "blogform" "button") `addText` "regist"
}




div_profile = makeDiv "profile" `addTAG` [image_profile] where
  image_profile = makeImage "./e.gif" "imageprofile"

link_description = makeA "./mypage.html" "descriptionlink" `addText` "tutorial"
link_agora = makeA "./agora.html" "link" `addText` "list"

-- css

styleBody = makeStyleFullScreenBody ["body"] ([p_background_color "green"] ++ (makeFlex "column"))

styleWrapper classNames flex props = STYLECLASS classNames ((makeFlex flex) ++ (makeWH "100%" "100%") ++ props)

styleHeader = STYLECLASS [getClassName div_header] (makeWH "100%" "100px")

-- door

styleDoorBoxList = [styleDoorBox, (styleDoorLink "200px" "200px"), styleTitle]

styleLoungeDoorBoxList = [styleDoorBox, (styleDoorLink "300px" "300px")]

styleDoorBox = STYLECLASS [getClassName (makeDoorBox "")] (makeWH "100%" "calc(100% - 100px)")
 `addPROPERTY` [p_text_align "center"]

styleDoorLink width height = STYLECLASS [getClassName (makeDoorBox ""), "doorlink"]  (makeWH width height)
  `addPROPERTY` [p_display style_display_INLINE_BLOCK]
  `addPROPERTY` makeFontSize "1.5rem" "coral"
  `addPROPERTY` propBorder

styleTitle = STYLECLASS [getClassName (makeDoorBox ""), "title"] (makeFontSize "3.0rem" "white")
  `addPROPERTY` [p_margin_top "30px"]

-- const
propBorder = makeBorder "thick" "solid" "white" "10px"
styleLink = STYLECLASS ["link:link"] (makeFontSize "1.0rem" "white")

-- description
styleDescription = STYLECLASS ["descriptionlink"] (makeWH "80%" "80%")
  `addPROPERTY` makeFontSize "10rem" "coral"

-- blog

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


-- menu

styleMenu = STYLECLASS ["menu"] (makeWH "calc(20% - 10px)" "100%")
  `addPROPERTY` [p_margin_left "5px"]
  `addPROPERTY` [p_margin_left "5px"]
  `addPROPERTY` propBorder
  `addPROPERTY` makeFlex "column"


-- profile
styleProfiles = [styleProfile, imageprofile] where
  styleProfile = STYLECLASS ["profile"] (makeWH "100px" "100px")
  imageprofile = STYLECLASS ["imageprofile"] (makeWH "100%" "100%")
