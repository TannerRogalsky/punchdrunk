class Shader
  constructor: (gl, vertex_code, fragment_code) ->
    [vertex_code, fragment_code] = shaderCodeToGLSL(vertex_code, fragment_code)
    vertex_shader = @compileCode(gl, "vertex", vertex_code)
    fragment_shader = @compileCode(gl, "fragment", fragment_code)
    @program = @loadVolatile(gl, vertex_shader, fragment_shader)

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
