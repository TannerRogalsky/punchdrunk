class ImageFont
  constructor: (image, glyphs) ->
    @quads = {}

    [w, h] = [image.getWidth(image), image.getHeight(image)]
    [glyph_width, glyph_height] = [w / glyphs.length, h]
    index = 0
    for glyph in glyphs
      [x, y] = [index * glyph_width, 0]
      quads[glyph] = new Quad(x, y, glyph_width, glyph_height, w, h)
      index += 1
