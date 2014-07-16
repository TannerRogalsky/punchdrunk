class Love.Color
  constructor: (@r, @g, @b, @a = 255) ->
    @html_code = "rgb(#{@r}, #{@g}, #{@b})"

  unpack: ->
    [@r, @g, @b, @a]

Color = Love.Color
