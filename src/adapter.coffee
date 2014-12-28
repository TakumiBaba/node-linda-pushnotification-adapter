request = require 'superagent'
debug = require('debug')('linda:adapter:pushnotification')
LindaClient = require 'linda/lib/linda-client'
EventEmitter2 = require('eventemitter2').EventEmitter2
EventEmitter = require('events').EventEmitter

# class HttpLinda
#
#   constructor: (api) ->
#     @api = "#{api}/__notification"
#
#   tuplespace: (name) ->
#     return new TupleSpace @, name
#
#   emit: (type, data) ->
#     sender = switch type
#       case 'cancel' then request.delete
#       else request.post
#     sender("#{@api}/#{type}")
#     .send data
#     .end (err, res) ->
#
#
# class TupleSpace
#
#   constructor: (@linda, @name) ->
#     @ioCallbacks = []
#     @watchCallbackIds = {}
#
#   createCallbackId: ->
#     return Date.now() - Math.random()
#
#   option: (opt) ->
#     return new ReadTakeOption @, opt
#
#   write: (tuple, options={expire: null}) ->
#     data =
#       tuplespace: @name
#       tuple: tuple
#       options: options
#     @send 'write', data
#
#   take: (tuple, callback) ->
#     return @option({}).take tuple, callback
#
#   read: (tuple, callback) ->
#     return @option({}).read tuple, callback
#
#   watch: (tuple, callback) ->
#     return if typeof callback isnt 'function'
#
#
#   send: (type, data) ->
#     debug data
#     sender = switch type
#       when 'cancel' then request.delete
#       else request.post
#     sender "#{@api}/#{type}"
#     .send data
#     .end (err, res) ->
#
#   cancel: (cid, reason) ->
#     send 'cancel',
#       baba: 'script'
#       cid: cid
#       type: 'cancel'
#       reason: reason
#
# class ReadTakeOption
#   DEFAULT =
#     sort: 'stack'
#
#   constructor: (@ts, @opts={}) ->
#     for k, v of DEFAULT
#       @opts[k] = v unless @opts.hasOwnProperty k
#
#   read: (tuple, callback) ->
#     return if typeof callback isnt 'function'
#     id = @ts.createCallbackId()
#     name = "__linda_read_#{id}"
#     listener = (err, tuple) ->
#       callback err, tuple
#     @ts.ioCallbacks.push {name: name, listener: listener}
#     @ts.linda.io.once name, listener
#     @ts.linda.io.emit "read",
#       tuplespace: @ts.name
#       tuple: tuple
#       id: id
#       options: @opts
#     return id
#
#   take: (tuple, callback) ->
#     return if typeof callback isnt 'function'
#     d = @ts.createCallbackId()
#     name = "__linda_take_#{id}"
#     listener = (err, tuple) ->
#       callback err, tuple
#     @ts.ioCallbacks.push {name: name, listener: listener}
#     @ts.linda.io.once name, listener
#     @ts.linda.emit "take",
#       tuplespace: @ts.name
#       tuple: tuple
#       id: id
#       options: @opts
#     return id

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
