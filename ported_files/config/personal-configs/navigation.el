(defun my-move-end-of-line-before-whitespace ()
  "Move to the last non-whitespace character in the current line.
  http://stackoverflow.com/questions/9597391/emacs-move-point-to-last-non-whitespace-character "
  
  (move-end-of-line nil)
  (re-search-backward "^\\|[^[:space:]]")
  (forward-char)
  )
  
  
(defun smart-end-of-line ()
  "Move point to first non-whitespace character or beginning-of-line.

Move point to the last non-whitespace character on this line.
If point was already at that position, move point to end of line."
  (interactive)
  (let ((oldpos (point)))
(my-move-end-of-line-before-whitespace)
    (and (= oldpos (point))
         (end-of-line))))  



(define-key evil-normal-state-map (kbd "C-e") 'evil-end-of-line)
(define-key evil-normal-state-map (kbd "C-a") 'smart-line-beginning)

(global-set-key (kbd "C-e") 'smart-end-of-line)
; (global-set-key (kbd "C-e") 'evil-end-of-line)

(global-set-key (kbd "C-a") 'x4-smarter-beginning-of-line)
(global-set-key [home] 'x4-smarter-beginning-of-line)
; (global-set-key (kbd "C-a") 'smart-line-beginning)
; (global-set-key [home] 'smart-line-beginning)

		 

		 
		 
		 ;; Smart beginning of the line
(defun x4-smarter-beginning-of-line ()
"""Move point to beginning-of-line or first non-whitespace character or first non-whitespace after a comment sign.
https://gist.github.com/X4lldux/5649195 
"""
"(interactive ""^"")"
(interactive)
(let (
(oldpos (point))
(indentpos (progn
(back-to-indentation)
(point)
)
)
(textpos (progn
(beginning-of-line-text)
(point)
)
)
)
(cond
((> oldpos textpos) (beginning-of-line-text))
((and (<= oldpos textpos) (> oldpos indentpos)) (back-to-indentation))
((and (<= oldpos indentpos) (> oldpos (line-beginning-position))) (beginning-of-line))
(t (beginning-of-line-text))
)
)
)
