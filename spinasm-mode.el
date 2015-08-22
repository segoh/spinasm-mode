;;; spinasm-mode.el --- mode for editing SpinAsm code

;; Copyright (C) 2010 Free Software Foundation, Inc

;; Author: Sebastian Gutsfeld <sebastian.gutsfeld@gmail.com>
;; Keywords: tools, languages

;; This file is NOT part of GNU Emacs.

;; GNU Emacs is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; spinasm-mode extends asm-mode with additionaly functionality and
;; syntax highlighting for SpinSemi SpinAsm code.

;; To use this mode, put spinasm-mode.el somewhere on your load-path.
;; Then add this to your .emacs:
;;
;;    (require 'spinasm-mode)
;;    (add-to-list 'auto-mode-alist '("\\.asm$" . spinasm-mode))
;;    (add-to-list 'auto-mode-alist '("\\.spn$" . spinasm-mode))
;;
;; NOTE: Remember to change `spinasm-conv-program' and
;; `spinasm-assemble-program' with its options `spinasm-assemble-options'.

;;; Code:

(defgroup spinasm nil
  "Mode for editing SpinAsm assembler code."
  :link '(custom-group-link :tag "Font Lock Faces group" font-lock-faces)
  :group 'languages)

(defcustom spinasm-conv-program "spnconv"
  "The program to convert between spinasm spn files and text asm files."
  :type 'string
  :group 'spinasm)

(defcustom spinasm-assemble-program "spnasm"
  "The program to assemble a file.  Its options are defined in `spinasm-assemble-arguments'."
  :type 'string
  :group 'spinasm)

(defcustom spinasm-assemble-options "--vm 'Windows' --user 'winuser' --pw 'winpw' --autoit 'C:\\\\Programme\\\\AutoIt3\\\\AutoIt3.exe' --au3script 'D:\\\\.emacs.d\\\\lisp\\\\spinasm-mode\\\\spn.au3' --winpath 'D:\\\\' --hostpath '/Users/me/'"
  "The arguments for the `spinasm-assemble-program'."
  :type 'string
  :group 'spinasm)

(defun spinasm-conv-buffer ()
  "Convert between SpinAsm spn and normal text .asm files."
  (interactive)
  (let* ((fname (buffer-file-name))
         (log-buffer (get-buffer-create "*spinasm-log*")))
    (call-process spinasm-conv-program nil log-buffer nil fname)
    (if (string-match "spn$" fname)
        (find-file (replace-match "asm" nil nil fname))
      (message "spn file generated."))))

(defun spinasm-assemble-buffer ()
  "Assemble the current buffer file and upload it."
  (interactive)
  (let* ((fname (buffer-file-name))
         (spinasm-fname (if (string-match "asm$" fname)
                            (progn (spinasm-conv-buffer)
                                   (replace-match "spn" nil nil fname))
                          fname)))
    (compile (concat spinasm-assemble-program
                     " "
                     spinasm-assemble-options
                     " "
                     spinasm-fname))))

;; Font-lock, keywords
(defvar spinasm-function-names
  '("mem" "equ" "nop" "clr" "rda" "wra" "wrap" "rmpa" "rdax" "rdfx"
    "wrax" "wrhx" "wrlx" "maxx" "absa" "mulx" "log" "exp" "sof" "and"
    "or" "xor" "not" "ldax" "skp" "jam" "wlds" "wldr" "cho" "rdal")
  "SpinAsm function names.")

(defvar spinasm-reserved-names
  '("run" "zrc" "zro" "gez" "neg" "sin" "cos" "reg" "compc" "compa"
    "rptr2" "na" "sin0_rate" "sin0_range" "sin1_rate" "sin1_range"
    "rmp0_rate" "ramp0_range" "rmp1_rate" "ramp1_range" "pot0" "pot1"
    "pot2" "adcl" "adcr" "dacl" "dacr" "addr_ptr" "reg0" "reg1" "reg2"
    "reg3" "reg4" "reg5" "reg6" "reg7" "reg8" "reg9" "reg10" "reg11"
    "reg12" "reg13" "reg14" "reg15" "reg16" "reg17" "reg18" "reg19"
    "reg20" "reg21" "reg22" "reg23" "reg24" "reg25" "reg26" "reg27"
    "reg28" "reg29" "reg30" "reg31")
  "SpinAsm reserved names.")

(defconst spinasm-font-lock-defaults
  (append
   ;; labels
   '(("^\\(\\(\\sw\\|\\s_\\)+\\)\\>:?[ \t]*"
      (1 font-lock-function-name-face)))
   ;; SpinAsm functions and reserved names
   `((,(concat "\\<" (regexp-opt spinasm-function-names t) "\\>") . font-lock-keyword-face)
     (,(concat "\\<" (regexp-opt spinasm-reserved-names t) "\\>") . font-lock-constant-face)))
  "Highlighting for SpinAsm functions and registers.")

;;;###autoload
(define-derived-mode spinasm-mode
  asm-mode
  "SpinAsm"
  "\\<spinasm-mode-map>
A mode for editing SpinAsm code.

This mode uses two external tools:

`spinasm-conv-program' to convert an ASCII file with .asm suffix
into the format written by the SpinSemi IDE with .spn suffix.

`spinasm-assemble-program' to assemble the resulting .spn file
with SpinAsm IDE running in a VirtualBox Windows guest machine.
Besides a working VirtualBox Windows guest you need a shared
folder between host and guest and
AutoIt (http://www.autoitscript.com/) installed on the guest.
Command line parameters for `spinasm-assemble-program' that
define the VirtualBox virtual machine name, shared folder path,
path to AutoIt script etc. are defined by
`spinasm-assemble-options'.

\\[spinasm-conv-buffer] converts a .asm ASCII file into a SpinAsm
.spn file and vice versa.

\\[spinasm-assemble-buffer] triggers the .asm to .spn
conversion (if required) and assembles the resulting .spn file on
the Windows VirtualBox guest.
"
  (setq font-lock-defaults '(spinasm-font-lock-defaults)))

;; Key bindings
(define-key spinasm-mode-map "\C-c\C-x" 'spinasm-conv-buffer)
(define-key spinasm-mode-map "\C-c\C-c" 'spinasm-assemble-buffer)

(provide 'spinasm-mode)

;;; spinasm-mode.el ends here
