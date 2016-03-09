chai = require 'chai'
sinon = require 'sinon'
bluebird = require 'bluebird'
co = require 'co'

Helper = require 'hubot-test-helper'
helper = new Helper('./../src/google-translate.coffee')

expect = chai.expect

describe 'google-translate', ->
  beforeEach ->
    @room = helper.createRoom(httpd: false)

  context "user asks for French translation", ->
    beforeEach ->
      co =>
        yield @room.user.say 'john', "hubot: translate me Bonjour"
        yield new bluebird.delay(1000)

    it 'answers with the translated text', ->
      expect(@room.messages).to.eql [
        ['john', "hubot: translate me Bonjour"]
        ['hubot', "\"Bonjour\" is French for \"Hello\""]
      ]

  context "user asks for French translation", ->
    beforeEach ->
      co =>
        yield @room.user.say 'john', "hubot: translate me from english into french How are you?"
        yield new bluebird.delay(1000)

    it 'answers with the translated text', ->
      expect(@room.messages).to.eql [
        ['john', "hubot: translate me from english into french How are you?"]
        ['hubot', "The English \"How are you?\" translates as \"Comment allez-vous?\" in French"]
      ]
