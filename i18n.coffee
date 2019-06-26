#!/usr/bin/env coffee

fs = require('fs')
path = require('path')

CONFIG = require './config'
ROOT = path.resolve __dirname, ".."

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

README = "readme.md"

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
        title = lang_title[i]
        txt.push "* [#{title}](##{title.toLowerCase().replace(/\s/,"-")})"

    txt.push "\n---\n"

    for i in li
        title = lang_title[i]
        txt.push "## #{title}\n"
        readme = fs.readFileSync(path.join(dir_doc, i , README))+""
        txt.push readme.trim()
        txt.push "\n---\n"

    txt.push CONFIG.FOOT
    fs.writeFileSync path.join(root, README), txt.join("\n")



do =>
    fs.readdir(
        ROOT
        (err, file_li) =>
            for i in file_li
                make i
    )

