class Color
  constructor: (@r, @g, @b, @a = 255) ->
    @html_code = "rgb(#{@r}, #{@g}, #{@b})"
