;; Ported from is Max Mikhanosha's code.
(require 'ansi-color)
(require 'sly-mrepl)

(define-sly-contrib sly-repl-ansi-color
  "Turn on ANSI colors in the mREPL output"
  (:authors '("Javier Olaechea" "Max Mikhanosha"))
  (:license "GPL")
  (:on-load (progn
              (sly-repl-ansi-on)
              (add-hook 'sly-mrepl-output-filter-functions
                        'sly-repl-ansi-colorize))))

(defvar sly-repl-ansi-color t
  "When Non-NIL will process ANSI colors in the lisp output")

(make-variable-buffer-local 'sly-repl-ansi-color)

(defun sly-repl-ansi-on ()
  "Set `ansi-color-for-comint-mode' to t."
  (interactive)
  (setq sly-repl-ansi-color t))

(defun sly-repl-ansi-off ()
  "Set `ansi-color-for-comint-mode' to t."
  (interactive)
  (setq sly-repl-ansi-color nil))

(defun sly-repl-ansi-colorize (string)
  (when sly-repl-ansi-color
    (with-temp-buffer
      (insert (ansi-color-apply string))
      (dotimes (char-pos (- (point-max) (point-min)))
        (let* ((char-pos (1+ char-pos))
               (prop (getf (text-properties-at char-pos) 'font-lock-face)))
          (when prop
            (put-text-property char-pos (1+ char-pos) 'face prop))))
      (buffer-string))))

(provide 'sly-repl-ansi-color)
