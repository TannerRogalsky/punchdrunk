class Color
  constructor: (@r, @g, @b, @a = 255) ->
    @html_code = "rgba(#{@r}, #{@g}, #{@b}, #{@a})"
