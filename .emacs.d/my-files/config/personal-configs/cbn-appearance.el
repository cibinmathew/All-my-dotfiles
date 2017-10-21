(message "loading cbn-appearance")
 ;; TODO debug this
 
 ; ===============================
 ;;; highlight-focus.el --- highlight the active buffer

;; Author: Amit J Patel <amitp@cs.stanford.edu>

;;; Commentary:
;; 
;; I find that I'm not good at tracking when focus changes across
;; apps, windows, and within a window. As much as possible, I try to
;; have all my applications somehow draw attention to what has
;; focus. In X11 I marked the focus in red. In Firefox I marked the
;; text fields in yellow. This Emacs package highlights the active
;; buffer. It's inspired by an earlier package I had written for
;; XEmacs, which changes the window color and modeline color for the
;; current window.
;;
;;; History:
;;
;; 2014-05-07: Updated to use the Emacs 24 focus-{in,out}-hook
;; 2013-05-10: Rewritten to use the Emacs 23 "remap faces" feature.
;; 2007-04-16: Initial version, temporarily highlighting the active buffer

;; Also see <https://github.com/emacsmirror/auto-dim-other-buffers>

;;; Code:

;; (require 'face-remap)
;; (defvar highlight-focus:last-buffer nil)
;; (defvar highlight-focus:cookie nil)
;; (defvar highlight-focus:background "red")
;; (defvar highlight-focus:app-has-focus t)

;; (defun highlight-focus:check ()
  ;; "Check if focus has changed, and if so, update remapping."
  ;; (let ((current-buffer (and highlight-focus:app-has-focus (current-buffer))))
    ;; (unless (eq highlight-focus:last-buffer current-buffer)
      ;; (when (and highlight-focus:last-buffer highlight-focus:cookie)
        ;; (with-current-buffer highlight-focus:last-buffer
          ;; (face-remap-remove-relative highlight-focus:cookie)))
      ;; (setq highlight-focus:last-buffer current-buffer)
      ;; (when current-buffer
        ;; (setq highlight-focus:cookie
              ;; (face-remap-add-relative 'default :background highlight-focus:background))))))

;; (defun highlight-focus:app-focus (state)
  ;; (setq highlight-focus:app-has-focus state)
  ;; (highlight-focus:check))

;; (defadvice other-window (after highlight-focus activate)
  ;; (highlight-focus:check))
;; (defadvice select-window (after highlight-focus activate)
  ;; (highlight-focus:check))
;; (defadvice select-frame (after highlight-focus activate)
  ;; (highlight-focus:check))
;; (add-hook 'window-configuration-change-hook 'highlight-focus:check)

;; (add-hook 'focus-in-hook (lambda () (highlight-focus:app-focus t)))
;; (add-hook 'focus-out-hook (lambda () (highlight-focus:app-focus nil)))




(require 'highlight-thing)
(global-highlight-thing-mode)
; Alternatively you can use the buffer-local version:
; (add-hook 'prog-mode-hook 'highlight-thing-mode)
; The default is to highlight the symbol under point, but you can customize hightlight-thing-what-thing to highlight different components. Set the following to only highlight the word under point:
; (setq highlight-thing-what-thing 'word)
(setq highlight-thing-delay-seconds 1.0)
; You can configure the matching of occurrences to be case-sensitive via the following setting:
; (setq highlight-thing-case-sensitive-p t)
; If you want all the matches highlighted but not the one occurrence at the point itself, you can do so by:
(setq highlight-thing-exclude-thing-under-point t)

 (require 'mic-paren) ; loading
     (paren-activate)     ; activating
	 ; TODO http://emacs.stackexchange.com/questions/5569/disable-mic-paren-in-the-minibuffer-or-at-least-in-ido

;; active and inactive buffer mode-line	 
(set-face-attribute  'mode-line
                 nil 
                 :foreground "gray80"
                 :background "#258b29" 
                 ;; :background "#2e8b57" 
                 :box '(:line-width 1 :style released-button))
(set-face-attribute  'mode-line-inactive
                 nil 
                 :foreground "gray30"
                 :background "gray15" 
                 :box '(:line-width 1 :style released-button))
(defun after-load-theme() 
  "run after a color theme is loaded using `load-theme'."
;; comment face	 
(set-face-attribute  'font-lock-comment-face nil :foreground "gray55" :background nil )
(set-face-attribute  'font-lock-comment-delimiter-face nil :foreground "green4")
(load-file "~/.emacs.d/my-files/config/personal-configs/tabbar-tweaks.el")
)

;; to override some theme settings
(defadvice load-theme (after after-load-theme activate)
  "Run `after-load-theme'."
  (after-load-theme))


; (load-file "~/.emacs.d/my-files/config/others/theme-changer.el")
; (require 'theme-changer)
; (setq calendar-location-name "Dallas, TX") 
; (setq calendar-latitude 32.85)
; (setq calendar-longitude -96.85)
;;; Specify the day and night themes:
; (change-theme 'solarized-light 'solarized-dark) 


;; <Color theme initialization code>
(setq current-theme '(color-theme-solarized-light))

(defun cibin/synchronize-theme() 
	(setq now 'spacemacs-dark)
	(setq hour (string-to-number (substring (current-time-string) 11 13)))
	(if (member hour (number-sequence 6 12)) (setq now 'spacemacs-light) nil)
	(if (member hour (number-sequence 12 17)) (setq now 'solarized-light) nil)
	(if (member hour (number-sequence 18 19)) (setq now 'solarized-dark) nil)

	(message (format "new theme is %s" now))
	(if (eq now current-theme)
		nil
		(setq current-theme now)
		(load-theme now t) ) ) ;; end of (defun ...
(run-with-timer 0 3600 'cibin/synchronize-theme)

                                              ;; MSEARCH
(load-file "~/.emacs.d/my-files/config/others/msearch.el")
;; http://makble.com/how-to-highlight-text-on-selection-in-emacs
;; enable to do it with keyboard selection using hooks.

(add-hook 'post-command-hook
  (lambda ()    
    (if (use-region-p)
      (progn
        (msearch-cleanup)
        (msearch-set-word (buffer-substring-no-properties (region-beginning)  (region-end)))
      )
      (msearch-cleanup)
    )
  )
)
(msearch-mode 1) 


;; create custom major modes http://ergoemacs.org/emacs/elisp_syntax_coloring.html

;; HIGHLIGHT NORMAL TEXT
; add debuggermode fundamental mode etc
; (add-hook 'after-change-major-mode-hook 'highlight-text)
(add-hook 'text-mode-hook 'highlight-text)
; (add-hook 'fundamental-mode-hook 'highlight-text)
; Do not use fundamental-mode -- at least not interactively. You rarely want to be in fundamental-mode. There is almost always something better.
; The whole point of fundamental-mode is to not have the usual major-mode handling (hooks etc.). You can think of fundamental-mode as kind of like an abstract class
(defun highlight-text ()
;;todo add comment line usinf syntax table
       ; (font-lock-add-keywords nil '(("\\([0-9]+\\)" 1 font-lock-warning-face prepend)))
       (font-lock-add-keywords nil '(("\\(\"[^\"]*\"\\)" 1 font-lock-constant-face prepend)))
       (font-lock-add-keywords nil '(("\\([=:#]*\\)" 1 font-lock-function-name-face prepend)))
                  (highlight-numbers-mode 1)
                  (rainbow-delimiters-mode 1)
                  (show-paren-mode 1)
)

;; todo create minor mode
(setq kwds
      '(("Sin\\|Cos\\|Sum" . font-lock-function-name-face)
        ("Pi\\|Infinity" . font-lock-constant-face)))
(define-minor-mode blah-mode
  "Doc string."
  nil "blah" nil
  (font-lock-add-keywords nil kwds)

  (if (fboundp 'font-lock-flush)
      (font-lock-flush)
    (when font-lock-mode
      (with-no-warnings (font-lock-fontify-buffer)))))
(make-face 'hard-to-read-font)
(set-face-attribute 'hard-to-read-font nil :background "darkgrey" :foreground "grey")


;;; HARD TO READ MODE
;;http://stackoverflow.com/questions/4462126/emacs-minor-mode-for-temporarily-modifying-the-default-face
(define-minor-mode hard-to-read-mode
  "This mode might be useful when you don't like certain text to be seen over your shoulders."
  :init-value nil :lighter " hard-to-read" :keymap nil
  (if hard-to-read-mode
      (progn
        (font-lock-mode nil)
        (buffer-face-mode t)
        (buffer-face-set 'hard-to-read-font))
    (progn (font-lock-mode t) (buffer-face-mode nil))))
;; (add-hook 'text-mode-hook (lambda () (hard-to-read-mode t))) 

;;should be loaded after loading standard library
;;    `menu-bar.el'.  So, in your `~/.emacs' file, do this:
 (eval-after-load "menu-bar" '(require 'menu-bar+))

;; make end of buffer visible
(setq indicate-buffer-boundaries t)

;; (setq-default indicate-empty-lines t)

(provide 'cbn-appearance)
