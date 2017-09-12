asciiboxes.el --- Emacs interface to the boxes program
--------------------------------------------------------------------

Provides [boxes][] functionality in Emacs.

### Variables

* `asciiboxes-comment-alist`: Default comment design by mode.
* `asciiboxes-headings-alist`: Default comment box design by mode. If no entry
  exists for a mode, then the design for text-mode is used and then commented
  in a separate step.
* `asciiboxes-boxes-command`: The boxes command used by asciiboxes.
* `asciiboxes-config-file`: The boxes config file to be used.

### Functions

* `asciiboxes-list`: List all available boxes designs.
* `asciiboxes-box-region`: Surround the region from `beg` to `end` with a box
  of style `design`.
* `asciiboxes-box-region-by-mode`: Surround the region from `beg` to `end` with
  a box according to `asciiboxes-headings-alist` and auto-indent.
* `asciiboxes-comment` Comment the region from `beg` to `end`, using style
  `design`.


[boxes]: http://boxes.thomasjensen.com/
