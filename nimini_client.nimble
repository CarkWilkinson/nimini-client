# Package

version       = "0.0.0"
author        = "Mark W"
description   = "A gemini client written in nim that uses nimini-library"
license       = "MIT"
srcDir        = "src"
bin           = @["nimini_client"]


# Dependencies

requires "nim >= 1.6.10"
requires "https://github.com/carkwilkinson/nimini-library"
