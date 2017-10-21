
;; keymaps

;; commands in search-map and facemenu-keymap
(xah-fly-map-keys
 (define-prefix-command 'xah-highlight-keymap)
 '(

   ("b" . facemenu-set-bold)
   ("f" . font-lock-fontify-block)
   ("c" . center-line)
   ("d" . facemenu-set-default)

   ("h" . highlight-symbol-at-point)
   ;; temp
   ("." . isearch-forward-symbol-at-point)
   ("1" . hi-lock-find-patterns)
   ("2" . highlight-lines-matching-regexp)
   ("3" . highlight-phrase)
   ("4" . highlight-regexp)
   ("5" . unhighlight-regexp)
   ("6" . hi-lock-write-interactive-patterns)
   ("s" . isearch-forward-symbol)
   ("w" . isearch-forward-word)

   ("i" . facemenu-set-italic)
   ("l" . facemenu-set-bold-italic)
   ("o" . facemenu-set-face)
   ("p" . center-paragraph)

   ("u" . facemenu-set-underline)
   ))

(xah-fly-map-keys
 (define-prefix-command 'xah-leader-tab-keymap)
 '(
   ("TAB" . indent-for-tab-command)

   ("i" . complete-symbol)
   ("g" . indent-rigidly)
   ("r" . indent-region)
   ("s" . indent-sexp)

   ;; temp
   ("1" . abbrev-prefix-mark)
   ("2" . edit-abbrevs)
   ("3" . expand-abbrev)
   ("4" . expand-region-abbrevs)
   ("5" . unexpand-abbrev)
   ("6" . add-global-abbrev)
   ("7" . add-mode-abbrev)
   ("8" . inverse-add-global-abbrev)
   ("9" . inverse-add-mode-abbrev)
   ("0" . expand-jump-to-next-slot)
   ("=" . expand-jump-to-previous-slot)))



(xah-fly-map-keys
 (define-prefix-command 'xah-leader-c-keymap)
 '(
   ("," . xah-open-in-external-app)
   ("." . find-file)
   ("c" . bookmark-bmenu-list)
   ("e" . ibuffer)
   ("u" . find-file-at-point)
   ("h" . recentf-open-files)
   ("l" . bookmark-set)
   ("n" . xah-new-empty-buffer)
   ("o" . xah-open-in-desktop)
   ("p" . xah-open-last-closed)
   ("f" . xah-open-recently-closed)
   ("y" . xah-list-recently-closed)
   ("r" . bookmark-jump)
   ("s" . write-file)
   ))

(xah-fly-map-keys
 (define-prefix-command 'xah-help-keymap)
 '(
   (";" . Info-goto-emacs-command-node)
   ("a" . apropos-command)
   ("b" . describe-bindings)
   ("c" . describe-char)
   ("d" . apropos-documentation)
   ("e" . view-echo-area-messages)
   ("f" . describe-face)
   ("g" . info-lookup-symbol)
   ("h" . describe-function)
   ("i" . info)
   ("j" . man)
   ("k" . describe-key)
   ("K" . Info-goto-emacs-key-command-node)
   ("l" . view-lossage)
   ("m" . xah-describe-major-mode)
   ("n" . describe-variable)
   ("o" . describe-language-environment)
   ("p" . finder-by-keyword)
   ("r" . apropos-variable)
   ("s" . describe-syntax)
   ("u" . elisp-index-search)
   ("v" . apropos-value)
   ("z" . describe-coding-system)))

(xah-fly-map-keys
 (define-prefix-command 'xah-leader-i-keymap) ; commands in goto-map
 '(
   ("TAB" . move-to-column)
   ("c" . goto-char)
   ("t" . goto-line)
   ("n" . next-error)
   ("d" . previous-error
    )))

