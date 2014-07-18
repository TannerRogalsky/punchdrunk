describe "love.math.bezier_curve", ->
  it 'exists', ->
    expect(Love.Math.BezierCurve).to.be.a("function")

  [controls_points, bezier] = []
  beforeEach ->
    controls_points = [{
      x: 100,
      y: 100
    }, {
      x: 125,
      y: 125
    }, {
      x: 100,
      y: 125
    }]
    bezier = new Love.Math.BezierCurve(controls_points)

  describe 'constructor', ->
    it 'should return a BezierCurve object with the control points that were passed to it', ->
      expect(bezier).to.be.an.instanceof(Love.Math.BezierCurve)
      for i in [0...3]
        [x, y] = bezier.getControlPoint(bezier, i)
        expect(x).to.equal(controls_points[i].x)
        expect(y).to.equal(controls_points[i].y)

  describe 'evaluate', ->
    it 'should return the first control point when passed 0', ->
      [x, y] = bezier.evaluate(bezier, 0)
      first_point = controls_points[0]
      expect(x).to.equal(first_point.x)
      expect(y).to.equal(first_point.y)

    it 'should return the last control point when passed 1', ->
      [x, y] = bezier.evaluate(bezier, 1)
      last_point = controls_points[controls_points.length - 1]
      expect(x).to.equal(last_point.x)
      expect(y).to.equal(last_point.y)

  describe 'getControlPoint', ->
    it 'should return the x and y components of the requested control point', ->
      for i in [0...bezier.getControlPointCount(bezier)]
        [x, y] = bezier.getControlPoint(bezier, i)
        expect(x).to.equal(controls_points[i].x)
        expect(y).to.equal(controls_points[i].y)

    it 'should throw an exception if the control point is out of range', ->
      fn = bezier.getControlPoint.bind(bezier, bezier, 100)
      expect(fn).to.throw(Love.Exception)
      fn = bezier.getControlPoint.bind(bezier, bezier, -100)
      expect(fn).to.throw(Love.Exception)

  describe 'getControlPointCount', ->
    it 'should return the number of control points passed to it', ->
      expect(bezier.getControlPointCount(bezier)).to.equal(controls_points.length)

  describe 'getDegree', ->
    it 'should return the number of control points passed to it less one', ->
      expect(bezier.getDegree(bezier)).to.equal(controls_points.length - 1)

  describe 'getDerivative', ->
    it 'should return a new BezierCurve', ->
      derivative = bezier.getDerivative(bezier)
      expect(derivative).to.be.an.instanceof(Love.Math.BezierCurve)

  describe 'insertControlPoint', ->
    it 'should increase the number of control points by one', ->
      count = controls_points.length
      [newx, newy] = [5, 6]
      index = 1
      expect(bezier.getControlPointCount(bezier)).to.equal(controls_points.length)
      bezier.insertControlPoint(bezier, newx, newy, index)
      expect(bezier.getControlPointCount(bezier)).to.equal(count + 1)
      [x, y] = bezier.getControlPoint(bezier, index)
      expect(x).to.equal(newx)
      expect(y).to.equal(newy)

  describe 'render', ->
    it 'should return a sequence of vertices starting and stopping at the first and last control point', ->
      render_points = bezier.render(bezier, 1)
      expect(render_points[0]).to.equal(controls_points[0].x)
      expect(render_points[1]).to.equal(controls_points[0].y)
      expect(render_points[render_points.length - 2]).to.equal(controls_points[controls_points.length - 1].x)
      expect(render_points[render_points.length - 1]).to.equal(controls_points[controls_points.length - 1].y)

    it 'should return more points when passed a greater depth', ->
      fewer_points = bezier.render(bezier, 1)
      more_points = bezier.render(bezier, 5)
      expect(fewer_points.length).to.be.lessThan(more_points.length)

  describe 'rotate', ->
    it ''

  describe 'scale', ->
    it ''

  describe 'setControlPoint', ->
    it 'should replace the specified control point with a new one', ->
      count = controls_points.length
      [newx, newy] = [5, 6]
      index = 1
      [oldx, oldy] = bezier.getControlPoint(bezier, index)
      bezier.setControlPoint(bezier, index, newx, newy)
      expect(bezier.getControlPointCount(bezier)).to.equal(count)
      [x, y] = bezier.getControlPoint(bezier, index)
      expect(x).to.equal(newx)
      expect(y).to.equal(newy)

  describe 'translate', ->
    it 'should alter the results of .evaluate by the offsets provided', ->
      t = 0.5
      [ox, oy] = [100, 200]
      [oldx, oldy] = bezier.evaluate(bezier, t)
      bezier.translate(bezier, ox, oy)
      [newx, newy] = bezier.evaluate(bezier, t)
      expect(newx).to.equal(oldx + ox)
      expect(newy).to.equal(oldy + oy)
