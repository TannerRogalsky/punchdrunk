(function() {
  describe("love.audio", function() {
    return it('exists', function() {
      return expect(Love.Audio).to.be.a("function");
    });
  });

}).call(this);

(function() {
  describe("love.color", function() {
    return it('exists', function() {
      return expect(Love.Color).to.be.a("function");
    });
  });

}).call(this);

(function() {
  describe('love.event', function() {
    it('exists', function() {
      return expect(Love.EventQueue).to.be.a("function");
    });
    describe('constructor', function() {
      return it('creates an internal queue', function() {
        var eventQueue;
        eventQueue = new Love.EventQueue();
        return expect(eventQueue.internalQueue).to.be.ok;
      });
    });
    describe('push', function() {
      return it('should accept a variable number of arguments up to four', function() {
        var event, eventQueue;
        eventQueue = new Love.EventQueue();
        eventQueue.push("test_event", 1, 2, 3, 4);
        event = eventQueue.internalQueue[0];
        expect(event.eventType).to.equal("test_event");
        expect(event.arg1).to.equal(1);
        expect(event.arg2).to.equal(2);
        expect(event.arg3).to.equal(3);
        return expect(event.arg4).to.equal(4);
      });
    });
    return describe('quit', function() {
      return it('should push the quit event onto the queue', function() {
        var event, eventQueue;
        eventQueue = new Love.EventQueue();
        eventQueue.quit();
        event = eventQueue.internalQueue[0];
        return expect(event.eventType).to.equal("quit");
      });
    });
  });

}).call(this);

(function() {
  describe("love.filesystem", function() {
    return it('exists', function() {
      return expect(Love.FileSystem).to.be.a("function");
    });
  });

}).call(this);

(function() {
  describe("love.graphics", function() {
    it('exists', function() {
      return expect(Love.Graphics).to.be.a("function");
    });
    describe('constructor', function() {
      beforeEach(function() {
        return Love.element = null;
      });
      describe('when called without arguments', function() {
        return it('uses default values for width and height', function() {
          var graphics;
          graphics = new Love.Graphics();
          expect(graphics.getWidth()).to.equal(800);
          return expect(graphics.getHeight()).to.equal(600);
        });
      });
      describe('when called with arguments', function() {
        return it('uses those arguments for the width and height of the graphics context', function() {
          var graphics, height, width, _ref;
          _ref = [300, 400], width = _ref[0], height = _ref[1];
          graphics = new Love.Graphics(width, height);
          expect(graphics.getWidth()).to.equal(width);
          return expect(graphics.getHeight()).to.equal(height);
        });
      });
      it('creates a default canvas rendering context', function() {
        var graphics;
        graphics = new Love.Graphics();
        return expect(graphics.default_canvas).to.be.an.instanceOf(Love.Graphics.Canvas2D);
      });
      return it('sets the default background and foreground colors', function() {
        var graphics;
        graphics = new Love.Graphics();
        expect(graphics.getColor()).to.eql(new Love.Color(255, 255, 255).unpack());
        return expect(graphics.getBackgroundColor()).to.eql(new Love.Color(0, 0, 0).unpack());
      });
    });
    return describe('drawing methods', function() {
      var canvas, graphics;
      graphics = null;
      canvas = null;
      beforeEach(function() {
        graphics = new Love.Graphics();
        return canvas = graphics.canvas;
      });
      describe('arc', function() {
        return it('should call the current canvas\'s arc method', function() {
          var arc;
          arc = sinon.spy(canvas, 'arc');
          graphics.arc("fill", 0, 0, 20, 0, Math.PI);
          return expect(arc).to.have.been.called;
        });
      });
      describe('circle', function() {
        return it('should call the current canvas\'s circle method', function() {
          var circle;
          circle = sinon.spy(canvas, 'circle');
          graphics.circle("fill", 0, 0, 20);
          return expect(circle).to.have.been.called;
        });
      });
      describe('clear', function() {
        return it('should call the current canvas\'s clear method', function() {
          var clear;
          clear = sinon.spy(canvas, 'clear');
          graphics.clear();
          return expect(clear).to.have.been.called;
        });
      });
      describe('draw', function() {
        return it('should call the current canvas\'s draw method', function() {
          var draw;
          draw = sinon.spy(canvas, 'draw');
          graphics.draw(new Love.Graphics.Image("sprites.png"), 100, 100);
          return expect(draw).to.have.been.called;
        });
      });
      describe('line', function() {
        return it('should call the current canvas\'s line method', function() {
          var line;
          line = sinon.spy(canvas, 'line');
          graphics.line(0, 0, 100, 100, 100, 0);
          return expect(line).to.have.been.called;
        });
      });
      describe('point', function() {
        return it('should call the current canvas\'s point method', function() {
          var point;
          point = sinon.spy(canvas, 'point');
          graphics.point(100, 100);
          return expect(point).to.have.been.called;
        });
      });
      describe('polygon', function() {
        return it('should call the current canvas\'s polygon method', function() {
          var polygon;
          polygon = sinon.spy(canvas, 'polygon');
          graphics.polygon("fill", 0, 0, 100, 100, 100, 0);
          return expect(polygon).to.have.been.called;
        });
      });
      describe('print', function() {
        return it('should call the current canvas\'s print method', function() {
          var print;
          print = sinon.spy(canvas, 'print');
          graphics.print("test", 100, 100);
          return expect(print).to.have.been.called;
        });
      });
      describe('printf', function() {
        return it('should call the current canvas\'s printf method', function() {
          var printf;
          printf = sinon.spy(canvas, 'printf');
          graphics.printf("test", 100, 100, 200);
          return expect(printf).to.have.been.called;
        });
      });
      return describe('rectangle', function() {
        return it('should call the current canvas\'s rectangle method', function() {
          var rectangle;
          rectangle = sinon.spy(canvas, 'rectangle');
          graphics.rectangle("test", 100, 100, 25, 50);
          return expect(rectangle).to.have.been.called;
        });
      });
    });
  });

}).call(this);

