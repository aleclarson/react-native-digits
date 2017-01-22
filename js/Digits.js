var Event, Promise, RNDigits, Shape, Type, UserData, processColor, type;

RNDigits = require("NativeModules").RNDigits;

processColor = require("processColor");

Promise = require("Promise");

Shape = require("Shape");

Event = require("Event");

Type = require("Type");

UserData = Shape("Digits_UserData", {
  userId: String,
  phoneNumber: String,
  authToken: String,
  authTokenSecret: String,
  consumerKey: String,
  consumerSecret: String
});

type = Type("Digits");

type.defineValues({
  accentColor: "#000",
  backgroundColor: "#fff",
  _authorizing: null
});

type.addMixin(Event.Mixin, {
  didLogin: {
    userData: UserData
  },
  didLogout: null
});

type.defineGetters({
  isAuthorizing: function() {
    return Promise.isPending(this._authorizing);
  },
  isAuthorized: function() {
    return Promise.isFulfilled(this._authorizing);
  }
});

type.defineMethods({
  login: function() {
    if (!Promise.isRejected(this._authorizing)) {
      return this._authorizing;
    }
    this._authorizing = RNDigits.login({
      accentColor: processColor(this.accentColor),
      backgroundColor: processColor(this.backgroundColor)
    });
    return this._authorizing.then((function(_this) {
      return function(json) {
        _this.emit("didLogin", json);
        return json;
      };
    })(this));
  },
  logout: function() {
    RNDigits.logout();
    this.emit("didLogout");
  }
});

module.exports = type.construct();

//# sourceMappingURL=map/Digits.map
