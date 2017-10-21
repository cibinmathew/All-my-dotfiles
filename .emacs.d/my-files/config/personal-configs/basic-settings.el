( message "loading basic-settings" )

;; open in full screen
( add-to-list 'default-frame-alist '( fullscreen . maximized ))

(defun minibuffer-keyboard-quit ()
	"http://stackoverflow.com/a/10166400
then it takes a second \\[keyboard-quit] to abort the minibuffer."
(interactive)
(if (and delete-selection-mode transient-mark-mode mark-active)
	(setq deactivate-mark  t)
	(when (get-buffer "*Completions*") (delete-windows-on "*Completions*"))
	(abort-recursive-edit)))
	
	
(defun cibin/global-set-key(binding)
	(interactive)
;(message function)
	(message (format "%s" (car binding) ))
	; (global-set-key (kbd arg) function)
(global-set-key (kbd (car binding)) (cdr binding))

	(define-key evil-normal-state-map (kbd (car binding)) (cdr binding))
	(define-key evil-insert-state-map (kbd (car binding)) (cdr binding))
	; (define-key evil-insert-state-map (kbd arg) function)
	; (define-key evil-normal-state-map (kbd arg) function)

)

;; Automatically reload files was modified by external program
(global-auto-revert-mode 1)
;; and display "half modal" warning about it
;(require 'w32-msgbox)
(setq revert-buffer-function 'inform-revert-modified-file)

(cibin/global-set-key '("<mouse-3>" . nil))
(fset 'evil-visual-update-x-selection 'ignore)
(setq mouse-drag-copy-region nil)
(setq x-select-enable-primary nil)
(setq visible-bell 1)


; Shift click to extend marked region
(define-key global-map (kbd "<S-down-mouse-1>") 'mouse-save-then-kill)


;; Typing text replaces marked regions
(delete-selection-mode 1)


(setq enable-recursive-minibuffers t) ;; allow recursive editing in minibuffer

(follow-mode t)                       ;; follow-mode allows easier editing of long files



(use-package smex
	:ensure t
	:config
	(smex-initialize))
	
	
;; Autoindent open-*-lines
(defvar newline-and-indent t
	"Modify the behavior of the open-*-line functions to cause them to autoindent.")
	

; If a line is wrapped, pressing j or <down> should move to the next part of the same line.
(define-key evil-normal-state-map (kbd "<remap> <evil-next-line>") 'evil-next-visual-line)
(define-key evil-normal-state-map (kbd "<remap> <evil-previous-line>") 'evil-previous-visual-line)
(define-key evil-motion-state-map (kbd "<remap> <evil-next-line>") 'evil-next-visual-line)
(define-key evil-motion-state-map (kbd "<remap> <evil-previous-line>") 'evil-previous-visual-line)

; Make horizontal movement cross lines
; if the cursor is at the end of a line, pressing l or <right> should move to the next line.
(setq-default evil-cross-lines t)




(defun my-kill-word-at-point ()
  "Kill the word at point."
  (interactive)
  (my-kill-thing-at-point 'word))
  
  
	(provide 'basic-settings)
