(message "loading snarfed")
; https://snarfed.org/dotfiles/.emacs



; https://snarfed.org/dotfiles/.emacs
(defvar my-local-shells
  '("*shell0*" "*shell1*" "*shell2*" "*shell3*" "*shell4*" "*music*"))
(defvar my-remote-shells '("*snarfed*"))

(defvar my-shells (append my-local-shells my-remote-shells))



;; run a few shells.
(defun start-my-shells ()
  (interactive)
  (let ((default-directory "~")
        ;; trick comint into thinking the current window is 82 columns, since it
        ;; uses that to set the COLUMNS env var. otherwise it uses whatever the
        ;; current window's width is, which could be anything.
        (window-width (lambda () 82)))
    (mapcar 'shell my-local-shells)
    ;; prompt to run this once at startup on mac os x
    (with-current-buffer "*shell0*"
      (insert "/Users/ryan/src/misc/macosx_startup.sh"))
    (run-python (concat "/usr/local/bin/python -i " (getenv "HOME") "/.python"))
    (with-current-buffer "*Python*" (emacs-lock-mode))
    ;; (async-shell-command
    ;;  "godoc --http=:6060 --index -v --index_files=/usr/local/go/godoc_index"
    ;;  "*godoc*")
    ;; (with-current-buffer "*godoc*" (emacs-lock-mode))
    ))
	(defadvice start-my-shells (after color-fringe-arrow activate)
  "Color the marker arrow (for compilation, debugger, etc.) in the margin.
Advice only because it breaks on emacs 23.2 if it runs directly
in .emacs at startup. Looks like set-fringe-bitmap-face isn't
defined while starting with --daemon, but works fine while
starting normally. Grr."
  (make-face 'blue-fringe-arrow)
  (set-face-attribute 'blue-fringe-arrow nil :foreground "blue")
  (if (>= emacs-major-version 23)
      (set-fringe-bitmap-face 'right-triangle 'blue-fringe-arrow)))

(when (or window-system (server-running-p))
  (start-my-shells))
(defun fix-shell ()
  "Sometimes the input area of a shell buffer goes read only. This fixes that."
  (interactive)
  (let ((inhibit-read-only t))
    (comint-send-input)))

(defun exit-all-shells ()
  (mapcar (lambda (name)
            (if (get-buffer-process name)
                (comint-send-string (get-buffer-process name) "exit\n")))
          my-local-shells))
(add-hook 'kill-emacs-hook 'exit-all-shells)


