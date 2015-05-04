# paket.el
[Paket](http://fsprojects.github.io/Paket/) tooling for Emacs.  Only for the brave; very much WIP.

## Installation

### Manual

For the moment, the only way to install paket.el is by 'require'ing it:

```el
(add-to-list 'load-path "~/.emacs.d/paket.el/")
(require 'paket)
```

## Usage

### paket.dependencies

A paket.dependencies buffer supports the following commands:

| Keybinding | Description |
|------------|-------------|
|<kbd>C-c C-i</kbd>| Runs 'paket install'|
|<kbd>C-c C-a</kbd>| Asks for the package name in the minibuffer and runs 'package add nuget'|
|<kbd>C-c C-o</kbd>| Runs 'paket outdated'|
