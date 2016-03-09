# Description:
#   Allows Hubot to know many languages.
#
# Commands:
#   hubot translate me <phrase> - Searches for a translation for the <phrase> and then prints that bad boy out.
#   hubot translate me from <source> into <target> <phrase> - Translates <phrase> from <source> into <target>. Both <source> and <target> are optional

languages =
  "af": "Afrikaans",
  "sq": "Albanian",
  "ar": "Arabic",
  "az": "Azerbaijani",
  "eu": "Basque",
  "bn": "Bengali",
  "be": "Belarusian",
  "bg": "Bulgarian",
  "ca": "Catalan",
  "zh-CN": "Simplified Chinese",
  "zh-TW": "Traditional Chinese",
  "hr": "Croatian",
  "cs": "Czech",
  "da": "Danish",
  "nl": "Dutch",
  "en": "English",
  "eo": "Esperanto",
  "et": "Estonian",
  "tl": "Filipino",
  "fi": "Finnish",
  "fr": "French",
  "gl": "Galician",
  "ka": "Georgian",
  "de": "German",
  "el": "Greek",
  "gu": "Gujarati",
  "ht": "Haitian Creole",
  "iw": "Hebrew",
  "hi": "Hindi",
  "hu": "Hungarian",
  "is": "Icelandic",
  "id": "Indonesian",
  "ga": "Irish",
  "it": "Italian",
  "ja": "Japanese",
  "kn": "Kannada",
  "ko": "Korean",
  "la": "Latin",
  "lv": "Latvian",
  "lt": "Lithuanian",
  "mk": "Macedonian",
  "ms": "Malay",
  "mt": "Maltese",
  "no": "Norwegian",
  "fa": "Persian",
  "pl": "Polish",
  "pt": "Portuguese",
  "ro": "Romanian",
  "ru": "Russian",
  "sr": "Serbian",
  "sk": "Slovak",
  "sl": "Slovenian",
  "es": "Spanish",
  "sw": "Swahili",
  "sv": "Swedish",
  "ta": "Tamil",
  "te": "Telugu",
  "th": "Thai",
  "tr": "Turkish",
  "uk": "Ukrainian",
  "ur": "Urdu",
  "vi": "Vietnamese",
  "cy": "Welsh",
  "yi": "Yiddish"

QL = (a) ->
  ->
    a
RL = (a, b) ->
  c = 0
  Tb = "+"

  while c < b.length - 2
    d = b.charAt(c + 2)
    d = (if d >= "a" then d.charCodeAt(0) - 87 else Number(d))
    d = (if b.charAt(c + 1) is Tb then a >>> d else a << d)
    a = (if b.charAt(c) is Tb then a + d & 4294967295 else a ^ d)
    c += 3
  a
tk_c = (a) ->
  b = undefined
  SL = null
  if null is SL
    c = QL(String.fromCharCode(84))
    b = QL(String.fromCharCode(75))
    c = [ c(), c() ]
    c[1] = b()
    SL = 403352 # Number(window[c.join(b())]) || 0 if window["TKK"] == 0
  b = SL
  cb = "&"
  k = ""
  mf = "="
  Vb = "+-a^+6"
  Ub = "+-3^+b+-f"
  t = "a"
  Tb = "+"
  dd = "."
  d = QL(String.fromCharCode(116))
  c = QL(String.fromCharCode(107))
  d = [ d(), d() ]
  d[1] = c()
  c = cb + d.join(k) + mf
  d = []
  e = 0
  f = 0

  while f < a.length
    g = a.charCodeAt(f)
    (if 128 > g then d[e++] = g else ((if 2048 > g then d[e++] = g >> 6 | 192 else ((if 55296 is (g & 64512) and f + 1 < a.length and 56320 is (a.charCodeAt(f + 1) & 64512) then (g = 65536 + ((g & 1023) << 10) + (a.charCodeAt(++f) & 1023)
    d[e++] = g >> 18 | 240
    d[e++] = g >> 12 & 63 | 128
    ) else d[e++] = g >> 12 | 224)
    d[e++] = g >> 6 & 63 | 128
    ))
    d[e++] = g & 63 | 128
    ))
    f++
  a = b or 0
  e = 0
  while e < d.length
    a += d[e]
    a = RL(a, Vb)
    e++
  a = RL(a, Ub)
  0 > a and (a = (a & 2147483647) + 2147483648)
  a %= 1e6
  tk = (a.toString() + dd + (a ^ b))
  tk

getCode = (language,languages) ->
  for code, lang of languages
      return code if lang.toLowerCase() is language.toLowerCase()

module.exports = (robot) ->
  language_choices = (language for _, language of languages).sort().join('|')
  pattern = new RegExp('translate(?: me)?' +
                       "(?: from (#{language_choices}))?" +
                       "(?: (?:in)?to (#{language_choices}))?" +
                       '(.*)', 'i')
  robot.respond pattern, (msg) ->
    term   = "\"#{msg.match[3]?.trim()}\""
    origin = if msg.match[1] isnt undefined then getCode(msg.match[1], languages) else 'auto'
    target = if msg.match[2] isnt undefined then getCode(msg.match[2], languages) else 'en'

    msg.http("https://translate.google.com/translate_a/single")
      .query({
        client: 't'
        hl: 'en'
        sl: origin
        ssel: 0
        tl: target
        tsel: 0
        q: term
        ie: 'UTF-8'
        oe: 'UTF-8'
        otf: 1
        dt: ['bd', 'ex', 'ld', 'md', 'qca', 'rw', 'rm', 'ss', 't', 'at']
        tk: tk_c(term)
      })
      .header('User-Agent', 'Mozilla/5.0')
      .get() (err, res, body) ->
        if err
          msg.send "Failed to connect to GAPI"
          robot.emit 'error', err, res
          return

        try
          if body.length > 4 and body[0] == '['
            parsed = eval(body)
            language = languages[parsed[2]]
            parsed = parsed[0] and parsed[0][0] and parsed[0][0][0]
            parsed and= parsed.trim()
            if parsed
              if msg.match[2] is undefined
                msg.send "#{term} is #{language} for #{parsed}"
              else
                msg.send "The #{language} #{term} translates as #{parsed} in #{languages[target]}"
          else
            throw new SyntaxError 'Invalid JS code #{body}'

        catch err
          msg.send "Failed to parse GAPI response"
          robot.emit 'error', err
