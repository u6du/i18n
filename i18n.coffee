#!/usr/bin/env coffee



googleTranslate = require('google-translate') require('./config').KEY.GOOGLE.TRANSLATE

text = 'I am using google translator to convert this text to spanish'
console.log("English :>",text)
googleTranslate.translate(
    text
    'zh'
    (err, translation) ->
        if err
            console.error(err)
            return
        console.log(">",translation.translatedText)
)

