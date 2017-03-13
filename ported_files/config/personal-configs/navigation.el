(defun my-move-end-of-line-before-whitespace ()
  "Move to the last non-whitespace character in the current line.
  http://stackoverflow.com/questions/9597391/emacs-move-point-to-last-non-whitespace-character "
  
  (move-end-of-line nil)
  (re-search-backward "^\\|[^[:space:]]")
  (forward-char)
  )
  
  (defun my-move-end-of-line-before-punctuation ()
 (interactive)
  (move-end-of-line nil)
  (re-search-backward "^\\|[\"\)#]")
                                        ; # asdsadf
  ; hellow")

(backward-char)
  ;; (forward-char)
  )
(define-key evil-normal-state-map (kbd "C-f") 'my-move-end-of-line-before-comment)
  
  (defun my-move-end-of-line-before-comment()
 (interactive)
  (move-end-of-line nil)
  (re-search-backward "^\\|[#]")
                                        ; # asdsadf
  ; hellow")

(backward-char)
  ;; (forward-char)
  )
(define-key evil-normal-state-map (kbd "C-f") 'my-move-end-of-line-before-punctuation )
  
  
(defun smart-end-of-line ()
  "Move point to first non-whitespace character or beginning-of-line.

Move point to the last non-whitespace character on this line.
If point was already at that position, move point to end of line."
  (interactive)
  (let ((oldpos (point)))
; (my-move-end-of-line-before-whitespace)
(my-move-end-of-line-before-punctuation)
    (and (= oldpos (point))
         (end-of-line)
		 )))  




(global-set-key (kbd "C-e") 'smart-end-of-line)
(global-set-key (kbd "<end>") 'smart-end-of-line)
; (global-set-key (kbd "C-e") 'evil-end-of-line)

; (define-key evil-normal-state-map (kbd "C-e") 'evil-end-of-line)
; (define-key evil-normal-state-map (kbd "C-a") 'smart-line-beginning)
(define-key evil-normal-state-map (kbd "C-e") 'smart-end-of-line)
(define-key evil-normal-state-map (kbd "C-a") 'x4-smarter-beginning-of-line)
(global-set-key (kbd "C-a") 'x4-smarter-beginning-of-line)
(global-set-key [home] 'x4-smarter-beginning-of-line)
(global-set-key (kbd "C-x 2") 'window-toggle-split-direction)
; (global-set-key (kbd "C-a") 'smart-line-beginning)
; (global-set-key [home] 'smart-line-beginning)

; TODO		 
; (global-set-key (kbd "C-<home>") 'x4-smarter-beginning-of-line)
; (global-set-key (kbd "S-<home>") 'x4-smarter-beginning-of-line)

		 
		 
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

(defun window-toggle-split-direction ()
  "Switch window split from horizontally to vertically, or vice versa.

i.e. change right window to bottom, or change bottom window to right."
; https://www.emacswiki.org/emacs/ToggleWindowSplit
  (interactive)
  (require 'windmove)
  (let ((done))
    (dolist (dirs '((right . down) (down . right)))
      (unless done
        (let* ((win (selected-window))
               (nextdir (car dirs))
               (neighbour-dir (cdr dirs))
               (next-win (windmove-find-other-window nextdir win))
               (neighbour1 (windmove-find-other-window neighbour-dir win))
               (neighbour2 (if next-win (with-selected-window next-win
                                          (windmove-find-other-window neighbour-dir next-win)))))
          ;;(message "win: %s\nnext-win: %s\nneighbour1: %s\nneighbour2:%s" win next-win neighbour1 neighbour2)
          (setq done (and (eq neighbour1 neighbour2)
                          (not (eq (minibuffer-window) next-win))))
          (if done
              (let* ((other-buf (window-buffer next-win)))
                (delete-window next-win)
                (if (eq nextdir 'right)
                    (split-window-vertically)
                  (split-window-horizontally))
                (set-window-buffer (windmove-find-other-window neighbour-dir) other-buf))))))))
				