(function() {
  describe("love.image", function() {
    return it('exists', function() {
      return expect(Love.ImageModule).to.be.a("function");
    });
  });

}).call(this);

(function() {
  describe("love.keyboard", function() {
    var dispatchKeyboardEvent;
    dispatchKeyboardEvent = function(eventType, key) {
      var evt;
      evt = document.createEvent("Events");
      evt.initEvent(eventType, true, true);
      evt.keyCode = key.charCodeAt(0);
      evt.which = key.charCodeAt(0);
      evt.shiftKey = true;
      return Love.element.dispatchEvent(evt);
    };
    it('exists', function() {
      return expect(Love.Keyboard).to.be.a("function");
    });
    it('pushes a "keypressed" event onto the queue when a key is pressed', function() {
      var evt, key, love;
      love = new Love();
      key = "E";
      dispatchKeyboardEvent("keydown", key);
      evt = love.event.internalQueue[0];
      expect(evt).to.be.ok;
      expect(evt.eventType).to.equal("keypressed");
      expect(evt.arg1).to.equal(key);
      return expect(evt.arg2).to.equal(key.charCodeAt(0));
    });
    it('pushes a "keyreleased" event onto the queue when a key is pressed', function() {
      var evt, key, love;
      love = new Love();
      key = "E";
      dispatchKeyboardEvent("keyup", key);
      evt = love.event.internalQueue[0];
      expect(evt).to.be.ok;
      expect(evt.eventType).to.equal("keyreleased");
      expect(evt.arg1).to.equal(key);
      return expect(evt.arg2).to.equal(key.charCodeAt(0));
    });
    return describe('.isDown', function() {
      var love;
      love = null;
      beforeEach(function() {
        love = new Love();
        return dispatchKeyboardEvent("keydown", "E");
      });
      it('should return true if the key passed it is down', function() {
        return expect(love.keyboard.isDown("E")).to.be["true"];
      });
      it('should return false if the key passed it is not down', function() {
        return expect(love.keyboard.isDown("h")).to.be["false"];
      });
      return it('should return false if any of the keys passed to it are not down', function() {
        expect(love.keyboard.isDown("E", "h")).to.be["false"];
        expect(love.keyboard.isDown("h", "E")).to.be["false"];
        return expect(love.keyboard.isDown("h", "E", "q")).to.be["false"];
      });
    });
  });

}).call(this);

(function() {
  describe("love", function() {
    it('exists', function() {
      return expect(Love).to.be.a("function");
    });
    describe('constructor', function() {
      describe('when invoked without parameters', function() {
        return it('should provide sensible defaults', function() {
          var love;
          love = new Love();
          expect(love.graphics).to.be.ok;
          expect(love.window).to.be.ok;
          expect(love.timer).to.be.ok;
          expect(love.event).to.be.ok;
          expect(love.keyboard).to.be.ok;
          expect(love.mouse).to.be.ok;
          expect(love.touch).to.be.ok;
          expect(love.filesystem).to.be.ok;
          expect(love.audio).to.be.ok;
          expect(love.system).to.be.ok;
          expect(love.image).to.be.ok;
          expect(love.math).to.be.ok;
          expect(love.graphics.getWidth()).to.equal(800);
          expect(love.graphics.getHeight()).to.equal(600);
          expect(love.load).to.be.a("function");
          expect(love.update).to.be.a("function");
          expect(love.mousepressed).to.be.a("function");
          expect(love.mousereleased).to.be.a("function");
          expect(love.touchpressed).to.be.a("function");
          expect(love.touchreleased).to.be.a("function");
          expect(love.touchmoved).to.be.a("function");
          expect(love.keypressed).to.be.a("function");
          expect(love.keyreleased).to.be.a("function");
          expect(love.draw).to.be.a("function");
          return expect(love.quit).to.be.a("function");
        });
      });
      return describe('when invoked with parameters', function() {
        it('uses the element specified', function() {
          var canvas, love;
          canvas = document.createElement('canvas');
          love = new Love(canvas);
          return expect(Love.element).to.equal(canvas);
        });
        it('reads the width and height from element', function() {
          var canvas, love;
          canvas = document.createElement('canvas');
          canvas.setAttribute('width', 320);
          canvas.setAttribute('height', 200);
          love = new Love(canvas);
          expect(love.graphics.getWidth()).to.equal(320);
          return expect(love.graphics.getHeight()).to.equal(200);
        });
        return it('uses the specified dimensions', function() {
          var love;
          love = new Love(null, {
            width: 900,
            height: 300
          });
          expect(love.graphics.getWidth()).to.equal(900);
          return expect(love.graphics.getHeight()).to.equal(300);
        });
      });
    });
    return describe('.run', function() {
      return it('invokes the expected functions', function() {
        var clear, counter, draw, load, love, nextFrame, update;
        this.clock = sinon.useFakeTimers(0, "setTimeout", "clearTimeout", "Date");
        love = new Love();
        load = sinon.spy(love, 'load');
        update = sinon.spy(love, 'update');
        clear = sinon.spy(love.graphics, 'clear');
        draw = sinon.spy(love, 'draw');
        counter = 0;
        nextFrame = sinon.stub(love.timer, 'nextFrame', function(f) {
          if (counter !== 0) {
            return;
          }
          counter += 1;
          return f(0);
        });
        love.run();
        expect(load).to.have.been.called;
        expect(update).to.have.been.called;
        expect(clear).to.have.been.called;
        expect(draw).to.have.been.called;
        expect(nextFrame).to.have.been.called;
        return this.clock.restore();
      });
    });
  });

}).call(this);

