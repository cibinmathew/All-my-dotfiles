;; https://www.reddit.com/r/emacs/comments/3vz6lx/command_to_rectangle_select_a_column_of_text/
(defun activate-word-column-region ()
  "Look at the symbol at point, search backward and place the point before a
symbol, and search forward and place the mark after a symbol such that all
lines have identical symbols at identical goal columns as the symbol at point."
  (interactive)
  (let (upper-pt lower-pt (next-line-add-newlines t))
    (save-excursion
      (let ((target (format "%s" (symbol-at-point))))
        (while (looking-back "\\(\\sw\\|\\s_\\)" 1)
          (backward-char 1))
        (with-no-warnings
            (save-excursion
              (next-line 1)
              (while (looking-at target)
                (setf lower-pt (point))
                (next-line 1)))
            (save-excursion
              (next-line -1)
              (while (looking-at target)
                (setf upper-pt (point))
                (next-line -1))))))
    (when (or upper-pt lower-pt)
      (let ((upper-pt (or upper-pt (point)))
            (lower-pt (or lower-pt (point))))    
        (goto-char lower-pt)
        (while (looking-at "\\(\\sw\\|\\s_\\)")
          (forward-char 1))
        (push-mark nil nil t)
        (goto-char upper-pt)
        (while (looking-back "\\(\\sw\\|\\s_\\)" 1)
          (backward-char 1)))))
  (rectangle-mark-mode))




;; change modeline color per evil state
(defun mode-line-set-evil-state ()
  (set-face-background 'mode-line
                      (cond ((evil-motion-state-p) "#AABBDD")
                            ((evil-visual-state-p) "#FFDDAA")
                            ((evil-emacs-state-p) "#FCDDAA")
                            ((evil-normal-state-p) "lightgrey")
                            ((evil-insert-state-p) "#FF0000")
                            (t "lightgrey"))))
(add-hook 'post-command-hook 'mode-line-set-evil-state) 
