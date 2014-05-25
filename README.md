punchdrunk.js
================

Punchdrunk = [Moonshine](http://moonshinejs.org/) + [LÖVE](http://love2d.org/)

Demo: http://tannerrogalsky.com/punchdrunk/

# Get This Running

1. Install [node.js](http://nodejs.org/)
2. Install [Lua](http://www.lua.org/) and make sure that it's in your path.
3. Install grunt: `npm install grunt-cli -g`
4. Install the project dependencies: `npm install`
5. `grunt` will watch and compile the source as well as run a simple web server on port 8000.
6. Open `localhost:8000` in your browser.

# Caveats

Some things don't work (and some may never work):
- love.image
- love.joystick
- love.math
- love.physics
- love.thread
- love.filesystem

Pretty much everything else has partial support. I'm not going to make a long list of everything that doesn't work right now because there's still too much that doesn't. I think you'll find that all the most basic elements of the API are functional. Those that aren't should be stubbed out in the hopes that they aren't crucial to the game that is being ported.

# FAQ

- Can I run my own game in the browser?

Sure! Just delete what's in the `lua` folder, replace it with your source code and run `grunt`. It should compile the Lua code in JSON-ized bytecode which should then just work, if you aren't using anything that hasn't been implemented yet. You may also have to preload your graphics and audio by putting tags for them in `index.html`.

- This is cool! How can I help?

Everything that I'm working on should be [logged as an issue](https://github.com/TannerRogalsky/punchdrunk/issues). If you find something that doesn't work, please create a new issue for it. If you're interested in picking one of the existing issues up, please comment on it first so that I can let you know if I've already done any work on it.

- Why is your CoffeScript so weird?

The interop between Lua and CoffeeScript has necessitated some CoffeeScript that is atypical. Mainly, you'll notice two things: heavy use of the 'fat-arrow notation' for function binding and a lot of passing the object being operated on to the function instead of using proper JavaScript context. Both of these are because the differences between how JavaScript and Lua handle function context. You can read more about it [here](https://github.com/gamesys/moonshine/issues/12).
