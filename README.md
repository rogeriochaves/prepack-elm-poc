Prepacking Elm
===============

This is a proof of concept of running prepack on the javascript output produced by Elm. The results are impressive, prepack reduced a lot of code, then I also minify and gzip it, making the TodoMVC app go from 224kb to just 20k, working perfectly.

Also, I got better results with closure compiler than with uglify. I've attempted to get even better results using advanced closure compiler, but the final size ended up the same (both 20 kb for TodoMVC), so I'll just use simple because it requires less changes.
