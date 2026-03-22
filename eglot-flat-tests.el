;;; eglot-flat-tests.el ---                          -*- lexical-binding: t; -*-

;; Copyright (C) 2026  Taiki Sugawara

;; Author: Taiki Sugawara <buzz.taiki@gmail.com>
;; Keywords:

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

(require 'ert)
(require 'eglot-flat)

(ert-deftest test-eglot-flat-workspace-configuration ()
  (let ((eglot-flat-workspace-configuration
         '(("gopls.usePlaceholders" . t)
           ("pylsp.plugins.pylint.enabled" . :json-false)
           ("pylsp.plugins.jedi_completion.fuzzy" . t)
           ("pylsp.plugins.jedi_completion.include_params" . t))))
    (should (equal (eglot-flat-workspace-configuration nil)
                   '( :pylsp ( :plugins ( :jedi_completion ( :include_params t
                                                             :fuzzy t)
                                          :pylint (:enabled :json-false)))
                      :gopls ( :usePlaceholders t))))))

(ert-deftest test-eglot-flat-workspace-configuration ()
  (let ((eglot-flat-workspace-configuration
         '(("gopls.usePlaceholders" . t)
           ("pylsp.plugins.pylint.enabled" . :json-false)
           ("pylsp.plugins.jedi_completion.fuzzy" . t)
           ("pylsp.plugins.jedi_completion.include_params" . t))))
    (with-temp-buffer
      (set (make-local-variable 'eglot-flat-workspace-configuration)
           '(("pylsp.plugins.pylint.enabled" . t)))
      (should (equal (eglot-flat-workspace-configuration nil)
                     '( :pylsp ( :plugins ( :jedi_completion ( :include_params t
                                                               :fuzzy t)
                                            :pylint (:enabled t)))
                        :gopls ( :usePlaceholders t)))))))

(ert-deftest test-eglot-flat--set ()
  (should (equal (eglot-flat--set nil '(:a :b :c) 1)
                 '(:a (:b (:c 1)))))
  (should (equal (eglot-flat--set '(:a (:b (:c 2))) '(:a :b :c) 1)
                 '(:a (:b (:c 1)))))
  (should (equal (eglot-flat--set '(:a (:b (:z 2))) '(:a :b :c) 1)
                 '(:a (:b (:c 1 :z 2))))))

(provide 'eglot-flat-tests)
;;; eglot-flat-tests.el ends here
