#!/usr/bin/env coffee

fs = require('fs')
path = require('path')

CONFIG = require './config'
ROOT = path.resolve __dirname, ".."

LANG = ['en','zh']
lang_order = (lang)->
    pos = LANG.indexOf(lang)
    if pos < 0
        pos - order.length
    return pos

TITLE = {
    zh:"中文说明"
    en:"English Readme"
}

README = "readme.md"

FOOT = {}

do ->
    for i in LANG
        FOOT[i] = (fs.readFileSync(path.join(__dirname, "doc", i , "foot.md"))+"").trim()

title_link = (title)=>
    "* [#{title}](##{title.toLowerCase().replace(/\s/,"-")})"

make = (dir)->

    root = path.join ROOT, dir
    dir_doc = path.join(root, "doc")
    readme = path.join(dir_doc, "zh",README)
    if not fs.existsSync(readme)
        return

    li = fs.readdirSync(dir_doc)

    li.sort (a,b)->
        return lang_order(a)-lang_order(b)

    txt = [
        "# #{CONFIG.PROJECT} "+dir+"\n"
    ]
    for i in li
        title = TITLE[i]
        txt.push title_link(title)

    txt.push "\n---\n"

    desc = {}

    for i in li
        title = TITLE[i]
        txt.push "## #{title}\n"
        readme = fs.readFileSync(path.join(dir_doc, i , README))+""
        desc[i] = readme.split("\n",1)[0]
        txt.push readme.trim()
        txt.push "\n"+FOOT[i]
        txt.push "\n---\n"

    txt.push CONFIG.FOOT
    fs.writeFileSync path.join(root, README), txt.join("\n")
    return desc


do =>
    file_li = fs.readdirSync(
        ROOT
    )

    desc_li = {}

    for i in file_li
        desc_li[i] = make i

    git = []
    txt = [
        "# "+ CONFIG.INDEX+" code repository index / 代码库清单\n"
    ]
    for lang in LANG
        txt.push title_link(TITLE[lang])

    for lang in LANG
        txt.push "\n---\n"
        txt.push "## " + TITLE[lang] + "\n"
        for k,v of desc_li
            if v
                txt.push "* [#{CONFIG.URL.split("://")[1]+k}](#{CONFIG.URL+k}) "+ v[lang]
        txt.push "\n"+FOOT[lang]

    txt.push "\n"+CONFIG.FOOT

    fs.writeFileSync(
        path.join(ROOT, CONFIG.INDEX, README)
        txt.join("\n")
    )


