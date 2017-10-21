(message "loading cbn-navigation")
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
;; (define-key evil-normal-state-map (kbd "C-f") 'my-move-end-of-line-before-comment)

  (defun my-move-end-of-line-before-comment()
 (interactive)
  (move-end-of-line nil)
  (re-search-backward "^\\|[#]")
                                        ; # asdsadf
  ; hellow")

(backward-char)
  ;; (forward-char)
  )
;; (define-key evil-normal-state-map (kbd "C-f") 'my-move-end-of-line-before-punctuation )


(defun smart-end-of-line ()
  "Move point to first non-whitespace character or beginning-of-line.

Move point to the last non-whitespace character on this line.
If point was already at that position, move point to end of line."
  (interactive)
  (let ((oldpos (point)))
(my-move-end-of-line-before-whitespace)
;; (my-move-end-of-line-before-punctuation)
    (and (= oldpos (point))
         (end-of-line)
		 )))  




; (cibin/global-set-key '("C-e" . evil-end-of-line))
; (define-key evil-normal-state-map (kbd "C-e") 'evil-end-of-line)
; (define-key evil-normal-state-map (kbd "C-a") 'smart-line-beginning)

(cibin/global-set-key '("C-e" . smart-end-of-line))
(cibin/global-set-key '("<end>" . smart-end-of-line))
(define-key evil-insert-state-map (kbd "C-e") 'smart-end-of-line)
(define-key evil-normal-state-map (kbd "C-e") 'smart-end-of-line)
(define-key evil-normal-state-map (kbd "ge") 'smart-end-of-line)

(define-key evil-insert-state-map (kbd "C-a") 'x4-smarter-beginning-of-line)
(define-key evil-normal-state-map (kbd "C-a") 'x4-smarter-beginning-of-line)
(define-key evil-normal-state-map (kbd "gh") 'x4-smarter-beginning-of-line)
(cibin/global-set-key '("C-a" . x4-smarter-beginning-of-line))
(global-set-key [home] 'x4-smarter-beginning-of-line)

; (cibin/global-set-key '("C-a" . smart-line-beginning))
; (global-set-key [home] 'smart-line-beginning)

(define-key evil-normal-state-map (kbd "\\") 'toggle-window-split)
(cibin/global-set-key '("C-x 2" . toggle-window-split))

; TODO
; (cibin/global-set-key '("C-<home>" . x4-smarter-beginning-of-line))
; (cibin/global-set-key '("S-<home>" . x4-smarter-beginning-of-line))

(global-set-key [(control \8)] 'fc/kill-to-beginning-of-line)
(global-set-key [(control x) (\8)] 'fc/kill-to-beginning-of-line)
;; (global-set-key [(meta \8)] 'kill-line)

(cibin/global-set-key '("C-9" . kill-line))

(cibin/global-set-key '("M-8" . kill-whole-line))

(cibin/global-set-key '("M-," . beginning-of-buffer))
(cibin/global-set-key '("M-." . end-of-buffer))
(define-key evil-normal-state-map (kbd "M-,") 'beginning-of-buffer)
(define-key evil-normal-state-map (kbd "M-.") 'end-of-buffer)

 ; TODO explore elisp-slime-nav
(cibin/global-set-key '("M->" . elisp-slime-nav-find-elisp-thing-at-point))

; TODO make these into something more useful
; (cibin/global-set-key '("M-<" . beginning-of-buffer))


		 
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

(defun cibin/goto-func-definition()
(interactive)
  (if (equal major-mode 'python-mode)
(elpy-goto-definition)
(message "searching definition")
(dumb-jump-go)
))

(defun toggle-window-split ()
; https://emacs.stackexchange.com/questions/318/switch-window-split-orientation-fastest-way
(interactive)
  (if (= (count-windows) 2)
      (let* ((this-win-buffer (window-buffer))
             (next-win-buffer (window-buffer (next-window)))
             (this-win-edges (window-edges (selected-window)))
             (next-win-edges (window-edges (next-window)))
             (this-win-2nd (not (and (<= (car this-win-edges)
                                         (car next-win-edges))
                                     (<= (cadr this-win-edges)
                                         (cadr next-win-edges)))))
             (splitter
              (if (= (car this-win-edges)
                     (car (window-edges (next-window))))
                  'split-window-horizontally
                'split-window-vertically)))
        (delete-other-windows)
        (let ((first-win (selected-window)))
          (funcall splitter)
          (if this-win-2nd (other-window 1))
          (set-window-buffer (selected-window) this-win-buffer)
          (set-window-buffer (next-window) next-win-buffer)
          (select-window first-win)
          (if this-win-2nd (other-window 1))))))

; TODO diff-mode-map debugger-mode-map message-buffer-mode-map fundamental-mode-map 

; (dolist (m (list  help-mode-map evil-normal-state-map spacemacs-buffer-mode-map)
  ; (bind-keys :map m
             ;;;;;;; :prefix-map f14-prefix-map
             ;;;;;;; :prefix "<f14>"
             ; ("l" . forward-char)
             ; ("h" . backward-char)
             ; ("j" . next-line)
             ; ("k" . previous-line)
             ; )))
			 
  (defun move-line-to-ends (n)
  "Move the current line up or down by N lines."
  ;; modified from https://www.emacswiki.org/emacs/MoveLine
  ;; (interactive "p")

  (setq col (current-column))
  (beginning-of-line) (setq start (point))
  (end-of-line)
  (forward-char)
  (setq end (point))
  (let ((line-text (delete-and-extract-region start end)))
    ; (forward-line n)
      (if (eq -1 n)
(beginning-of-buffer)
      (progn (end-of-buffer)(open-line 1)(next-line 1)))
    (insert line-text)
    ;; restore point to original column in moved line
    (forward-line -1)
(forward-char col)
))

(defun move-line-to-top (n)
  "Move the current line up by N lines."
  (interactive "p")
  (move-line-to-ends (if (null n) -1 (- n))))

(defun move-line-to-bottom (n)
  "Move the current line down by N lines."
  (interactive "p")
(move-line-to-ends (if (null n) 1 n)))

(cibin/global-set-key '("M-P" . move-line-to-top))

(cibin/global-set-key '("M-N" . move-line-to-bottom))


(define-key evil-normal-state-map   (kbd "f") 'avy-goto-char-timer)

(define-key evil-normal-state-map   (kbd "J") 'xah-forward-block)
(define-key evil-visual-state-map   (kbd "J") 'xah-forward-block)
(define-key evil-normal-state-map   (kbd "K") 'xah-backward-block)
(define-key evil-visual-state-map   (kbd "K") 'xah-backward-block)

;;Make the cursor stop at the last character of a line instead of the newline character
(setq evil-move-cursor-back t)

; Beacon is just a tiny utility that indicates the cursor position when the cursor moves suddenly. You can also manually invoke it by calling the function beacon-blink and it is bound by default.
                                        ; TODO disabling for speed;
;; (use-package beacon
  ;; :ensure t
  ;; :demand t
  ;; :diminish beacon-mode
  ;; :bind* (("M-m g z" . beacon-blink))
  ;; :config
  ;; (beacon-mode 1))

(message "checkpoint 43")

(use-package avy
  :ensure t
  :init
  (setq avy-keys-alist
        `((avy-goto-char-timer . (?j ?k ?l ?f ?s ?d ?e ?r ?u ?i))
          (avy-goto-line . (?j ?k ?l ?f ?s ?d ?e ?r ?u ?i))))
  (setq avy-style 'pre)
  :bind* (("M-m f" . avy-goto-char-timer)
          ("M-m F" . avy-goto-line)
		  ;; ("C-'" . avy-goto-char)
          ;; ("C-," . avy-goto-char-2)
          ))


; dumb-jump
; Use it to jump to function definitions. Requires no external depedencies.

(use-package dumb-jump
  :diminish dumb-jump-mode
  :bind (
         ;; TODO
         ("C-M-G" . dumb-jump-go)
         ("C-M-p" . dumb-jump-back)
         ("C-M-q" . dumb-jump-quick-look)
         ))
(setq dumb-jump-prefer-searcher 'ag) 
(setq dumb-jump-selector 'ivy) ; to use ivy instead of the default popup for multiple options.
(cibin/global-set-key '("C-M-g" . cibin/goto-func-definition))

; disabling just for now
;; Fast line numbers
(use-package nlinum
  :config
  ;; Line number gutter in ncurses mode
  (unless window-system
    (setq nlinum-format "%d "))
  ;; :idle
  (global-nlinum-mode -1))

(use-package cycle-quotes
  :ensure t
  :bind* (("M-m s q" . cycle-quotes)))
  

; go to the last change
; (use-package goto-chg)
(use-package goto-chg
  :ensure t
  :defer t
  :bind* (("M-m g ;" . goto-last-change)
          ("M-m g ," . goto-last-change-reverse))
		  :config
  (progn

(global-set-key [(control .)] 'goto-last-change)
(cibin/global-set-key '("C-." . goto-last-change))

(define-key evil-normal-state-map (kbd "C-.") 'goto-last-change)
(define-key evil-normal-state-map (kbd "C-,") 'goto-last-change-reverse)
; (global-set-key [(control ,)] 'goto-last-change-reverse)
(cibin/global-set-key '("C-," . goto-last-change-reverse))


)
)

(provide 'cbn-navigation)
