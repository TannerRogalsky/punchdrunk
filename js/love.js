(function() {
  var Audio, Canvas2D, Color, EventQueue, FileSystem, Font, Graphics, Image, ImageData, Keyboard, Mouse, Quad, Source, System, Timer, Window,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __slice = [].slice;

  Audio = (function() {
    function Audio() {
      this.stop = __bind(this.stop, this);
      this.setVolume = __bind(this.setVolume, this);
      this.setVelocity = __bind(this.setVelocity, this);
      this.setPosition = __bind(this.setPosition, this);
      this.setOrientation = __bind(this.setOrientation, this);
      this.setDistanceModel = __bind(this.setDistanceModel, this);
      this.rewind = __bind(this.rewind, this);
      this.resume = __bind(this.resume, this);
      this.play = __bind(this.play, this);
      this.pause = __bind(this.pause, this);
      this.newSource = __bind(this.newSource, this);
      this.getVolume = __bind(this.getVolume, this);
      this.getVelocity = __bind(this.getVelocity, this);
      this.getSourceCount = __bind(this.getSourceCount, this);
      this.getPosition = __bind(this.getPosition, this);
      this.getOrientation = __bind(this.getOrientation, this);
      this.getDistanceModel = __bind(this.getDistanceModel, this);
    }

    Audio.prototype.getDistanceModel = function() {};

    Audio.prototype.getOrientation = function() {};

    Audio.prototype.getPosition = function() {};

    Audio.prototype.getSourceCount = function() {};

    Audio.prototype.getVelocity = function() {};

    Audio.prototype.getVolume = function() {};

    Audio.prototype.newSource = function(filename, type) {
      return new Source(filename, type);
    };

    Audio.prototype.pause = function(source) {
      return source.pause(source);
    };

    Audio.prototype.play = function(source) {
      return source.play(source);
    };

    Audio.prototype.resume = function(source) {
      return source.play(source);
    };

    Audio.prototype.rewind = function(source) {
      return source.rewind(source);
    };

    Audio.prototype.setDistanceModel = function() {};

    Audio.prototype.setOrientation = function() {};

    Audio.prototype.setPosition = function() {};

    Audio.prototype.setVelocity = function() {};

    Audio.prototype.setVolume = function() {};

    Audio.prototype.stop = function(source) {
      return source.stop(source);
    };

    return Audio;

  })();

  Color = (function() {
    function Color(r, g, b, a) {
      this.r = r;
      this.g = g;
      this.b = b;
      this.a = a != null ? a : 255;
      this.html_code = "rgb(" + this.r + ", " + this.g + ", " + this.b + ")";
    }

    return Color;

  })();

  EventQueue = (function() {
    var Event;

    function EventQueue() {
      this.wait = __bind(this.wait, this);
      this.quit = __bind(this.quit, this);
      this.push = __bind(this.push, this);
      this.pump = __bind(this.pump, this);
      this.poll = __bind(this.poll, this);
      this.clear = __bind(this.clear, this);
      this.internalQueue = [];
    }

    EventQueue.prototype.clear = function() {
      return this.internalQueue = [];
    };

    EventQueue.prototype.poll = function() {};

    EventQueue.prototype.pump = function() {};

    EventQueue.prototype.push = function() {
      var args, eventType, newEvent;
      eventType = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      newEvent = (function(func, args, ctor) {
        ctor.prototype = func.prototype;
        var child = new ctor, result = func.apply(child, args);
        return Object(result) === result ? result : child;
      })(Event, [eventType].concat(__slice.call(args)), function(){});
      return this.internalQueue.push(newEvent);
    };

    EventQueue.prototype.quit = function() {};

    EventQueue.prototype.wait = function() {};

    Event = (function() {
      function Event(eventType, arg1, arg2, arg3, arg4) {
        this.eventType = eventType;
        this.arg1 = arg1;
        this.arg2 = arg2;
        this.arg3 = arg3;
        this.arg4 = arg4;
      }

      return Event;

    })();

    return EventQueue;

  })();

  FileSystem = (function() {
    function FileSystem() {
      this.write = __bind(this.write, this);
      this.unmount = __bind(this.unmount, this);
      this.setSource = __bind(this.setSource, this);
      this.setIdentity = __bind(this.setIdentity, this);
      this.remove = __bind(this.remove, this);
      this.read = __bind(this.read, this);
      this.newFileData = __bind(this.newFileData, this);
      this.newFile = __bind(this.newFile, this);
      this.mount = __bind(this.mount, this);
      this.load = __bind(this.load, this);
      this.lines = __bind(this.lines, this);
      this.isFused = __bind(this.isFused, this);
      this.isFile = __bind(this.isFile, this);
      this.isDirectory = __bind(this.isDirectory, this);
      this.init = __bind(this.init, this);
      this.getWorkingDirectory = __bind(this.getWorkingDirectory, this);
      this.getUserDirectory = __bind(this.getUserDirectory, this);
      this.getSize = __bind(this.getSize, this);
      this.getSaveDirectory = __bind(this.getSaveDirectory, this);
      this.getLastModified = __bind(this.getLastModified, this);
      this.getIdentity = __bind(this.getIdentity, this);
      this.getDirectoryItems = __bind(this.getDirectoryItems, this);
      this.getAppdataDirectory = __bind(this.getAppdataDirectory, this);
      this.exists = __bind(this.exists, this);
      this.createDirectory = __bind(this.createDirectory, this);
      this.append = __bind(this.append, this);
    }

    FileSystem.prototype.append = function() {};

    FileSystem.prototype.createDirectory = function() {};

    FileSystem.prototype.exists = function(filename) {
      return localStorage.getItem(filename) !== null;
    };

    FileSystem.prototype.getAppdataDirectory = function() {};

    FileSystem.prototype.getDirectoryItems = function() {};

    FileSystem.prototype.getIdentity = function() {};

    FileSystem.prototype.getLastModified = function() {};

    FileSystem.prototype.getSaveDirectory = function() {};

    FileSystem.prototype.getSize = function() {};

    FileSystem.prototype.getUserDirectory = function() {};

    FileSystem.prototype.getWorkingDirectory = function() {};

    FileSystem.prototype.init = function() {};

    FileSystem.prototype.isDirectory = function() {};

    FileSystem.prototype.isFile = function() {};

    FileSystem.prototype.isFused = function() {};

    FileSystem.prototype.lines = function() {};

    FileSystem.prototype.load = function() {};

    FileSystem.prototype.mount = function() {};

    FileSystem.prototype.newFile = function() {};

    FileSystem.prototype.newFileData = function() {};

    FileSystem.prototype.read = function(filename) {
      return localStorage.getItem(filename);
    };

    FileSystem.prototype.remove = function(filename) {
      return localStorage.removeItem(filename);
    };

    FileSystem.prototype.setIdentity = function() {};

    FileSystem.prototype.setSource = function() {};

    FileSystem.prototype.unmount = function() {};

    FileSystem.prototype.write = function(filename, data) {
      return localStorage.setItem(filename, data);
    };

    return FileSystem;

  })();

  Graphics = (function() {
    function Graphics(width, height) {
      this.width = width != null ? width : 800;
      this.height = height != null ? height : 600;
      this.getWidth = __bind(this.getWidth, this);
      this.getHeight = __bind(this.getHeight, this);
      this.getDimensions = __bind(this.getDimensions, this);
      this.translate = __bind(this.translate, this);
      this.shear = __bind(this.shear, this);
      this.scale = __bind(this.scale, this);
      this.rotate = __bind(this.rotate, this);
      this.push = __bind(this.push, this);
      this.pop = __bind(this.pop, this);
      this.origin = __bind(this.origin, this);
      this.setWireframe = __bind(this.setWireframe, this);
      this.setStencil = __bind(this.setStencil, this);
      this.setShader = __bind(this.setShader, this);
      this.setScissor = __bind(this.setScissor, this);
      this.setPointStyle = __bind(this.setPointStyle, this);
      this.setPointSize = __bind(this.setPointSize, this);
      this.setLineWidth = __bind(this.setLineWidth, this);
      this.setLineStyle = __bind(this.setLineStyle, this);
      this.setLineJoin = __bind(this.setLineJoin, this);
      this.setInvertedStencil = __bind(this.setInvertedStencil, this);
      this.setDefaultFilter = __bind(this.setDefaultFilter, this);
      this.setColorMask = __bind(this.setColorMask, this);
      this.setFont = __bind(this.setFont, this);
      this.setColor = __bind(this.setColor, this);
      this.setCanvas = __bind(this.setCanvas, this);
      this.setBlendMode = __bind(this.setBlendMode, this);
      this.setBackgroundColor = __bind(this.setBackgroundColor, this);
      this.reset = __bind(this.reset, this);
      this.isWireframe = __bind(this.isWireframe, this);
      this.isSupported = __bind(this.isSupported, this);
      this.getSystemLimit = __bind(this.getSystemLimit, this);
      this.getShader = __bind(this.getShader, this);
      this.getScissor = __bind(this.getScissor, this);
      this.getRendererInfo = __bind(this.getRendererInfo, this);
      this.getPointStyle = __bind(this.getPointStyle, this);
      this.getPointSize = __bind(this.getPointSize, this);
      this.getMaxPointSize = __bind(this.getMaxPointSize, this);
      this.getMaxImageSize = __bind(this.getMaxImageSize, this);
      this.getLineWidth = __bind(this.getLineWidth, this);
      this.getLineStyle = __bind(this.getLineStyle, this);
      this.getLineJoin = __bind(this.getLineJoin, this);
      this.getFont = __bind(this.getFont, this);
      this.getDefaultFilter = __bind(this.getDefaultFilter, this);
      this.getColorMask = __bind(this.getColorMask, this);
      this.getColor = __bind(this.getColor, this);
      this.getCanvas = __bind(this.getCanvas, this);
      this.getBlendMode = __bind(this.getBlendMode, this);
      this.getBackgroundColor = __bind(this.getBackgroundColor, this);
      this.setNewFont = __bind(this.setNewFont, this);
      this.newSpriteBatch = __bind(this.newSpriteBatch, this);
      this.newShader = __bind(this.newShader, this);
      this.newScreenshot = __bind(this.newScreenshot, this);
      this.newQuad = __bind(this.newQuad, this);
      this.newParticleSystem = __bind(this.newParticleSystem, this);
      this.newMesh = __bind(this.newMesh, this);
      this.newImageFont = __bind(this.newImageFont, this);
      this.newImage = __bind(this.newImage, this);
      this.newFont = __bind(this.newFont, this);
      this.newCanvas = __bind(this.newCanvas, this);
      this.rectangle = __bind(this.rectangle, this);
      this.printf = __bind(this.printf, this);
      this.print = __bind(this.print, this);
      this.polygon = __bind(this.polygon, this);
      this.point = __bind(this.point, this);
      this.line = __bind(this.line, this);
      this.draw = __bind(this.draw, this);
      this.clear = __bind(this.clear, this);
      this.circle = __bind(this.circle, this);
      this.arc = __bind(this.arc, this);
      this.canvas = new Canvas2D(this.width, this.height);
      document.body.appendChild(this.canvas.element);
      this.default_canvas = this.canvas;
      this.default_font = new Font("Vera", 12);
      this.setColor(255, 255, 255);
      this.setBackgroundColor(0, 0, 0);
      this.setFont(this.default_font);
    }

    Graphics.prototype.arc = function(mode, x, y, radius, startAngle, endAngle, segments) {
      return this.canvas.arc(mode, x, y, radius, startAngle, endAngle, segments);
    };

    Graphics.prototype.circle = function(mode, x, y, radius, segments) {
      return this.canvas.circle(mode, x, y, radius, segments);
    };

    Graphics.prototype.clear = function() {
      var a, b, g, r, _ref;
      _ref = this.getBackgroundColor(), r = _ref[0], g = _ref[1], b = _ref[2], a = _ref[3];
      return this.canvas.clear(this.canvas, r, g, b, a);
    };

    Graphics.prototype.draw = function() {
      var args, _ref;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return (_ref = this.canvas).draw.apply(_ref, args);
    };

    Graphics.prototype.line = function() {
      var points, _ref;
      points = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return (_ref = this.canvas).line.apply(_ref, points);
    };

    Graphics.prototype.point = function(x, y) {
      return this.canvas.point(x, y);
    };

    Graphics.prototype.polygon = function() {
      var mode, points;
      mode = arguments[0], points = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      return this.canvas.polygon(mode, points);
    };

    Graphics.prototype.print = function(text, x, y) {
      return this.canvas.print(text, x, y);
    };

    Graphics.prototype.printf = function(text, x, y, limit, align) {
      if (align == null) {
        align = "left";
      }
      return this.canvas.printf(text, x, y, limit, align);
    };

    Graphics.prototype.rectangle = function(mode, x, y, width, height) {
      return this.canvas.rectangle(mode, x, y, width, height);
    };

    Graphics.prototype.newCanvas = function(width, height) {
      return new Canvas(width, height);
    };

    Graphics.prototype.newFont = function(filename, size) {
      if (size == null) {
        size = 12;
      }
      return new Font(filename, size);
    };

    Graphics.prototype.newImage = function(path) {
      return new Image(path);
    };

    Graphics.prototype.newImageFont = function() {};

    Graphics.prototype.newMesh = function() {};

    Graphics.prototype.newParticleSystem = function() {};

    Graphics.prototype.newQuad = function(x, y, width, height, sw, sh) {
      return new Quad(x, y, width, height, sw, sh);
    };

    Graphics.prototype.newScreenshot = function() {};

    Graphics.prototype.newShader = function() {};

    Graphics.prototype.newSpriteBatch = function() {};

    Graphics.prototype.setNewFont = function(filename, size) {
      var font;
      font = this.newFont(filename, size);
      return this.setFont(font);
    };

    Graphics.prototype.getBackgroundColor = function() {
      return this.canvas.getBackgroundColor();
    };

    Graphics.prototype.getBlendMode = function() {
      return this.canvas.getBlendMode();
    };

    Graphics.prototype.getCanvas = function() {
      return this.canvas;
    };

    Graphics.prototype.getColor = function() {
      return this.canvas.getColor();
    };

    Graphics.prototype.getColorMask = function() {
      return this.canvas.getColorMask();
    };

    Graphics.prototype.getDefaultFilter = function() {
      return this.canvas.getDefaultFilter();
    };

    Graphics.prototype.getFont = function() {
      return this.canvas.getFont();
    };

    Graphics.prototype.getLineJoin = function() {
      return this.canvas.getLineJoin();
    };

    Graphics.prototype.getLineStyle = function() {
      return this.canvas.getLineStyle();
    };

    Graphics.prototype.getLineWidth = function() {
      return this.canvas.getLineWidth();
    };

    Graphics.prototype.getMaxImageSize = function() {
      return this.canvas.getMaxImageSize();
    };

    Graphics.prototype.getMaxPointSize = function() {
      return this.canvas.getMaxPointSize();
    };

    Graphics.prototype.getPointSize = function() {
      return this.canvas.getPointSize();
    };

    Graphics.prototype.getPointStyle = function() {
      return this.canvas.getPointStyle();
    };

    Graphics.prototype.getRendererInfo = function() {
      return this.canvas.getRendererInfo();
    };

    Graphics.prototype.getScissor = function() {
      return this.canvas.getScissor();
    };

    Graphics.prototype.getShader = function() {
      return this.canvas.getShader();
    };

    Graphics.prototype.getSystemLimit = function() {
      return this.canvas.getSystemLimit();
    };

    Graphics.prototype.isSupported = function() {};

    Graphics.prototype.isWireframe = function() {
      return this.canvas.isWireframe();
    };

    Graphics.prototype.reset = function() {
      this.setCanvas();
      return this.origin();
    };

    Graphics.prototype.setBackgroundColor = function(r, g, b, a) {
      if (a == null) {
        a = 255;
      }
      return this.canvas.setBackgroundColor(r, g, b, a);
    };

    Graphics.prototype.setBlendMode = function(mode) {
      return this.canvas.setBlendMode(mode);
    };

    Graphics.prototype.setCanvas = function(canvas) {
      if (canvas === void 0 || canvas === null) {
        this.default_canvas.copyContext(this.canvas.context);
        return this.canvas = this.default_canvas;
      } else {
        canvas.copyContext(this.canvas.context);
        return this.canvas = canvas;
      }
    };

    Graphics.prototype.setColor = function(r, g, b, a) {
      if (a == null) {
        a = 255;
      }
      return this.canvas.setColor(r, g, b, a);
    };

    Graphics.prototype.setFont = function(font) {
      return this.canvas.setFont(font);
    };

    Graphics.prototype.setColorMask = function(r, g, b, a) {
      return this.canvas.setColorMask(r, g, b, a);
    };

    Graphics.prototype.setDefaultFilter = function(min, mag, anisotropy) {
      return this.canvas.setDefaultFilter(min, mag, anisotropy);
    };

    Graphics.prototype.setInvertedStencil = function(callback) {
      return this.canvas.setInvertedStencil(callback);
    };

    Graphics.prototype.setLineJoin = function(join) {
      return this.canvas.setLineJoin(join);
    };

    Graphics.prototype.setLineStyle = function(style) {
      return this.canvas.setLineStyle(style);
    };

    Graphics.prototype.setLineWidth = function(width) {
      return this.canvas.setLineWidth(width);
    };

    Graphics.prototype.setPointSize = function(size) {
      return this.canvas.setPointSize(size);
    };

    Graphics.prototype.setPointStyle = function(style) {
      return this.canvas.setPointStyle(style);
    };

    Graphics.prototype.setScissor = function(x, y, width, height) {
      return this.canvas.setScissor(x, y, width, height);
    };

    Graphics.prototype.setShader = function(shader) {
      return this.canvas.setShader(shader);
    };

    Graphics.prototype.setStencil = function(callback) {
      return this.canvas.setStencil(callback);
    };

    Graphics.prototype.setWireframe = function(enable) {
      return this.canvas.setWireframe(enable);
    };

    Graphics.prototype.origin = function() {
      return this.canvas.origin();
    };

    Graphics.prototype.pop = function() {
      return this.canvas.pop();
    };

    Graphics.prototype.push = function() {
      return this.canvas.push();
    };

    Graphics.prototype.rotate = function(r) {
      return this.canvas.rotate(r);
    };

    Graphics.prototype.scale = function(sx, sy) {
      if (sy == null) {
        sy = sx;
      }
      return this.canvas.scale(sx, sy);
    };

    Graphics.prototype.shear = function(kx, ky) {
      return this.canvas.shear(kx, ky);
    };

    Graphics.prototype.translate = function(dx, dy) {
      return this.canvas.translate(dx, dy);
    };

    Graphics.prototype.getDimensions = function() {
      return [this.getWidth(), this.getHeight()];
    };

    Graphics.prototype.getHeight = function() {
      return this.default_canvas.getHeight();
    };

    Graphics.prototype.getWidth = function() {
      return this.default_canvas.getWidth();
    };

    return Graphics;

  })();

  Keyboard = (function() {
    var getKeyFromEvent, keys, rightKeys, shiftedKeys;

    function Keyboard(eventQueue) {
      this.isDown = __bind(this.isDown, this);
      this.keysDown = {};
      document.addEventListener("keydown", (function(_this) {
        return function(evt) {
          var key;
          evt.preventDefault();
          evt.stopPropagation();
          key = getKeyFromEvent(evt);
          _this.keysDown[key] = true;
          return eventQueue.push("keypressed", key, evt.which);
        };
      })(this));
      document.addEventListener("keyup", (function(_this) {
        return function(evt) {
          var key;
          evt.preventDefault();
          evt.stopPropagation();
          key = getKeyFromEvent(evt);
          _this.keysDown[key] = false;
          return eventQueue.push("keyreleased", key, evt.which);
        };
      })(this));
    }

    Keyboard.prototype.isDown = function() {
      var key, others;
      key = arguments[0], others = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      if (this.keysDown[key]) {
        return true;
      } else {
        if (others.length === 0) {
          return false;
        } else {
          return this.isDown.apply(this, others);
        }
      }
    };

    keys = {
      8: "backspace",
      9: "tab",
      13: "return",
      16: "shift",
      17: "ctrl",
      18: "alt",
      19: "pause",
      20: "capslock",
      27: "escape",
      33: "pageup",
      34: "pagedown",
      35: "end",
      36: "home",
      45: "insert",
      46: "delete",
      37: "left",
      38: "up",
      39: "right",
      40: "down",
      91: "lmeta",
      92: "rmeta",
      93: "mode",
      96: "kp0",
      97: "kp1",
      98: "kp2",
      99: "kp3",
      100: "kp4",
      101: "kp5",
      102: "kp6",
      103: "kp7",
      104: "kp8",
      105: "kp9",
      106: "kp*",
      107: "kp+",
      109: "kp-",
      110: "kp.",
      111: "kp/",
      112: "f1",
      113: "f2",
      114: "f3",
      115: "f4",
      116: "f5",
      117: "f6",
      118: "f7",
      119: "f8",
      120: "f9",
      121: "f10",
      122: "f11",
      123: "f12",
      144: "numlock",
      145: "scrolllock",
      186: ",",
      187: "=",
      188: ",",
      189: "-",
      190: ".",
      191: "/",
      192: "`",
      219: "[",
      220: "\\",
      221: "]",
      222: "'"
    };

    shiftedKeys = {
      192: "~",
      48: ")",
      49: "!",
      50: "@",
      51: "#",
      52: "$",
      53: "%",
      54: "^",
      55: "&",
      56: "*",
      57: "(",
      109: "_",
      61: "+",
      219: "{",
      221: "}",
      220: "|",
      59: ":",
      222: "\"",
      188: "<",
      189: ">",
      191: "?",
      96: "insert",
      97: "end",
      98: "down",
      99: "pagedown",
      100: "left",
      102: "right",
      103: "home",
      104: "up",
      105: "pageup"
    };

    rightKeys = {
      16: "rshift",
      17: "rctrl",
      18: "ralt"
    };

    getKeyFromEvent = function(event) {
      var code, key;
      code = event.which;
      if (event.location && event.location > 1) {
        key = rightKeys[code];
      } else if (event.shiftKey) {
        key = shiftedKeys[code] || keys[code];
      } else {
        key = keys[code];
      }
      if (typeof key === "undefined") {
        key = String.fromCharCode(code);
        if (!event.shiftKey) {
          key = key.toLowerCase();
        }
      }
      return key;
    };

    return Keyboard;

  })();

  this.Love = (function() {
    function Love(window_conf) {
      this.run = __bind(this.run, this);
      this.graphics = new Graphics(window_conf.width, window_conf.height);
      this.window = new Window(this.graphics);
      this.timer = new Timer();
      this.event = new EventQueue();
      this.keyboard = new Keyboard(this.event);
      this.mouse = new Mouse(this.event, this.graphics.default_canvas.element);
      this.filesystem = new FileSystem();
      this.audio = new Audio();
      this.system = new System();
      window.addEventListener("beforeunload", (function(_this) {
        return function() {
          return _this.quit.call();
        };
      })(this));
    }

    Love.prototype.run = function() {
      var game_loop;
      this.timer.step();
      this.load.call();
      game_loop = (function(_this) {
        return function() {
          var e, _i, _len, _ref;
          _ref = _this.event.internalQueue;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            e = _ref[_i];
            _this[e.eventType].call(null, e.arg1, e.arg2, e.arg3, e.arg4);
          }
          _this.event.clear();
          _this.timer.step();
          _this.update.call(null, _this.timer.getDelta());
          _this.graphics.origin();
          _this.graphics.clear();
          _this.draw.call();
          return _this.timer.nextFrame(game_loop);
        };
      })(this);
      return this.timer.nextFrame(game_loop);
    };

    Love.prototype.load = function(args) {};

    Love.prototype.update = function(dt) {};

    Love.prototype.mousepressed = function(x, y, button) {};

    Love.prototype.mousereleased = function(x, y, button) {};

    Love.prototype.keypressed = function(key, unicode) {};

    Love.prototype.keyreleased = function(key, unicode) {};

    Love.prototype.draw = function() {};

    Love.prototype.quit = function() {};

    return Love;

  })();

  Mouse = (function() {
    var getButtonFromEvent, getWheelButtonFromEvent, mouseButtonNames;

    function Mouse(eventQueue, canvas) {
      this.setY = __bind(this.setY, this);
      this.setX = __bind(this.setX, this);
      this.setVisible = __bind(this.setVisible, this);
      this.setPosition = __bind(this.setPosition, this);
      this.setGrabbed = __bind(this.setGrabbed, this);
      this.setCursor = __bind(this.setCursor, this);
      this.newCursor = __bind(this.newCursor, this);
      this.isVisible = __bind(this.isVisible, this);
      this.isGrabbed = __bind(this.isGrabbed, this);
      this.isDown = __bind(this.isDown, this);
      this.getY = __bind(this.getY, this);
      this.getX = __bind(this.getX, this);
      this.getSystemCursor = __bind(this.getSystemCursor, this);
      this.getPosition = __bind(this.getPosition, this);
      this.getCursor = __bind(this.getCursor, this);
      var handlePress, handleRelease, handleWheel;
      this.x = 0;
      this.y = 0;
      this.buttonsDown = {};
      this.wheelTimeOuts = {};
      handlePress = (function(_this) {
        return function(button) {
          _this.buttonsDown[button] = true;
          return eventQueue.push("mousepressed", _this.x, _this.y, button);
        };
      })(this);
      handleRelease = (function(_this) {
        return function(button) {
          _this.buttonsDown[button] = false;
          return eventQueue.push("mousereleased", _this.x, _this.y, button);
        };
      })(this);
      handleWheel = (function(_this) {
        return function(evt) {
          var button;
          evt.preventDefault();
          button = getWheelButtonFromEvent(evt);
          clearTimeout(mouse.wheelTimeOuts[button]);
          mouse.wheelTimeOuts[button] = setTimeout(function() {
            return handleRelease(button);
          }, Mouse.WHEEL_TIMEOUT * 1000);
          return handlePress(button);
        };
      })(this);
      canvas.addEventListener('mousemove', (function(_this) {
        return function(evt) {
          _this.x = evt.offsetX;
          return _this.y = evt.offsetY;
        };
      })(this));
      canvas.addEventListener('mousedown', (function(_this) {
        return function(evt) {
          return handlePress(getButtonFromEvent(evt));
        };
      })(this));
      canvas.addEventListener('mouseup', (function(_this) {
        return function(evt) {
          return handleRelease(getButtonFromEvent(evt));
        };
      })(this));
      canvas.addEventListener('DOMMouseScroll', handleWheel);
      canvas.addEventListener('mousewheel', handleWheel);
    }

    Mouse.prototype.getCursor = function() {
      return null;
    };

    Mouse.prototype.getPosition = function() {
      return [this.x, this.y];
    };

    Mouse.prototype.getSystemCursor = function() {
      return null;
    };

    Mouse.prototype.getX = function() {
      return this.x;
    };

    Mouse.prototype.getY = function() {
      return this.y;
    };

    Mouse.prototype.isDown = function() {
      var button, others;
      button = arguments[0], others = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      if (this.buttonsDown[button]) {
        return true;
      } else {
        if (others.length === 0) {
          return false;
        } else {
          return this.isDown.apply(this, others);
        }
      }
    };

    Mouse.prototype.isGrabbed = function() {
      return false;
    };

    Mouse.prototype.isVisible = function() {
      return true;
    };

    Mouse.prototype.newCursor = function() {
      return null;
    };

    Mouse.prototype.setCursor = function(cursor) {};

    Mouse.prototype.setGrabbed = function(grab) {};

    Mouse.prototype.setPosition = function(x, y) {
      this.setX(x);
      return this.setY(y);
    };

    Mouse.prototype.setVisible = function(visible) {};

    Mouse.prototype.setX = function(x) {};

    Mouse.prototype.setY = function(y) {};

    mouseButtonNames = {
      1: "l",
      2: "m",
      3: "r"
    };

    getButtonFromEvent = function(evt) {
      return mouseButtonNames[evt.which];
    };

    getWheelButtonFromEvent = function(evt) {
      var delta;
      delta = Math.max(-1, Math.min(1, evt.wheelDelta || -evt.detail));
      if (delta === 1) {
        return 'wu';
      } else {
        return 'wd';
      }
    };

    return Mouse;

  })();

  Mouse.WHEEL_TIMEOUT = 0.02;

  System = (function() {
    function System() {
      this.setClipboardText = __bind(this.setClipboardText, this);
      this.openURL = __bind(this.openURL, this);
      this.getProcessorCount = __bind(this.getProcessorCount, this);
      this.getPowerInfo = __bind(this.getPowerInfo, this);
      this.getOS = __bind(this.getOS, this);
      this.getClipboardText = __bind(this.getClipboardText, this);
    }

    System.prototype.getClipboardText = function() {};

    System.prototype.getOS = function() {
      return window.navigator.appVersion;
    };

    System.prototype.getPowerInfo = function() {
      var battery, percent, seconds, state;
      battery = window.navigator.battery;
      if (battery) {
        state = battery.charging ? "charging" : "unknown";
        percent = battery.level * 100;
        seconds = battery.dischargingTime;
        return [state, percent, seconds];
      } else {
        return ["unknown", null, null];
      }
    };

    System.prototype.getProcessorCount = function() {
      return window.navigator.hardwareConcurrency || 1;
    };

    System.prototype.openURL = function(url) {
      return window.open(url);
    };

    System.prototype.setClipboardText = function(text) {};

    return System;

  })();

  Timer = (function() {
    var lastTime, performance, requestAnimationFrame;

    function Timer() {
      this.step = __bind(this.step, this);
      this.sleep = __bind(this.sleep, this);
      this.getTime = __bind(this.getTime, this);
      this.getFPS = __bind(this.getFPS, this);
      this.getDelta = __bind(this.getDelta, this);
      this.nextFrame = __bind(this.nextFrame, this);
      this.microTime = performance.now();
      this.deltaTime = 0;
      this.deltaTimeLimit = 0.25;
      this.events = {};
      this.maxEventId = 0;
    }

    Timer.prototype.nextFrame = function(callback) {
      return requestAnimationFrame(callback);
    };

    Timer.prototype.getDelta = function() {
      return this.deltaTime;
    };

    Timer.prototype.getFPS = function() {
      if (this.deltaTime === 0) {
        return 0;
      } else {
        return 1 / this.deltaTime;
      }
    };

    Timer.prototype.getTime = function() {
      return this.microTime;
    };

    Timer.prototype.sleep = function() {};

    Timer.prototype.step = function() {
      var dt;
      dt = (performance.now() - this.microTime) / 1000;
      this.deltaTime = Math.max(0, Math.min(this.deltaTimeLimit, dt));
      return this.microTime += dt * 1000;
    };

    performance = window.performance || Date;

    performance.now = performance.now || performance.msNow || performance.mozNow || performance.webkitNow || Date.now;

    lastTime = 0;

    requestAnimationFrame = window.requestAnimationFrame || window.msRequestAnimationFrame || window.mozRequestAnimationFrame || window.webkitRequestAnimationFrame || window.oRequestAnimationFrame || function(callback) {
      var currTime, delay, timeToCall;
      currTime = performance.now();
      timeToCall = Math.max(0, 16 - (currTime - lastTime));
      delay = function() {
        return callback(currTime + timeToCall);
      };
      lastTime = currTime + timeToCall;
      return setTimeout(delay, timeToCall);
    };

    return Timer;

  })();

  Window = (function() {
    function Window(graphics) {
      this.graphics = graphics;
      this.setTitle = __bind(this.setTitle, this);
      this.setMode = __bind(this.setMode, this);
      this.setIcon = __bind(this.setIcon, this);
      this.setFullscreen = __bind(this.setFullscreen, this);
      this.isVisible = __bind(this.isVisible, this);
      this.isCreated = __bind(this.isCreated, this);
      this.hasMouseFocus = __bind(this.hasMouseFocus, this);
      this.hasFocus = __bind(this.hasFocus, this);
      this.getWidth = __bind(this.getWidth, this);
      this.getTitle = __bind(this.getTitle, this);
      this.getPixelScale = __bind(this.getPixelScale, this);
      this.getMode = __bind(this.getMode, this);
      this.getIcon = __bind(this.getIcon, this);
      this.getHeight = __bind(this.getHeight, this);
      this.getFullscreenModes = __bind(this.getFullscreenModes, this);
      this.getFullscreen = __bind(this.getFullscreen, this);
      this.getDisplayCount = __bind(this.getDisplayCount, this);
      this.getDimensions = __bind(this.getDimensions, this);
      this.getDesktopDimensions = __bind(this.getDesktopDimensions, this);
    }

    Window.prototype.getDesktopDimensions = function() {};

    Window.prototype.getDimensions = function() {};

    Window.prototype.getDisplayCount = function() {};

    Window.prototype.getFullscreen = function() {};

    Window.prototype.getFullscreenModes = function() {};

    Window.prototype.getHeight = function() {};

    Window.prototype.getIcon = function() {};

    Window.prototype.getMode = function() {};

    Window.prototype.getPixelScale = function() {};

    Window.prototype.getTitle = function() {};

    Window.prototype.getWidth = function() {};

    Window.prototype.hasFocus = function() {};

    Window.prototype.hasMouseFocus = function() {};

    Window.prototype.isCreated = function() {};

    Window.prototype.isVisible = function() {};

    Window.prototype.setFullscreen = function() {};

    Window.prototype.setIcon = function() {};

    Window.prototype.setMode = function(width, height, flags) {
      return this.graphics.canvas.setDimensions(width, height);
    };

    Window.prototype.setTitle = function() {};

    return Window;

  })();

  Source = (function() {
    function Source(filename, type) {
      this.filename = filename;
      this.type = type;
      this.element = document.createElement("audio");
      this.element.setAttribute("src", "lua/" + filename);
      this.element.setAttribute("preload", "auto");
    }

    Source.prototype.clone = function(self) {
      return new Source(self.filename, self.type);
    };

    Source.prototype.getAttenuationDistances = function(self) {};

    Source.prototype.getChannels = function(self) {};

    Source.prototype.getCone = function(self) {};

    Source.prototype.getDirection = function(self) {};

    Source.prototype.getPitch = function(self) {};

    Source.prototype.getPosition = function(self) {};

    Source.prototype.getRolloff = function(self) {};

    Source.prototype.getVelocity = function(self) {};

    Source.prototype.getVolume = function(self) {
      return self.element.volume;
    };

    Source.prototype.getVolumeLimits = function(self) {};

    Source.prototype.isLooping = function(self) {
      return !!self.element.getAttribute("loop");
    };

    Source.prototype.isPaused = function(self) {
      return self.element.paused;
    };

    Source.prototype.isPlaying = function(self) {
      return !self.element.paused;
    };

    Source.prototype.isRelative = function(self) {};

    Source.prototype.isStatic = function(self) {};

    Source.prototype.isStopped = function(self) {
      return self.isPaused(self) && self.currentTime === 0;
    };

    Source.prototype.pause = function(self) {
      return self.element.pause();
    };

    Source.prototype.play = function(self) {
      return self.element.play();
    };

    Source.prototype.resume = function(self) {
      return self.element.play();
    };

    Source.prototype.rewind = function(self) {
      return self.element.currentTime = 0;
    };

    Source.prototype.seek = function(self, offset, time_unit) {
      if (time_unit == null) {
        time_unit = "seconds";
      }
      switch (time_unit) {
        case "seconds":
          return self.element.currentTime = offset;
      }
    };

    Source.prototype.setAttenuationDistances = function(self) {};

    Source.prototype.setCone = function(self) {};

    Source.prototype.setDirection = function(self) {};

    Source.prototype.setLooping = function(self, looping) {
      return self.element.setAttribute("loop", looping);
    };

    Source.prototype.setPitch = function(self) {};

    Source.prototype.setPosition = function(self) {};

    Source.prototype.setRelative = function(self) {};

    Source.prototype.setRolloff = function(self) {};

    Source.prototype.setVelocity = function(self) {};

    Source.prototype.setVolume = function(self, volume) {
      return self.element.volume = volume;
    };

    Source.prototype.setVolumeLimits = function(self) {};

    Source.prototype.stop = function(self) {
      return self.element.load();
    };

    Source.prototype.tell = function(self, time_unit) {
      if (time_unit == null) {
        time_unit = "seconds";
      }
      switch (time_unit) {
        case "seconds":
          return self.element.currentTime;
        case "samples":
          return 0;
      }
    };

    return Source;

  })();

  Canvas2D = (function() {
    var drawDrawable, drawWithQuad;

    function Canvas2D(width, height) {
      this.element = document.createElement('canvas');
      this.setDimensions(width, height);
      this.context = this.element.getContext('2d');
      this.current_transform = Matrix.I(3);
    }

    Canvas2D.prototype.clear = function(self, r, g, b, a) {
      var color;
      if (r === null || r === void 0) {
        color = Canvas2D.transparent;
      } else {
        color = new Color(r, g, b, a);
      }
      self.context.save();
      self.context.setTransform(1, 0, 0, 1, 0, 0);
      self.context.fillStyle = color.html_code;
      self.context.globalAlpha = color.a / 255;
      self.context.fillRect(0, 0, self.width, self.height);
      return self.context.restore();
    };

    Canvas2D.prototype.getDimensions = function(self) {
      return [this.getWidth(self), this.getHeight(self)];
    };

    Canvas2D.prototype.getHeight = function(self) {
      return self.height;
    };

    Canvas2D.prototype.getImageData = function(self) {
      var image_data;
      image_data = self.context.getImageData(0, 0, self.width, self.height);
      return new ImageData(image_data);
    };

    Canvas2D.prototype.getPixel = function(self, x, y) {
      var data;
      data = self.context.getImageData(x, y, 1, 1).data;
      return [data[0], data[1], data[2], data[3]];
    };

    Canvas2D.prototype.getWidth = function(self) {
      return self.width;
    };

    Canvas2D.prototype.getWrap = function(self) {};

    Canvas2D.prototype.setWrap = function(self) {};

    Canvas2D.prototype.arc = function(mode, x, y, radius, startAngle, endAngle, segments) {
      this.context.beginPath();
      this.context.moveTo(x, y);
      this.context.arc(x, y, radius, startAngle, endAngle);
      this.context.closePath();
      switch (mode) {
        case "fill":
          return this.context.fill();
        case "line":
          return this.context.stroke();
      }
    };

    Canvas2D.prototype.circle = function(mode, x, y, radius, segments) {
      this.context.beginPath();
      this.context.arc(x, y, radius, 0, 2 * Math.PI);
      this.context.closePath();
      switch (mode) {
        case "fill":
          return this.context.fill();
        case "line":
          return this.context.stroke();
      }
    };

    Canvas2D.prototype.draw = function(drawable, quad) {
      switch (true) {
        case !(quad instanceof Quad):
          return drawDrawable.apply(this, arguments);
        case quad instanceof Quad:
          return drawWithQuad.apply(this, arguments);
      }
    };

    Canvas2D.prototype.line = function() {
      var i, points, x, y, _i, _ref, _ref1;
      points = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      this.context.beginPath();
      this.context.moveTo(points[0], points[1]);
      for (i = _i = 2, _ref = points.length; _i < _ref; i = _i += 2) {
        _ref1 = [points[i], points[i + 1]], x = _ref1[0], y = _ref1[1];
        this.context.lineTo(x, y);
      }
      return this.context.stroke();
    };

    Canvas2D.prototype.point = function(x, y) {
      return this.context.fillRect(x, y, 1, 1);
    };

    Canvas2D.prototype.polygon = function() {
      var i, mode, points, x, y, _i, _ref, _ref1;
      mode = arguments[0], points = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      this.context.beginPath();
      this.context.moveTo(points[0], points[1]);
      for (i = _i = 2, _ref = points.length; _i < _ref; i = _i += 2) {
        _ref1 = [points[i], points[i + 1]], x = _ref1[0], y = _ref1[1];
        this.context.lineTo(x, y);
      }
      this.context.closePath();
      switch (mode) {
        case "fill":
          return this.context.fill();
        case "line":
          return this.context.stroke();
      }
    };

    Canvas2D.prototype.print = function(text, x, y) {
      return this.context.fillText(text, x, y);
    };

    Canvas2D.prototype.printf = function(text, x, y, limit, align) {
      if (align == null) {
        align = "left";
      }
      this.context.save();
      this.context.translate(x + limit / 2, y);
      switch (align) {
        case "center":
          this.context.textAlign = "center";
          break;
        case "left":
          this.context.textAlign = "left";
          break;
        case "right":
          this.context.textAlign = "right";
      }
      this.context.fillText(text, 0, 0);
      this.context.restore();
      return this.context.textBaseline = "top";
    };

    Canvas2D.prototype.rectangle = function(mode, x, y, width, height) {
      switch (mode) {
        case "fill":
          return this.context.fillRect(x, y, width, height);
        case "line":
          return this.context.strokeRect(x, y, width, height);
      }
    };

    Canvas2D.prototype.getBackgroundColor = function() {
      var c;
      c = this.background_color;
      return [c.r, c.g, c.b, c.a];
    };

    Canvas2D.prototype.getBlendMode = function() {};

    Canvas2D.prototype.getColor = function() {
      var c;
      c = this.current_color;
      return [c.r, c.g, c.b, c.a];
    };

    Canvas2D.prototype.getColorMask = function() {};

    Canvas2D.prototype.getDefaultFilter = function() {};

    Canvas2D.prototype.getFont = function() {
      return this.current_font;
    };

    Canvas2D.prototype.getLineJoin = function() {};

    Canvas2D.prototype.getLineStyle = function() {};

    Canvas2D.prototype.getLineWidth = function() {};

    Canvas2D.prototype.getMaxImageSize = function() {};

    Canvas2D.prototype.getMaxPointSize = function() {};

    Canvas2D.prototype.getPointSize = function() {};

    Canvas2D.prototype.getPointStyle = function() {};

    Canvas2D.prototype.getRendererInfo = function() {};

    Canvas2D.prototype.getScissor = function() {};

    Canvas2D.prototype.getShader = function() {};

    Canvas2D.prototype.getSystemLimit = function() {};

    Canvas2D.prototype.isSupported = function() {};

    Canvas2D.prototype.isWireframe = function() {};

    Canvas2D.prototype.setBackgroundColor = function(r, g, b, a) {
      if (typeof r === "number") {
        return this.background_color = new Color(r, g, b, a);
      } else {
        return this.background_color = new Color(r.getMember(1), r.getMember(2), r.getMember(3), r.getMember(4));
      }
    };

    Canvas2D.prototype.setColor = function(r, g, b, a) {
      if (a == null) {
        a = 255;
      }
      if (typeof r === "number") {
        this.current_color = new Color(r, g, b, a);
      } else {
        this.current_color = new Color(r.getMember(1), r.getMember(2), r.getMember(3), r.getMember(4));
      }
      this.context.fillStyle = this.current_color.html_code;
      this.context.strokeStyle = this.current_color.html_code;
      return this.context.globalAlpha = this.current_color.a / 255;
    };

    Canvas2D.prototype.setFont = function(font) {
      this.current_font = font;
      if (font) {
        return this.context.font = font.html_code;
      } else {
        return this.context.font = this.default_font.html_code;
      }
    };

    Canvas2D.prototype.setColorMask = function() {};

    Canvas2D.prototype.setDefaultFilter = function() {};

    Canvas2D.prototype.setInvertedStencil = function() {};

    Canvas2D.prototype.setLineJoin = function() {};

    Canvas2D.prototype.setLineStyle = function() {};

    Canvas2D.prototype.setLineWidth = function() {};

    Canvas2D.prototype.setPointSize = function() {};

    Canvas2D.prototype.setPointStyle = function() {};

    Canvas2D.prototype.setScissor = function(x, y, width, height) {};

    Canvas2D.prototype.setShader = function() {};

    Canvas2D.prototype.setStencil = function(callback) {};

    Canvas2D.prototype.setWireframe = function() {};

    Canvas2D.prototype.origin = function() {
      return this.context.setTransform(1, 0, 0, 1, 0, 0);
    };

    Canvas2D.prototype.pop = function() {
      return this.context.restore();
    };

    Canvas2D.prototype.push = function() {
      return this.context.save();
    };

    Canvas2D.prototype.rotate = function(r) {
      return this.context.rotate(r);
    };

    Canvas2D.prototype.scale = function(sx, sy) {
      if (sy == null) {
        sy = sx;
      }
      return this.context.scale(sx, sy);
    };

    Canvas2D.prototype.shear = function(kx, ky) {
      return this.context.transform(1, ky, kx, 1, 0, 0);
    };

    Canvas2D.prototype.translate = function(dx, dy) {
      return this.context.translate(dx, dy);
    };

    Canvas2D.prototype.copyContext = function(context) {
      this.context.fillStyle = context.fillStyle;
      this.context.font = context.font;
      this.context.globalAlpha = context.globalAlpha;
      this.context.globalCompositeOperation = context.globalCompositeOperation;
      this.context.lineCap = context.lineCap;
      this.context.lineDashOffset = context.lineDashOffset;
      this.context.lineJoin = context.lineJoin;
      this.context.lineWidth = context.lineWidth;
      this.context.miterLimit = context.miterLimit;
      this.context.shadowBlur = context.shadowBlur;
      this.context.shadowColor = context.shadowColor;
      this.context.shadowOffsetX = context.shadowOffsetX;
      this.context.shadowOffsetY = context.shadowOffsetY;
      this.context.strokeStyle = context.strokeStyle;
      this.context.textAlign = context.textAlign;
      return this.context.textBaseline = context.textBaseline;
    };

    Canvas2D.prototype.setDimensions = function(width, height) {
      this.width = width;
      this.height = height;
      this.element.setAttribute('width', this.width);
      return this.element.setAttribute('height', this.height);
    };

    drawDrawable = function(drawable, x, y, r, sx, sy, ox, oy, kx, ky) {
      var halfHeight, halfWidth;
      if (x == null) {
        x = 0;
      }
      if (y == null) {
        y = 0;
      }
      if (r == null) {
        r = 0;
      }
      if (sx == null) {
        sx = 1;
      }
      if (sy == null) {
        sy = sx;
      }
      if (ox == null) {
        ox = 0;
      }
      if (oy == null) {
        oy = 0;
      }
      if (kx == null) {
        kx = 0;
      }
      if (ky == null) {
        ky = 0;
      }
      halfWidth = drawable.element.width / 2;
      halfHeight = drawable.element.height / 2;
      this.context.save();
      this.context.translate(x, y);
      this.context.rotate(r);
      this.context.scale(sx, sy);
      this.context.transform(1, ky, kx, 1, 0, 0);
      this.context.translate(-ox, -oy);
      this.context.drawImage(drawable.element, 0, 0);
      return this.context.restore();
    };

    drawWithQuad = function(drawable, quad, x, y, r, sx, sy, ox, oy, kx, ky) {
      var halfHeight, halfWidth;
      if (x == null) {
        x = 0;
      }
      if (y == null) {
        y = 0;
      }
      if (r == null) {
        r = 0;
      }
      if (sx == null) {
        sx = 1;
      }
      if (sy == null) {
        sy = sx;
      }
      if (ox == null) {
        ox = 0;
      }
      if (oy == null) {
        oy = 0;
      }
      if (kx == null) {
        kx = 0;
      }
      if (ky == null) {
        ky = 0;
      }
      halfWidth = drawable.element.width / 2;
      halfHeight = drawable.element.height / 2;
      this.context.save();
      this.context.translate(x, y);
      this.context.rotate(r);
      this.context.scale(sx, sy);
      this.context.transform(1, ky, kx, 1, 0, 0);
      this.context.translate(-ox, -oy);
      this.context.drawImage(drawable.element, quad.x, quad.y, quad.width, quad.height, 0, 0, quad.width, quad.height);
      return this.context.restore();
    };

    return Canvas2D;

  })();

  Canvas2D.transparent = new Color(0, 0, 0, 0);

  Font = (function() {
    function Font(filename, size) {
      this.filename = filename;
      this.size = size;
      this.html_code = "" + this.size + "px " + this.filename;
    }

    Font.prototype.getAscent = function(self) {};

    Font.prototype.getBaseline = function(self) {};

    Font.prototype.getDescent = function(self) {};

    Font.prototype.getFilter = function(self) {};

    Font.prototype.getHeight = function(self) {};

    Font.prototype.getLineHeight = function(self) {};

    Font.prototype.getWidth = function(self) {};

    Font.prototype.getWrap = function(self) {};

    Font.prototype.hasGlyphs = function(self) {};

    Font.prototype.setFilter = function(self) {};

    Font.prototype.setLineHeight = function(self) {};

    return Font;

  })();

  Image = (function() {
    function Image(path) {
      this.element = document.getElementById(path);
      if (this.element === null) {
        this.element = document.createElement("img");
        this.element.setAttribute("src", "lua/" + path);
      }
    }

    Image.prototype.getData = function(self) {};

    Image.prototype.getDimensions = function(self) {
      return [self.element.width, self.element.height];
    };

    Image.prototype.getFilter = function(self) {};

    Image.prototype.getHeight = function(self) {
      return self.element.height;
    };

    Image.prototype.getMipmapFilter = function(self) {};

    Image.prototype.getWidth = function(self) {
      return self.element.width;
    };

    Image.prototype.getWrap = function(self) {};

    Image.prototype.isCompressed = function(self) {};

    Image.prototype.refresh = function(self) {};

    Image.prototype.setFilter = function(self) {};

    Image.prototype.setMipmapFilter = function(self) {};

    Image.prototype.setWrap = function(self) {};

    return Image;

  })();

  ImageData = (function() {
    function ImageData() {}

    return ImageData;

  })();

  Quad = (function() {
    function Quad(x, y, width, height, sw, sh) {
      this.x = x;
      this.y = y;
      this.width = width;
      this.height = height;
      this.sw = sw;
      this.sh = sh;
    }

    Quad.prototype.getViewport = function(self) {
      return [self.x, self.y, self.width, self.height];
    };

    Quad.prototype.setViewport = function(self, x, y, width, height) {
      self.x = x;
      self.y = y;
      self.width = width;
      return self.height = height;
    };

    return Quad;

  })();

}).call(this);