(xah-fly-map-keys
 ;; commands here are harmless (safe). They don't modify text.
 ;; they turn on minor/major mode, change display, prompt, start shell, etc.
 (define-prefix-command 'xah-harmless-keymap)
 '(
   ("SPC" . whitespace-mode)
   ("RET" . nil)
   ("TAB" . nil)
   ("DEL" . nil)
   ("," . abbrev-mode)
   ("." . toggle-frame-fullscreen)
   ("'" . frame-configuration-to-register)
   (";" . window-configuration-to-register)
   ("1" . set-input-method)
   ("2" . global-hl-line-mode)
   ("4" . linum-mode)
   ("5" . visual-line-mode)
   ("6" . calendar)
   ("7" . calc)
   ("8" . nil)
   ("9" . shell-command)
   ("0" . shell-command-on-region)
   ("a" . text-scale-adjust)
   ("b" . toggle-debug-on-error)
   ("c" . toggle-case-fold-search)
   ("d" . narrow-to-page)
   ("e" . eshell)
   ("f" . nil)
   ("g" . nil)
   ("h" . widen)
   ("i" . make-frame-command)
   ("j" . nil)
   ("k" . menu-bar-open)
   ("l" . toggle-word-wrap)
   ("m" . global-linum-mode)
   ("n" . narrow-to-region)
   ("o" . nil)
   ("p" . read-only-mode) ; toggle-read-only
   ("q" . nil)
   ("r" . nil)
   ("s" . flyspell-buffer)
   ("t" . narrow-to-defun)
   ("u" . shell)
   ("v" . variable-pitch-mode)
   ("w" . eww)
   ("x" . save-some-buffers)
   ("y" . nil)
   ("z" . abort-recursive-edit)))

(xah-fly-map-keys
   ;; kinda replacement related
 (define-prefix-command 'xah-edit-cmds-keymap)
 '(
   ("SPC" . rectangle-mark-mode)
   ("9" . delete-non-matching-lines)
   ("0" . delete-duplicate-lines)
   ("," . apply-macro-to-region-lines)
   ("." . kmacro-start-macro)
   ("p" . kmacro-end-macro)
   ("e" . call-last-kbd-macro)
   ("c" . replace-rectangle)
   ("d" . delete-rectangle)
   ("g" . kill-rectangle)
   ("l" . clear-rectangle)
   ("n" . rectangle-number-lines)
   ("o" . open-rectangle)
   ("r" . yank-rectangle)
   ("t" . delete-matching-lines)
   ("y" . delete-whitespace-rectangle)))

(xah-fly-map-keys
 (define-prefix-command 'xah-leader-t-keymap)
 '(
   ("SPC" . xah-clean-whitespace)
   ("TAB" . nil)
   ("3" . point-to-register)
   ("4" . jump-to-register)
   ("." . sort-lines)
   ("," . sort-numeric-fields)
   ("'" . reverse-region)
   ("d" . mark-defun)
   ("e" . list-matching-lines)
   ("j" . copy-to-register)
   ("k" . insert-register)
   ("l" . increment-register)
   ("m" . xah-make-backup-and-save)
   ("n" . repeat-complex-command)
   ("p" . query-replace-regexp)
   ("r" . copy-rectangle-to-register)
   ("t" . repeat)
   ("w" . xah-next-window-or-frame)
   ("z" . number-to-register)))

(xah-fly-map-keys
 (define-prefix-command 'xah-danger-keymap)
 '(
   ("DEL" . xah-delete-current-file)
   ("." . eval-buffer)
   ("e" . eval-defun)
   ("m" . eval-last-sexp)
   ("p" . eval-expression)
   ("u" . eval-region)
   ("q" . save-buffers-kill-terminal)
   ("w" . delete-frame)
   ("j" . xah-run-current-file)))

(xah-fly-map-keys
 (define-prefix-command 'xah-insertion-keymap)
 '(
   ("RET" . insert-char)
   ("SPC" . xah-insert-unicode)
   ("b" . xah-insert-black-lenticular-bracket【】)
   ("c" . xah-insert-ascii-single-quote)
   ("d" . xah-insert-double-curly-quote“”)
   ("f" . xah-insert-emacs-quote)
   ("g" . xah-insert-ascii-double-quote)
   ("h" . xah-insert-brace) ; {}
   ("i" . xah-insert-curly-single-quote‘’)
   ("m" . xah-insert-corner-bracket「」)
   ("n" . xah-insert-square-bracket) ; []
   ("p" . xah-insert-single-angle-quote‹›)
   ("r" . xah-insert-tortoise-shell-bracket〔〕 )
   ("s" . xah-insert-string-assignment)
   ("t" . xah-insert-paren)
   ("u" . xah-insert-date)
   ("w" . xah-insert-angle-bracket〈〉)
   ("W" . xah-insert-double-angle-bracket《》)
   ("y" . xah-insert-double-angle-quote«»)))

(xah-fly-map-keys
 (define-prefix-command 'xah-coding-system-keymap)
 '(

   ("n" . set-file-name-coding-system)
   ("s" . set-next-selection-coding-system)
   ("c" . universal-coding-system-argument)
   ("f" . set-buffer-file-coding-system)
   ("k" . set-keyboard-coding-system)
   ("l" . set-language-environment)
   ("p" . set-buffer-process-coding-system)
   ("r" . revert-buffer-with-coding-system)
   ("t" . set-terminal-coding-system)
   ("x" . set-selection-coding-system)

))

