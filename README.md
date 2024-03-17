# SSSG (Stupid Static Site Generator)

Build static site from markdown files and html templates

## Features

- Relative to absolute links
- Code highlighting
- Math formulas

## How to use

- clone this repo
- change things 
- build with `make`
- test with `make testing && make serve`

## Documentation

### project tree

* `source/` contains `*.md` to convert
* `resource/` contains static resources like images, videos, css ..
* `theme/` contains __pandoc html templates__
* `theme/resources/` same as `resources/` but for theme
* `settings.yaml` configuration file for building the site
* `build/`, `build/testing/`, `build/release/` contains the static site 

### steps of conversions

given a `file.md` produces a `file/index.html` with [pandoc template](https://pandoc.org/MANUAL.html#templates) 
`base.html` combined with `settings.yaml`

### links mapping

* all resources are combined in the `build/[release or testing]/resources/` folder
* if you want to make a link in `page1.md` to `subfolder/page2.md` write
    `[link](subfolder/page2)`