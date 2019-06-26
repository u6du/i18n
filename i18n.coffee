#!/usr/bin/env coffee

fs = require('fs')
path = require('path')

CONFIG = require './config'

lang_order = (lang)->
    order = ['en','zh']
    pos = order.indexOf(lang)
    if pos < 0
        pos - order.length
    return pos

lang_title = {
    zh:"中文说明"
    en:"English Readme"
}

make = (dir)->
    dir_doc = path.join(dir, "doc")
    readme = path.join(dir_doc, "zh","readme.md")
    if not fs.existsSync(readme)
        return

    li = fs.readdirSync(dir_doc)

    li.sort (a,b)->
        return lang_order(a)-lang_order(b)

    txt = [
        "# "+dir+"\n"
    ]
    for i in li
        title = lang_title[i]
        txt.push "* [#{title}](##{title.toLowerCase()})"

    txt.push "\n---\n"

    for i in li
        title = lang_title[i]
        txt.push "## "+title
        txt.push "\n---\n"

    txt.push CONFIG.FOOT
    console.log txt.join("\n")




do =>
    root = path.resolve __dirname, ".."
    fs.readdir(
        root
        (err, file_li) =>
            for i in file_li
                make path.join(root,i)
    )

# googleTranslate = require('google-translate') require('./config').KEY.GOOGLE.TRANSLATE

# text = 'I am using google translator to convert this text to spanish'
# console.log("English :>",text)
# googleTranslate.translate(
#     text
#     'zh'
#     (err, translation) ->
#         if err
#             console.error(err)
#             return
#         console.log(">",translation.translatedText)
# )

