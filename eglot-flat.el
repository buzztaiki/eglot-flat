;;; eglot-flat.el --- Flat and mergeable workspace configuration support for Eglot.  -*- lexical-binding: t; -*-

;; Copyright (C) 2026  Taiki Sugawara

;; Author: Taiki Sugawara <buzz.taiki@gmail.com>
;; Keywords: convenience

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; see README.md

;;; TODO
;; - read vscode configuration

;;; Code:

(require 'eglot)
(require 'jsonrpc)
(require 'seq)

(defgroup eglot-flat nil
  "Flat and mergeable workspace configuration support for Eglot."
  :prefix "eglot-flat-"
  :group 'eglot)

(defcustom eglot-flat-global-workspace-configuration nil
  "Global flat workspace configuration."
  :type '(repeat (cons (string :tag "Key") (sexp :tag "Value"))))

(defcustom eglot-flat-workspace-configuration nil
  "Flat workspace configuration."
  :type '(repeat (cons (string :tag "Key") (sexp :tag "Value")))
  :safe #'eglot-flat--workspace-configuration-safe-p)

(defun eglot-flat-workspace-configuration (_server)
  "Return workspace configuration by merging flat configurations.
Merge variable `eglot-flat-global-workspace-configuration' and
variable `eglot-flat-workspace-configuration', converting dot-separated keys
like \"yaml.format.enable\" into the nested plist format expected by
`eglot-workspace-configuration'.

To use this, set `eglot-workspace-configuration' to this function:
  (setq-default eglot-workspace-configuration #\\='eglot-flat-workspace-configuration)"

  (cl-loop with config
           for (flat-key . value) in (append eglot-flat-global-workspace-configuration
                                             eglot-flat-workspace-configuration)
           for keys = (mapcar (lambda (x) (intern (concat ":" x)))
                              (split-string flat-key "\\."))
           do (setq config (eglot-flat--plist-put-in config keys value))
           finally return config))

(defun eglot-flat--plist-put-in (plist keys value)
  "Put a VALUE into PLIST at the path specified by KEYS."
  (if (null keys)
      value
    (setf (plist-get plist (car keys))
          (eglot-flat--plist-put-in (plist-get plist (car keys)) (cdr keys) value))
    plist))

(defun eglot-flat--workspace-configuration-safe-p (conf)
  (and (listp conf)
       (seq-every-p (lambda (x) (and (consp x)
                                     (stringp (car x))
                                     (ignore-errors (jsonrpc--json-encode (cdr x)))))
                    conf)))

(provide 'eglot-flat)
;;; eglot-flat.el ends here
