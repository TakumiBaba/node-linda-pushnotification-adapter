request = require 'superagent'
debug = require('debug')('linda:adapter:pushnotification')
LindaClient = require 'linda/lib/linda-client'
EventEmitter2 = require('eventemitter2').EventEmitter2

class PushReceiver
  constructor: ->
    # これは、指定可能にしておく。
    # cordova pluginとか、そういうのが使える予定にしよう
    # aws-sns client とかも指定できるとか。

class PushNotificationIO extends EventEmitter2
  constructor: ->
    # ここで、PushNotificationを取得する系のやつをアレする
    # PushReceiver classとか？

  connect: (api) ->
    @api = api + '/__notification'
    for name in ['watch','take','read','write']
      @on "__linda_#{name}", @__emit
    return @

  __emit: (data) ->
    name = @event.replace '__linda_', ""
    sender = switch name
      when 'cancel' then request.delete
      else request.post
    debug data
    sender("#{@api}/#{name}")
    .send data
    .end (err, res) ->


module.exports = class PushnotificationAdapter
  constructor: (api, @options={}) ->
    @api = api or 'http://babascript-linda.herokuapp.com'
    @linda = new HttpLinda @api

  attach: (@baba) ->

  connect: ->

  disconnect: ->

  send: (data) ->

  receive: (tuple, callback) ->

  clientReceive: (tuple, callback) ->
    # if tuple.type is 'broadcast' or tuple

  cancel: (cid, reason) ->

io = new PushNotificationIO().connect('http://localhost:3000')
linda = new LindaClient().connect io

ts = linda.tuplespace('hoge')
ts.write {baba: 'script'}
# io.emit '__linda_watch', {hoge: 'fuga'}
# io.emit '__linda_take', {hoge: 'take'}
# io.emit '__linda_take_hogefuga', {aaa: 'bbb'}
