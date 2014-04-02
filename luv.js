(function(root, factory) {
    if(typeof exports === 'object') {
        module.exports = factory();
    }
    else if(typeof define === 'function' && define.amd) {
        define('Luv', [], factory);
    }
    else {
        root.Luv = factory();
    }
}(this, function() {
/*! luv 0.0.1 (2014-04-01) - https://github.com/kikito/luv.js */
/*! Minimal HTML5 game development lib */
/*! Enrique Garcia Cota */
// # core.js

var Luv = (function() {

// ## Luv.js Class System

// Luv.js has a very minimal (and optional) class system, based on functions and, in
// some cases, prototypes.

// By "optional", I mean that you are not required to "inherit from" Luv objects when
// creating a game with Luv.js. You can build your game entities however you want. You
// can make them hold references to Luv.js objects when needed.
// In other words, the relationship between your objects and Luv.js should
// be composition (`has_a`) not inheritance (`is_a`).

// This said, you can certainly use Luv.js class system as a base, if you like it.

// That is, unless you are programming some sort of Luv.js plugin. Then you will probably
// be better off using Luv.js' class system.

// `extend` is similar to [underscore's extend](http://underscorejs.org/#extend), it
// copies into `dest` all the methods of the objects passed in as extra arguments.
var extend = function(dest) {
  var properties;
  for(var i=1; i < arguments.length; i++) {
    properties = arguments[i];
    for(var property in properties) {
      if(properties.hasOwnProperty(property)) {
        dest[property] = properties[property];
      }
    }
  }
  return dest;
};

// `remove` deletes the elements from an object, given an array of names of methods to be deleted
var remove = function(dest, names) {
  names = Array.isArray(names) ? names : [names];
  for(var i=0; i < names.length; i++) { delete dest[names[i]]; }
  return dest;
};

// `create` expects an object, and creates another one which "points to it" through its `__proto__`
// For now, it's just an alias to Object.create
var create = Object.create;


// `baseMethods` contains the instance methods of a basic object (by default just two: `toString` and `getClass`)
var baseMethods = {
  toString: function() { return 'instance of ' + this.getClass().getName(); }
};

// ### Base class definition
var Base = extend(function() {
  return create(baseMethods);
}, {
  init    : function() {},
  getName : function() { return "Base"; },
  toString: function() { return "Base"; },
  getSuper: function() { return null; },
  methods : baseMethods,

  // `include` will extend a class with one or more objects. Acts very similarly to what other languages call
  // "mixins". Example usage:

  //       var Flyer = { fly: function(){ console.log('flap flap'); } };
  //       var Bee = Luv.Class('Bee', {...});
  //       Bee.include(Flyer);

  // It returns the class, so a compressed version of the previous example is:

  //       var Flyer = { fly: function(){ console.log('flap flap'); } };
  //       var Bee = Luv.Class('Bee', {...}).include(Flyer);
  include : function() {
    return extend.apply(this, [this.methods].concat(Array.prototype.slice.call(arguments, 0)));
  },

  // `subclass` is used like this:

  //       var Enemy = Luv.Class('Enemy', {
  //         fight: function() { console.log('zap!'); }
  //         shout: function() { console.log('hey!'); }
  //       });
  //
  //       var Ninja = Enemy.subclass('Ninja', {
  //         shout: function() { console.log('...'); }
  //       });
  //
  //       // Luv.js' class system doesn't require "new"
  //       var peter = Ninja();
  //
  //       peter.fight(); // zap!
  //       peter.shout(); // ...
  subclass: function(name, methods) {
    methods = methods || {};
    var superClass = this;

    var getName = function(){ return name; };
    var newMethods = remove(extend(create(superClass.methods), methods), 'init');

    var newClass = extend(function() {
      var instance = create(newMethods);
      newClass.init.apply(instance, arguments);
      return instance;
    },
    superClass,
    methods, {
      getName : getName,
      toString: getName,
      getSuper: function(){ return superClass; },
      methods : newMethods
    });

    newMethods.getClass = function() { return newClass; };

    return newClass;
  }
});

baseMethods.getClass = function() { return Base; };

// ## Luv definition

// The main Luv class
var Luv = Base.subclass('Luv', {
// Luv expects a single `options` parameter (see `initializeOptions` for a list of accepted options).
// and returns a game.
// The recommended name for the variable to store the game is `luv`, but you are free to choose any other.

//       var luv = Luv({...});
//       // options omitted, see below for details

// The game will not start until you execute `luv.run()` (assuming that your game variable name is `luv`).

//       var luv = Luv({...});
//       ... // more code ommited, see LuvProto below for details
//       luv.run();

// If you have initialized your game completely with options, you could just run it straight away,
// without storing it into a variable:

//       Luv({...}).run();

// The `options` param is optional, so you can start with an empty call to `Luv`, personalize the game variable
// however you want, and then call run:

//       var luv = Luv();
//       ... // do stuff with luv, i.e. define luv.update and luv.draw
//       luv.run(); // start the game
  init: function(options) {

    options = initializeOptions(options);

    var luv = this;

    // `luv.el` contains a reference to the specified DOM element representing the "Main game canvas".
    // If no element was specified via the `options` parameter, then a new DOM element will be created
    // and inserted into the document's body.
    luv.el  = options.el;

    // make el focus-able
    luv.el.tabIndex = 1;

    "load update draw run onResize onBlur onFocus".split(" ").forEach(function(name) {
      if(options[name]) { luv[name] = options[name]; }
    });

    // Initialize all the game submodules (see their docs for more info about each one)
    luv.media     = Luv.Media();
    luv.timer     = Luv.Timer();
    luv.keyboard  = Luv.Keyboard(luv.el);
    luv.mouse     = Luv.Mouse(luv.el);
    luv.touch     = Luv.Touch(luv.el);
    luv.audio     = Luv.Audio(luv.media);
    luv.graphics  = Luv.Graphics(luv.el, luv.media);
    luv.canvas    = Luv.Graphics.Canvas(luv.el);


    // Attach listeners to the window, if the game is in fullWindow mode, to resize the canvas accordingly
    if(options.fullWindow) {
      var resize = function() {
        luv.canvas.setDimensions(window.innerWidth, window.innerHeight);
        luv.onResize(window.innerWidth, window.innerHeight);
      };
      window.addEventListener('resize', resize, false);
      window.addEventListener('orientationChange', resize, false);
      luv.el.focus();
    }

    // Attach onBlur/onFocus
    luv.el.addEventListener('blur',  function() { luv.onBlur(); });
    luv.el.addEventListener('focus', function() { luv.onFocus(); });
  },

  // Use the `load` function to start loading up resources:

  //       var image;
  //       var luv = Luv();
  //       luv.load = function() {
  //         image = luv.media.Image('cat.png');
  //       };

  // As al alternative, you can override it directly on the options parameter. Note that in that case, you must use
  // `this` instead of `luv` inside the function:

  //       var image;
  //       var luv = Luv({
  //         load: function() {
  //           // notice the usage of this.media instead of luv.media
  //           image = this.media.Image('cat.png');
  //         };
  //       });

  // `load` will be called once at the beginning of the first game cycle, and then never again (see the `run`
  // function below for details). By default, it does nothing (it is an empty function).
  load  : function(){},

  // Use the draw function to draw everything on the canvas. For example:

  //       var luv = Luv();
  //       luv.draw = function() {
  //         luv.graphics.print("hello", 100, 200);
  //       };

  // Alternative syntax, passed as an option:

  //     var luv = Luv({
  //       draw: function() {
  //         // this.graphics instead of luv.graphics
  //         this.graphics.print("hello", 100, 200);
  //       }
  //     });

  // `draw` is called once per frame, after the screen has been erased. See the `run` function below for details.
  draw  : function(){},

  // Use the `update` function to update your game objects/variables between frames.
  // Note that `update` has a parameter `dt`, which is the time that has passed since the last frame.
  // You should use dt to update your entity positions according to their velocity/movement – *Don't assume that
  // the time between frames stays constant*.

  //       var player = { x: 0, y: 0 };
  //       var luv = Luv();
  //       luv.update = function(dt) {
  //         // Player moves to the right 10 pixels per second
  //         player.x += dt * 10;
  //       };

  // Alternative syntax, passed as an option:

  //       var player = { x: 0, y: 0 };
  //       var luv = Luv({
  //         update: function(dt) {
  //         // Player moves to the right 10 pixels per second
  //           player.x += dt * 10;
  //         };
  //       });

  // As with all other luv methods, if you choose this syntax you must use `this` instead of `luv`, since
  // `luv` is still not defined.

  // `update` will be invoked once per frame (see `run` below) and is empty by default (it updates nothing).
  update: function(dt){},

  // The `run` function provides a default game loop. It is usually a good default, and you rarely will need to
  // change it. But you could, if you so desired, the same way you can change `load`, `update` and `draw` (as a
  // field of the `luv` variable or as an option).
  run   : function(){
    var luv = this;

    luv.load.call(); // luv.run execute luv.load just once, at the beginning

    var loop = function() {

      // The first thing we do is updating the timer with the new frame
      luv.timer.nativeUpdate(luv.el);

      // We obtain dt (the difference between previous and this frame's timestamp, in seconds) and pass it
      // to luv.update
      var dt = luv.timer.getDeltaTime();
      luv.update.call(null, dt);           // Execute luv.update(dt) once per frame

      luv.canvas.clear();     // And clear everything
      luv.draw.call();

      // This enqueues another call to the loop function in the next available frame
      luv.timer.nextFrame(loop);
    };

    // Once the loop function is defined, we call it once, so the cycle begins
    luv.timer.nextFrame(loop);
  },

  // `onResize` gets called when `fullWindow` is active and the window is resized. It can be used to
  // control game resizings, i.e. recalculate your camera's viewports. By default, it does nothing.
  onResize  : function(newWidth, newHeight) {},

  // overridable callback which is called when the main game element loses focus.
  // useful for things like pausing a game when the user clicks outside of it
  // Does nothing by default
  onBlur : function() {},

  // overridable callback called when the main game element gains focus
  // mainly useful for "undoing" the actions done in onBlur, for example unpausing
  // the game
  onFocus : function() {}
});

// ## Luv.Class
// Creates classes; takes two parameters: the class name and an object containing instance methods
// For inheritance, do <BaseClass>.subclass(<name>, <methods>) instead
Luv.Class = function(name, methods) {
  return Base.subclass(name, methods);
};

// ## Luv.Base
// The root of Luv.js' (optional) class system
Luv.Base = Base;

// ## Luv.extend
// Expose extend so that it can be used in other modules
Luv.extend = extend;

// ## initializeOptions
var initializeOptions = function(options) {
  // Accepted options:

  // * `el`: A canvas DOM element to be used
  // * `id`: A canvas DOM id to be used (Ignored if `el` is provided)
  // * `width`: Sets the width of the canvas, in pixels
  // * `height`: Sets the height of the canvas, in pixels
  // * `fullWindow`: If set to true, the game canvas will ocuppy the whole window, and auto-adjust (off by default)
  // * `load`: A load function (see above for details)
  // * `update`: A update function (see above for details)
  // * `draw`: A draw function (see above for details)
  // * `run`: A run function (see above for details)
  // * `onResize`: A callback that is called when the window is resized (only works when `fullWindow` is active)
  // * `onBlur`: Callback invoked when the user clicks outside the game (useful for pausing the game, for example)
  // * `onFocus`: Callback invoked when the user set the focus back on the game (useful for unpausing after pausing with onBlur)

  // Notes:

  // * All options are ... well, optional.
  // * The options parameter itself is optional (you can do `var luv = Luv();`)
  // * Any other options passed through the `options` hash are ignored
  // * If neither `el` or `id` is specified, a new DOM canvas element will be generated and appended to the window.
  // * `width` and `height` will attempt to get their values from the DOM element. If they can't, and they are not
  //    provided as options, they will default to 800x600px
  options = options || {};
  var el      = options.el,
      id      = options.id,
      width   = options.width,
      height  = options.height,
      body    = document.getElementsByTagName('body')[0],
      html    = document.getElementsByTagName('html')[0],
      fullCss = "width: 100%; height: 100%; margin: 0; overflow: hidden;";

  if(!el && id) { el = document.getElementById(id); }
  if(el) {
    if(!width  && el.getAttribute('width'))  { width = Number(el.getAttribute('width')); }
    if(!height && el.getAttribute('height')) { height = Number(el.getAttribute('height')); }
  } else {
    el = document.createElement('canvas');
    body.appendChild(el);
  }
  if(options.fullWindow) {
    html.style.cssText = body.style.cssText = fullCss;
    width  = window.innerWidth;
    height = window.innerHeight;
  } else {
    width = width   || 800;
    height = height || 600;
  }
  el.setAttribute('width', width);
  el.setAttribute('height', height);

  options.el      = el;
  options.width   = width;
  options.height  = height;

  return options;
};

// export the local Luv variable so that the window.Luv = ... at the top of this file can take it
return Luv;

}());

// # timer.js
(function(){

// ## Luv.Timer
Luv.Timer = Luv.Class('Luv.Timer', {

// In luv, time is managed via instances of this constructor, instead of with
// javascript's setInterval.
// Usually, the timer is something internal that is created by Luv when a game
// is created, and it's used mostly inside luv.js' `run` function.
// luv.js users will rarely need to manipulate objects of this
// library, except to obtain the Frames per second or maybe to tweak the
// deltaTimeLimit (see below)

  init: function() {
    // The time that has passed since the timer was created, in milliseconds
    this.microTime = performance.now();

    // The time that has passed between the last two frames, in seconds
    this.deltaTime = 0;

    // The upper value that deltaTime can have, in seconds. Defaults to 0.25.
    // Can be changed via `setDeltaTimeLimit`.
    // Note that this does *not* magically make a game go faster. If a game has
    // very low FPS, this makes sure that the delta time is not too great (its bad
    // for things like physics simulations, etc).
    this.deltaTimeLimit = Luv.Timer.DEFAULT_DELTA_TIME_LIMIT;

    this.events = {};
    this.maxEventId = 0;
  },

  // updates the timer with a new timestamp.
  nativeUpdate : function(el) {
    this.update((performance.now() - this.microTime) / 1000, el);
  },

  // updates the timer with a new deltatime
  update : function(dt) {
    this.deltaTime = Math.max(0, Math.min(this.deltaTimeLimit, dt));
    this.microTime += dt * 1000;
    for(var id in this.events) {
      if(this.events.hasOwnProperty(id) &&
         this.events[id].update(dt)) {
        delete(this.events[id]);
      }
    }
  },

  // `deltaTimeLimit` means "the maximum delta time that the timer will report".
  // It's 0.25 by default. That means that if a frame takes 3 seconds to complete,
  // the *reported* delta time will be 0.25s. This setting doesn't magically make
  // games go faster. It's there to prevent errors when a lot of time passes between
  // frames (for example, if the user changes tabs, the timer could spend entire
  // minutes locked in one frame).
  setDeltaTimeLimit : function(deltaTimeLimit) {
    this.deltaTimeLimit = deltaTimeLimit;
  },

  // returns the `deltaTimeLimit`; the maximum delta time that will be reported.
  // see `setDeltaTimeLimit` for details.
  getDeltaTimeLimit : function() {
    return this.deltaTimeLimit;
  },

  // returns how much time has passed between this frame and the previous one,
  // in seconds. Note that it's capped by `deltaTimeLimit`.
  getDeltaTime : function() {
    return Math.min(this.deltaTime, this.deltaTimeLimit);
  },

  // Returns the frames per second
  getFPS : function() {
    return this.deltaTime === 0 ? 0 : 1 / this.deltaTime;
  },

  // This function is used in the main game loop. For now, it just calls `window.requestAnimationFrame`.
  nextFrame : function(f) {
    requestAnimationFrame(f);
  },

  after : function(timeToCall, callback, context) {
    return add(this, Luv.Timer.After(timeToCall, callback, context));
  },

  every : function(timeToCall, callback, context) {
    return add(this, Luv.Timer.Every(timeToCall, callback, context));
  },

  tween : function(timeToFinish, subject, to, options) {
    return add(this, Luv.Timer.Tween(timeToFinish, subject, to, options));
  },

  clear : function(id) {
    if(this.events[id]) {
      delete(this.events[id]);
      return true;
    }
    return false;
  }

});

Luv.Timer.DEFAULT_DELTA_TIME_LIMIT = 0.25;

var add = function(timer, e) {
  var id = timer.maxEventId++;
  timer.events[id] = e;
  return id;
};


// `performance.now` polyfill
var performance = window.performance || Date;
performance.now = performance.now       ||
                  performance.msNow     ||
                  performance.mozNow    ||
                  performance.webkitNow ||
                  Date.now;

// `requestAnimationFrame` polyfill
var lastTime = 0,
    requestAnimationFrame =
      window.requestAnimationFrame       ||
      window.msRequestAnimationFrame     ||
      window.mozRequestAnimationFrame    ||
      window.webkitRequestAnimationFrame ||
      window.oRequestAnimationFrame      ||
      function(callback) {
        var currTime   = performance.now(),
            timeToCall = Math.max(0, 16 - (currTime - lastTime)),
            id         = setTimeout(function() { callback(currTime + timeToCall); }, timeToCall);
        lastTime = currTime + timeToCall;
        return id;
      };

}());

// # timer/after.js
(function() {

// ## Luv.Timer.After
Luv.Timer.After = Luv.Class('Luv.Timer.After', {

  init: function(timeToCall, callback, context) {
    this.timeRunning = 0;
    this.timeToCall  = timeToCall;
    this.callback    = callback;
    this.context     = context;
  },

  update: function(dt) {
    this.timeRunning += dt;
    var diff = this.timeRunning - this.timeToCall;
    if(diff >= 0) {
      this.callback.call(this.context, diff);
      return true;
    }
    return false;
  }

});

}());

// # timer/every.js
(function() {

// ## Luv.Timer.Every
Luv.Timer.Every = Luv.Class('Luv.Timer.Every', {

  init: function(timeToCall, callback, context) {
    this.timeRunning = 0;
    this.timeToCall  = timeToCall;
    this.callback    = callback;
    this.context     = context;
  },

  update: function(dt) {
    this.timeRunning += dt;

    if(this.timeToCall > 0) {
      while(this.timeRunning >= this.timeToCall) {
        this.callback.call(this.context, this.timeRunning - this.timeToCall);
        this.timeRunning -= this.timeToCall;
      }
    } else {
      this.callback.call(this.context, dt);
    }
    return false;
  }

});

}());

// # timer/tween.js
(function(){

// ## Luv.Timer.Tween
Luv.Timer.Tween = Luv.Class('Luv.Timer.Tween', {

  init: function(timeToFinish, subject, to, options) {
    deepParamsCheck(subject,to,[]);

    options = options || {};
    this.easing       = getEasingFunction(options.easing);
    this.every        = options.every      || this.every;
    this.after        = options.after      || this.after;
    this.context      = options.context    || this;

    this.runningTime  = 0;
    this.finished     = false;
    this.timeToFinish = timeToFinish;
    this.subject      = subject;
    this.from         = deepCopy(subject, to);
    this.to           = deepCopy(to);
  },

  update: function(dt) {
    if(this.runningTime >= this.timeToFinish) { return; }
    this.runningTime += dt;
    if(this.runningTime >= this.timeToFinish) {
      this.runningTime = this.timeToFinish;
      this.after.call(this.context);
      this.finished = true;
    }
    this.every.call(this.context, deepEase(this, this.from, this.to));
    return this.finished;
  },

  every: function(values) {
    this.subject = deepMerge(this.subject, values);
  },

  after: function() {
  },

  isFinished: function() {
    return !!this.finished;
  }

});


// ## Easing functions
  // ### linear
var linear= function(t, b, c, d){ return c * t / d + b; },

  // ### quad
  inQuad  = function(t, b, c, d){ return c * Math.pow(t / d, 2) + b; },
  outQuad = function(t, b, c, d){
    t = t / d;
    return -c * t * (t - 2) + b;
  },
  inOutQuad = function(t, b, c, d){
    t = t / d * 2;
    if(t < 1){ return c / 2 * Math.pow(t, 2) + b; }
    return -c / 2 * ((t - 1) * (t - 3) - 1) + b;
  },
  outInQuad = function(t, b, c, d){
    if(t < d / 2) { return outQuad(t * 2, b, c / 2, d); }
    return inQuad((t * 2) - d, b + c / 2, c / 2, d);
  },

  // ### cubic
  inCubic  = function(t, b, c, d){ return c * Math.pow(t / d, 3) + b; },
  outCubic = function(t, b, c, d){ return c * (Math.pow(t / d - 1, 3) + 1) + b; },
  inOutCubic = function(t, b, c, d){
    t = t / d * 2;
    if(t < 1){ return c / 2 * t * t * t + b; }
    t = t - 2;
    return c / 2 * (t * t * t + 2) + b;
  },
  outInCubic = function(t, b, c, d){
    if(t < d / 2){ return outCubic(t * 2, b, c / 2, d); }
    return inCubic((t * 2) - d, b + c / 2, c / 2, d);
  },

  // ### quart
  inQuart = function(t, b, c, d){ return c * Math.pow(t / d, 4) + b; },
  outQuart = function(t, b, c, d){ return -c * (Math.pow(t / d - 1, 4) - 1) + b; },
  inOutQuart = function(t, b, c, d){
    t = t / d * 2;
    if(t < 1){ return c / 2 * Math.pow(t, 4) + b; }
    return -c / 2 * (Math.pow(t - 2, 4) - 2) + b;
  },
  outInQuart = function(t, b, c, d){
    if(t < d / 2){ return outQuart(t * 2, b, c / 2, d); }
    return inQuart((t * 2) - d, b + c / 2, c / 2, d);
  },

  // ### quint
  inQuint = function(t, b, c, d){ return c * Math.pow(t / d, 5) + b; },
  outQuint = function(t, b, c, d){ return c * (Math.pow(t / d - 1, 5) + 1) + b; },
  inOutQuint = function(t, b, c, d){
    t = t / d * 2;
    if(t < 1){ return c / 2 * Math.pow(t, 5) + b; }
    return c / 2 * (Math.pow(t - 2, 5) + 2) + b;
  },
  outInQuint = function(t, b, c, d){
    if(t < d / 2){ return outQuint(t * 2, b, c / 2, d); }
    return inQuint((t * 2) - d, b + c / 2, c / 2, d);
  },

  // ### sine
  inSine = function(t, b, c, d){ return -c * Math.cos(t / d * (Math.PI / 2)) + c + b; },
  outSine = function(t, b, c, d){ return c * Math.sin(t / d * (Math.PI / 2)) + b; },
  inOutSine = function(t, b, c, d){ return -c / 2 * (Math.cos(Math.PI * t / d) - 1) + b; },
  outInSine = function(t, b, c, d){
    if(t < d / 2){ return outSine(t * 2, b, c / 2, d); }
    return inSine((t * 2) -d, b + c / 2, c / 2, d);
  },

  // ### expo
  inExpo = function(t, b, c, d){
    if(t === 0){ return b; }
    return c * Math.pow(2, 10 * (t / d - 1)) + b - c * 0.001;
  },
  outExpo = function(t, b, c, d){
    if(t == d){ return b + c; }
    return c * 1.001 * (-Math.pow(2, -10 * t / d) + 1) + b;
  },
  inOutExpo = function(t, b, c, d){
    if(t === 0){ return b; }
    if(t == d){ return b + c; }
    t = t / d * 2;
    if(t < 1){ return c / 2 * Math.pow(2, 10 * (t - 1)) + b - c * 0.0005; }
    return c / 2 * 1.0005 * (-Math.pow(2, -10 * (t - 1)) + 2) + b;
  },
  outInExpo = function(t, b, c, d){
    if(t < d / 2){ return outExpo(t * 2, b, c / 2, d); }
    return inExpo((t * 2) - d, b + c / 2, c / 2, d);
  },

  // ### circ
  inCirc = function(t, b, c, d){ return(-c * (Math.sqrt(1 - Math.pow(t / d, 2)) - 1) + b); },
  outCirc = function(t, b, c, d){ return(c * Math.sqrt(1 - Math.pow(t / d - 1, 2)) + b); },
  inOutCirc = function(t, b, c, d){
    t = t / d * 2;
    if(t < 1){ return -c / 2 * (Math.sqrt(1 - t * t) - 1) + b; }
    t = t - 2;
    return c / 2 * (Math.sqrt(1 - t * t) + 1) + b;
  },
  outInCirc = function(t, b, c, d){
    if(t < d / 2){ return outCirc(t * 2, b, c / 2, d); }
    return inCirc((t * 2) - d, b + c / 2, c / 2, d);
  },

  // ### elastic
  calculatePAS = function(p,a,c,d) {
    p = typeof p === "undefined" ? d * 0.3 : p;
    a = a || 0;
    if(a < Math.abs(c)){
      a = c;
      s = p / 4;
    } else {
      s = p / (2 * Math.PI) * Math.asin(c/a);
    }
    return [p,a,s];
  },
  inElastic = function(t, b, c, d, a, p){
    if(t === 0){ return b; }
    t = t / d;
    if(t == 1 ){ return b + c; }
    var pas = calculatePAS(p,a,c,d),
        s = pas[2];
    p = pas[0];
    a = pas[1];
    t = t - 1;
    return -(a * Math.pow(2, 10 * t) * Math.sin((t * d - s) * (2 * Math.PI) / p)) + b;
  },
  outElastic = function(t, b, c, d, a, p) {
    if(t === 0){ return b; }
    t = t / d;
    if(t == 1 ){ return b + c; }
    var pas = calculatePAS(p,a,c,d),
        s = pas[2];
    p = pas[0];
    a = pas[1];
    return a * Math.pow(2, -10 * t) * Math.sin((t * d - s) * (2 * Math.PI) / p) + c + b;
  },
  inOutElastic = function(t, b, c, d, a, p){
    if(t === 0){ return b; }
    t = t / d;
    if(t == 1 ){ return b + c; }
    var pas = calculatePAS(p,a,c,d),
        s = pas[2];
    p = pas[0];
    a = pas[1];

    t = t - 1;
    if(t < 0){ return -0.5 * (a * Math.pow(2, 10 * t) * Math.sin((t * d - s) * (2 * Math.PI) / p)) + b; }
    return a * Math.pow(2, -10 * t) * Math.sin((t * d - s) * (2 * Math.PI) / p ) * 0.5 + c + b;
  },
  outInElastic = function(t, b, c, d, a, p) {
    if(t < d / 2){ return outElastic(t * 2, b, c / 2, d, a, p); }
    return inElastic((t * 2) - d, b + c / 2, c / 2, d, a, p);
  },

  // ### back
  inBack = function(t, b, c, d, s) {
    s = s || 1.70158;
    t = t / d;
    return c * t * t * ((s + 1) * t - s) + b;
  },
  outBack = function(t, b, c, d, s) {
    s = s || 1.70158;
    t = t / d - 1;
    return c * (t * t * ((s + 1) * t + s) + 1) + b;
  },
  inOutBack = function(t, b, c, d, s){
    s = (s || 1.70158) * 1.525;
    t = t / d * 2;
    if(t < 1){ return c / 2 * (t * t * ((s + 1) * t - s)) + b; }
    t = t - 2;
    return c / 2 * (t * t * ((s + 1) * t + s) + 2) + b;
  },
  outInBack = function(t, b, c, d, s){
    if(t < d / 2){ return outBack(t * 2, b, c / 2, d, s); }
    return inBack((t * 2) - d, b + c / 2, c / 2, d, s);
  },

  // ### bounce
  outBounce = function(t, b, c, d){
    t = t / d;
    if(t < 1 / 2.75){ return c * (7.5625 * t * t) + b; }
    if(t < 2 / 2.75){
      t = t - (1.5 / 2.75);
      return c * (7.5625 * t * t + 0.75) + b;
    } else if(t < 2.5 / 2.75){
      t = t - (2.25 / 2.75);
      return c * (7.5625 * t * t + 0.9375) + b;
    }
    t = t - (2.625 / 2.75);
    return c * (7.5625 * t * t + 0.984375) + b;
  },
  inBounce = function(t, b, c, d){ return c - outBounce(d - t, 0, c, d) + b; },
  inOutBounce = function(t, b, c, d){
    if(t < d / 2){ return inBounce(t * 2, 0, c, d) * 0.5 + b; }
    return outBounce(t * 2 - d, 0, c, d) * 0.5 + c * 0.5 + b;
  },
  outInBounce = function(t, b, c, d){
    if(t < d / 2){ return outBounce(t * 2, b, c / 2, d); }
    return inBounce((t * 2) - d, b + c / 2, c / 2, d);
  };

//## Luv.Timer.Tween.easing
Luv.Timer.Tween.easing = {
  linear    : linear,
  inQuad    : inQuad,    outQuad    : outQuad,    inOutQuad    : inOutQuad,    outInQuad    : outInQuad,
  inCubic   : inCubic,   outCubic   : outCubic,   inOutCubic   : inOutCubic,   outInCubic   : outInCubic,
  inQuart   : inQuart,   outQuart   : outQuart,   inOutQuart   : inOutQuart,   outInQuart   : outInQuart,
  inQuint   : inQuint,   outQuint   : outQuint,   inOutQuint   : inOutQuint,   outInQuint   : outInQuint,
  inSine    : inSine,    outSine    : outSine,    inOutSine    : inOutSine,    outInSine    : outInSine,
  inExpo    : inExpo,    outExpo    : outExpo,    inOutExpo    : inOutExpo,    outInExpo    : outInExpo,
  inCirc    : inCirc,    outCirc    : outCirc,    inOutCirc    : inOutCirc,    outInCirc    : outInCirc,
  inElastic : inElastic, outElastic : outElastic, inOutElastic : inOutElastic, outInElastic : outInElastic,
  inBack    : inBack,    outBack    : outBack,    inOutBack    : inOutBack,    outInBack    : outInBack,
  inBounce  : inBounce,  outBounce  : outBounce,  inOutBounce  : inOutBounce,  outInBounce  : outInBounce
};


var deepParamsCheck = function(subject, to, path) {
  var toType, newPath;
  for(var k in to) {
    if(to.hasOwnProperty(k)) {
      toType  = typeof to[k];
      newPath = path.slice(0);
      newPath.push(String(k));
      if(toType === 'number') {
        if(typeof subject[k] !== 'number') {
          throw new Error("Parameter '" + newPath.join('/') + "' is missing from 'from' or isn't a number");
        }
      } else if(toType === 'object') {
        deepParamsCheck(subject[k], to[k], newPath);
      } else {
        throw new Error("Parameter '" + newPath.join('/') + "' must be a number or string, was " + to[k]);
      }
    }
  }
};


var deepEase = function(tween, from, to) {
  var result;
  if(typeof to === "object") {
    result = Array.isArray(to) ? [] : {};
    for(var key in to) {
      if(to.hasOwnProperty(key)) {
        result[key] = deepEase(tween, from[key], to[key]);
      }
    }
  } else {
    result = tween.easing(
      tween.runningTime,  // t
      from,               // b
      to - from,          // c
      tween.timeToFinish  // d
    );
  }
  return result;
};

var getEasingFunction= function(easing) {
  easing = easing || "linear";
  return typeof easing == 'string' ? Luv.Timer.Tween.easing[easing] : easing;
};

var deepMerge = function(result, keysObj, valuesObj) {
  valuesObj = valuesObj || keysObj;
  if(typeof keysObj === "object") {
    result = result || (Array.isArray(keysObj) ? [] : {});
    for(var key in keysObj){
      if(keysObj.hasOwnProperty(key)) {
        result[key] = deepMerge(result[key], keysObj[key], valuesObj[key]);
      }
    }
  } else {
    result = keysObj;
  }
  return result;
};

var deepCopy = function(keysObj, valuesObj) {
  return deepMerge(null, keysObj, valuesObj);
};

}());


// # keyboard.js
(function() {

// ## Luv.Keyboard
//
// This class encapsulates the functionality which has to do with keyboard handling in Luv.
//
// *Disclaimer*: the code on this module was inspired by [selfcontained.us](http://www.selfcontained.us/2009/09/16/getting-keycode-values-in-javascript/)
Luv.Keyboard = Luv.Class('Luv.Keyboard', {
  // You will almost never need to instantiate this Luv module manually. Instead,
  // you will create a `Luv` object, which will have a `keyboard` attribute. For
  // example:
  //
  //        var luv = Luv();
  //        luv.keyboard // You will use this
  init: function(el) {
    var keyboard = this;

    keyboard.keysDown  = {};
    keyboard.el        = el;

    el.addEventListener('keydown', function(evt) {
      evt.preventDefault();
      evt.stopPropagation();

      var key  = getKeyFromEvent(evt);
      keyboard.keysDown[key] = true;
      keyboard.onPressed(key, evt.which);
    });

    el.addEventListener('keyup', function(evt) {
      evt.preventDefault();
      evt.stopPropagation();

      var key  = getKeyFromEvent(evt);
      keyboard.keysDown[key] = false;
      keyboard.onReleased(key, evt.which);
    });

    return keyboard;
  },

  // `onPressed` is a user-overrideable that is triggered when a keyboard key
  // is pressed.
  //
  // The first parameter is a string with the key human name (for example the
  // arrow keys are named "up", "down", "left" and "right"). The second parameter
  // is a number that browsers use internally to identify keys. I've included both
  // because there is no way I can name all keys that exist (the list of key names
  // that luv.js understands is below).
  //
  // Example of use of onPressed:

  //       var msg = "";
  //       var luv = Luv();
  //       luv.keyboard.onPressed = function(key, code) {
  //         msg = "The key " + key + " with code " + code + " was pressed";
  //       };

  // It does nothing by default.
  onPressed  : function(key, code) {},

  // `onReleased` works the same way as onPressed, except that it gets triggered
  // when a key stops being pressed.
  //
  // Similarly to `onPressed`, the first parameter is a key name, while the second
  // one is the browser's internal keycode (a number).
  onReleased : function(key, code) {},

  // `isDown` will return true if a key is pressed, and false otherwise.
  // If used, it will probably be used inside `luv.update`:

  //       var player = {y: 100};
  //       var luv = Luv();
  //       luv.update = function(dt) {
  //         if(luv.keyboard.isPressed('up')) {
  //           player.y -= 10*dt;
  //         };
  //       };

  // Notice that while using `isDown` is easier than using `onPressed` and `onReleased`,
  // it is also less flexible. On medium games that allow things like keyboard configuration,
  // it's recommended to use `onPressed` and `onReleased`.
  isDown     : function(key) {
    return !!this.keysDown[key];
  }
});

// ## key names
//
// This object contains the names used for each key code. Notice that this is not a
// comprehensive list; common ASCII characters like 'a', which can be calculated via
// `String.fromCharCode`, are not included here.
var keys = {
  8: "backspace",
  9: "tab",
  13: "enter",
  16: "shift",
  17: "ctrl",
  18: "alt",
  19: "pause", 20: "capslock", 27: "escape",
  33: "pageup", 34: "pagedown", 35: "end", 36: "home", 45: "insert", 46: "delete",
  37: "left", 38: "up", 39: "right", 40: "down",
  91: "lmeta", 92: "rmeta", 93: "mode",
  96: "kp0", 97: "kp1", 98: "kp2", 99: "kp3", 100: "kp4", 101: "kp5",
  102: "kp6", 103: "kp7", 104: "kp8", 105: "kp9",
  106: "kp*", 107: "kp+", 109: "kp-", 110: "kp.", 111: "kp/",
  112: "f1", 113: "f2", 114: "f3", 115: "f4", 116: "f5", 117: "f6", 118: "f7",
  119: "f8", 120: "f9", 121: "f10", 122: "f11", 123: "f12",
  144: "numlock", 145: "scrolllock",
  186: ",", 187: "=", 188: ",", 189: "-", 190: ".", 191: "/", 192: "`",
  219: "[", 220: "\\",221: "]", 222: "'"
};

// ## Shifted key names
//
// These names will get passed to onPress and onRelease instead of the default ones
// if one of the two "shift" keys is pressed.
var shiftedKeys = {
  192:"~", 48:")", 49:"!", 50:"@", 51:"#", 52:"$", 53:"%", 54:"^", 55:"&", 56:"*", 57:"(", 109:"_", 61:"+",
  219:"{", 221:"}", 220:"|", 59:":", 222:"\"", 188:"<", 189:">", 191:"?",
  96:"insert", 97:"end", 98:"down", 99:"pagedown", 100:"left", 102:"right", 103:"home", 104:"up", 105:"pageup"
};

// ## Right keys
//
// luv.js will attempt to differentiate rshift from shift, rctrl from ctrl, and
// ralt from alt. This is browser-dependent though, and not completely supported.
var rightKeys = {
  16: "rshift", 17: "rctrl", 18: "ralt"
};

// This function tries to guess the best name for a event.
var getKeyFromEvent = function(event) {
  // Getting the keybode is easy
  var code = event.which;
  var key;
  // See if we are pressing one of the "right keys"
  if(event.keyLocation && event.keyLocation > 1) { key = rightKeys[code]; }
  // otherwise see if we are pressing shift
  else if(event.shiftKey) { key = shiftedKeys[code] || keys[code]; }
  // otherwise, it's a "non-special" key, Try to get its name from the `keys` var.
  else { key = keys[code]; }

  // If everything else fails, try to return [String.fromCharCode](https://developer.mozilla.org/en-US/docs/JavaScript/Reference/Global_Objects/String/fromCharCode)
  // That will return "normal letters", such as 'a', 'b', 'c', '1', '2', '3', etc.
  if(typeof key === "undefined") {
    key = String.fromCharCode(code);
    if(event.shiftKey) { key = key.toUpperCase(); }
  }

  return key;
};

}());




// # mouse.js
(function() {

// ## Luv.Mouse
Luv.Mouse = Luv.Class('Luv.Mouse', {
  // This function creates a mouse handler for a mouse game.
  // It is usually instantiated directly by the main Luv() function,
  // you will probably not need to call `Luv.Mouse()` yourself:

  //       var luv = Luv();
  //       luv.mouse // Already instantiated mouse handler

  init: function(el) {

    var mouse  = this;

    mouse.x               = 0;
    mouse.y               = 0;
    mouse.pressedButtons  = {};
    mouse.wheelTimeOuts   = {};

    // The mouse module works by attaching several event listeners to the
    // given el element. That's how mouse position, button presses and wheel state
    // are detected.

    var handlePress = function(button) {
      mouse.pressedButtons[button] = true;
      mouse.onPressed(mouse.x, mouse.y, button);
    };

    var handleRelease = function(button) {
      mouse.pressedButtons[button] = false;
      mouse.onReleased(mouse.x, mouse.y, button);
    };

    var handleWheel = function(evt) {
      evt.preventDefault();
      var button = getWheelButtonFromEvent(evt);
      // The 'wheel has stopped scrolling' event is triggered via setTimeout, since
      // browsers don't provide a native 'stopped scrolling' event
      clearTimeout(mouse.wheelTimeOuts[button]);
      mouse.wheelTimeOuts[button] = setTimeout(function() {
        handleRelease(button);
      }, Luv.Mouse.WHEEL_TIMEOUT * 1000);
      handlePress(button);
    };

    // mousemove is particularly laggy in Chrome. I'd love to find a better solution
    el.addEventListener('mousemove', function(evt) {
      var rect = el.getBoundingClientRect();
      mouse.x = evt.pageX - rect.left;
      mouse.y = evt.pageY - rect.top;
      mouse.onMoved(mouse.x, mouse.y);
    });

    el.addEventListener('mousedown', function(evt) {
      handlePress(getButtonFromEvent(evt));
    });

    el.addEventListener('mouseup', function(evt) {
      handleRelease(getButtonFromEvent(evt));
    });

    el.addEventListener('DOMMouseScroll', handleWheel); // firefox
    el.addEventListener('mousewheel', handleWheel); // everyone else
  },

  // Returns the x coordinate where the mouse is (relative to the DOM element)
  getX: function() { return this.x; },

  // Returns the x coordinate where the mouse is (relative to the DOM element)
  getY: function() { return this.y; },

  // Returns both the x and y coordinates of the mouse, as an object of the form
  // `{x: 100, y:200}
  getPosition: function() {
    return {x: this.x, y: this.y};
  },

  // `onPressed` is an overridable callback that is called when any of the mouse
  // buttons is pressed.
  // `button` is a string representing a button name (`"l"` for left, `"m"` for middle,
  // `"r"` for right).

  //       var luv = Luv();
  //       luv.mouse.onPressed = function(x,y,button) {
  //         console.log("Mouse button " + button + " was pressed in " + x + ", " + y);
  //       }
  onPressed: function(x,y,button) {},

  // Works the same as `onPressed`, but is called when a button stops being pressed.
  onReleased: function(x,y,button) {},

  onMoved: function(x,y) {},

  // Returns true if a button is pressed, false otherwhise. Usually used inside
  // the update loop:

  //       var luv = Luv();
  //       luv.update = function(dt) {
  //         if(luv.mouse.isPressed('l')) {
  //           console.log('Left mouse button pressed');
  //         }
  //       };
  isPressed: function(button) {
    return !!this.pressedButtons[button];
  }
});

// The mouse considers it has stopped scrolling after 20ms
Luv.Mouse.WHEEL_TIMEOUT = 0.02;

// Internal variable + function to transform DOM event magic numbers into human button names
// (left, middle, right)
var mouseButtonNames = {1: "l", 2: "m", 3: "r"};
var getButtonFromEvent = function(evt) {
  return mouseButtonNames[evt.which];
};

// Internal function to determine the mouse weel direction
var getWheelButtonFromEvent = function(evt) {
  var delta = Math.max(-1, Math.min(1, (evt.wheelDelta || -evt.detail)));
  return delta === 1 ? 'wu' : 'wd';
};

}());

// # touch.js
(function() {

// ## Luv.Touch
//
// This class encapsulates the functionality which has to do with touch interfaces in Luv
//
Luv.Touch = Luv.Class('Luv.Touch', {
  // You will almost never need to instantiate this Luv module manually. Instead,
  // you will create a `Luv` object, which will have a `touch` attribute. For
  // example:
  //
  //        var luv = Luv();
  //        luv.touch // You will use this
  init: function(el) {
    var touch = this;

    touch.fingers = {};
    touch.el      = el;

    var preventDefault = function(evt) {
      evt.preventDefault();
      evt.stopPropagation();
    };

    el.addEventListener('gesturestart',  preventDefault);
    el.addEventListener('gesturechange', preventDefault);
    el.addEventListener('gestureend',    preventDefault);

    el.addEventListener('touchstart', function(evt) {
      preventDefault(evt);

      var t, finger,
          rect = el.getBoundingClientRect();
      for(var i=0; i < evt.targetTouches.length; i++) {
        t = evt.targetTouches[i];
        finger = getFingerByIdentifier(touch, t.identifier);
        if(!finger){
          finger = {
            identifier: t.identifier,
            position: getNextAvailablePosition(touch),
            x: t.pageX - rect.left,
            y: t.pageY - rect.top
          };
          touch.fingers[finger.position] = finger;
          touch.onPressed(finger.position, finger.x, finger.y);
        }
      }
    });

    var touchend = function(evt) {
      preventDefault(evt);

      var t, finger,
          rect = el.getBoundingClientRect();
      for(var i=0; i < evt.changedTouches.length; i++) {
        t = evt.changedTouches[i];
        finger = getFingerByIdentifier(touch, t.identifier);
        if(finger) {
          delete(touch.fingers[finger.position]);
          touch.onReleased(finger.position, finger.x, finger.y);
        }
      }
    };
    el.addEventListener('touchend',    touchend);
    el.addEventListener('touchleave',  touchend);
    el.addEventListener('touchcancel', touchend);

    el.addEventListener('touchmove', function(evt) {
      preventDefault(evt);

      var t, finger,
          rect = el.getBoundingClientRect();
      for(var i=0; i < evt.targetTouches.length; i++) {
        t = evt.targetTouches[i];
        finger = getFingerByIdentifier(touch, t.identifier);
        if(finger) {
          finger.x = t.pageX - rect.left;
          finger.y = t.pageY - rect.top;
          touch.onMoved(finger.position, finger.x, finger.y);
        }
      }
    });
  },

  // `onPressed` is a user-overrideable function that is triggered when the screen
  // is touched.
  //
  // The first parameter is a number indicating the finger touching the screen
  // (usually, 1 is for the index finger, and so on). `x` and `y`
  // are the coordinates on the DOM element where the touching happens.
  //
  // Example of use of onPressed:

  //       var luv = Luv();
  //       luv.touch.onPressed = function(finger, x, y) {
  //         msg = "Finger " + finger + " in (" + x + "," + y + ")";
  //       };

  // It does nothing by default.
  onPressed  : function(finger, x, y) {},

  // `onReleased` works the same way as onPressed, except that it gets triggered
  // when a finger stops being pressed. `x` and `y`
  // represent the positions at which the finger stopped touching the screen.
  onReleased : function(finger, x, y) {},

  onMoved: function(finger, x, y) {},

  // `isPressed` returns true if the finger in question is pressing the screen
  isPressed : function(finger) {
    return !!this.fingers[finger];
  },

  // `getFinger` returns the position of a finger, or false if the finger
  // in question is not pressed
  getFinger: function(position) {
    var finger = this.fingers[position];
    return finger && {position: finger.position,
                      identifier: finger.identifier,
                      x: finger.x, y: finger.y};
  },

  // `getFingers` returns an array with all the fingers information, with the following
  // syntax: `[ {position: 1, x: 2, y:2}, {position: 5, x: 120, y:40} ]
  getFingers: function() {
    var result = [],
        positions = Object.keys(this.fingers).sort(),
        finger, position;
    for(var i=0; i < positions.length; i++) {
      position = positions[i];
      finger   = this.fingers[position];
      result.push({position: position, x: finger.x, y: finger.y});
    }
    return result;
  },

  // `isAvailable` returns true if the device/browser accepts touch events, false
  // otherwise
  isAvailable: function() {
    return window.ontouchstart !== undefined;
  }
});

var getMaxPosition = function(touch) {
  var positions = Object.keys(touch.fingers);
  if(positions.length === 0) { return 0; }
  return Math.max.apply(Math, positions);
};

var getNextAvailablePosition = function(touch) {
  var maxPosition = getMaxPosition(touch);
  for(var i=1; i < maxPosition; i++) {
    if(!touch.isPressed(i)){ return i; }
  }
  return maxPosition + 1;
};

var getFingerByIdentifier = function(touch, identifier) {
  var fingers = touch.fingers;
  for(var position in fingers) {
    if(fingers.hasOwnProperty(position) &&
       fingers[position].identifier == identifier) {
      return fingers[position];
    }
  }
};

}());




// # media.js
(function() {
// ## Luv.Media
Luv.Media = Luv.Class('Luv.Media', {
  // This module creates the `media` object when you create a luv game. It's usually
  // instantiated by the Luv function.

  //       var luv = Luv();
  //       luv.media // this is the media object

  // The media object is an "asset manager". It keeps track of those
  // assets (i.e. images) that load asynchronously, or can fail to load.
  //
  init: function() {
    this.pending = 0;
    this.loaded = true;
  },

  // `isLoaded` returns `true` if all the assets have been loaded, `false` if there are assets still being loaded.
  // Useful to wait actively until all assets are finished loading:

  //       var luv = Luv();
  //       var dogImage;
  //       luv.load = function() {
  //         dogImage = luv.graphics.Image('dog.png');
  //       }
  //       luv.draw = function() {
  //         // wait until all images are loaded before drawing anything
  //         if(!luv.media.isLoaded()) { return; }
  //         luv.graphics.drawImage(dogImage, 100, 100);
  //       }
  isLoaded     : function() { return this.loaded; },

  // Returns the numbers of assets that are loading, but not yet ready
  getPending   : function() { return this.pending; },

  // `onAssetLoaded` is an overridable callback.
  // It will be called once for each asset (Image, Sound, etc) that is loaded.
  // You may use it for things like displaing a "loaded percentage"

  //       luv.media.onAssetLoaded = function(asset) {
  //         assetsLoaded += 1;
  //       };
  onAssetLoaded: function(asset) {},

  // `onAssetError` is an overridable callback that will be called when an asset can not be loaded (for example,
  // the path to an image does not exist)
  // By default, it throws an error
  onAssetError  : function(asset) { throw new Error("Could not load " + asset); },

  // `onLoaded` is an overridable callback that will be called when the last pending asset is finished loading
  // you can use it instead of `isLoaded` to control the game flow
  onLoaded     : function() {},

  // Pseudo-Internal function. Registers the asset in the media object.
  newAsset  : function(asset) {
    this.pending++;
    this.loaded = false;
    clearTimeout(this.onLoadedTimeout);
    asset.status = "pending";
  },

  // Pseudo-internal function. Assets that have been loaded successfully should call this function
  // (this will trigger onAssetLoaded, etc)
  registerLoad : function(asset) {
    this.pending--;

    asset.status = "loaded";

    this.onAssetLoaded(asset);
    if(this.pending === 0) {
      var self = this;
      clearTimeout(this.onLoadedTimeout);
      this.onLoadedTimeout = setTimeout(function() {
        self.loaded = true;
        self.onLoaded();
      }, Luv.Timer.ONLOAD_TIMEOUT);
    }
  },

  // Pseudo-internal function. Assets that can't be loaded must invoke this method
  registerError: function(asset) {
    this.pending--;

    asset.status = "error";

    this.onAssetError(asset);
  }
});

Luv.Timer.ONLOAD_TIMEOUT = 200;

// This just a method holding object, to be extended by specialized assets
// like Image or Sound. Usage:

//       MyAwesomeClass.include(Luv.Media.Asset)

// See `Luv.Graphics.Image` for an example.
Luv.Media.Asset = {
  isPending: function() { return this.status == "pending"; },
  isLoaded:  function() { return this.status == "loaded"; },
  isError:   function() { return this.status == "error"; }
};

}());



// # audio.js
(function(){

// ## Luv.Audio
// The audio module is in charge of loading and playing sounds in Luv.
// It is a wrapper around the `audio` tag, so it is relatively cross-browser.
//
// The `audio` module is attached to the game object that you receive when
// you invoke the `Luv` function, and you usually don't need more than one,
// so you will most likely not be instantiating this class directly. Instead,
// you will be instantiating `Luv` and using the `audio` attribute of the returned
// object:

//       var luv = Luv();
//       luv.audio.isAvailable(); // luv.audio already contains the instance you need

// The function that you will use the most of this module is `Sound`:

//       var luv = Luv();
//       var cry = luv.audio.Sound('sfx/cry.ogg', 'sfx/cry.mp3');

// Love.audio will not fail if the browser using it is not capable of playing sounds; it will
// just not play sounds at all. *However*, `audio.Sound` *will* fail if the game tries to
// load a Sound that is not available. In the example above:
//
// * The code will produce no errors (and no sound) in an android phone with no `audio` support.
// * The code will work in a modern Firefox browser, if `sfx/cry.ogg` is loaded correctly.
// * The code will produce an error in Internet Explorer, if `sfx/cry.mp3` could not be found.

Luv.Audio = Luv.Class('Luv.Audio', {

  init: function(media) {
    this.media = media;
  },

  // `isAvailable` returns whether the browser is capable of reproducing sounds.
  // You don't have to test for this explicitly. If a browser is totally incapable of using the
  // audio tag, sounds will not load and the system will not try to emit any sound when
  // `Sound.play()` gets called.
  isAvailable: function() { return Luv.Audio.isAvailable(); },

  // Returns an array of the supported audio types that the current browser allows.
  //
  // * chrome: `['ogg', 'mp3', 'wav', 'm4a', 'aac']`
  // * firefox: `['ogg', 'mp3', 'wav', 'm4a', 'aac']`
  // * ie: `['mp3', 'wav', 'm4a', 'aac']`
  // * others: unknown (try!)
  getSupportedTypes: function() {
    return Luv.Audio.getSupportedTypes();
  },

  // `canPlayType` expects a file extension (i.e. `"mp3"`), and returns whether the current
  // browser is capable of playing files with that extension.
  canPlayType: function(type) {
    return this.supportedTypes[type.toLowerCase()];
  },

  // `Sound` creates sounds. Once loaded, sounds can be played, if the browser supports them.
  //
  //       var luv = Luv();
  //       var cry = luv.audio.Sound('sfx/cry.ogg', 'sfx/cry.mp3');
  //
  // See audio/sound.js for more information.
  Sound: function() {
    if(this.isAvailable()) {
      var args = [this.media].concat(Array.prototype.slice.call(arguments, 0));
      return Luv.Audio.Sound.apply(Luv.Audio.Sound, args);
    } else {
      return Luv.Audio.NullSound();
    }
  }

});

// The following three are class methods; they return the same as the instance methods described above.
Luv.Audio.isAvailable = function() {
  return audioAvailable;
};

Luv.Audio.canPlayType = function(type) {
  return !!supportedTypes[type.toLowerCase()];
};

Luv.Audio.getSupportedTypes = function() {
  return Object.keys(supportedTypes);
};

// These internal variables dealing with audio support detection
var el = document.createElement('audio'),
    supportedTypes = {},
    audioAvailable = !!el.canPlayType;
if(audioAvailable) {
  supportedTypes.ogg = !!el.canPlayType('audio/ogg; codecs="vorbis"');
  supportedTypes.mp3 = !!el.canPlayType('audio/mpeg;');
  supportedTypes.wav = !!el.canPlayType('audio/wav; codecs="1"');
  supportedTypes.m4a = !!el.canPlayType('audio/x-m4a;');
  supportedTypes.aac = !!el.canPlayType('audio/aac;');
}


})();

// # audio/sound.js
(function(){

// ## Luv.Audio.Sound

// This class wraps an `<audio>` tag. You will likely not instantiate this
// class directly; instead you will create a `Luv` instance, which has an
// `audio` module. And that module will have a `Sound` method, which will
// internally call `Luv.Audio.Sound` with the appropiate parameters. In other
// words, you will probably do this:

//       var luv = Luv();
//       var cry = luv.audio.Sound('sfx/cry.ogg', 'sfx/cry.mp3');

// `Luv.Audio.Sound` accepts a variable number of paths (strings). This is due to the fact
// that different browsers have different sound codecs. Luv will detect which
// codecs the browser supports, and load the first one on the given list that is
// available.

// If the browser is not capable of playing sounds reliably (for example in some
// old iphone browsers) then creating sounds will not produce any errors; no files
// will be downloaded, but calling `cry.play()` will not produce any sound.
// For more information about sound calls in non-sound-capable browsers, see
// `audio/null_sound.js`

// However, if the browser is capable of playing sounds, but it could not load
// them (for a network reason, or because the list of file paths doesn't include
// a file format that the browser can handle) then an error will be produced.

// Notice that Sounds can't be played right after they are created; they must
// finish loading first. See the `play` method below for details.
Luv.Audio.Sound = Luv.Class('Luv.Audio.Sound', {

  init: function(media) {
    var paths = Array.prototype.slice.call(arguments, 1);
    if(paths.length === 0) {
      throw new Error("Must provide at least one path for the Sound");
    }
    paths = paths.filter(isPathExtensionSupported);
    if(paths.length === 0) {
      throw new Error("None of the provided sound types (" +
                      paths.join(", ") +
                      ") is supported by the browser: (" +
                      Luv.Audio.getSupportedTypes().join(", ") +
                      ")");
    }

    var sound = this;

    sound.path = paths[0];

    media.newAsset(sound);
    var el = sound.el= document.createElement('audio');
    el.preload = "auto";

    el.addEventListener('canplaythrough', function() {
      if(sound.isLoaded()){ return; }
      media.registerLoad(sound);
    });
    el.addEventListener('error', function() { media.registerError(sound); });

    el.src     = sound.path;
    el.load();

    sound.instances = [];
    sound.expirationTime = Luv.Audio.Sound.DEFAULT_EXPIRATION_TIME;
  },

  toString: function() {
    return 'Luv.Audio.Sound("' + this.path + '")';
  },

  // `play` is the main way one has for playing sounds in Luv. Usually you call it
  // inside the `update` function.
  //
  // There is a catch, though. If you attempt to play a sound that has not been
  // completely loaded, you might get an error:
  //
  //       var luv = Luv();
  //       var cry;
  //
  //       luv.load = function() {
  //         cry = luv.audio.Sound('sfx/cry.ogg', 'sfx/cry.mp3');
  //       };
  //
  //       luv.update = function() {
  //         // This will throw an error;
  //         // cry might need some time to load.
  //         // Continue reading for a working version.
  //         if(something) { cry.play(); }
  //       };
  //
  // A simple way to fix this is to check that all media has been loaded before
  // attempting to play any sounds. The `luv.media` object has a `isLoaded` method
  // that we can use for that. A simple way is to just end the `luv.update` call
  // if media is still being loaded. Like this:
  //
  //       luv.update = function() {
  //         if(!luv.media.isLoaded()) { return; }
  //         // All sounds (and images) are loaded now, we can play them
  //         if(something) { cry.play(); }
  //       };
  //
  // Note: play returns a *sound instance*. The same sound can have several sound
  // instances playing simultaneously; each of those is one instance. See `audio/sound_instance.js` for
  // details.
  //
  // Possible options:
  //
  // * `volume`: float number, from 0 (muted) to 1 (max volume). Default: 1.
  // * `loop`: boolean, true if the instance must loop, false otherwise. Default: false.
  // * `speed`: float number, 1 is regular velocity, 2 is 2x, 0.5 is half, etc. Default: 1.
  // * `time`: float number, in seconds. The time offset to be used. Default: 0
  // * `status`: string, it can be either "paused" or "ready". Defaults to "ready".
  play: function(options) {
    if(!this.isLoaded()) {
      throw new Error("Attepted to play a non loaded sound: " + this);
    }
    var instance = this.getReadyInstance(options);
    instance.play();
    return instance;
  },

  // Pauses all the instances of the sound. If you want to pause an individual instance,
  // call `instance.pause()` instead of `sound.pause()`.
  pause: function() {
    this.instances.forEach(function(instance){ instance.pause(); });
  },

  // Stops all the instances of the sound. The difference between `pause` and `stop` is that
  // stop "rewinds" each instance, and marks it as "ready to be reused";
  stop: function() {
    this.instances.forEach(function(instance){ instance.stop(); });
  },

  // `countInstances` returns how many instances the sound has.
  // Includes both playing and finished instances.
  countInstances: function() {
    return this.instances.length;
  },

  // `countPlayingInstances` counts how many instances of the sound are currently playing.
  // Non-playing instances are destroyed after 3 seconds of inactivity by default.
  countPlayingInstances: function() {
    var count = 0;
    this.instances.forEach(function(inst){ count += inst.isPlaying() ? 1 : 0; });
    return count;
  },

  // `getReadyInstance` returns the first instance which is available for playing.
  // The method tries to find one available instance in the list of instances; if no
  // available instances are found, it creates a new one.
  //
  // accepts the same options as `play`. The only difference is that getReadyInstance returns
  // an instance in the `"ready"` status, while the one returned by `play` is in the `"playing"` status.
  getReadyInstance: function(options) {
    var instance = getExistingReadyInstance(this.instances);
    if(!instance) {
      instance = createInstance(this);
      this.instances.push(instance);
    }
    instance.reset(this.el, options);
    return instance;
  },

  // `getExpirationTime` returns how much time instances are preserved before they
  // expire. By default it's 3 seconds.
  getExpirationTime: function() {
    return this.expirationTime;
  },

  // `setExpirationTime` sets the time it takes to expire an instance after it has stopped playing.
  // In some browers, it takes time to create each sound instance, so increasing this value can
  // By default it is 3 seconds.
  setExpirationTime: function(seconds) {
    this.expirationTime = seconds;
  }
});

// This class variable controls the default expiration time of sound instances
Luv.Audio.Sound.DEFAULT_EXPIRATION_TIME = 3; // 3 seconds

// Sound is an asset. The `Luv.Media.Asset` mixin adds methods like `isLoaded` and `isPending` to the class.
Luv.Audio.Sound.include(Luv.Media.Asset);

// `Luv.Audio.SoundMethods` is a mixin shared by both `Luv.Audio.Sound` and `Luv.Audio.SoundInstance`.
// In `Sound`, they modify the "defaults" used for creating new instances. In `SoundInstance` they modify
// the instances themselves.
Luv.Audio.SoundMethods = {

  // `setVolume` expects a float between 0.0 (no sound) and 1.0 (full sound). Defaults to 1.
  //
  // * When invoked in a `Sound`, it alters how any subsequent calls to sound.play() sound. Alternatively, you can invoke
  //   `sound.play({sound: 0.5})` to alter the volume of only one sound instance.
  // * When invoked in a `SoundInstance`, it alters the volume of that particular instance.
  setVolume: function(volume) {
    volume = clampNumber(volume, 0, 1);
    this.el.volume = volume;
  },

  // `getVolume` returns the volume of a particular sound/sound instance. See `setVolume` for more details.
  getVolume: function() {
    return this.el.volume;
  },

  // `setLoop` expects a `true` or `false` value.
  //
  // * When invoked in a `Sound`, it will make the sound "play in loop" in all sucessive calls to `sound.play()`. It is
  //   usually a better idea to call `sound.play({loop: true})` instead. That way, only one instance of the sound will loop.
  // * When invoked in a `SoundInstance`, it will make the instance loop (or deactivate the looping).
  setLoop: function(loop) {
    this.loop = !!loop;
    if(loop) {
      this.el.loop = "loop";
    } else {
      this.el.removeAttribute("loop");
    }
  },

  // `getLoop` returns the state of the internal `loop` variable (true if the sound/sound instance starts over after finishing, false
  // if the sound/sound instance just halts after the first play).
  getLoop: function() {
    return this.loop;
  },

  // `setSpeed` expects a numeric float with the speed at which the sound/sound instance will play. 1.0 is regular. 2.0 is 2x. 0.5 is half
  // speed. And so on.
  // If nothing is specified, the default speed of any sound is 1.0.
  //
  // * When invoked in a `Sound`, it alters the speed of all the sound instances produced by calls to `sound.play()`. You can also invoke
  //   `sound.play({speed: 2.0})` to alter the speed of a particular sound instance without modifying the others.
  // * When invoked in a `SoundInstance`, it alters the speed of that instance only.
  setSpeed: function(speed) {
    this.el.playbackRate = speed;
  },

  // `getSpeed` returns the sound/sound instance speed. See `setSpeed` for details.
  getSpeed: function() {
    return this.el.playbackRate;
  },

  // `setTime` expects a float number specifying the "time offset" of a particular sound/sound instance. Defaults to 0.
  //
  // * When invoked in a `Sound`, it will make all the sound instances created by `sound.play()` have a default time when they start playing.
  //   You can alternatively do `sound.play({time: 4})` to only modify one particular instance.
  // * When invoked in a `SoundInstance`:
  //   * If the instance is playing, it will "jump" to that time.
  //   * If the instance is not playing, it will "start" on that time when it is played.
  setTime: function(time) {
    try {
      this.el.currentTime = time;
    } catch(err) {
      // some browsers throw an error when setting currentTime right after loading
      // a node. See https://bugzilla.mozilla.org/show_bug.cgi?id=465498
    }
  },

  // `getTime` returns the internal `time` attribute of a sound/sound instance. See `setTime` for details.
  getTime: function() {
    return this.el.currentTime;
  },

  // `getDuration` returns the total duration of a sound instance.
  getDuration: function() {
    return this.el.duration;
  }
};

Luv.Audio.Sound.include(Luv.Audio.SoundMethods);

// Internal function used by Luv.Sound.getReadyInstance
var getExistingReadyInstance = function(instances) {
  var instance;
  for(var i=0; i< instances.length; i++) {
    instance = instances[i];
    if(instance.isReady()) {
      return instance;
    }
  }
};

// Internal function used by Luv.Sound.getReadyInstance
var createInstance = function(sound) {
 return Luv.Audio.SoundInstance(
    sound.el.cloneNode(true),
    function() { clearTimeout(this.expirationTimeOut); },
    function() {
      var instance = this;
      instance.expirationTimeOut = setTimeout(
        function() { removeInstance(sound, instance); },
        sound.getExpirationTime() * 1000
      );
  });
};

// Internal function. Removes an instance from the list of instances.
var removeInstance = function(sound, instance) {
  var index = sound.instances.indexOf(instance);
  if(index != -1){ sound.instances.splice(index, 1); }
};

// Internal function to get the file extension from a path. It takes into account things like removing query
// parameters (it takes something like `"http://example.com/foo.mp3?x=1&y=2"` and returns `"mp3"`).
var getExtension = function(path) {
  var match = path.match(/.+\.([^?]+)(\?|$)/);
  return match ? match[1].toLowerCase() : "";
};

// Internal function. Given a path, return whether its file extension is playable by the current browser.
var isPathExtensionSupported = function(path) {
  return Luv.Audio.canPlayType(getExtension(path));
};

// Internal function. If x < min, return min. If x > max, return max. Otherwise, return x.
var clampNumber = function(x, min, max) {
  return Math.max(min, Math.min(max, Number(x)));
};

})();

// # audio/sound_instance.js
(function() {

// ## Luv.Audio.SoundInstance

// Once a `Luv.Sound` is loaded, you can invoke its `play` method to play it.
// Every time you invoke `play`, a instance of that sound (a `SoundInstance`)
// will be created (or recycled) and a reference to that instance will be
// returned by `play`. If you want, you can preserve that instance to do things
// with it later on.
//
// For example: You might have an `Enemy` class that `shouts` something when it
// sees the player. If an enemy is killed while he's shouting, you will probably
// want to hold a reference to that enemy's sound instance, and stop it. The rest
// of the enemies, who also saw the player, should "keep shouting", since they are
// still alive.
//
// You will almost certainly not instantiate this class directly. Instead, you will
// use `Luv.Sound.play` to create sound instances, like this:

//       var luv = Luv();
//       var shout = Luv.audio.Sound('sfx/shout.ogg', 'sfx/shout.mp3');
//       ...
//       // You could also do if(luv.media.isLoaded()){ here
//       if(shout.isLoaded()) {
//         var instance = shout.play({volume: 0.5});
//       }

Luv.Audio.SoundInstance = Luv.Class('Luv.Audio.SoundInstance', {

  // `init` takes an `el` (an audio tag) and an optional `options` array.
  // * `el` is usually a clone of a Sound's el instance.
  // * `onPlay` and `onStop` are callbacks that the sound instance must call when played/stopped.
  //   They are usually used by the Sound, to note that the instance is ready to be put in the
  //   available/expired track.
  init: function(el, onPlay, onStop) {
    var instance = this;
    instance.el = el;
    instance.onPlay = onPlay;
    instance.onStop = onStop;
    instance.el.addEventListener('ended', function(){ instance.stop(); });
  },

  // `reset` expects an audio element (usually, the one wrapped by a sound) and an options object
  // (with the same properties as `Luv.Audio.Sound.play`). It
  // sets the sound instance properties according to what they specify. When an option
  // is not specified, it resets the instance to a default value (for instance, if volume
  // is not specified, it's reset to 1.0).
  reset: function(soundEl, options) {
    options = options || {};
    var volume = typeof options.volume === "undefined" ? soundEl.volume       : options.volume,
        loop   = typeof options.loop   === "undefined" ? !!soundEl.loop       : options.loop,
        speed  = typeof options.speed  === "undefined" ? soundEl.playbackRate : options.speed,
        time   = typeof options.time   === "undefined" ? soundEl.currentTime  : options.time,
        status = typeof options.status === "undefined" ? "ready"              : options.status;

    this.setVolume(volume);
    this.setLoop(loop);
    this.setSpeed(speed);
    this.setTime(time);
    this.status = status;
  },

  // If the instance was not playing, it starts playing. If it was not playing, it does nothing
  play: function() {
    this.el.play();
    this.status = "playing";
    this.onPlay();
  },

  // `pause` halts the reproduction of a sound instance. The instance `status` is set to `"paused"`, and
  // sound is interrupted.
  pause: function() {
    if(this.isPlaying()) {
      this.el.pause();
      this.status = "paused";
    }
  },

  // `stop` halts the reproduction of a sound instance, and also rewinds it.
  // The instance `status` is set to `"ready"`.
  stop: function() {
    this.el.pause();
    this.setTime(0);
    this.status = "ready";
    this.onStop();
  },

  isPaused : function() { return this.status == "paused"; },
  isReady  : function() { return this.status == "ready"; },
  isPlaying: function() { return this.status == "playing"; },

  // Empty functions, usually set up by the Sound that creates the sound instance
  onPlay: function() {},
  onStop: function() {}

});

// This inserts lots of methods like `get/setVolume`, `get/setTime`, and so on.
// See the definition of `Luv.Audio.SoundMethods` inside `audio/sound.js` for details.
Luv.Audio.SoundInstance.include(Luv.Audio.SoundMethods);

}());

// # audio/null_sound.js
(function(){

// ## Luv.Audio.NullSound
//
// This class has the same methods as Luv.Audio.Sound, but they do nothing; they don't
// play or try to load any sounds.
//
// Browsers which don't support the `<audio>` tag will instantiate this class instead
// of Luv.Audio.Sound.
Luv.Audio.NullSound = Luv.Class('Luv.Audio.NullSound');

// Implement all the methods of Luv.Audio.Sound, but just return 0 instead of
// doing anything.
var fakeMethods = {},
    fakeMethod = function() { return 0; };
for(var name in Luv.Audio.Sound.methods) {
  if(Luv.Audio.Sound.methods.hasOwnProperty(name)) {
    fakeMethods[name] = fakeMethod;
  }
}

Luv.Audio.NullSound.include(fakeMethods, {
  // `play` is the only method that does something in a NullSound (it still does very little)
  // It returns a `SoundInstance` whose internal element is a "fake" audio tag (in reality, a plain js object).
  // This makes it interface-compatible with Luv.Audio.Sound, but with no side effects,
  // since the sound instances it produces do nothing.
  play: function() {
    return Luv.Audio.SoundInstance(FakeAudioElement());
  }
});

var FakeAudioElement = function() {
  return {
    volume: 1,
    playbackRate: 1,
    loop: undefined,
    currentTime: 0,
    play: function(){},
    pause: function(){},
    addEventListener: function(ignored, f) { f(); }
  };
};


})();

// # graphics.js
(function(){

// ## Luv.Graphics
//
// Everything graphics-related in Luv is controlled via this class.

Luv.Graphics = Luv.Class('Luv.Graphics', {

  // As a game programmer, you will normally not instantiate the Luv.Graphics
  // class directly. Instead, you will call `Luv({...})`. The variable returned by
  // that call will have a `graphics` attribute which you can use.
  //
  //       var luv = Luv();
  //       luv.graphics // this variable
  init: function(el, media) {
    this.el               = el;
    this.media            = media;
  },

  // `parseColor` transforms a variety of parameters into a "standard js object" of the form
  // `{r: 255, g: 0, b: 120}`.
  //
  // Types of accepted params:
  //
  // * Three integers: `luv.graphics.parseColor(255, 0, 120)`
  // * Array of integers: `luv.graphics.parseColor([255, 0, 120])`
  // * As an object: `luv.graphics.parseColor({r:255, g:0, b:120})`
  // * Strings:
  //   * 6-digit hex: `luv.graphics.setColor("#ff0078")`
  //   * 3-digit hex: `luv.graphics.setColor("#f12")`
  //   * rgb: `luv.graphics.setColor("rgb(255,0,120)")`
  //
  parseColor : function(r,g,b) {
    return Luv.Graphics.parseColor(r,g,b);
  },

  // ### Object Constructors

  // `Canvas` creates an instance of `Luv.Graphics.Canvas`; an invisible object to draw things
  // "off the main drawing canvas". Canvases are drawable objects.
  // The two parameters will define the dimensions of the new canvas, in pixels. If no dimensions
  // are specified, the new canvas will have the same dimensions as the current canvas.
  Canvas : function(width, height) {
    width  = width  || this.el.getAttribute('width');
    height = height || this.el.getAttribute('height');
    return Luv.Graphics.Canvas(width, height);
  },

  // `Image` creates an instance of `Luv.Graphics.Image` and the given path.
  // The advantage of using this method instead of directly instantiating `Luv.Graphics.Image` manually
  // is that the a default media object is passed by default by the graphics library.
  Image : function(path) {
    return Luv.Graphics.Image(this.media, path);
  },

  // `Sprite` just invokes `Luv.Graphics.Sprite` with the same parameters. Please refer to that class'
  // documentation for more details.
  Sprite : function(image, l,t,w,h) {
    return Luv.Graphics.Sprite(image, l,t,w,h);
  },

  // `SpriteSheet` is also a simple redirect. See the documentation of `Luv.Graphics.SpriteSheet` for details.
  SpriteSheet : function(image, w,h,l,t,b) {
    return Luv.Graphics.SpriteSheet(image, w,h,l,t,b);
  }

});

// `Luv.Graphics.parseColor` is a class method implementing `parseColor` at the instance level. See the
// `parseColor` instance method above for details.
Luv.Graphics.parseColor = function(r,g,b) {
  var m, p = parseInt;

  if(Array.isArray(r))      { return { r: r[0], g: r[1], b: r[2] }; }
  if(typeof r === "object") { return { r: r.r, g: r.g, b: r.b }; }
  if(typeof r === "string") {
    r = r.replace(/#|\s+/g,""); // Remove all spaces and #

    // `ffffff` & `#ffffff`
    m = /^([\da-fA-F]{2})([\da-fA-F]{2})([\da-fA-F]{2})/.exec(r);
    if(m){ return { r: p(m[1], 16), g: p(m[2], 16), b: p(m[3], 16) }; }

    // `fff` & `#fff`
    m = /^([\da-fA-F])([\da-fA-F])([\da-fA-F])/.exec(r);
    if(m){ return { r: p(m[1], 16) * 17, g: p(m[2], 16) * 17, b: p(m[3], 16) * 17 }; }

    // `rgb(255,3,120)`
    m = /^rgb\(([\d]+),([\d]+),([\d]+)\)/.exec(r);
    if(m){ return { r: p(m[1], 10), g: p(m[2], 10), b: p(m[3], 10) }; }
  }
  return { r: r, g: g, b: b };
};

}());

// # animation.js
(function() {

// ## Luv.Graphics.Animation
// Animations are lists of sprites which are swapped as time passes.
Luv.Graphics.Animation = Luv.Class('Luv.Graphics.Animation', {

  // `init` only takes two params.
  //
  // Althrough you can instantiate Animation directly, you will probably want to use
  // Luv.Graphics.SpriteSheet.Animation. Like this:
  //
  //       var image = luv.graphics.Image('player.png'),
  //           sheet = luv.graphics.SpriteSheet(image, 32,32);
  //           anim  = sheet.Animation([0,0, '0-5',1], 0.1);
  //
  // But you can instantiate Animation directly if you want. It needs two parameters.
  //
  // * `sprites` is an array of drawables (normally instances of Luv.Graphics.Sprite)
  //   which will be sequentially updated as the animation rolls. Usually the output
  //   of SpriteSheet.getSprites.
  // * `durations` can be:
  //   * A positive number, representing a duration in seconds. It will be used for
  //     all frames. For example, 0.1 will mean that all frames will take 0.1s.
  //   * An array of numbers, each one representing the duration of one frame. When
  //     providing an array, it must have at least one number per sprite.
  //   * A javascript object. The keys can be integers or strings of the form 'a-b',
  //     where a and b are integers representing an interval.
  init: function(sprites, durations) {
    if(!Array.isArray(sprites)) {
      throw new Error('Array of sprites needed. Got ' + sprites);
    }
    if(sprites.length === 0) {
      throw new Error('No sprites where provided. Must provide at least one');
    }
    this.sprites      = sprites.slice(0);
    this.time         = 0;
    this.index        = 0;
    this.durations    = parseDurations(sprites.length, durations);
    this.intervals    = calculateIntervals(this.durations);
    this.loopDuration = this.intervals[this.intervals.length - 1];
  },

  // `update` changes the internal counters of the animation, and updates the current
  // sprite accordingly to the time that has passed.
  update: function(dt) {
    var loops;

    this.time += dt;
    loops = Math.floor(this.time / this.loopDuration);
    this.time -= this.loopDuration * loops;

    if(loops !== 0) { this.onLoopEnded(loops); }

    this.index = findSpriteIndexByTime(this.intervals, this.time);
  },

  // `gotoStprite` resets the animation to the sprite specified by `newSpriteIndex` (an integer)
  gotoSprite: function(newSpriteIndex) {
    this.index = newSpriteIndex;
    this.time = this.intervals[newSpriteIndex];
  },

  // `getCurrentSprite` returns the sprite currently being shown by the animation.
  getCurrentSprite: function() {
    return this.sprites[this.index];
  },

  // `onLoopEnded` is invoked every time an animation loop ends. It can be reset and used for controlling purposes.
  onLoopEnded: function(how_many) {}
});

// These methods are delegated to the current animation sprite
"getWidth getHeight getDimensions getCenter drawInCanvas".split(" ").forEach(function(method) {
  Luv.Graphics.Animation.methods[method] = function() {
    var sprite = this.getCurrentSprite();
    return sprite[method].apply(sprite, arguments);
  };
});

// private function. It transforms the durations table into an intervals table, for faster searches
var calculateIntervals = function(durations) {
  var result = [0],
      time   = 0;
  for(var i=0; i<durations.length; i++) {
    time += durations[i];
    result.push(time);
  }
  return result;
};

// private function. Given a time, it returns the index of the sprite which should be
// used to represent it.
var findSpriteIndexByTime = function(frames, time) {
  var high = frames.length - 2,
      low = 0,
      i = 0;

  while (low <= high) {
    i = Math.floor((low + high) / 2);
    if (time >= frames[i+1]) { low  = i + 1; continue; }
    if (time < frames[i])   { high = i - 1; continue; }
    break;
  }

  return i;
};

// Parses the durations param and transforms it into a simple numbers array.
var parseDurations = function(length, durations) {
  var result=[], r, i, range, value;

  if(Array.isArray(durations)) {
    result = durations.slice(0);

  } else if(typeof durations == "object") {
    result.length = length;
    for(r in durations) {
      if(durations.hasOwnProperty(r)) {
        range = parseRange(r);
        value = Number(durations[r]);
        for(i=0; i<range.length; i++) {
          result[range[i]] = value;
        }
      }
    }
  } else {
    durations = Number(durations);
    for(i=0; i<length; i++) {
      result.push(durations);
    }
  }

  if(result.length != length) {
    throw new Error('The durations table length should be ' + length +
                    ', but it is ' + result.length);
  }

  for(i=0; i<result.length; i++) {
    if(typeof result[i] === "undefined") { throw new Error('Missing delay for sprite ' + i); }
    if(isNaN(result[i])) { throw new Error('Could not parse the delay for sprite ' + i); }
  }
  return result;
};

// Given the string '1-5', return the array [1,2,3,4,5]
var parseRange = function(r) {
  var match, result, start, end, i;
  if(typeof r != "string") {
    throw new Error("Unknown range type (must be integer or string in the form 'start-end'): " + r);
  }
  match = r.match(/^(\d+)-(\d+)$/);
  if(match) {
    result = [];
    start  = Number(match[1]);
    end    = Number(match[2]);
    if(start < end) {
      for(i=start; i<=end; i++) { result.push(i); }
    } else {
      for(i=start; i>=end; i--) { result.push(i); }
    }
  } else {
    result = [Number(r)];
  }

  return result;
};


}());

// # canvas.js
(function() {

// ## Luv.Graphics.Canvas

Luv.Graphics.Canvas = Luv.Class('Luv.Graphics.Canvas', {

// represents a  drawing surface, useful
// for precalculating costly drawing operations or
// applying effects.
//
// Any Luv instance comes with a default canvas in `luv.canvas`.
// Anything drawn into that canvas is made visible on the screen.
//
// In addition to that, it's possible to create canvases for off-screen
// image manipulations. This can be done by invoking:
//
// * `luv.graphics.Canvas() to obtain a canvas as big as the current main canvas.
// * `luv.graphics.Canvas(width, height) to obtain a canvas with the given dimensions.
// * `luv.graphics.Canvas(el) to obtain a canvas attached to a given DOM element. The
//   dimendions will be obtained from the element.
//
//       var luv    = Luv();
//
//       // print on the default canvas (visible
//       luv.canvas.print("This is print off-screen", 100, 100);
//
//       // create an off-screen canvas
//       var buffer = luv.graphics.Canvas(320,200);
//
//       // print on the off-screen canvas
//       buffer.print("This is print inscreen", 100, 100);
//
//       // Draw the off-screen canvas on the screen
//       luv.canvas.draw(buffer, 200, 500);
//
// The main canvas is cleared at the beginning of each draw cycle, before calling luv.draw()

  init: function(width, height) {
    var el;
    if(width.getAttribute) {
      el     = width;
      width  = el.getAttribute('width');
      height = el.getAttribute('height');
    } else {
      el = document.createElement('canvas');
      el.setAttribute('width', width);
      el.setAttribute('height', height);
    }
    this.el               = el;
    this.ctx              = el.getContext('2d');
    this.color            = {};
    this.backgroundColor  = {};

    this.setBackgroundColor(0,0,0);
    this.setColor(255,255,255);
    this.setLineCap("butt");
    this.setLineWidth(1);
    this.setImageSmoothing(true);
    this.setAlpha(1);
  },

  // `clear` fills the whole canvas with the background color, effectively clearing
  // up the screen. See `setBackgroundColor` for details.
  clear : function() {
    this.ctx.save();
    this.ctx.setTransform(1,0,0,1,0,0);
    this.ctx.globalAlpha = 1;
    this.ctx.fillStyle = this.backgroundColorStyle;
    this.ctx.fillRect(0, 0, this.getWidth(), this.getHeight());
    this.ctx.restore();
  },

  // ### Text-related functions

  // `print` is the function that prints text on the screen. It expects a string
  // and the two coordinates of the upper-left corner from which the text will
  // be written.
  print : function(str,x,y) {
    this.ctx.fillStyle = this.colorStyle;
    this.ctx.fillText(str, x, y);
  },

  // ### Primitive drawing

  // `line` draws a line using the currently selected color, line width and line cap
  // (see `setColor`, `setLineWidth` and `setLineCap` for details about those).
  //
  // On it simplest form, it expects 4 numbers in the form `x1,y1,x2,y2`. It draws
  // a line between the points `x1,y1` and `x2,y2`.
  //
  // It's possible to add more points (`x1,y1,x2,y2,x3,y3 ...`), in which case `line`
  // will draw a line between `x1,y1` and `x2,y2`, then a line between `x2,y2` and `x3,y3`,
  // and so on.
  //
  // The coordinate list must be all numbers, and have an even number of elements. It
  // can also be passed as a JS array (`luv.graphics.line(10,20,30,40)` draws the same as
  // `luv.graphics.line([10,20,30,40])`
  line : function() {
    var coords = Array.isArray(arguments[0]) ? arguments[0] : arguments;

    this.ctx.beginPath();
    drawPolyLine(this, 'luv.graphics.line', 4, coords);
    drawPath(this, MODE.STROKE);
  },

  // `strokeRectangle` draws a the perimeter of a rectangle using the specified
  // coordinates in pixels, using the current color, line width and line cap.
  strokeRectangle : function(left, top, width, height) { rectangle(this, MODE.STROKE, left, top, width, height); },

  // `fillRectangle` draws a rectangle filled with the currently selected color.
  fillRectangle   : function(left, top, width, height) { rectangle(this, MODE.FILL, left, top, width, height); },

  // `strokePolygon` draws a the perimeter of a polygon using the specified
  // coordinates in pixels, using the current color, line width and line cap.
  // The polygon coordinates must be an even number of numbers, in the form
  // `x1,y1,x2,y2,x3,y3...`.
  //
  //        var luv = Luv();
  //        luv.strokePolygon(0,0, 10,20, 20,0);
  //
  // You must specify at least three points (6 coordinates) or else the function
  // will fail.
  //
  // The point coordinates can be specified as plain arguments (as above) or
  // inside an array. This would print the same as in the previous example:
  //
  //        var luv = Luv();
  //        luv.strokePolygon([0,0, 10,20, 20,0]);
  strokePolygon   : function() { polygon(this, MODE.STROKE, arguments); },

  // `fillPolygon` takes the same parameters as `strokePolygon`, but it fills the
  // polygon with the current color instead of drawing its perimeter.
  fillPolygon     : function() { polygon(this, MODE.FILL, arguments); },

  // `strokeCircle` draws the perimeter of a circle using the current line width and color.
  // It expects the coordinates of the circle's center in pixels, and its radius.
  strokeCircle    : function(x,y,radius)  { circle(this, MODE.STROKE, x,y, radius); },

  // `fillCircle` works the same way as `strokeCircle`, but draws a circle filled with
  // the current color instead of drawing its perimeter.
  fillCircle      : function(x,y,radius)  { circle(this, MODE.FILL, x,y, radius); },

  // `strokeArc` draws a section of the perimeter of a circle. Takes the same
  // parameter as `strokeCircle`, plus the start and end of the angles of the arc,
  // in radians.
  strokeArc       : function(x,y,radius, startAngle, endAngle)  { arc(this, MODE.STROKE, x,y, radius, startAngle, endAngle); },

  // `fillArc` draws an "applepie" or a "pacman" filled with the currently selected
  // color. Takes the same parameters as `strokeArc`.
  fillArc         : function(x,y,radius, startAngle, endAngle)  { arc(this, MODE.FILL, x,y, radius, startAngle, endAngle); },

  // ### Drawables

  // `draw` can be used to draw what Luv calls "drawable" objects.
  //
  // Currently, the following objects are drawable:
  //
  // * Images
  // * Sprites
  // * Animations
  // * Canvases
  //
  // Parameters:
  //
  // * `drawable` is an object implementing the drawable interface (see below). It is the only required param.
  // * `x` and `y` are the coordinates of the top-left corner where the drawable will be drawn. They default to 0,0.
  // * `angle` is the angle at which the drawable wil be turned, in radians. Defaults to 0.
  // * `sx and sy` are the horizontal and vertical scales. They default to 1,1 (no scale). If you set them to `2,2`, then
  //   the drawable will be drawn "double sized". If you set them to `0.5,1`, it will have its default height but its width will
  //   be halved.
  // * `ox and oy` are the coordinates of the point used as center of rotation when an angle is specified. By default they are
  //   0,0. The center of rotation is relative to the top-left corner (specified by the x,y params). So if `x,y` = `10,10` ,
  //   and `ox,oy` = `5,5`, then the rotation will occur around the point in 15,15.
  //
  // You can implement other drawable objects if you want. Drawable objects must implement a `draw` method with the following signature:
  //
  //       obj.drawInCanvas(canvas, x, y)
  //
  // Where context is a js canvas 2d context, and x and y are the coordinates of the
  // object's top left corner.
  //
  // It is also recommended that your drawable objects implement a `getCenter` function, so they can be used by `drawCentered` (see
  // details below)
  //
  // Note that javascript canvases try to "minimize the amount of pixellation" when doing transformations in images, so they
  // apply an "image smoothing" algorithm to rotated/translated images. See
  // `setImageSmoothing` for more details.
  draw : function(drawable, x, y, angle, sx, sy, ox, oy) {
    var ctx = this.ctx;

    x     = x  || 0;
    y     = y  || 0;
    sx    = sx || 1;
    sy    = sy || 1;
    ox    = ox || 0;
    oy    = oy || 0;
    angle = normalizeAngle(angle || 0);

    if(angle !== 0 || sx !== 1 || sy !== 1 || ox !== 0 || oy !== 0) {
      ctx.save();

      ctx.translate(x,y);

      ctx.translate(ox, oy);
      ctx.rotate(angle);
      ctx.scale(sx,sy);
      ctx.translate(-ox, -oy);
      drawable.drawInCanvas(this, 0, 0);

      ctx.restore();
    } else {
      drawable.drawInCanvas(this, x, y);
    }
  },

  // `drawCentered` draws a drawable object (images, sprites, animations, canvases ...
  // see the `draw` method for more info) but centering it on its center instead of
  // using the top-left coordinates.
  //
  // The drawables must implement a method called `getCenter()` that should return
  // a JS object with two properties called `x` and `y`, representing the geometrical
  // center of the object.
  //
  //       var c = obj.getCenter();
  //       console.log(c.x, c.y);
  //
  // Note that the center must be expressed relatively to the top-left corner of the object,
  // not the origin of coordinates.
  //
  // All drawable objects in Luv also implement a getCenter function.
  drawCentered : function(drawable, x,y, angle, sx, sy) {
    var c = drawable.getCenter();
    this.draw(drawable, x-c.x,y-c.y, angle, sx, sy, c.x, c.y);
  },

  // `drawInCanvas` makes Canvases drawable - it allows you to be able to draw one canvas inside
  // another canvas
  drawInCanvas: function(canvas, x, y) {
    canvas.ctx.drawImage(this.el, x, y);
  },

  // ### Transformations

  // `translate` displaces the origin of coordinates `x` pixels to the right and `y` down.
  // This means that it can be used to simulate things like scrolling or camera.
  // The origin of coordinates is in 0,0 by default.
  translate : function(x,y) {
    this.ctx.translate(x,y);
  },

  // `scale` sets the world scale on both the x and y axes. 2,2 will make everything look
  // bigger, and 0.5,0.5 will make everything look half its size; so it can be used for
  // zooming in an out.
  // The default scale is 1 in both axes. That means no scale.
  scale : function(sx,sy) {
    this.ctx.scale(sx,sy);
  },

  // `rotate` transforms the origin of coordinates with an angle (specified in radians).
  rotate : function(angle) {
    this.ctx.rotate(angle);
  },

  // `push` inserts the current state of the transformation matrix (things like translate, rotate
  // and scale configuration) in a stack. This means you can add further transformations later on, and
  // then "come back to the current state" by invoking `pop`
  push : function() {
    this.ctx.save();
  },

  // `pop` is the opposite of `push`: it removes the current transformation settings from the
  // graphics canvas and replaces it with the one at the top of the stack, which is "popped" out.
  // `pop` can be invoked several times, as long as there are transformations left on the stack.
  pop : function() {
    this.ctx.restore();
  },


  // ### Getters and setters

  // `getDimensions` returns a JS object containing two components: `width` and `height`,
  // with the width and height of the canvas in pixels.
  //
  //        var luv = Luv();
  //        var d = luv.getDimensions();
  //        console.log(d.width, d.height);
  getDimensions : function(){ return { width: this.getWidth(), height: this.getHeight() }; },

  setDimensions : function(width, height) {
    this.el.setAttribute('width', width);
    this.el.setAttribute('height', height);
  },

  // `getWidth` returns the width of the canvas, in pixels.
  getWidth      : function(){ return Number(this.el.getAttribute('width')); },

  // `getHeight` returns the height of the canvas, in pixels.
  getHeight     : function(){ return Number(this.el.getAttribute('height')); },

  getCenter     : function(){ return { x: this.getWidth()/2, y: this.getHeight() / 2}; },

  // `setColor` just sets an internal variable with the color to be used for
  // during the next graphical operations. If you set the color to `255,0,0`
  // (pure red) and then draw a line or a rectangle, they will be red.
  //
  // Admits the same parameters as `parseColor` (see below)
  setColor  : function(r,g,b) { setColor(this, 'color', r,g,b); },

  // `getColor` returns the currently selected color. See `setColor` for details.
  // The current color is returned like a JS object whith the properties
  // `r`, `g` & `b`, similar to what parseColor returns.
  //
  //        var luv = Luv();
  //        var c = luv.graphics.getColor();
  //        console.log(c.red, c.green, c.blue, c.alpha);
  getColor  : function() { return getColor(this.color); },

  // `setBackgroundColor` changes the color used to clear the screen at the beginning
  // of each frame. It takes the same parameters as `setColor`.
  // The default background color is black (`0,0,0`)
  setBackgroundColor : function(r,g,b) {
    setColor(this, 'backgroundColor', r,g,b);
  },

  // `getBackgroundColor` returns the background color the same way as
  // `getColor` returns the foreground color. See `setBackgroundColor` and `getColor`
  // for more info.
  getBackgroundColor : function() { return getColor(this.backgroundColor); },

  // `setAlpha` acceps a number from 0 (full transparency) to 1 (full opaqueness).
  // Call setAlpha before drawing things to alter how transparent they are.
  //
  //       var luv = Luv();
  //       luv.graphics.setAlpha(0.5);
  //       // draw a semi-transparent line
  //       luv.graphics.line(0,0,20,20);
  //
  // Alpha defaults to 1 (no transparency).
  setAlpha: function(alpha) {
    this.alpha = clampNumber(alpha, 0, 1);
    this.ctx.globalAlpha = this.alpha;
  },

  // `getAlpha` returns the current alpha. See `setAlpha` for details
  getAlpha: function() { return this.alpha; },

  // `setLineWidth` changes the width of the lines used for drawing lines with the `line` method,
  // as well as the various stroke methods (`strokeRectangle`, `strokePolygon`, etc). It expects
  // a number, in pixels. The number must be positive.
  setLineWidth : function(width) {
    this.lineWidth = width;
    this.ctx.lineWidth = width;
  },

  // `getLineWidth` returns the line width, in pixels.
  getLineWidth : function() {
    return this.lineWidth;
  },

  // `setLineCap` changes the line "endings" when drawing lines. It expects a string.
  // It can have three values:
  //
  // * `"butt"`: The lines have "no special ending". Lines behave like small oriented rectangles
  //   connecting two coordinates.
  // * '"round"': Adds a semicircle to the end of each line. This makes corners look "rounded".
  // * '"square"': Adds a small square to the end of each line. Lines are "a big longer" than when
  //   using the `"butt"` line cap. As a result, rectangles and squares' corners look "complete".
  //
  // The default value is "butt".
  setLineCap : function(cap) {
    if(cap != "butt" && cap != "round" && cap != "square") {
      throw new Error("Line cap must be either 'butt', 'round' or 'square' (was: " + cap + ")");
    }
    this.ctx.lineCap = cap;
    this.lineCap     = this.ctx.lineCap;
  },

  // `getLineCap` returns the line cap as a string. See `setLineCap` for details.
  getLineCap : function() { return this.lineCap; },

  // `setImageSmoothing` accepts either true or false. It activates or deactivates the image
  // smoothing algorithms that browsers use in images, particularly when they are rendered in
  // non-integer locations or with transformations like scales or rotations.
  // It is `true` by default.
  setImageSmoothing: function(smoothing) {
    this.imageSmoothing = smoothing = !!smoothing;
    setImageSmoothing(this.ctx, smoothing);
  },

  // `getImageSmoothing` returns whether the graphics have image smoothing active or not, in a boolean.
  // See `setImageSmoothing` for a further explanation.
  getImageSmoothing: function() {
    return this.imageSmoothing;
  }

});

// ### Private functions and constants

var twoPI = Math.PI * 2;

// Internal function used for setting the foreground and background color
var setColor = function(self, name, r,g,b) {
  var color = self[name],
      newColor = Luv.Graphics.parseColor(r,g,b);
  Luv.extend.call(color, newColor);
  self[name + 'Style'] = "rgb(" + [color.r, color.g, color.b].join() + ")";
};

var getColor = function(color) {
  return {r: color.r, g: color.g, b: color.b};
};

// Strokes a polyline given an array of methods.
var drawPolyLine = function(self, methodName, minLength, coords) {

  if(coords.length < minLength) { throw new Error(methodName + " requires at least 4 parameters"); }
  if(coords.length % 2 == 1) { throw new Error(methodName + " requires an even number of parameters"); }

  self.ctx.moveTo(coords[0], coords[1]);

  for(var i=2; i<coords.length; i=i+2) {
    self.ctx.lineTo(coords[i], coords[i+1]);
  }

  self.ctx.stroke();
};

// Given an angle in radians, return an equivalent angle in the [0 - 2*PI) range.
var normalizeAngle = function(angle) {
  angle = angle % twoPI;
  return angle < 0 ? angle + twoPI : angle;
};

// This function makes sure that `ctx` (a 2d canvas context) is configured to have
// the same properties as graphics. This makes sure that the graphics instance is the main
// "authority". It's called after each canvas is used with `setCanvas`.
var resetCanvas = function(self, ctx) {
  ctx.setTransform(1,0,0,1,0,0);
  setImageSmoothing(ctx, self.getImageSmoothing());
  ctx.lineWidth    = self.getLineWidth();
  ctx.lineCap      = self.getLineCap();
  ctx.globalAlpha  = self.getAlpha();
};

// Image smoothing helper function
var setImageSmoothing = function(ctx, smoothing) {
  ctx.webkitImageSmoothingEnabled = smoothing;
  ctx.mozImageSmoothingEnabled    = smoothing;
  ctx.imageSmoothingEnabled       = smoothing;
};

// Internal function by all the primitive drawing functions. It fills or strokes the current path
// in the current canvas 2d context.
var drawPath = function(self, mode) {
  switch(mode){
  case MODE.FILL:
    self.ctx.fillStyle = self.colorStyle;
    self.ctx.fill();
    break;
  case MODE.STROKE:
    self.ctx.strokeStyle = self.colorStyle;
    self.ctx.stroke();
    break;
  default:
    throw new Error('Invalid mode: [' + mode + ']. Should be "fill" or "line"');
  }
};

// Rectangle drawing implementation
var rectangle = function(self, mode, left, top, width, height) {
  self.ctx.beginPath();
  self.ctx.rect(left, top, width, height);
  drawPath(self, mode);
  self.ctx.closePath();
};

// Polygon drawing implementation
var polygon = function(self, mode, args) {
  var coordinates = Array.isArray(args[0]) ? args[0] : Array.prototype.slice.call(args, 0);
  self.ctx.beginPath();

  drawPolyLine(self, 'luv.Graphics.Canvas.polygon', 6, coordinates);
  drawPath(self, mode);

  self.ctx.closePath();
};

// Arc drawing implementation
var arc = function(self, mode, x,y,radius, startAngle, endAngle) {
  self.ctx.beginPath();
  self.ctx.arc(x,y,radius, startAngle, endAngle, false);
  drawPath(self, mode);
};

// Circle implementation (mainly it invokes `arc`)
var circle = function(self, mode, x,y,radius) {
  arc(self, mode, x, y, radius, 0, twoPI);
  self.ctx.closePath();
};

// Private "constant" for magic numbers
var MODE = {
  STROKE: 1,
  FILL  : 2
};

// Internal function. If x < min, return min. If x > max, return max. Otherwise, return x.
var clampNumber = function(x, min, max) {
  return Math.max(min, Math.min(max, Number(x)));
};


}());

// # image.js
(function() {

// ## Luv.Graphics.Image
// This class encapsulates images loaded from the internet
Luv.Graphics.Image = Luv.Class('Luv.Graphics.Image', {

  // Usually you will not instantiate images directly. Instead, you will use
  // the instance method of Luv.Graphics, like this:
  //
  //       var luv = Luv(...);
  //       var image = luv.graphics.Image('face.png');
  //
  // Notice that this constructor requires an additional parameter (an instance
  // of Luv.Media), which is provided automatically by luv.graphics.Image.
  init: function(media, path) {
    var image = this;

    image.path = path;

    media.newAsset(image);

    var source   = new Image(); // html image
    image.source = source;

    source.addEventListener('load',  function(){ media.registerLoad(image); });
    source.addEventListener('error', function(){ media.registerError(image); });
    source.src = path;
  },

  toString      : function() {
    return 'instance of Luv.Graphics.Image("' + this.path + '")';
  },

  getWidth      : function() { return this.source.width; },

  getHeight     : function() { return this.source.height; },

  getDimensions : function() {
    return { width: this.source.width, height: this.source.height };
  },

  getCenter: function() {
    return { x: this.source.width / 2, y: this.source.height / 2 };
  },

  drawInCanvas: function(graphics, x, y) {
    if(!this.isLoaded()) {
      throw new Error("Attepted to draw a non loaded image: " + this);
    }
    graphics.ctx.drawImage(this.source, x, y);
  }

});

// Add methods like isLoaded, isError, isPending to image
Luv.Graphics.Image.include(Luv.Media.Asset);

}());

// # sprite.js
(function() {

// ## Luv.Graphics.Sprite
// Represents a rectangular region of an image
// Useful for spritesheets and animations
Luv.Graphics.Sprite = Luv.Class('Luv.Graphics.Sprite', {
  // The constructor expects an image and the coordinates of the sprite's Bounding box.
  init: function(image, left,top,width,height) {
    this.image = image;
    this.left = left;
    this.top = top;
    this.width = width;
    this.height = height;
  },

  toString : function() {
    return [
      'instance of Luv.Graphics.Sprite(',
      this.image, ', ',
      this.left, ', ',  this.top, ', ', this.width, ', ', this.height, ')'
    ].join("");
  },

  getImage      : function() { return this.image; },

  getWidth      : function() { return this.width; },

  getHeight     : function() { return this.height; },

  getDimensions : function() {
    return { width: this.width, height: this.height };
  },

  getCenter     : function() {
    return { x: this.width / 2, y: this.height / 2 };
  },

  getBoundingBox : function() {
    return { left: this.left, top: this.top, width: this.width, height: this.height };
  },

  // `drawInCanvas` makes Sprites drawable. It draws only the parts of the image that include the sprite, and nothing else.
  drawInCanvas: function(graphics, x, y) {
    if(!this.image.isLoaded()) {
      throw new Error("Attepted to draw a prite of a non loaded image: " + this);
    }
    graphics.ctx.drawImage(this.image.source, this.left, this.top, this.width, this.height, x, y, this.width, this.height);
  }

});

}());

// # sprite_sheet.js
(function() {

// ## Luv.Graphics.SpriteSheet
// A Spritesheet is used to easily divide an image in rectangular blocks (sprites)
// Their most important use is animations (see Luv.Graphics.Animation for details)
Luv.Graphics.SpriteSheet = Luv.Class('Luv.Graphics.SpriteSheet', {

  // `init` has the following parameters:
  //
  // * `image` is the image from which the spriteSheet takes its sprites. It's mandatory.
  // * `width` and `height` are the dimensions (in pixels) of all the sprites that the
  //   spriteSheet will generate. They are mandatory.
  // * `left` and `top` are the coordinates where the spritesheet starts inside the image;
  //   an "offset" (they default to 0,0)
  // * `border` is the distance in pixels between each sprite and its neighbors. Defaults to 0.
  init: function(image, width, height, left, top, border) {
    this.image   = image;
    this.width   = width;
    this.height  = height;
    this.left    = left   || 0;
    this.top     = top    || 0;
    this.border  = border || 0;
  },

  // `getSprites` accepts a variable number of parameters and returns an array of sprites (instances of
  // `Luv.Graphics.Sprite`). The parameters can be either integers or strings of the form 'A-B', where A and
  // B are integers, too. It's parsed as follows:
  //
  // * Two integers reference one sprite. For example `sheet.getSprites(1,1)` will return the sprite on the
  //   second row and second column of the spritesheet in one array. `sheet.getSprites(0,0, 0,1)` will return
  //   the first two sprites of the first column of the spritesheet.
  // * An integer and a string will "iterate" over the string, between A and B. For example,
  //   `sheet.getSprites('0-9', 0)` will return the first 9 sprites of the first row of the sheet (y remains fixed
  //   at 0, and x iterates from 0 to 9). You can also iterate over columns: `sheet.getSprites(0, '0-9')`. If you
  //   want to iterate backwards (from right to left or from bottom to top) just switch the numbers of the string:
  //   `sheet.getSprites('9-0', 0)`.
  // * Two strings will iterate over a set of rows and columns (rows will get iterated over first). This means that
  //   `sheet.getSprites('5-10', '2-3')` will return the sprites in [5,2], [5,3], [6,2], [6,3] ... [10,2], [10,3].
  //
  // Finally, take into accont that you can get as many rows/columns as you want
  // in a single call, and even add individual spritesheets. For example, this call will get the 10 first sprites
  // of the first two rows, and then the sprite in 10,10: `sheet.getSprites('0-9',0, '0-9',1, 10,10)`.
  getSprites: function() {
    var result = [], xCoords, yCoords;

    for(var i=0; i<arguments.length; i+=2) {
      xCoords = parseRange(arguments[i]);
      yCoords = parseRange(arguments[i+1]);
      for(var iy=0; iy < yCoords.length; iy++) {
        for(var ix=0; ix < xCoords.length; ix++) {
          result.push(this.Sprite(xCoords[ix], yCoords[iy]));
        }
      }
    }
    return result;
  },

  // `Sprite` returns the instance of Luv.Graphics.Sprite which is on column x, row y of the SpriteSheet.
  Sprite: function(x,y) {
    return Luv.Graphics.Sprite(
      this.image,
      this.left + this.width * x + this.border * (x+1),
      this.top + this.height * y + this.border * (y+1),
      this.width,
      this.height
    );
  },

  // `Animation` returns an instance of Luv.Graphics.Animation.
  //
  // * `spriteInfo` is an array of indexes for sprites, following the same rules as the parameters of getSprites.
  // * `durations` follows the same rules as it does in Luv.Graphics.Animation.init. See Luv.Graphics.Animation.init
  //   for details
  Animation: function(spriteInfo, durations) {
    var sprites = this.getSprites.apply(this, spriteInfo);
    return Luv.Graphics.Animation(sprites, durations);
  }

});

// Transform a string of type '2-5' in an array of type [2,3,4,5].
var parseRange = function(r) {
  if(typeof r == "number") { return [r]; }
  if(typeof r == "string") {
    var split = r.split("-");
    if(split.length != 2) {
      throw new Error("Could not parse from '" + r + "'. Must be of the form 'start-end'");
    }
    var result = [],
        start  = Number(split[0]),
        end    = Number(split[1]),
        i;

    if(start < end) {
      for(i=start; i<=end; i++) { result.push(i); }
    } else {
      for(i=start; i>=end; i--) { result.push(i); }
    }

    return result;
  }
  throw new Error("Ranges must be integers or strings of the form 'start-end'. Got " + r);
};

}());

    return Luv;
}));