(progn
  (define-prefix-command 'xah-fly-leader-key-map)
  (define-key xah-fly-leader-key-map (kbd "SPC") 'xah-fly-insert-mode-activate)
  (define-key xah-fly-leader-key-map (kbd "DEL") 'xah-close-current-buffer)
  (define-key xah-fly-leader-key-map (kbd "RET") (if (fboundp 'smex) 'smex 'execute-extended-command ))
  (define-key xah-fly-leader-key-map (kbd "TAB") xah-leader-tab-keymap)

  (define-key xah-fly-leader-key-map "." xah-highlight-keymap)

  (define-key xah-fly-leader-key-map "'" 'xah-fill-or-unfill)
  (define-key xah-fly-leader-key-map "," 'universal-argument)
  (define-key xah-fly-leader-key-map "-" 'xah-display-page-break-as-line)
  (define-key xah-fly-leader-key-map "/" nil)
  (define-key xah-fly-leader-key-map ";" nil)
  (define-key xah-fly-leader-key-map "=" nil)
  (define-key xah-fly-leader-key-map "[" nil)
  (define-key xah-fly-leader-key-map (kbd "\\") nil)
  (define-key xah-fly-leader-key-map "`" nil)

  (define-key xah-fly-leader-key-map "1" nil)
  (define-key xah-fly-leader-key-map "2" nil)
  (define-key xah-fly-leader-key-map "3" 'delete-window)
  (define-key xah-fly-leader-key-map "4" 'split-window-right)
  (define-key xah-fly-leader-key-map "5" nil)
  (define-key xah-fly-leader-key-map "6" nil)
  (define-key xah-fly-leader-key-map "7" nil)
  (define-key xah-fly-leader-key-map "8" nil)
  (define-key xah-fly-leader-key-map "9" 'ispell-word)
  (define-key xah-fly-leader-key-map "0" nil)

  (define-key xah-fly-leader-key-map "a" 'mark-whole-buffer)
  (define-key xah-fly-leader-key-map "b" 'end-of-buffer)
  (define-key xah-fly-leader-key-map "c" xah-leader-c-keymap)
  (define-key xah-fly-leader-key-map "d" 'beginning-of-buffer)
  (define-key xah-fly-leader-key-map "e" xah-insertion-keymap)
  (define-key xah-fly-leader-key-map "f" 'xah-search-current-word)
  (define-key xah-fly-leader-key-map "g" 'isearch-forward)
  (define-key xah-fly-leader-key-map "h" 'xah-help-keymap)
  (define-key xah-fly-leader-key-map "i" 'xah-copy-file-path)
  (define-key xah-fly-leader-key-map "j" 'xah-cut-all-or-region)
  (define-key xah-fly-leader-key-map "k" 'yank)
  (define-key xah-fly-leader-key-map "l" 'recenter-top-bottom)
  (define-key xah-fly-leader-key-map "m" 'dired-jump)
  (define-key xah-fly-leader-key-map "n" xah-harmless-keymap)
  (define-key xah-fly-leader-key-map "o" 'exchange-point-and-mark)
  (define-key xah-fly-leader-key-map "p" 'query-replace)
  (define-key xah-fly-leader-key-map "q" 'xah-copy-all-or-region)
  (define-key xah-fly-leader-key-map "r" xah-edit-cmds-keymap)
  (define-key xah-fly-leader-key-map "s" 'save-buffer)
  (define-key xah-fly-leader-key-map "t" xah-leader-t-keymap)
  (define-key xah-fly-leader-key-map "u" 'switch-to-buffer)
  (define-key xah-fly-leader-key-map "v" nil)
  (define-key xah-fly-leader-key-map "w" xah-danger-keymap)
  (define-key xah-fly-leader-key-map "x" nil)
  (define-key xah-fly-leader-key-map "y" xah-leader-i-keymap)
  (define-key xah-fly-leader-key-map "z" nil))


;;;; misc

;; these commands have keys in emacs, but right now i decided not to give them a key

;; C-x C-p	mark-page
;; C-x C-l	downcase-region
;; C-x C-u	upcase-region

;; C-x C-t	transpose-lines
;; C-x C-o	delete-blank-lines

;; C-x C-r	find-file-read-only
;; C-x C-v	find-alternate-file

;; C-x =	what-cursor-position, use describe-char instead
;; C-x <	scroll-left
;; C-x >	scroll-right
;; C-x [	backward-page
;; C-x ]	forward-page
;; C-x ^	enlarge-window

;; C-x {	shrink-window-horizontally
;; C-x }	enlarge-window-horizontally
;; C-x DEL	backward-kill-sentence

;; C-x C-z	suspend-frame
;; C-x +	balance-windows

;; C-x k	kill-buffer , use xah-close-current-buffer
;; C-x l	count-lines-page
;; C-x m	compose-mail


;; undecided yet

;; C-x e	kmacro-end-and-call-macro
;; C-x q	kbd-macro-query
;; C-x C-k	kmacro-keymap

;; C-x C-d	list-directory
;; C-x C-n	set-goal-column
;; C-x ESC	Prefix Command
;; C-x $	set-selective-display
;; C-x *	calc-dispatch
;; C-x -	shrink-window-if-larger-than-buffer
;; C-x .	set-fill-prefix

;; C-x 4	ctl-x-4-prefix
;; C-x 5	ctl-x-5-prefix
;; C-x 6	2C-command
;; C-x ;	comment-set-column

;; C-x `	next-error
;; C-x f	set-fill-column
;; C-x i	insert-file
;; C-x n	Prefix Command
;; C-x r	Prefix Command

;; C-x C-k C-a	kmacro-add-counter
;; C-x C-k C-c	kmacro-set-counter
;; C-x C-k C-d	kmacro-delete-ring-head
;; C-x C-k C-e	kmacro-edit-macro-repeat
;; C-x C-k C-f	kmacro-set-format
;; C-x C-k TAB	kmacro-insert-counter
;; C-x C-k C-k	kmacro-end-or-call-macro-repeat
;; C-x C-k C-l	kmacro-call-ring-2nd-repeat
;; C-x C-k RET	kmacro-edit-macro
;; C-x C-k C-n	kmacro-cycle-ring-next
;; C-x C-k C-p	kmacro-cycle-ring-previous
;; C-x C-k C-s	kmacro-start-macro
;; C-x C-k C-t	kmacro-swap-ring
;; C-x C-k C-v	kmacro-view-macro-repeat
;; C-x C-k SPC	kmacro-step-edit-macro
;; C-x C-k b	kmacro-bind-to-key
;; C-x C-k e	edit-kbd-macro
;; C-x C-k l	kmacro-edit-lossage
;; C-x C-k n	kmacro-name-last-macro
;; C-x C-k q	kbd-macro-query
;; C-x C-k r	apply-macro-to-region-lines
;; C-x C-k s	kmacro-start-macro



;; C-x 4 C-f	find-file-other-window
;; C-x 4 C-o	display-buffer
;; C-x 4 .	find-tag-other-window
;; C-x 4 0	kill-buffer-and-window
;; C-x 4 a	add-change-log-entry-other-window
;; C-x 4 b	switch-to-buffer-other-window
;; C-x 4 c	clone-indirect-buffer-other-window
;; C-x 4 d	dired-other-window
;; C-x 4 f	find-file-other-window
;; C-x 4 m	compose-mail-other-window
;; C-x 4 r	find-file-read-only-other-window

;; C-x 6 2	2C-two-columns
;; C-x 6 b	2C-associate-buffer
;; C-x 6 s	2C-split
;; C-x 6 <f2>	2C-two-columns

  ;; (define-key xah-leader-i-keymap (kbd "r") ctl-x-5-map)

;; r C-f     find-file-other-frame
;; r C-o     display-buffer-other-frame
;; r .       find-tag-other-frame
;; r 0       delete-frame
;; r 1       delete-other-frames
;; r 2       make-frame-command
;; r b       switch-to-buffer-other-frame
;; r d       dired-other-frame
;; r f       find-file-other-frame
;; r m       compose-mail-other-frame
;; r o       other-frame
;; r r       find-file-read-only-other-frame

;; (xah-fly-map-keys
;;  (define-prefix-command 'xah-leader-vc-keymap)
;;  '(
;;    ("+" . vc-update)
;;    ("=" . vc-diff)
;;    ("D" . vc-root-diff)
;;    ("L" . vc-print-root-log)
;;    ("a" . vc-update-change-log)
;;    ("b" . vc-switch-backend)
;;    ("c" . vc-rollback)
;;    ("d" . vc-dir)
;;    ("g" . vc-annotate)
;;    ("h" . vc-insert-headers)
;;    ("l" . vc-print-log)
;;    ("m" . vc-merge)
;;    ("r" . vc-retrieve-tag)
;;    ("s" . vc-create-tag)
;;    ("u" . vc-revert)
;;    ("v" . vc-next-action)
;;    ("~" . vc-revision-other-window)))

;; ;; 2013-11-04 make emacs auto show suggestions when a prefix key is pressed
;; (require 'guide-key)
;; (guide-key-mode 1)


;; setting keys


      (define-key xah-fly-key-map (kbd "C-a") 'mark-whole-buffer)
      (define-key xah-fly-key-map (kbd "C-k") 'yank-pop)
      (define-key xah-fly-key-map (kbd "C-n") 'xah-new-empty-buffer)
      (define-key xah-fly-key-map (kbd "C-S-n") 'make-frame-command)
      (define-key xah-fly-key-map (kbd "C-o") 'find-file)
      (define-key xah-fly-key-map (kbd "C-s") 'save-buffer)
      (define-key xah-fly-key-map (kbd "C-S-s") 'write-file)
      (define-key xah-fly-key-map (kbd "C-S-t") 'xah-open-last-closed)
      (define-key xah-fly-key-map (kbd "C-v") 'yank)
      (define-key xah-fly-key-map (kbd "C-w") 'xah-close-current-buffer)
      (define-key xah-fly-key-map (kbd "C-z") 'undo)

      (define-key xah-fly-key-map (kbd "C-+") 'text-scale-increase)
      (define-key xah-fly-key-map (kbd "C--") 'text-scale-decrease)
      (define-key xah-fly-key-map (kbd "C-0") (lambda () (interactive) (text-scale-set 0)))
    (define-key xah-fly-key-map (kbd "M-RET") 'xah-cycle-hyphen-underscore-space)
    
    (define-key xah-fly-key-map (kbd "M-n") 'xah-insert-square-bracket)
    (define-key xah-fly-key-map (kbd "M-t") 'xah-insert-paren)
    (define-key xah-fly-key-map (kbd "M-l") 'left-char) ; rid of downcase-word


  (define-key xah-fly-key-map (kbd "<f11>") 'xah-previous-user-buffer)
  (define-key xah-fly-key-map (kbd "<f12>") 'xah-next-user-buffer)
  (define-key xah-fly-key-map (kbd "<C-f11>") 'xah-previous-emacs-buffer)
  (define-key xah-fly-key-map (kbd "<C-f12>") 'xah-next-emacs-buffer)

  (progn
    



  (define-key xah-fly-key-map (kbd "'") 'xah-reformat-lines)
      (define-key xah-fly-key-map (kbd ",") 'xah-shrink-whitespaces)
      (define-key xah-fly-key-map (kbd "-") 'xah-cycle-hyphen-underscore-space)
      (define-key xah-fly-key-map (kbd ".") 'backward-kill-word)
      (define-key xah-fly-key-map (kbd "/") 'xah-backward-equal-sign)
      (define-key xah-fly-key-map (kbd "=") 'xah-forward-equal-sign)
      (define-key xah-fly-key-map (kbd "[") 'xah-backward-quote )
      (define-key xah-fly-key-map (kbd "]") 'xah-forward-quote-smart)
      (define-key xah-fly-key-map (kbd "`") 'other-frame)
          (define-key xah-fly-key-map (kbd "2") 'xah-select-line)
          (define-key xah-fly-key-map (kbd "1") 'xah-extend-selection))
        (define-key xah-fly-key-map (kbd "7") 'xah-select-current-line)
        (define-key xah-fly-key-map (kbd "8") 'xah-extend-selection)))

    (define-key xah-fly-key-map (kbd "3") 'delete-other-windows)
    (define-key xah-fly-key-map (kbd "4") 'split-window-below)
    (define-key xah-fly-key-map (kbd "6") 'xah-select-block)
    (define-key xah-fly-key-map (kbd "9") 'xah-select-text-in-quote)
    
    (define-key xah-fly-key-map (kbd "a") (if (fboundp 'smex) 'smex 'execute-extended-command ))
    (define-key xah-fly-key-map (kbd "m") 'xah-backward-left-bracket)
	
    (define-key xah-fly-key-map (kbd "p") 'kill-word)
    (define-key xah-fly-key-map (kbd "q") 'xah-copy-line-or-region)
    (define-key xah-fly-key-map (kbd "s") 'xah-end-of-line-or-block)
    (define-key xah-fly-key-map (kbd "v") 'xah-forward-right-bracket)
    (define-key xah-fly-key-map (kbd "z") 'xah-goto-matching-bracket)

    ;;

;;; xah-fly-keys.el ends here
(provide 'cbn-xah-fly-keys)