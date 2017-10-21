(message "loading cbn-dired-show")
;; introducing dired-show, a mini ranger-like preview browsing style.
;; https://gitlab.com/emacs-stuff/my-elisp/commit/ab54aa4f38f2e23a906a7576908e28de6d68e16e


;; Show buffer content when exploring a directory with Dired.
;; Press "n"/p to show the next/previous buffer in other window. Useful to
;; have a glimpse of files when exploring a directory.
;; It is possible to browse without file previews with the arrow keys.

;; nice feature of the ranger file manager.

;; Try it and see how it goes.

(defgroup cbn-dired-show nil
  "See the file at point when browsing in a Dired buffer."
  :group 'dired
  )

(setq show-next-current-buffer nil)

(defun show-next ()
     (interactive)
     (next-line 1)
     (dired-find-file-other-window)
     (if show-next-current-buffer (kill-buffer show-next-current-buffer))
     (setq show-next-current-buffer (current-buffer))
     (other-window 1)
     )

(defun show-previous ()
     (interactive)
     (previous-line 1)
     (dired-find-file-other-window)
     (if show-next-current-buffer (kill-buffer show-next-current-buffer))
     (setq show-next-current-buffer (current-buffer))
     (other-window 1)
     )


(define-minor-mode cbn-dired-show-mode
  "Toggle preview of files when browsing in a Dired buffer."
  :global t
  :group 'cbn-dired-show
  (if cbn-dired-show-mode
      (progn
        (define-key dired-mode-map "j" 'show-next)
        (define-key dired-mode-map "k" 'show-previous)
        )
  (define-key dired-mode-map "j" 'diredp-next-line)
  (define-key dired-mode-map "k" 'diredp-previous-line)
  ))

(provide 'cbn-dired-show)
;;; dired-show ends here