(function() {
  describe('love.math', function() {
    var math;
    it('exists', function() {
      return expect(Love.Math).to.be.a("function");
    });
    math = null;
    beforeEach(function() {
      return math = new Love.Math();
    });
    describe('.noise', function() {
      var noise;
      noise = null;
      beforeEach(function() {
        return noise = math.noise;
      });
      describe('when called with one argument', function() {
        it('should return the same value for the same input', function() {
          return expect(noise(0.1)).to.equal(noise(0.1));
        });
        it('should return a different value for a different input', function() {
          return expect(noise(0.1)).to.not.equal(noise(0.2));
        });
        it('should return values between -1 and 1', function() {
          var x, _i, _results;
          _results = [];
          for (x = _i = 0; _i <= 10; x = ++_i) {
            _results.push(expect(noise(x)).to.be.within(-1, 1));
          }
          return _results;
        });
        it('should return similar values for similar inputs', function() {
          return expect(Math.abs(noise(0.1) - noise(0.101))).to.be.below(0.1).and.above(0);
        });
        return it('should invoke the correct function in the underlying library', function() {
          var noise1D;
          noise1D = sinon.spy(math.simplex, "noise1D");
          noise(0.1);
          return expect(noise1D).to.have.been.called;
        });
      });
      describe('when called with two arguments', function() {
        it('should return the same value for the same input', function() {
          return expect(noise(0.1, 0.2)).to.equal(noise(0.1, 0.2));
        });
        it('should return a different value for a different input', function() {
          return expect(noise(0.1, 0.1)).to.not.equal(noise(0.2, 0.2));
        });
        it('should return values between -1 and 1', function() {
          var x, y, _i, _results;
          _results = [];
          for (x = _i = 0; _i <= 10; x = ++_i) {
            _results.push((function() {
              var _j, _results1;
              _results1 = [];
              for (y = _j = 0; _j <= 10; y = ++_j) {
                _results1.push(expect(noise(x, y)).to.be.within(-1, 1));
              }
              return _results1;
            })());
          }
          return _results;
        });
        it('should return similar values for similar inputs', function() {
          return expect(Math.abs(noise(0.1, 0.2) - noise(0.101, 0.201))).to.be.below(0.1).and.above(0);
        });
        return it('should invoke the correct function in the underlying library', function() {
          var noise2D;
          noise2D = sinon.spy(math.simplex, "noise2D");
          noise(0.1, 0.2);
          return expect(noise2D).to.have.been.called;
        });
      });
      describe('when called with three arguments', function() {
        it('should return the same value for the same input', function() {
          return expect(noise(0.1, 0.2, 0.3)).to.equal(noise(0.1, 0.2, 0.3));
        });
        it('should return a different value for a different input', function() {
          return expect(noise(0.1, 0.1, 0.1)).to.not.equal(noise(0.2, 0.2, 0.2));
        });
        it('should return values between -1 and 1', function() {
          var i, j, _i, _results;
          _results = [];
          for (i = _i = 0; _i <= 10; i = ++_i) {
            _results.push((function() {
              var _j, _results1;
              _results1 = [];
              for (j = _j = 0; _j <= 10; j = ++_j) {
                _results1.push(expect(noise(i / 5, j / 5, i + j)).to.be.within(-1, 1));
              }
              return _results1;
            })());
          }
          return _results;
        });
        it('should return similar values for similar inputs', function() {
          return expect(Math.abs(noise(0.1, 0.2, 0.3) - noise(0.101, 0.201, 0.301))).to.be.below(0.1).and.above(0);
        });
        return it('should invoke the correct function in the underlying library', function() {
          var noise3D;
          noise3D = sinon.spy(math.simplex, "noise3D");
          noise(0.1, 0.2, 0.3);
          return expect(noise3D).to.have.been.called;
        });
      });
      return describe('when called with four arguments', function() {
        it('should return the same value for the same input', function() {
          return expect(noise(0.1, 0.2, 0.3, 0.4)).to.equal(noise(0.1, 0.2, 0.3, 0.4));
        });
        it('should return a different value for a different input', function() {
          return expect(noise(0.1, 0.1, 0.1, 0.1)).to.not.equal(noise(0.2, 0.2, 0.2, 0.2));
        });
        it('should return values between -1 and 1', function() {
          var i, j, _i, _results;
          _results = [];
          for (i = _i = 0; _i <= 10; i = ++_i) {
            _results.push((function() {
              var _j, _results1;
              _results1 = [];
              for (j = _j = 0; _j <= 10; j = ++_j) {
                _results1.push(expect(noise(i / 5, j / 5, i + j, i - j)).to.be.within(-1, 1));
              }
              return _results1;
            })());
          }
          return _results;
        });
        it('should return similar values for similar inputs', function() {
          return expect(Math.abs(noise(0.1, 0.2, 0.3, 0.4) - noise(0.101, 0.201, 0.301, 0.401))).to.be.below(0.1).and.above(0);
        });
        return it('should invoke the correct function in the underlying library', function() {
          var noise4D;
          noise4D = sinon.spy(math.simplex, "noise4D");
          noise(0.1, 0.2, 0.3, 0.4);
          return expect(noise4D).to.have.been.called;
        });
      });
    });
    describe('.random', function() {
      var random;
      random = null;
      beforeEach(function() {
        return random = math.random;
      });
      describe('when called with no arguments', function() {
        return it('should return a value between 0 and 1', function() {
          return expect(random()).to.be.within(0, 1);
        });
      });
      describe('when called with one argument', function() {
        return it('should return a value between 1 and the argument, inclusively', function() {
          return expect(random(10)).to.be.within(1, 10 + 1);
        });
      });
      return describe('when called with two arguments', function() {
        return it('should return a value between the two arguments, inclusively', function() {
          return expect(random(5, 10)).to.be.within(5, 10 + 1);
        });
      });
    });
    describe('.setRandomSeed', function() {
      var random;
      random = null;
      beforeEach(function() {
        return random = math.random;
      });
      it('should result in the same random numbers when passed the same args', function() {
        var i, result_set_a, result_set_b, seed_high, seed_low, _ref;
        _ref = [100, 200], seed_low = _ref[0], seed_high = _ref[1];
        math.setRandomSeed(seed_low, seed_high);
        result_set_a = (function() {
          var _i, _results;
          _results = [];
          for (i = _i = 1; _i <= 5; i = ++_i) {
            _results.push(random());
          }
          return _results;
        })();
        math.setRandomSeed(seed_low, seed_high);
        result_set_b = (function() {
          var _i, _results;
          _results = [];
          for (i = _i = 1; _i <= 5; i = ++_i) {
            _results.push(random());
          }
          return _results;
        })();
        return expect(result_set_a).to.eql(result_set_b);
      });
      return it('should accept a single argument', function() {
        var high, low, _ref;
        math.setRandomSeed(100);
        _ref = math.getRandomSeed(), low = _ref[0], high = _ref[1];
        expect(low).to.equal(100);
        return expect(high).to.equal(0);
      });
    });
    describe('.getRandomSeed', function() {
      var random;
      random = null;
      beforeEach(function() {
        return random = math.random;
      });
      return it('should return the same numbers passed to setRandomSeed', function() {
        var seed_high, seed_low, _ref;
        _ref = [100, 200], seed_low = _ref[0], seed_high = _ref[1];
        math.setRandomSeed(seed_low, seed_high);
        expect(math.getRandomSeed()).to.eql([seed_low, seed_high]);
        random();
        return expect(math.getRandomSeed()).to.eql([seed_low, seed_high]);
      });
    });
    describe('.gammaToLinear', function() {
      it('should be reversed by linearToGamma', function() {
        var gb, gg, gr, lb, lg, lr, rb, rg, rounding_error_margin, rr, _ref, _ref1, _ref2;
        rounding_error_margin = 0.1;
        _ref = [120, 50, 100], gr = _ref[0], gg = _ref[1], gb = _ref[2];
        _ref1 = math.gammaToLinear(gr, gg, gb), lr = _ref1[0], lg = _ref1[1], lb = _ref1[2];
        _ref2 = math.linearToGamma(lr, lg, lb), rr = _ref2[0], rg = _ref2[1], rb = _ref2[2];
        expect(rr).to.be.closeTo(gr, rounding_error_margin);
        expect(rg).to.be.closeTo(gg, rounding_error_margin);
        return expect(rb).to.be.closeTo(gb, rounding_error_margin);
      });
      describe('when called with three separate color components', function() {
        return it('should return three linear-space color components', function() {
          var gb, gg, gr, lb, lg, lr, _ref, _ref1;
          _ref = [120, 50, 100], gr = _ref[0], gg = _ref[1], gb = _ref[2];
          _ref1 = math.gammaToLinear(gr, gg, gb), lr = _ref1[0], lg = _ref1[1], lb = _ref1[2];
          expect(lr).to.be.ok;
          expect(lg).to.be.ok;
          return expect(lb).to.be.ok;
        });
      });
      describe('when called with a sequence of color components', function() {
        return it('should return three linear-space color components', function() {
          var gb, gg, gr, lb, lg, lr, _ref, _ref1;
          _ref = [120, 50, 100], gr = _ref[0], gg = _ref[1], gb = _ref[2];
          _ref1 = math.gammaToLinear(gr, gg, gb), lr = _ref1[0], lg = _ref1[1], lb = _ref1[2];
          expect(lr).to.be.ok;
          expect(lg).to.be.ok;
          return expect(lb).to.be.ok;
        });
      });
      return describe('when called with one color component', function() {
        return it('should return three linear-space color components', function() {
          var gb, gg, gr, lb, lg, lr, _ref, _ref1;
          _ref = [120, 50, 100], gr = _ref[0], gg = _ref[1], gb = _ref[2];
          _ref1 = math.gammaToLinear(gr, gg, gb), lr = _ref1[0], lg = _ref1[1], lb = _ref1[2];
          expect(lr).to.be.ok;
          expect(lg).to.be.ok;
          return expect(lb).to.be.ok;
        });
      });
    });
    describe('.isConvex', function() {
      it('returns true for a convex polygon', function() {
        var vertices;
        vertices = [0, 0, 0, 100, 100, 100, 100, 0];
        return expect(math.isConvex(vertices)).to.be["true"];
      });
      return it('returns false for a non-convex polygon', function() {
        var vertices;
        vertices = [0, 0, 0, 100, -100, -100, 100, 0];
        return expect(math.isConvex(vertices)).to.be["false"];
      });
    });
    describe('.linearToGamma', function() {
      it('should be reversed by gammaToLinear', function() {
        var gb, gg, gr, lb, lg, lr, rb, rg, rounding_error_margin, rr, _ref, _ref1, _ref2;
        rounding_error_margin = 0.1;
        _ref = [120, 50, 100], lr = _ref[0], lg = _ref[1], lb = _ref[2];
        _ref1 = math.linearToGamma(lr, lg, lb), gr = _ref1[0], gg = _ref1[1], gb = _ref1[2];
        _ref2 = math.gammaToLinear(gr, gg, gb), rr = _ref2[0], rg = _ref2[1], rb = _ref2[2];
        expect(rr).to.be.closeTo(lr, rounding_error_margin);
        expect(rg).to.be.closeTo(lg, rounding_error_margin);
        return expect(rb).to.be.closeTo(lb, rounding_error_margin);
      });
      describe('when called with three separate color components', function() {
        return it('should return three gamma-space color components', function() {
          var gb, gg, gr, lb, lg, lr, _ref, _ref1;
          _ref = [120, 50, 100], lr = _ref[0], lg = _ref[1], lb = _ref[2];
          _ref1 = math.linearToGamma(lr, lg, lb), gr = _ref1[0], gg = _ref1[1], gb = _ref1[2];
          expect(gr).to.be.ok;
          expect(gg).to.be.ok;
          return expect(gb).to.be.ok;
        });
      });
      describe('when called with a sequence of color components', function() {
        return it('should return three gamma-space color components', function() {
          var gb, gg, gr, linear_colors, _ref;
          linear_colors = [120, 50, 100];
          _ref = math.linearToGamma(linear_colors), gr = _ref[0], gg = _ref[1], gb = _ref[2];
          expect(gr).to.be.ok;
          expect(gg).to.be.ok;
          return expect(gb).to.be.ok;
        });
      });
      return describe('when called with one color component', function() {
        return it('should return one gamma-space color component', function() {
          var gb, gg, gr, linear_color, _ref;
          linear_color = 120;
          _ref = math.linearToGamma(linear_color), gr = _ref[0], gg = _ref[1], gb = _ref[2];
          expect(gr).to.be.ok;
          expect(gg).to.be.undefined;
          return expect(gb).to.be.undefined;
        });
      });
    });
    describe('.newBezierCurve', function() {
      return it('should return a new bezier curve comprised of the vertices that were passed', function() {
        var bezier, controls_points, i, x, y, _i, _ref, _results;
        controls_points = [100, 100, 125, 125, 100, 125];
        bezier = math.newBezierCurve(controls_points);
        _results = [];
        for (i = _i = 0; _i < 3; i = ++_i) {
          _ref = bezier.getControlPoint(bezier, i), x = _ref[0], y = _ref[1];
          expect(x).to.equal(controls_points[i * 2]);
          _results.push(expect(y).to.equal(controls_points[i * 2 + 1]));
        }
        return _results;
      });
    });
    describe('.newRandomGenerator', function() {
      it('should return a new RandomGenerator object', function() {
        return expect(math.newRandomGenerator()).to.be.an["instanceof"](Love.Math.RandomGenerator);
      });
      return it('should use the seed passed to it', function() {
        var high, high_s, low, low_s, r, _ref, _ref1;
        _ref = [100, 200], low_s = _ref[0], high_s = _ref[1];
        r = math.newRandomGenerator(low_s, high_s);
        _ref1 = r.getSeed(r), low = _ref1[0], high = _ref1[1];
        expect(low_s).to.equal(low);
        return expect(high_s).to.equal(high);
      });
    });
    describe('.randomNormal', function() {
      return it('');
    });
    return describe('.triangulate', function() {
      it('should return two triangles when you pass it a rectangular polygon', function() {
        var triangles, vertices;
        vertices = [0, 0, 0, 100, 100, 100, 100, 0];
        triangles = math.triangulate(vertices);
        return expect(triangles.length).to.equal(2);
      });
      it('should handle concave polygons', function() {
        var triangles, vertices;
        vertices = [0, 0, 0, 100, -100, -100, 100, 0];
        triangles = math.triangulate(vertices);
        return expect(triangles.length).to.equal(2);
      });
      return it('should handle clockwise vertices', function() {
        var triangles, vertices;
        vertices = [0, 0, 100, 0, 100, 100, 0, 100];
        triangles = math.triangulate(vertices);
        return expect(triangles.length).to.equal(2);
      });
    });
  });

}).call(this);

