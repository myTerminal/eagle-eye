;;; eagle-eye.el --- A utility to zoom-in and zoom-out while editing text

;; This file is not part of Emacs

;; Author: Mohammed Ismail Ansari <team.terminal@gmail.com>
;; Keywords: text-editing
;; Maintainer: Mohammed Ismail Ansari <team.terminal@gmail.com>
;; Created: 2017/08/22
;; Description: A utility to zoom-in and zoom-out while editing text
;; URL: http://ismail.teamfluxion.com
;; Compatibility: Emacs24


;; COPYRIGHT NOTICE
;;
;; This program is free software; you can redistribute it and/or modify it
;; under the terms of the GNU General Public License as published by the Free
;; Software Foundation; either version 2 of the License, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
;; or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
;; for more details.
;;

;;; Install:

;; Put this file on your Emacs-Lisp load path, add following into your
;; ~/.emacs startup file
;;
;;     (require 'eagle-eye)
;;
;; Enable eagle-eye-mode in any buffer to zoom out to the set level.
;; Disabling the minor-mode will bring the text size back to normal.
;;
;;     (eagle-eye-mode)
;;
;; You can also set key-bindings to functions `eagle-eye-zoom-in' and
;; `eagle-eye-zoom-out', so that you can change text size across Emacs at once.
;;
;;     (global-set-key (kbd "C->") 'eagle-eye-zoom-in)
;;
;;     (global-set-key (kbd "C-<") 'eagle-eye-zoom-out)
;;
;; The eagle-eye zoom level can be set as
;;
;;     (eagle-eye-set-font-height 50)
;;
;; Also, you can set the step by which zooming in and zooming out happens by
;;
;;     (eagle-eye-set-zoom-step 10)
;;
;; By default, the eagle-eye zoom level is 50 and zoom step is 10.
;;

;;; Commentary:

;;     You can use this package to change the text-size across Emacs at once or
;;     suddenly zoom out to get a eagle-eye view and then take it back to normal.
;;
;;  Overview of features:
;;
;;     o   Change text size in steps
;;     o   Temporarily zoom-out and then back to normal
;;

;;; Code:

(defvar eagle-eye--saved-font-height
  nil)

(defvar eagle-eye--tiny-font-height
  50)

(defvar eagle-eye--font-zoom-step
  10)

;;;###autoload
(defun eagle-eye-set-font-height (height)
  (setq eagle-eye--tiny-font-height
        height))

;;;###autoload
(defun eagle-eye-set-zoom-step (step)
  (setq eagle-eye--font-zoom-step
        step))

;;;###autoload
(define-minor-mode eagle-eye-mode
  "Toggle eagle-eye-mode"
  :init-value nil
  :lighter " eagle-eye"
  (cond (eagle-eye-mode (progn (setq eagle-eye--saved-font-height
                                     (face-attribute 'default :height))
                               (custom-set-faces
                                `(default ((t (:height ,eagle-eye--tiny-font-height)))))
                               (message (concatenate 'string
                                                     "Zoomed to "
                                                     (number-to-string eagle-eye--tiny-font-height)
                                                     " percent"))))
        (t (progn (custom-set-faces
                   `(default ((t (:height ,eagle-eye--saved-font-height)))))
                  (message (concatenate 'string
                                        "Zoomed back to "
                                        (number-to-string eagle-eye--saved-font-height)
                                        " percent"))))))
;;;###autoload
(defun eagle-eye-zoom-out ()
  "Decreases font-size in steps"
  (interactive)
  (let* ((current-font-height (face-attribute 'default :height))
         (decremented-font-height (- current-font-height
                                     eagle-eye--font-zoom-step)))
    (cond ((> decremented-font-height
              0) (progn (custom-set-faces
                         `(default ((t (:height ,decremented-font-height)))))
                        (message (concatenate 'string
                                              "Zoomed out to "
                                              (number-to-string decremented-font-height)
                                              " percent"))))
          (t (message "Already at minimum zoom level")))))

;;;###autoload
(defun eagle-eye-zoom-in ()
  "Increases font-size in steps"
  (interactive)
  (let* ((current-font-height (face-attribute 'default :height))
         (incremented-font-height (+ current-font-height
                                     eagle-eye--font-zoom-step)))
    (custom-set-faces
     `(default ((t (:height ,incremented-font-height)))))
    (message (concatenate 'string
                          "Zoomed in to "
                          (number-to-string incremented-font-height)
                          " percent"))))

(provide 'eagle-eye)

;;; eagle-eye.el ends here
