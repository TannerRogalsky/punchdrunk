class Shader
  constructor: (gl, vertex_code, fragment_code) ->
    [vertex_code, fragment_code] = shaderCodeToGLSL(vertex_code, fragment_code)
    vertex_shader = @compileCode(gl, "vertex", vertex_code)
    fragment_shader = @compileCode(gl, "fragment", fragment_code)
    @program = @loadVolatile(gl, vertex_shader, fragment_shader)

    @uniforms = @mapActiveUniforms(gl)
    @context = gl

  shaderCodeToGLSL = (vertex_code, fragment_code) ->
    vertex_code ?= VERTEX.DEFAULT
    fragment_code ?= FRAGMENT.DEFAULT
    vertex_code = VERTEX.HEAD + vertex_code + VERTEX.FOOT
    fragment_code = FRAGMENT.HEAD + fragment_code + FRAGMENT.FOOT
    return [vertex_code, fragment_code]

  compileCode: (gl, type, source) ->
    switch type
      when "fragment" then shader = gl.createShader(gl.FRAGMENT_SHADER)
      when "vertex" then shader = gl.createShader(gl.VERTEX_SHADER)
      else return null
    gl.shaderSource(shader, source)
    gl.compileShader(shader)

    # See if it compiled successfully
    if not gl.getShaderParameter(shader, gl.COMPILE_STATUS)
        console.log ("An error occurred compiling the shaders: " + gl.getShaderInfoLog(shader))
        return null
    else
      return shader

  loadVolatile: (gl, vertex_shader, fragment_shader) ->
    program = gl.createProgram()
    gl.attachShader(program, vertex_shader)
    gl.attachShader(program, fragment_shader)
    gl.bindAttribLocation(program, 0, "VertexPosition")
    gl.bindAttribLocation(program, 1, "VertexTexCoord")
    gl.bindAttribLocation(program, 2, "VertexColor")
    gl.linkProgram(program)

    # Check the link status
    linked = gl.getProgramParameter(program, gl.LINK_STATUS)
    if not linked
        # something went wrong with the link
        lastError = gl.getProgramInfoLog (program)
        console.log("Error in program linking:" + lastError)

        gl.deleteProgram(program)
        return null
    return program

  mapActiveUniforms: (gl) ->
    uniforms = {count: 0}

    activeUniformCount = gl.getProgramParameter(@program, gl.ACTIVE_UNIFORMS)

    for i in [0...activeUniformCount]
      uniform = gl.getActiveUniform(@program, i)
      uniform.typeName = UNIFORM_TYPES[uniform.type]
      uniform.location = gl.getUniformLocation(@program, uniform.name)
      uniforms[uniform.name] = uniform
      uniforms.count += 1

    return uniforms

  send: (self, name, values...) ->
    switch typeof(values[0])
      when 'number' then self.sendFloat(name, values)
      when 'object' then self.sendMatrix(values)

  sendMatrix: (name, matrix) ->
    uniform = @uniforms[name]

    if not uniform
      return

    switch Math.sqrt(matrix.length)
      when 2 then @context.uniformMatrix2fv(uniform.location, false, new Float32Array(matrix))
      when 3 then @context.uniformMatrix3fv(uniform.location, false, new Float32Array(matrix))
      when 4 then @context.uniformMatrix4fv(uniform.location, false, new Float32Array(matrix))

  sendFloat: (name, floats...) ->
    uniform = @uniforms[name]

    if not uniform
      return

    switch floats.length
      when 1 then @context.uniform1fv(uniform.location, new Float32Array(floats))
      when 2 then @context.uniform2fv(uniform.location, new Float32Array(floats))
      when 3 then @context.uniform3fv(uniform.location, new Float32Array(floats))
      when 4 then @context.uniform4fv(uniform.location, new Float32Array(floats))



  # Taken from the WebGl spec:
  # http://www.khronos.org/registry/webgl/specs/latest/1.0/#5.14
  UNIFORM_TYPES =
    0x8B50: 'FLOAT_VEC2'
    0x8B51: 'FLOAT_VEC3'
    0x8B52: 'FLOAT_VEC4'
    0x8B53: 'INT_VEC2'
    0x8B54: 'INT_VEC3'
    0x8B55: 'INT_VEC4'
    0x8B56: 'BOOL'
    0x8B57: 'BOOL_VEC2'
    0x8B58: 'BOOL_VEC3'
    0x8B59: 'BOOL_VEC4'
    0x8B5A: 'FLOAT_MAT2'
    0x8B5B: 'FLOAT_MAT3'
    0x8B5C: 'FLOAT_MAT4'
    0x8B5E: 'SAMPLER_2D'
    0x8B60: 'SAMPLER_CUBE'
    0x1400: 'BYTE'
    0x1401: 'UNSIGNED_BYTE'
    0x1402: 'SHORT'
    0x1403: 'UNSIGNED_SHORT'
    0x1404: 'INT'
    0x1405: 'UNSIGNED_INT'
    0x1406: 'FLOAT'

  VERTEX = {
    HEAD: """
#define number float
#define Image sampler2D
#define extern uniform
#define Texel texture2D
#define love_Canvases gl_FragData

#define VERTEX

precision mediump float;

attribute vec4 VertexPosition;
attribute vec4 VertexTexCoord;
attribute vec4 VertexColor;

varying vec4 VaryingTexCoord;
varying vec4 VaryingColor;

//#if defined(GL_EXT_draw_instanced)
//  #extension GL_EXT_draw_instanced : enable
//  #define love_InstanceID gl_InstanceIDEXT
//#else
//  attribute float love_PseudoInstanceID;
//  int love_InstanceID = int(love_PseudoInstanceID);
//#endif

uniform mat4 TransformMatrix;
uniform mat4 ProjectionMatrix;
uniform mat4 TransformProjectionMatrix;
// uniform mat4 NormalMatrix;
uniform sampler2D _tex0_;
uniform mediump vec4 love_ScreenSize;
uniform mediump float love_PointSize;""",
    FOOT: """
void main() {
  VaryingTexCoord = VertexTexCoord;
  VaryingColor = VertexColor;
  gl_PointSize = love_PointSize;
  gl_Position = position(TransformProjectionMatrix, VertexPosition);
}""",
    DEFAULT: """
vec4 position(mat4 transform_proj, vec4 vertpos) {
  return transform_proj * vertpos;
}"""
  }

  FRAGMENT = {
    HEAD: """
#define number float
#define Image sampler2D
#define extern uniform
#define Texel texture2D
#define love_Canvases gl_FragData

#define PIXEL

precision mediump float;

varying mediump vec4 VaryingTexCoord;
varying lowp vec4 VaryingColor;

uniform mat4 TransformMatrix;
uniform mat4 ProjectionMatrix;
uniform mat4 TransformProjectionMatrix;
// uniform mat4 NormalMatrix;
uniform sampler2D _tex0_;
uniform mediump vec4 love_ScreenSize;
uniform mediump float love_PointSize;"""
    FOOT: """
void main() {
  vec2 pixelcoord = vec2(gl_FragCoord.x, (gl_FragCoord.y * love_ScreenSize.z) + love_ScreenSize.w);

  gl_FragColor = effect(VaryingColor, _tex0_, VaryingTexCoord.st, pixelcoord);
}""",
    DEFAULT: """
vec4 effect(lowp vec4 vcolor, Image texture, vec2 texcoord, vec2 pixcoord) {
  return Texel(texture, texcoord) * vcolor;
}"""
  }
