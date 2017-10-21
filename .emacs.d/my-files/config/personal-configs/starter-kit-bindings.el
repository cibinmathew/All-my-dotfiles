(message "loading starter-kit-bindings")

;;; starter-kit-bindings.el --- Set up some handy key bindings
; http://www.cibinmathew.com
; github.com/cibinmathew

;; https://github.com/hjz/emacs

;; Part of the Emacs Starter Kit.

; (cibin/global-set-key '("M-a" . execute-extended-command))

; TODO do it for insert mode also
; (define-key evil-normal-state-map (kbd "s") 'nil)
;(define-key evil-normal-state-map  "s p" 'evil-unimpaired/paste-below)
;(define-key evil-normal-state-map "s P" 'evil-unimpaired/paste-above)

;; C-9 for *scratch*, C-9 for *compilation*.
;; (use M-9, etc as alternates since C-number keys don't have ascii control
;; codes, so they can't be used in terminal frames.)
; or use i for insert and I for trigger
(global-set-key [(control \0)] 'switch-to-scratch)
(global-set-key [(control x) (\0)] 'switch-to-scratch)
(global-set-key [(meta \0)] 'switch-to-scratch)

(global-set-key (kbd "M-0") (lambda()(interactive) (switch-to-buffer (get-buffer-create "*Messages*"))))

; or use i for insert and I for trigger
(define-key evil-visual-state-map "I" 'evil-insert)

(message "checkpoint")

                                        ; interpret and use ansi color codes in shell buffers
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
; (add-hook 'diff-mode-hook 'ansijespace in some modes)
(dolist (hook '(shell-mode-hook compilation-mode-hook diff-mode-hook))
  (add-hook hook (lambda () (set-variable 'show-trailing-whitespace nil))))

(message "checkpoint")
;;; esc quits
(define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)

(define-key evil-normal-state-map [escape] 'keyboard-quit)
(define-key evil-visual-state-map [escape] 'keyboard-quit)

;;; C-g as general purpose escape key sequence.
   ;;; https://www.emacswiki.org/emacs/Evil
   (defun my-esc (prompt)
     "Functionality for escaping generally.  Includes exiting Evil insert state and C-g binding. "
     (cond
      ;; If we're in one of the Evil states that defines [escape] key, return [escape] so as
      ;; Key Lookup will use it.
      ((or (evil-insert-state-p) (evil-normal-state-p) (evil-replace-state-p) (evil-visual-state-p)) [escape])
      ;; This is the best way I could infer for now to have C-g work during evil-read-key.
      ;; Note: As long as I return [escape] in normal-state, I don't need this.
      ;;((eq overriding-terminal-local-map evil-read-key-map) (keyboard-quit) (kbd ""))
      (t (kbd "C-g"))))
   (define-key key-translation-map (kbd "C-g") 'my-esc)
   ;; Works around the fact that Evil uses read-event directly when in operator state, which
   ;; doesn't use the key-translation-map.
   (define-key evil-operator-state-map (kbd "C-g") 'keyboard-quit)
   ;; Not sure what behavior this changes, but might as well set it, seeing the Elisp manual's
   ;; documentation of it.
   (set-quit-char "C-g")


(defun evil-keyboard-quit ()
  "Keyboard quit and force normal state."
  (interactive)
  (evil-normal-state)
  (and evil-mode (evil-force-normal-state))
  (keyboard-quit))
; Now go ahead and bind it in the relevant maps:

 (define-key evil-normal-state-map   (kbd "C-g" ) #'evil-keyboard-quit)
 (define-key evil-motion-state-map   (kbd "C-g" ) #'evil-keyboard-quit)
 (define-key evil-emacs-state-map    (kbd "C-g" ) #'evil-exit-emacs-state)
 (define-key evil-insert-state-map   (kbd "C-g" ) #'evil-keyboard-quit)
 (define-key evil-window-map         (kbd "C-g" ) #'evil-keyboard-quit)
 (define-key evil-replace-state-map (kbd "C-g" ) #'evil-keyboard-quit)
 (define-key evil-operator-state-map (kbd "C-g" ) #'evil-keyboard-quit)

(global-set-key [escape] 'keyboard-escape-quit)         ;; everywhere else

; Map escape to cancel (like C-g)...
(define-key isearch-mode-map [escape] 'isearch-abort)   ;; isearch
(define-key isearch-mode-map "\e" 'isearch-abort)   ;; \e seems to work better for terminals

; move to first letter of next word
(cibin/global-set-key '("M-f" . forward-word-to-beginning))
(global-set-key (kbd "<backspace>") 'delete-backward-char)
(global-set-key (kbd "<BS>") 'delete-backward-char)

; added already i guss
; dumb-jump-go C-M g core functionality. Attempts to jump to the definition for the thing under point
; dumb-jump-back C-M p jumps back to where you were when you jumped. These are chained so if you go down a rabbit hole you can get back out or where you want to be.
; dumb-jump-quick-look C-M q like dumb-jump-go but shows tooltip with file, line, and context
; dumb-jump-go-other-window exactly like dumb-jump-go but uses find-file-other-window instead of find-file



; TODO check this file https://github.com/magnars/.emacs.d/blob/master/site-lisp/evil/evil-maps.el
; easy editing mode

; delete line but keep newline char, so that it is evident that nothing happens accidently
; (define-key evil-normal-state-map "x" 'kill-whole-line)
; (define-key evil-normal-state-map "w" 'duplicate-current-line-or-region)
; (define-key evil-normal-state-map "e" 'drag-stuff-up)
; (define-key evil-normal-state-map "d" 'drag-stuff-down)
; (define-key evil-normal-state-map "d" 'comment.....lines)
; (define-key evil-normal-state-map "d" 'goto next oocurrence of current word)
; (define-key evil-normal-state-map "a" 'goto start of line)
; (define-key evil-normal-state-map "z" 'goto end of line)


; TODO duplicate-line-or-region (&optional n) With negative N, comment out original line and use the absolute value.
; pageup/dn or 75%screenup/dn

; (define-key evil-normal-state-map "e" 'evil-scroll-up)
; (define-key evil-normal-state-map "d" 'evil-scroll-down)


(define-key evil-visual-state-map   (kbd "f") 'mark-whole-buffer)
(define-key evil-visual-state-map   (kbd "J") 'evil-visual-block)
;; triple cycling
;; (define-key evil-visual-state-map (kbd "v") 'evil-visual-block)
;; TODO for mouse http://emacs.stackexchange.com/questions/7244/enable-emacs-column-selection-using-mouse


(cibin/global-set-key '("C-;" . comment-line))
(with-eval-after-load 'flyspell
(define-key flyspell-mode-map  (kbd "C-;") 'comment-line) ; flyspell is overriding
)
(cibin/global-set-key '("C-x C-;" . comment-or-uncomment-region))
(cibin/global-set-key '("C-c C-b" . xah-make-backup-and-save))
(with-eval-after-load 'org

(define-key org-mode-map (kbd "C-c C-b") 'xah-make-backup-and-save)
)
;; You know, like Readline.
(cibin/global-set-key '("C-M-h" . backward-kill-word))

 ;; Align your code in a pretty way.
(cibin/global-set-key '("C-x \\" . align-regexp))




;; Completion that uses many different methods to find options.
(cibin/global-set-key '("M-/" . hippie-expand))


;; Perform general cleanup.
(cibin/global-set-key '("C-c n" . cleanup-buffer))

;; Turn on the menu bar for exploring new modes
(global-set-key (kbd "C-<f10>") (lambda () (interactive) (toggle-menu-bar-mode-from-frame)(toggle-tool-bar-mode-from-frame)))

; (cibin/global-set-key '("<f6>" . switch-to-prev-buffer))
; (cibin/global-set-key '("<f7>" . switch-to-next-buffer))


(global-set-key (kbd "C-k") (lambda () (interactive) (evil-scroll-up nil)))
(global-set-key (kbd "C-j") (lambda () (interactive) (evil-scroll-down nil)))
(define-key evil-insert-state-map (kbd "C-k") (lambda () (interactive) (evil-scroll-up nil)))
(define-key evil-insert-state-map (kbd "C-j") (lambda () (interactive)  (evil-scroll-down nil)))
(define-key evil-normal-state-map (kbd "C-k") (lambda () (interactive) (evil-scroll-up nil)))
(define-key evil-normal-state-map (kbd "C-j") (lambda () (interactive)  (evil-scroll-down nil)))
(with-eval-after-load 'dired
(define-key dired-mode-map "h" (lambda ()  (interactive) (find-alternate-file "..")))
(define-key dired-mode-map (kbd "C-k") (lambda () (interactive) (evil-scroll-up nil)))
(define-key dired-mode-map (kbd "C-j") (lambda () (interactive)  (evil-scroll-down nil)))
(define-key dired-mode-map (kbd "O") 'switch-to-next-buffer)

)
(cibin/global-set-key '("C-l" . switch-to-prev-buffer))
(cibin/global-set-key '("C-o" . switch-to-next-buffer))
;;todo ;; (define-key dired-mode-map (kbd "o") 'switch-to-prev-buffer)

(define-key evil-normal-state-map (kbd "O") 'switch-to-next-buffer)
;;todo ;;(define-key evil-normal-state-map (kbd "o") 'switch-to-prev-buffer)

(define-key evil-insert-state-map (kbd "C-o") 'switch-to-next-buffer)
(define-key evil-normal-state-map (kbd "C-o") 'switch-to-next-buffer)
(define-key evil-normal-state-map (kbd "C-l") 'switch-to-prev-buffer)
(define-key evil-insert-state-map (kbd "C-l") 'switch-to-prev-buffer)


(with-eval-after-load 'org
    ; (define-key org-mode-map (kbd "C-k") 'switch-to-next-buffer)
    (define-key org-mode-map (kbd "C-l") 'switch-to-prev-buffer)
    (define-key org-mode-map (kbd "C-o") 'switch-to-next-buffer)
 ;; TODO maake below work if in orgmode with normal
;; (define-key org-mode-map (kbd "O") 'switch-to-next-buffer)
;; (define-key org-mode-map (kbd "o") 'switch-to-prev-buffer)

	)

;  kill the same line even if at the end of line
(cibin/global-set-key '("C-S-k" . kill-whole-line))

;; TODO create in current major mode
(cibin/global-set-key '("C-x C-n" . xah-new-empty-buffer))


; Mouse Wheel Scrolling
; Scroll up five lines without modifiers
(defun up-slightly () (interactive) (scroll-up 5))
(defun down-slightly () (interactive) (scroll-down 5))
(global-set-key [mouse-4] 'down-slightly)
(global-set-key [mouse-5] 'up-slightly)
; Scroll up five lines with META held
(global-set-key [M-mouse-4] 'down-slightly)
(global-set-key [M-mouse-5] 'up-slightly)
; Scroll up one line with SHIFT held
(defun up-one () (interactive) (scroll-up 1))
(defun down-one () (interactive) (scroll-down 1))
(global-set-key [S-mouse-4] 'down-one)
(global-set-key [S-mouse-5] 'up-one)
; Scroll up one page with CTRL held
(defun up-a-lot () (interactive) (scroll-up))
(defun down-a-lot () (interactive) (scroll-down))
(global-set-key [C-mouse-4] 'down-a-lot)
(global-set-key [C-mouse-5] 'up-a-lot)



;; Font size
(define-key global-map [C-mouse-wheel-up-event] 'cibin/text-scale-increase)
(define-key global-map [C-mouse-wheel-down-event] 'cibin/text-scale-decrease)
(define-key global-map (kbd "C-+") 'cibin/text-scale-increase)
(define-key global-map (kbd "C--") 'cibin/text-scale-decrease)
(defun cibin/text-scale-increase () (interactive) (text-scale-increase .4))
(defun cibin/text-scale-decrease () (interactive) (text-scale-decrease .4))


;; Jump to a definition in the current file. (This is awesome.)
(cibin/global-set-key '("C-x C-i" . ido-imenu))


(cibin/global-set-key '("M-a" . helm-M-x))
(cibin/global-set-key '("M-x" . helm-M-x))

;; TODO enter key may also trigger this 
;;(cibin/global-set-key '("C-m" . helm-M-x))

;; File finding
; https://github.com/emacs-helm/helm/blob/master/helm-files.el


;;; helm-for-files > helm-multi-files > helm-find-files
(cibin/global-set-key '("C-x C-f" . helm-for-files))
(cibin/global-set-key '("M-o" . helm-for-files))

; Fixme: error
; (define-key helm-find-files-map (kbd "C-j") 'helm-find-files-up-one-level)
; (define-key helm-find-files-map (kbd "C-l") 'helm-execute-persistent-action)

(global-set-key (kbd "S-<f4>") (lambda () (interactive)(dired (format "C://Users//%s//Downloads" user-login-name))))

; file searching
(cibin/global-set-key '("C-x M-f" . ido-find-file-other-window))
(cibin/global-set-key '("C-x C-M-f" . find-file-in-project))
;; (cibin/global-set-key '("C-x p" . cibin-find-related-files))
(cibin/global-set-key '("C-x F" . file-cache-ido-find-file))

; text searching
(cibin/global-set-key '("C-x j" . cibin-search-in-text-files-related-bash))
(cibin/global-set-key '("C-x e" . cibin-search-in-files-advgrep-here))

; (global-set-key (kbd "C-x f") (lambda () (interactive)
; (file-cache-read-cache-from-file)
; 'file-cache-ido-find-file
; ))
(cibin/global-set-key '("C-c f" . cibin/launcher))



(cibin/global-set-key '("C-c m" . cibin/music))

; use swiper instead of this
(cibin/global-set-key '("C-x M-j" . cibin/search-all-buffers)) ; multi occur modified
; (cibin/global-set-key '("C-x f" . recentf-ido-find-file))

(cibin/global-set-key '("C-x C" . locate-current-file-in-explorer))
(cibin/global-set-key '("C-x c" . cibin/xah-open-file-at-cursor))

(cibin/global-set-key '("C-c y" . bury-buffer))
(cibin/global-set-key '("C-c r" . revert-buffer))
(cibin/global-set-key '("M-`" . file-cache-minibuffer-complete))
(cibin/global-set-key '("C-x C-b" . cbn/ibuffer))

(require 'expand-region)
; use spc-v & then only v
;; (cibin/global-set-key '("C-=" . er/expand-region))
; TODO "t" was something else
;; (define-key evil-normal-state-map "v" 'er/expand-region)
;; (define-key evil-normal-state-map "t" 'er/expand-region)

(cibin/global-set-key '("M-a" . mark-whole-buffer))
(cibin/global-set-key '("C-\\" . highlight-symbol-at-point))
(cibin/global-set-key '("M-R" . toggle-window-split))

; TODO ; (cibin/global-set-key '("M-f" . split-window-right-and-move-there))
(cibin/global-set-key '("M-F" . split-window-below-and-move-there))
;(cibin/global-set-key '("M-w" . quit-window))
; (cibin/global-set-key '("M-W" . only-current-buffer))

;;; normal
(define-key evil-normal-state-map " m" 'evil-jump-item)
(define-key evil-normal-state-map ",," 'evil-buffer)
(define-key evil-normal-state-map "-" 'delete-other-windows)
;; (define-key evil-normal-state-map "b" 'ido-switch-buffer)
(define-key evil-normal-state-map "B" 'ibuffer)
(define-key evil-normal-state-map "Y" 'copy-to-end-of-line)

; C-x k
; f4/C-x 0=kill buffer
; C-x 0/q/M-q=kill buffer & remove window
; Q/M-Q=maximize/minimize
; C-q
(global-set-key (kbd "<f4>") (lambda () (interactive) (kill-this-buffer)))
(cibin/global-set-key '("M-q" . kill-buffer-and-if-many-kill-window-too))
;; (define-key evil-normal-state-map "q" 'xah-close-current-buffer)
(define-key evil-normal-state-map "q" 'kill-this-buffer-if-not-modified)

(global-set-key (kbd "M-Q") (lambda () (interactive) (spacemacs/toggle-maximize-buffer)))

(define-key evil-normal-state-map "Q" 'cibin/toggle-maximize-buffer)

; is this needed?
(cibin/global-set-key '("C-q" . kill-buffer-and-if-many-kill-window-too))

(cibin/global-set-key '("M-e" . other-window))
(define-key evil-normal-state-map "e" 'other-window)
(define-key evil-visual-state-map   (kbd "f") 'mark-whole-buffer)
;TODO o in visual state was exchange-point-and-mark
(define-key evil-visual-state-map   (kbd "o") 'evil-visual-line)

;; enable Shift+direction for window movements
;; (windmove-default-keybindings)

;; Window switching. (C-x o goes to the next window)

(global-set-key (kbd "C-x O") (lambda () (interactive) (other-window -1))) ;; back one
(global-set-key (kbd "C-x C-o") (lambda () (interactive) (other-window 2))) ;; forward two

;; (cibin/global-set-key '("<f7>" . split-window-right))
(cibin/global-set-key '("<f7>" . hsplit-last-buffer))

(define-key evil-insert-state-map (kbd "C-n") 'evil-next-visual-line)
(define-key evil-normal-state-map (kbd "C-n") 'evil-next-visual-line)
(define-key evil-insert-state-map (kbd "C-p") 'evil-previous-visual-line)
(define-key evil-normal-state-map (kbd "C-p") 'evil-previous-visual-line)
;; (define-key evil-normal-state-map "a" 'helm-M-x)
(define-key evil-normal-state-map "a" nil)
(define-key evil-normal-state-map (kbd "aq") 'hydra-quick-edit/body)

(define-key evil-normal-state-map (kbd "aa") 'cibin-apply-default-major-mode)
(define-key evil-normal-state-map "gl" 'end-of-buffer) ;evil-goto-line) ; goto last line
; goto last line in insert mode
(define-key evil-normal-state-map "gk" (lambda (arg)

      (interactive "p")
      (end-of-buffer)(open-line arg)(next-line 1)
	  ; TODO
      ; (when newline-and-indent
        ;(indent-according-to-mode))
	(evil-insert 1)
))
; TODO: gj was evil next visual line, give some other hotkey
; TODO: same as C-return; remove gj
(define-key evil-normal-state-map "gj" 'open-previous-line-move-down)

(defun open-previous-line-move-down (arg)
	"insert a line and push the text by one line down"
	(interactive "p")
	(beginning-of-line)(open-line arg)(next-line 1)
	(when newline-and-indent
		(indent-according-to-mode)))


(define-key evil-normal-state-map "ga" (lambda (arg)

      (interactive "p")
      (beginning-of-buffer)(open-line arg)(evil-insert 1)
))
; TODO: gk was evil previous visual-line, map it to somewhere else

; key-chord
(use-package key-chord
:defer t)
;(require 'key-chord)

; (key-chord-define-global "jj" 'avy-goto-word-1)
; (key-chord-define-global "jl" 'avy-goto-line)
; (key-chord-define-global "jk" 'avy-goto-char)
; (key-chord-define-global "JJ" 'crux-switch-to-previous-buffer)
; (key-chord-define-global "uu" 'undo-tree-visualize)
; (key-chord-define-global "xx" 'execute-extended-command)
; (key-chord-define-global "yy" 'browse-kill-ring)

; (key-chord-define-global "o0" 'find-file)
; (key-chord-define-global "o=" 'dired-jump)
; (key-chord-define-global "o-" 'ido-recentf-open)
; (key-chord-define-global "o[" 'find-file-at-point)

;And one for projectile:

; (key-chord-define-global "p-" 'projectile-find-file)

;I also bind replace-string to something useful:

; (key-chord-define-global "r4" 'replace-string)
; (key-chord-define-global "r3" 'vr/query-replace)

;And I use expand/contract region a lot too:

; (key-chord-define-global "e3" 'er/expand-region)
; (key-chord-define-global "e2" 'er/contract-region)
; (key-chord-define-global "\}\}" 'undo-tree-switch-branch)

; (key-chord-define-global "]'"   'completion-at-point)
; (key-chord-define-global "[;"   'completion-at-point)
; (key-chord-define-global ";."   'completion-at-point)

; (key-chord-define-global ";u" 'undo-tree-visualize)
; (key-chord-define-global ";j" 'ace-jump-mode)
; (key-chord-define-global ";s" 'monky-status)
; (key-chord-define-global ";c" 'comment-dwim)


; buffer actions
; (key-chord-define-global "vg"     'eval-region)
; (key-chord-define-global "vb"     'eval-buffer)
; (key-chord-define-global "cy"     'yank-pop)
; (key-chord-define-global "cg"     "\C-c\C-c")
; frame actions
; (key-chord-define-global "xo"     'other-window);
; (key-chord-define-global "x1"     'delete-other-windows)
; (key-chord-define-global "x0"     'delete-window)


; (key-chord-define-global "xk"     'kill-this-buffer-if-not-modified)
; file actions
; (key-chord-define-global "bf"     'ido-switch-buffer)
; (key-chord-define-global "cf"     'ido-find-file)
; (key-chord-define-global "vc"     'vc-next-action)



; (key-chord-define-global ";x" 'execute-extended-command) ;; Meta-X

; window management:
; (key-chord-define-global ";2" 'double-window)
; (key-chord-define-global ";3" 'triple-window)
; (key-chord-define-global ";8" 'eighty-columns)
; (key-chord-define-global ";w" 'one-hundred-thirty-two-columns)
; (key-chord-define-global ";s" 'rotate-windows)  ;; "s" for switch

(defvar key-chord-tips '("Press <jj> quickly to jump to the beginning of a visible word."
                         "Press <jl> quickly to jump to a visible line."
                         "Press <jk> quickly to jump to a visible character."
                         "Press <JJ> quickly to switch to previous buffer."
                         "Press <uu> quickly to visualize the undo tree."
                         "Press <xx> quickly to execute extended command."
                         "Press <yy> quickly to browse the kill ring."))

(key-chord-mode +1)



; https://github.com/syohex/emacs-dired-k

(cibin/global-set-key '("RET" . newline-and-indent))

;; make shell-command-on-region work on line if no region is active
(cibin/global-set-key '("M-|" . sh-send-line-or-region))

;; Start eshell or switch to it if it's active.
(cibin/global-set-key '("C-x m" . eshell))


;; Start a new eshell even if one is active.
(global-set-key (kbd "C-x M") (lambda () (interactive) (eshell t)))

;; Start a regular shell if you prefer that.
(cibin/global-set-key '("C-x M-m" . shell))

;; If you want to be able to M-x without meta (phones, etc)
(cibin/global-set-key '("C-x C-m" . execute-extended-command))

;; Fetch the contents at a URL, display it raw.
;;(cibin/global-set-key '("C-x C-h" . view-url))

;; Help should search more than just commands
; (cibin/global-set-key '("C-h a" . apropos))

;; Should be able to eval-and-replace anywhere.
(cibin/global-set-key '("C-c e" . eval-and-replace))

;; For debugging Emacs modes
(cibin/global-set-key '("C-c p" . message-point))

;; So good!
(cibin/global-set-key '("C-x m" . magit-mode))
(cibin/global-set-key '("C-x g" . magit-status))
(cibin/global-set-key '("C-c q" . join-line))

;; This is a little hacky since VC doesn't support git add internally
(eval-after-load 'vc
  (define-key vc-prefix-map "i" '(lambda () (interactive)
                                   (if (not (eq 'Git (vc-backend buffer-file-name)))
                                       (vc-register)
                                     (shell-command (format "git add %s" buffer-file-name))
                                     (message "Staged changes.")))))
(with-eval-after-load 'org

;; Org
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
)

(cibin/global-set-key '("<C-up>" . xah-backward-block))
(cibin/global-set-key '("<C-down>" . xah-forward-block))





(defun my/quick-view-file-at-point ()
  "Preview the file at point then jump back after some idle time.

In order for this to work you need to bind this function to a key combo,
you cannot call it from the minibuffer and let it work.

The reason it works is that by holding the key combo down, you inhibit
idle timers from running so as long as you hold the key combo, the
buffer preview will still display."
  (interactive)
  (setq-local lexical-binding t)
  (let* ((buffer (current-buffer))
         (file (thing-at-point 'filename t))
         (file-buffer-name (format "*preview of %s*" file)))
    (if (and file (file-exists-p file))
        (let ((contents))
          (if (get-buffer file)
              (setq contents (save-excursion
                               (with-current-buffer (get-buffer file)
                                 (font-lock-fontify-buffer)
                                 (buffer-substring (point-min) (point-max)))))
            (let ((new-buffer (find-file-noselect file)))
              (with-current-buffer new-buffer
                (font-lock-mode t)
                (font-lock-fontify-buffer)
                (setq contents (buffer-substring (point-min) (point-max))))
              (kill-buffer new-buffer)))
          (switch-to-buffer (get-buffer-create file-buffer-name))
          (setq-local header-line-format "%60b")
          (delete-region (point-min) (point-max))
          (save-excursion (insert contents))
          (local-set-key (kbd "C-M-v") (lambda () (interactive) (sit-for .2)))
          (run-with-idle-timer
           .7
           nil
           (lambda ()
             (switch-to-buffer buffer)
             (kill-buffer file-buffer-name))))
      (message "no file to preview at point!"))))

(cibin/global-set-key '("C-M-v" . my/quick-view-file-at-point))

; There are some hooks that allow to do things when we enter or exit a mode (see the pdf manual).
; For example, to save the buffer when we exit the insert mode:

   (defun my-save-if-bufferfilename ()
     (if (buffer-file-name)
         (progn
           (save-buffer)
           )
       (message "no file is associated to this buffer: do nothing")
       )
   )
   (add-hook 'evil-insert-state-exit-hook 'my-save-if-bufferfilename)

                                        ; or only in evil’s normal state:


   ;; INCREMENT AND DECREMENT numbers in Emacs

(cibin/global-set-key '("C-c +" . evil-numbers/inc-at-pt))
(cibin/global-set-key '("C-c -" . evil-numbers/dec-at-pt))

(define-key evil-normal-state-map (kbd "C-f") 'evil-forward-char)
(define-key evil-normal-state-map (kbd "C-b") 'evil-backward-char)
(define-key evil-normal-state-map (kbd "C-u") 'universal-argument)


(define-key evil-normal-state-map (kbd "C-c +") 'evil-numbers/inc-at-pt)
(define-key evil-normal-state-map (kbd "C-c -") 'evil-numbers/dec-at-pt)

; For window system users the keypad + and - present an alternative that can be directly bound without shadowing the regular + and -:

(define-key evil-normal-state-map (kbd "<kp-add>") 'evil-numbers/inc-at-pt)
(define-key evil-normal-state-map (kbd "<kp-subtract>") 'evil-numbers/dec-at-pt)


;; Set the maximum length (in characters) for key descriptions (commands or
;; prefixes). Descriptions that are longer are truncated and have ".." added.
(setq which-key-max-description-length 34)
(setq which-key-side-window-max-height 0.6)



; M-. can conflict with etags tag search. But C-. can get overwritten
; by flyspell-auto-correct-word. And goto-last-change needs a really
; fast key.
; ensure that even in worst case some goto-last-change is available
; (global-set-key [(control meta .)] 'goto-last-change)

 


;C-./> last-change
;C-, = zap
; C-< = zap upto
; select till end of line
; del entire line
; select till beg of line usE CAPsLOCK
; select till beg of file capslock u



;; This function kills the region if active and kills the backward word if it is not.
(defun sk/kill-region-or-backward-word (arg)
  (interactive "p")
  (if (region-active-p)
      (kill-region (region-beginning) (region-end))
    (backward-kill-word arg)))
(global-set-key (kbd "C-w" ) 'sk/kill-region-or-backward-word)
(define-key evil-normal-state-map (kbd "C-w" ) 'sk/kill-region-or-backward-word)

(define-key evil-normal-state-map (kbd "f") 'avy-goto-char-timer)


(define-key evil-normal-state-map  (kbd "C-S-y") 'evil-unimpaired/paste-below)
(define-key evil-normal-state-map  (kbd "C-M-y") 'evil-unimpaired/paste-above)


(global-set-key [(control x) (control r)] 'rename-this-file)

(with-eval-after-load 'drag-stuff
; enable drag-stuff globally, use:
(drag-stuff-global-mode 1))
(cibin/global-set-key '("M-p" . drag-stuff-up))
(cibin/global-set-key '("M-n" . drag-stuff-down))
(cibin/global-set-key '("M-<up>" . drag-stuff-up))
(cibin/global-set-key '("M-<down>" . drag-stuff-down))

;; TODO  conflicting org-mode-map even after re assigning in org-mode-map
;;(cibin/global-set-key '("M-<left>" . drag-stuff-left))
;;(cibin/global-set-key '("M-<right>" . drag-stuff-right))

 ;; override dragg-stuff
(with-eval-after-load 'org
(define-key org-mode-map (kbd "M-<left>") 'cibin/org-do-promote)
(define-key org-mode-map  (kbd "M-<right>") 'org-do-demote) )


; (cibin/global-set-key '("M-p" . move-line-region-up))
; (cibin/global-set-key '("M-n" . move-line-region-down))
; (cibin/global-set-key '("M-<up>" . move-line-region-up))
; (cibin/global-set-key '("M-<down>" . move-line-region-down))
; (cibin/global-set-key '("M-<up>" . move-line-up))
; (cibin/global-set-key '("M-<down>" . move-line-down))

; (cibin/global-set-key '("M-<up>" . move-region-up))
; (cibin/global-set-key '("M-<down>" . move-region-down))


(with-eval-after-load 'company
  (define-key company-active-map (kbd "C-h") 'delete-backward-char ))
  
(define-key evil-insert-state-map (kbd "C-h")   'delete-backward-char)
(global-set-key [?\C-h] 'delete-backward-char)
(cibin/global-set-key '( "\C-h" . delete-backward-char))
; (global-set-key [?\C-x ?h] 'help-command)    ;; overrides mark-whole-buffer

; kill the current visible buffer without confirmation unless the buffer has been modified. In this last case, you have to answer y/n.

(global-set-key [(control x) (k)] 'kill-this-buffer)



(cibin/global-set-key '("M-D" . my-kill-word-at-point))
(cibin/global-set-key '("C-y" .  yank))
(cibin/global-set-key '("C-w" .  evil-delete))

(define-key evil-visual-state-map "\C-y" 'yank)

;; (define-key evil-normal-state-map "\C-w" 'evil-delete)
;; (define-key evil-insert-state-map "\C-w" 'evil-delete)
(define-key evil-insert-state-map "\C-r" 'search-backward)

(define-key evil-visual-state-map "\C-w" 'evil-delete)





; (dolist (binding
 ; `(
   ; ("Q" . cibin/toggle-maximize-buffer)
   ; ))
   
   ;; list of key bindings
   (setq binding `(
   ("Q" . cibin/toggle-maximize-buffer)
   ))
   
   
(dolist  (binding)
	
	(with-eval-after-load 'dired
	(define-key dired-mode-map (car binding) (cdr binding)))

	(define-key evil-normal-state-map (car binding) (cdr binding))
	;;;;;; (define-key org-mode-map (car binding) (cdr binding)
	(with-eval-after-load 'org

		(evil-define-key 'normal org-mode-map  (car binding) (cdr binding))
	)
	;;;;;;;;(add-hook 'org-mode-hook (lambda ()(define-key org-mode-map (car binding) (cdr binding))))  )
)


 ; delete till non whitespace cycle 
;; (cibin/global-set-key '("C-D" . xah-shrink-whitespaces))
(cibin/global-set-key '("C-S-d" . shrink-whitespace))
(cibin/global-set-key '("C-d" . delete-char))
;; (define-key evil-normal-state-map (kbd "C-D")   'xah-shrink-whitespaces)
(define-key evil-insert-state-map (kbd "C-d")   'delete-char)
(define-key evil-normal-state-map (kbd "C-d")   'delete-char)
(define-key evil-insert-state-map (kbd "C-S-d")   'shrink-whitespace)
(define-key evil-normal-state-map (kbd "C-S-d")   'shrink-whitespace)
                                        ; (cibin/global-set-key '("M-SPC" . fc/delete-space))
; (cibin/global-set-key '("<M-Spc>" . fixup-whitespace))
; (cibin/global-set-key '("C-c M-d" . fc/delete-space))


(provide 'starter-kit-bindings)
