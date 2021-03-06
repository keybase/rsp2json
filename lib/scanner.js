// Generated by IcedCoffeeScript 1.6.3-g
(function() {
  var Line, Scanner, fs, iced, strip, __iced_k, __iced_k_noop;

  iced = require('iced-coffee-script').iced;
  __iced_k = __iced_k_noop = function() {};

  fs = require('fs');

  strip = function(line) {
    var m;
    if ((line != null) && ((m = line.match(/^(.*)(\s+)$/)) != null)) {
      line = m[1];
    }
    if (line.match(/^#/)) {
      return '';
    } else {
      return line;
    }
  };

  exports.Line = Line = (function() {
    function Line(data) {
      var m, parts;
      this.raw = data;
      if (!(this._empty = !!(data.match(/^\s*$/)))) {
        if ((m = data.match(/^\[(.*)\]\s*$/)) != null) {
          this._header = true;
          data = m[1];
        } else {
          this._header = false;
        }
        parts = data.split(/\s*=\s*/);
        this._key = parts[0];
        this._value = parts.length > 1 ? parts[1] : parts[0];
      }
    }

    Line.prototype.is_header = function() {
      return this._header;
    };

    Line.prototype.key = function() {
      return this._key;
    };

    Line.prototype.value = function() {
      return this._value;
    };

    Line.prototype.is_empty = function() {
      return this._empty;
    };

    Line.prototype.is_data = function() {
      return !this._header && !this._empty;
    };

    return Line;

  })();

  exports.Scanner = Scanner = (function() {
    function Scanner(filename) {
      this.filename = filename;
      this._i = 0;
    }

    Scanner.prototype.open = function(cb) {
      var data, err, line, ___iced_passed_deferral, __iced_deferrals, __iced_k,
        _this = this;
      __iced_k = __iced_k_noop;
      ___iced_passed_deferral = iced.findDeferral(arguments);
      (function(__iced_k) {
        __iced_deferrals = new iced.Deferrals(__iced_k, {
          parent: ___iced_passed_deferral,
          filename: "src/scanner.iced",
          funcname: "Scanner.open"
        });
        fs.readFile(_this.filename, __iced_deferrals.defer({
          assign_fn: (function() {
            return function() {
              err = arguments[0];
              return data = arguments[1];
            };
          })(),
          lineno: 41
        }));
        __iced_deferrals._fulfill();
      })(function() {
        if (typeof err === "undefined" || err === null) {
          _this.lines = (function() {
            var _i, _len, _ref, _results;
            _ref = data.toString().split(/\n/);
            _results = [];
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              line = _ref[_i];
              _results.push(strip(line));
            }
            return _results;
          })();
        }
        return cb(err);
      });
    };

    Scanner.prototype.eof = function() {
      return this._i >= this.lines.length;
    };

    Scanner.prototype.peek = function(cb) {
      var ret;
      ret = this.eof() ? null : new Line(this.lines[this._i]);
      return cb(ret);
    };

    Scanner.prototype.consume = function(cb) {
      if (!this.eof()) {
        return this._i++;
      }
    };

    return Scanner;

  })();

}).call(this);