(function() {
  describe("love.mouse", function() {
    return it('exists', function() {
      return expect(Love.Mouse).to.be.a("function");
    });
  });

}).call(this);

(function() {
  describe("love.system", function() {
    return it('exists', function() {
      return expect(Love.System).to.be.a("function");
    });
  });

}).call(this);

(function() {
  describe("love.timer", function() {
    return it('exists', function() {
      return expect(Love.Timer).to.be.a("function");
    });
  });

}).call(this);

(function() {
  describe("love.touch", function() {
    return it('exists', function() {
      return expect(Love.Touch).to.be.a("function");
    });
  });

}).call(this);

(function() {
  describe("love.window", function() {
    return it('exists', function() {
      return expect(Love.Window).to.be.a("function");
    });
  });

}).call(this);

(function() {
  describe("love.audio.source", function() {
    return it('exists', function() {
      return expect(Love.Audio.Source).to.be.a("function");
    });
  });

}).call(this);

(function() {
  describe("love.filesystem.file_data", function() {
    return it('exists', function() {
      return expect(Love.FileSystem.FileData).to.be.a("function");
    });
  });

}).call(this);

(function() {
  describe("love.graphics.canvas_2d", function() {
    it('exists', function() {
      return expect(Love.Graphics.Canvas2D).to.be.a("function");
    });
    describe('constructor', function() {
      return it('sets the dimensions passed to it', function() {
        var canvas, height, width, _ref;
        _ref = [300, 400], width = _ref[0], height = _ref[1];
        canvas = new Love.Graphics.Canvas2D(width, height);
        expect(canvas.getWidth()).to.equal(width);
        return expect(canvas.getHeight()).to.equal(height);
      });
    });
    return describe('drawing methods', function() {
      var canvas;
      canvas = null;
      beforeEach(function() {
        return canvas = new Love.Graphics.Canvas2D(400, 300);
      });
      describe('arc', function() {
        var beginPath, closePath, fill, lineTo, moveTo, radius, stroke, _ref;
        _ref = [], radius = _ref[0], beginPath = _ref[1], moveTo = _ref[2], lineTo = _ref[3], closePath = _ref[4], fill = _ref[5], stroke = _ref[6];
        beforeEach(function() {
          radius = 20;
          beginPath = sinon.spy(canvas.context, 'beginPath');
          moveTo = sinon.spy(canvas.context, 'moveTo');
          lineTo = sinon.spy(canvas.context, 'lineTo');
          closePath = sinon.spy(canvas.context, 'closePath');
          fill = sinon.spy(canvas.context, 'fill');
          return stroke = sinon.spy(canvas.context, 'stroke');
        });
        describe('when called with a "fill" draw mode', function() {
          return it('should call the appropriate 2D context functions', function() {
            canvas.arc("fill", 0, 0, radius, 0, Math.PI);
            expect(beginPath).to.be.calledOnce;
            expect(moveTo).to.be.calledOnce;
            expect(lineTo).to.be.callCount(radius + 1);
            expect(closePath).to.be.calledOnce;
            return expect(fill).to.be.calledOnce;
          });
        });
        return describe('when called with a "stroke" draw mode', function() {
          return it('should call the appropriate 2D context functions', function() {
            canvas.arc("line", 0, 0, radius, 0, Math.PI);
            expect(beginPath).to.be.calledOnce;
            expect(moveTo).to.be.calledOnce;
            expect(lineTo).to.be.callCount(radius + 1);
            expect(closePath).to.be.calledOnce;
            return expect(stroke).to.be.calledOnce;
          });
        });
      });
      describe('circle', function() {
        return it('');
      });
      describe('clear', function() {
        return it('');
      });
      describe('draw', function() {
        it('calls drawDrawable if you do not pass it a quad', function() {
          var drawDrawable, image;
          image = new Love.Graphics.Image("sprites.png");
          drawDrawable = sinon.spy(canvas, 'drawDrawable');
          canvas.draw(image, 100, 100);
          return expect(drawDrawable).to.be.calledOnce;
        });
        describe('drawDrawable', function() {
          var drawImage, restore, rotate, save, scale, transform, translate, _ref;
          _ref = [], save = _ref[0], translate = _ref[1], rotate = _ref[2], scale = _ref[3], transform = _ref[4], drawImage = _ref[5], restore = _ref[6];
          beforeEach(function() {
            save = sinon.spy(canvas.context, 'save');
            translate = sinon.spy(canvas.context, 'translate');
            rotate = sinon.spy(canvas.context, 'rotate');
            scale = sinon.spy(canvas.context, 'scale');
            transform = sinon.spy(canvas.context, 'transform');
            drawImage = sinon.spy(canvas.context, 'drawImage');
            return restore = sinon.spy(canvas.context, 'restore');
          });
          return it('should call the appropriate 2D context functions', function() {
            var image, kx, ky, ox, oy, r, sx, sy, x, y, _ref1;
            image = new Love.Graphics.Image("sprites.png");
            _ref1 = [100, 100, Math.PI, 2, 5, 50, 50, 3, 4], x = _ref1[0], y = _ref1[1], r = _ref1[2], sx = _ref1[3], sy = _ref1[4], ox = _ref1[5], oy = _ref1[6], kx = _ref1[7], ky = _ref1[8];
            canvas.draw(image, x, y, r, sx, sy, ox, oy, kx, y);
            expect(drawImage).to.be.calledWith(image.element, 0, 0);
            expect(save).to.be.called;
            expect(restore).to.be.called;
            expect(translate).to.be.calledWith(x, y);
            expect(translate).to.be.calledWith(-ox, -oy);
            expect(rotate).to.be.calledWith(r);
            return expect(scale).to.be.calledWith(sx, sy);
          });
        });
        it('calls drawWithQuad if you pass it a quad', function() {
          var drawWithQuad, image, quad;
          image = new Love.Graphics.Image("sprites.png");
          quad = new Love.Graphics.Quad(3, 3, 1, 1);
          drawWithQuad = sinon.spy(canvas, 'drawWithQuad');
          canvas.draw(image, quad, 100, 100);
          return expect(drawWithQuad).to.be.calledOnce;
        });
        return describe('drawWithQuad', function() {
          var drawImage, restore, rotate, save, scale, transform, translate, _ref;
          _ref = [], save = _ref[0], translate = _ref[1], rotate = _ref[2], scale = _ref[3], transform = _ref[4], drawImage = _ref[5], restore = _ref[6];
          beforeEach(function() {
            save = sinon.spy(canvas.context, 'save');
            translate = sinon.spy(canvas.context, 'translate');
            rotate = sinon.spy(canvas.context, 'rotate');
            scale = sinon.spy(canvas.context, 'scale');
            transform = sinon.spy(canvas.context, 'transform');
            drawImage = sinon.spy(canvas.context, 'drawImage');
            return restore = sinon.spy(canvas.context, 'restore');
          });
          return it('should call the appropriate 2D context functions', function() {
            var image, kx, ky, ox, oy, quad, r, sx, sy, x, y, _ref1;
            image = new Love.Graphics.Image("sprites.png");
            quad = new Love.Graphics.Quad(3, 3, 1, 1);
            _ref1 = [100, 100, Math.PI, 2, 5, 50, 50, 3, 4], x = _ref1[0], y = _ref1[1], r = _ref1[2], sx = _ref1[3], sy = _ref1[4], ox = _ref1[5], oy = _ref1[6], kx = _ref1[7], ky = _ref1[8];
            canvas.draw(image, quad, x, y, r, sx, sy, ox, oy, kx, y);
            expect(drawImage).to.be.calledWith(image.element, quad.x, quad.y, quad.width, quad.height, 0, 0, quad.width, quad.height);
            expect(save).to.be.called;
            expect(restore).to.be.called;
            expect(translate).to.be.calledWith(x, y);
            expect(translate).to.be.calledWith(-ox, -oy);
            expect(rotate).to.be.calledWith(r);
            return expect(scale).to.be.calledWith(sx, sy);
          });
        });
      });
      describe('line', function() {
        return it('');
      });
      describe('point', function() {
        return it('');
      });
      describe('polygon', function() {
        return it('');
      });
      describe('print', function() {
        return it('');
      });
      describe('printf', function() {
        return it('');
      });
      return describe('rectangle', function() {
        return it('');
      });
    });
  });

}).call(this);

