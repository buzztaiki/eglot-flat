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

;;

;;; Code:

(require 'eglot)

(defgroup eglot-flat nil
  "Flat and mergeable workspace configuration support for Eglot."
  :prefix "eglot-flat-"
  :group 'eglot)

(defcustom eglot-flat-workspace-configuration nil
  "Flat workspace configuration.")

(defun eglot-flat-workspace-configuration (_server)
  "Transforms the variable `eglot-flat-workspace-configuration' to the format expected by `eglot-workspace-configuration'."
  (cl-loop with config
           for (flat-key . value) in (append (default-value 'eglot-flat-workspace-configuration)
                                             eglot-flat-workspace-configuration)
           for keys = (mapcar (lambda (x) (intern (concat ":" x)))
                              (split-string flat-key "\\."))
           do (setq config (eglot-flat--set config keys value))
           finally return config))

(defun eglot-flat--set (plist keys value)
  (if (null keys)
      value
    (setf (plist-get plist (car keys))
          (eglot-flat--set (plist-get plist (car keys)) (cdr keys) value))
    plist))

(provide 'eglot-flat)
;;; eglot-flat.el ends here
