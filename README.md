moonshine-love2d
================

An attempt to replicate the Love2D API in the browser using moonshine.

# Get This Running

- install Moonshine: http://moonshinejs.org/
- compile the lua file to json/bytecode format `cd lua; moonshine distil *.lua`
  - I've also been using entr to do this automatically: `find . -name '*.lua' | entr moonshine distil *.lua`
- run an http server: `python -c 'import SimpleHTTPServer; SimpleHTTPServer.test()'`
- open the url created by your http server