(function() {
  describe("love.graphics.font", function() {
    return it('exists', function() {
      return expect(Love.Graphics.Font).to.be.a("function");
    });
  });

}).call(this);

(function() {
  describe("love.graphics.image", function() {
    return it('exists', function() {
      return expect(Love.Graphics.Image).to.be.a("function");
    });
  });

}).call(this);

(function() {
  describe("love.graphics.quad", function() {
    return it('exists', function() {
      return expect(Love.Graphics.Quad).to.be.a("function");
    });
  });

}).call(this);

(function() {
  describe("love.image.image_data", function() {
    return it('exists', function() {
      return expect(Love.ImageModule.ImageData).to.be.a("function");
    });
  });

}).call(this);

(function() {
  describe("love.math.bezier_curve", function() {
    var bezier, controls_points, _ref;
    it('exists', function() {
      return expect(Love.Math.BezierCurve).to.be.a("function");
    });
    _ref = [], controls_points = _ref[0], bezier = _ref[1];
    beforeEach(function() {
      controls_points = [
        {
          x: 100,
          y: 100
        }, {
          x: 125,
          y: 125
        }, {
          x: 100,
          y: 125
        }
      ];
      return bezier = new Love.Math.BezierCurve(controls_points);
    });
    describe('constructor', function() {
      return it('should return a BezierCurve object with the control points that were passed to it', function() {
        var i, x, y, _i, _ref1, _results;
        expect(bezier).to.be.an["instanceof"](Love.Math.BezierCurve);
        _results = [];
        for (i = _i = 0; _i < 3; i = ++_i) {
          _ref1 = bezier.getControlPoint(bezier, i), x = _ref1[0], y = _ref1[1];
          expect(x).to.equal(controls_points[i].x);
          _results.push(expect(y).to.equal(controls_points[i].y));
        }
        return _results;
      });
    });
    describe('evaluate', function() {
      it('should return the first control point when passed 0', function() {
        var first_point, x, y, _ref1;
        _ref1 = bezier.evaluate(bezier, 0), x = _ref1[0], y = _ref1[1];
        first_point = controls_points[0];
        expect(x).to.equal(first_point.x);
        return expect(y).to.equal(first_point.y);
      });
      return it('should return the last control point when passed 1', function() {
        var last_point, x, y, _ref1;
        _ref1 = bezier.evaluate(bezier, 1), x = _ref1[0], y = _ref1[1];
        last_point = controls_points[controls_points.length - 1];
        expect(x).to.equal(last_point.x);
        return expect(y).to.equal(last_point.y);
      });
    });
    describe('getControlPoint', function() {
      it('should return the x and y components of the requested control point', function() {
        var i, x, y, _i, _ref1, _ref2, _results;
        _results = [];
        for (i = _i = 0, _ref1 = bezier.getControlPointCount(bezier); 0 <= _ref1 ? _i < _ref1 : _i > _ref1; i = 0 <= _ref1 ? ++_i : --_i) {
          _ref2 = bezier.getControlPoint(bezier, i), x = _ref2[0], y = _ref2[1];
          expect(x).to.equal(controls_points[i].x);
          _results.push(expect(y).to.equal(controls_points[i].y));
        }
        return _results;
      });
      return it('should throw an exception if the control point is out of range', function() {
        var fn;
        fn = bezier.getControlPoint.bind(bezier, bezier, 100);
        expect(fn).to["throw"](Love.Exception);
        fn = bezier.getControlPoint.bind(bezier, bezier, -100);
        return expect(fn).to["throw"](Love.Exception);
      });
    });
    describe('getControlPointCount', function() {
      return it('should return the number of control points passed to it', function() {
        return expect(bezier.getControlPointCount(bezier)).to.equal(controls_points.length);
      });
    });
    describe('getDegree', function() {
      return it('should return the number of control points passed to it less one', function() {
        return expect(bezier.getDegree(bezier)).to.equal(controls_points.length - 1);
      });
    });
    describe('getDerivative', function() {
      return it('should return a new BezierCurve', function() {
        var derivative;
        derivative = bezier.getDerivative(bezier);
        return expect(derivative).to.be.an["instanceof"](Love.Math.BezierCurve);
      });
    });
    describe('insertControlPoint', function() {
      return it('should increase the number of control points by one', function() {
        var count, index, newx, newy, x, y, _ref1, _ref2;
        count = controls_points.length;
        _ref1 = [5, 6], newx = _ref1[0], newy = _ref1[1];
        index = 1;
        expect(bezier.getControlPointCount(bezier)).to.equal(controls_points.length);
        bezier.insertControlPoint(bezier, newx, newy, index);
        expect(bezier.getControlPointCount(bezier)).to.equal(count + 1);
        _ref2 = bezier.getControlPoint(bezier, index), x = _ref2[0], y = _ref2[1];
        expect(x).to.equal(newx);
        return expect(y).to.equal(newy);
      });
    });
    describe('render', function() {
      it('should return a sequence of vertices starting and stopping at the first and last control point', function() {
        var render_points;
        render_points = bezier.render(bezier, 1);
        expect(render_points[0]).to.equal(controls_points[0].x);
        expect(render_points[1]).to.equal(controls_points[0].y);
        expect(render_points[render_points.length - 2]).to.equal(controls_points[controls_points.length - 1].x);
        return expect(render_points[render_points.length - 1]).to.equal(controls_points[controls_points.length - 1].y);
      });
      return it('should return more points when passed a greater depth', function() {
        var fewer_points, more_points;
        fewer_points = bezier.render(bezier, 1);
        more_points = bezier.render(bezier, 5);
        return expect(fewer_points.length).to.be.lessThan(more_points.length);
      });
    });
    describe('rotate', function() {
      return it('');
    });
    describe('scale', function() {
      return it('');
    });
    describe('setControlPoint', function() {
      return it('should replace the specified control point with a new one', function() {
        var count, index, newx, newy, oldx, oldy, x, y, _ref1, _ref2, _ref3;
        count = controls_points.length;
        _ref1 = [5, 6], newx = _ref1[0], newy = _ref1[1];
        index = 1;
        _ref2 = bezier.getControlPoint(bezier, index), oldx = _ref2[0], oldy = _ref2[1];
        bezier.setControlPoint(bezier, index, newx, newy);
        expect(bezier.getControlPointCount(bezier)).to.equal(count);
        _ref3 = bezier.getControlPoint(bezier, index), x = _ref3[0], y = _ref3[1];
        expect(x).to.equal(newx);
        return expect(y).to.equal(newy);
      });
    });
    return describe('translate', function() {
      return it('should alter the results of .evaluate by the offsets provided', function() {
        var newx, newy, oldx, oldy, ox, oy, t, _ref1, _ref2, _ref3;
        t = 0.5;
        _ref1 = [100, 200], ox = _ref1[0], oy = _ref1[1];
        _ref2 = bezier.evaluate(bezier, t), oldx = _ref2[0], oldy = _ref2[1];
        bezier.translate(bezier, ox, oy);
        _ref3 = bezier.evaluate(bezier, t), newx = _ref3[0], newy = _ref3[1];
        expect(newx).to.equal(oldx + ox);
        return expect(newy).to.equal(oldy + oy);
      });
    });
  });

}).call(this);

(function() {
  describe("love.math.random_generator", function() {
    it('exists', function() {
      return expect(Love.Math.RandomGenerator).to.be.a("function");
    });
    describe('constructor', function() {
      return it('');
    });
    describe('rand', function() {
      return it('');
    });
    describe('random', function() {
      return it('');
    });
    describe('randomNormal', function() {
      return it('');
    });
    describe('setSeed', function() {
      return it('');
    });
    describe('getSeed', function() {
      return it('');
    });
    describe('getState', function() {
      return it('');
    });
    return describe('setState', function() {
      return it('');
    });
  });

}).call(this);
