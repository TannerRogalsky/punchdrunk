class WebGL
  constructor: (@gl) ->


  createDefaultTexture: ->
    data = new Uint8Array([255, 255, 255, 255])
    texture = @gl.createTexture()
    @gl.bindTexture(@gl.TEXTURE_2D, texture)
    @gl.texImage2D(@gl.TEXTURE_2D, 0, @gl.RGBA, 1, 1, 0, @gl.RGBA, @gl.UNSIGNED_BYTE, data)
    @gl.texParameteri(@gl.TEXTURE_2D, @gl.TEXTURE_MAG_FILTER, @gl.NEAREST)
    @gl.texParameteri(@gl.TEXTURE_2D, @gl.TEXTURE_MIN_FILTER, @gl.NEAREST)
    return texture

  prepareDraw: ->
    @gl.uniformMatrix4fv(@transformMatrixLocation, false, new Float32Array(@transformMatrix.flatten()))
    @gl.uniformMatrix4fv(@projectionMatrixLocation, false, new Float32Array(@projectionMatrix.flatten()))
    @gl.uniformMatrix4fv(@transformProjectionMatrixLocation, false, new Float32Array(@transformProjectionMatrix.flatten()))

  bindTexture: (texture) ->
    if texture != @activeTexture
      @gl.bindTexture(@gl.TEXTURE_2D, texture)
      @activeTexture = texture

  useProgram: (shader) ->
    @gl.useProgram(shader.program)

  # bool initContext();
  # void deInitContext();
  # void prepareDraw();
  # void drawArraysInstanced(GLenum mode, GLint first, GLsizei count, GLsizei primcount);
  # void drawElementsInstanced(GLenum mode, GLsizei count, GLenum type, const void *indices, GLsizei primcount);
  # void setColor(const Color &c);
  # Color getColor() const;
  # void setClearColor(const Color &c);
  # Color getClearColor() const;
  # void enableVertexAttribArray(VertexAttrib attrib);
  # void disableVertexAttribArray(VertexAttrib attrib);
  # void setVertexAttribArray(VertexAttrib attrib, GLint size, GLenum type, GLsizei stride, const GLvoid *pointer);
  # void setViewport(const Viewport &v);
  # Viewport getViewport() const;
  # void setScissor(const Viewport &v);
  # Viewport getScissor() const;
  # void setBlendState(const BlendState &blend);
  # BlendState getBlendState() const;
  # void setPointSize(float size);
  # float getPointSize() const;
  # GLuint getDefaultFBO() const;
  # GLuint getDefaultTexture() const;
  # void setTextureUnit(int textureunit);
  # void bindTexture(GLuint texture);
  # void bindTextureToUnit(GLuint texture, int textureunit, bool restoreprev);
  # void deleteTexture(GLuint texture);
  # float setTextureFilter(graphics::Texture::Filter &f);
  # graphics::Texture::Filter getTextureFilter();
  # void setTextureWrap(const graphics::Texture::Wrap &w);
  # graphics::Texture::Wrap getTextureWrap();
  # int getMaxTextureSize() const;
  # int getMaxRenderTargets() const;
  # Vendor getVendor() const;
  # static const char *debugSeverityString(GLenum severity);
  # static const char *debugSourceString(GLenum source);
  # static const char *debugTypeString(GLenum type);


  @getGLContext = (canvas) ->
    names = ["webgl", "experimental-webgl", "webkit-3d", "moz-webgl"]
    for name in names
      try
        context = canvas.getContext(name)
      catch e
      if context
        break
    return context
