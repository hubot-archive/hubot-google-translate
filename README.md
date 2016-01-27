# hubot-google-translate

Allows Hubot to know many languages using Google Translate

See [`src/google-translate.coffee`](src/google-translate.coffee) for full documentation.

## Installation

In hubot project repo, run:

`npm install hubot-google-translate --save`

Then add **hubot-google-translate** to your `external-scripts.json`:

```json
[
  "hubot-google-translate"
]
```

set the environment variable:

`HUBOT_GOOGLE_TRANSLATE_API_KEY=YOUR_GOOGLE_API_KEY`

## Sample Interaction

```
user> hubot translate me bienvenu
hubot> " bienvenu" is Turkish for " Bienvenu "
user> hubot translate me from french into english bienvenu
hubot> The French " bienvenu" translates as " Welcome " in English
```
