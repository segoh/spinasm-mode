# SpinAsm Emacs Mode

This is an [Emacs](http://www.gnu.org/s/emacs/) mode for editing
[SpinAsm assembler](http://spinsemi.com/) code for the Spin
Semiconductor FV-1 DSP chip.

Unfortunately the
[SpinAsm IDE](http://spinsemi.com/Products/software/spn1001-dev/SpinSetup_1_1_31.exe)
is only available for Windows, but this mode allows Macintosh and
GNU/Linux hosts to start the assembler running in a Windows VirtualBox
guest machine.


## Prerequisites

1. [Emacs](http://www.gnu.org/s/emacs/)
2. [VirtualBox](https://www.virtualbox.org/) with a Windows guest machine
3. [shared folder](http://www.virtualbox.org/manual/ch04.html#sharedfolders) between the host and the guest machine (using your host's home folder is probably the easiest solution)
4. [AutoIt](http://www.autoitscript.com/) installed on Windows guest
5. [SpinAsm IDE](http://spinsemi.com/Products/software/spn1001-dev/SpinSetup_1_1_31.exe) installed on Windows guest


## Installation

The following instructions assume that are familiar with configuring
Emacs and working with VirtualBox.

Put this folder in your Emacs' load-path and add this to your .emacs file:

```
(require 'spinasm-mode)
(add-to-list 'auto-mode-alist '("\\.asm$" . spinasm-mode))
(add-to-list 'auto-mode-alist '("\\.spn$" . spinasm-mode))
```

Set all entries in the spinasm customization group according to your
system (`M-x customize-group spinasm`). You can call `spinasm` without
any parameters to get some help what all its parameters are all about.

Finally you should update the two variables defined in the AutoIt
script `spn.au3`. `$spinasm_exe` is the full path to the SpinAsm IDE
on your Windows guest and `$open_window_title` is the title of the
SpinAsm IDE open file dialog opened by selecting the respective menu
entry.


## License

Copyright © 2011 Sebastian Gutsfeld

Files are licensed under the same license as Emacs unless otherwise
specified. See the file COPYING for details.
