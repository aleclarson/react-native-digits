
{RNDigits} = require "NativeModules"

processColor = require "processColor"
Promise = require "Promise"
Shape = require "Shape"
Type = require "Type"

UserData = Shape "Digits_UserData",
  userId: String
  phoneNumber: String
  authToken: String
  authTokenSecret: String
  consumerKey: String
  consumerSecret: String

type = Type "Digits"

type.defineValues

  accentColor: "#000"

  backgroundColor: "#fff"

  _authorizing: null

type.defineEvents

  didLogin: {userData: UserData}

  didLogout: null

type.defineGetters

  isAuthorizing: -> Promise.isPending @_authorizing

  isAuthorized: -> Promise.isFulfilled @_authorizing

type.defineMethods

  login: ->

    if not Promise.isRejected @_authorizing
      return @_authorizing

    @_authorizing = RNDigits.login
      accentColor: processColor @accentColor
      backgroundColor: processColor @backgroundColor

    return @_authorizing.then (json) =>
      @__events.didLogin json
      return json

  logout: ->
    RNDigits.logout()
    @__events.didLogout()
    return

module.exports = type.construct()
