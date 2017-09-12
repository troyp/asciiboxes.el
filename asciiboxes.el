;;; asciiboxes.el --- Emacs interface to the boxes program

;; Copyright (C) 2017 Troy Pracy

;; Author: Troy Pracy
;; Keywords: box comment
;; Version: 0.0.1
;; Package-Requires: ((emacs "24") ())

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 2 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Provides boxes <http://boxes.thomasjensen.com/> functionality in Emacs.

;;; Code:

(provide 'asciiboxes)


;; Variables

(defvar asciiboxes-comment-alist
  '((c-mode            . "c-cmt2")
    (c++-mode          . "c-cmt2")
    (java-mode         . "java-cmt")
    (js-mode           . "java-cmt")
    (js2-mode          . "java-cmt")
    (html-mode         . "html-cmt")
    (sh-mode           . "pound-cmt")
    (perl-mode         . "pound-cmt")
    (python-mode       . "pound-cmt")
    (ruby-mode         . "pound-cmt")
    (lisp-mode         . "lisp-cmt")
    (emacs-lisp-mode   . "lisp-cmt")
    (scheme-lisp-mode  . "lisp-cmt")
    (clojure-lisp-mode . "lisp-cmt")
    (vim-mode          . "vim-cmt")
    (ada-mode          . "ada-cmt")
    (haskell-mode      . "ada-cmt")
    (tex-mode          . "tex-cmt")
    (sml-mode          . "caml-cmt")
    (tuareg-mode       . "caml-cmt")
    )
  "Default comment design by mode.")

(defvar asciiboxes-heading-alist
  '((text-mode    . "simple")
    (c-mode       . "cc")
    (c++-mode     . "cc")
    (java-mode    . "cc")
    (html-mode    . "html")
    (sh-mode      . "shell")
    (perl-mode    . "shell")
    (python-mode  . "shell")
    (ruby-mode    . "shell")
    (ada-mode     . "ada-box")
    (haskell-mode . "ada-box")
    (tex-mode     . "tex-box")
    (sml-mode     . "caml")
    (tuareg-mode  . "caml")
    )
  "Default comment box design by mode. If no entry exists for a mode, then the
design for text-mode is used and then commented in a separate step.")

(defvar asciiboxes-boxes-command "/usr/bin/boxes" "The boxes command used by asciiboxes.")
(defvar asciiboxes-config-file
  (expand-file-name "asciiboxes-config"
                    (file-name-directory load-file-name))
  "The boxes config file to be used.")

;; Private Functions

(defun asciiboxes--read-box-design ()
  (completing-read "Design: " (asciiboxes-list)))
(defun asciiboxes--read-comment-design ()
  (completing-read "Design: " (asciiboxes-list-comment-designs)))
(defun asciiboxes--read-heading-design ()
  (completing-read "Design: " (asciiboxes-list-heading-designs)))
(defun asciiboxes--comment-design-by-mode-or-read ()
  (or (alist-get major-mode asciiboxes-comment-alist)
      (asciiboxes--read-comment-design)))
(defun asciiboxes--heading-design-by-mode-or-read ()
  (or (alist-get major-mode asciiboxes-heading-alist)
      (asciiboxes--read-heading-design)))

;; Non-interactive Functions

(defun asciiboxes-list ()
  "List all available boxes designs."
  (s-split "\\( \\|\t\\|\n\\)+"
           (shell-command-to-string
    (format "cat %s | sed -nr 's/BOX (.*)/\\1/p'" asciiboxes-config-file))))
(defun asciiboxes-list-comment-designs ()
  "List all comment designs in `asciiboxes-comment-alist'."
  (seq-uniq (mapcar #'cdr asciiboxes-comment-alist)))
(defun asciiboxes-list-heading-designs ()
  "List all heading designs in `asciiboxes-heading-alist'."
  (seq-uniq (mapcar #'cdr asciiboxes-heading-alist)))

;; Commands

(defun asciiboxes-box-region (beg end design)
  "Surround the region from BEG to END with a box of style DESIGN."
  (interactive
   (list (if (region-active-p) (region-beginning) (line-beginning-position))
         (if (region-active-p) (region-end) (line-end-position))
         (asciiboxes--read-box-design)))
   (let ((cmd (format "%s -d %s" asciiboxes-boxes-command design)))
     (shell-command-on-region beg end cmd nil t)
     (message cmd)))

(defun asciiboxes-comment (beg end design)
  "Comment the region from BEG to END, using style DESIGN."
  (interactive
   (list (if (region-active-p) (region-beginning) (line-beginning-position))
         (if (region-active-p) (region-end) (line-end-position))
         (asciiboxes--comment-design-by-mode-or-read)
         ))
  (shell-command-on-region beg end
                           (format "%s -d %s" asciiboxes-boxes-command design)
                           nil t))

;;; asciiboxes ends here
