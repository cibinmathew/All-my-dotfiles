(message "loading buttonize-buffer")

; Clickable file,url links
; TODO this has one more solution
; http://superuser.com/questions/331895/how-to-get-emacs-to-highlight-and-link-file-paths
(define-button-type 'find-file-button
  'follow-link t
  'action #'find-file-button)

(defun find-file-button (button)
  (find-file (buffer-substring (button-start button) (button-end button))))

;; https://www.abc.com
;; www.abc.com
;; ftp://www.abc.com
;; c:/cbn
;; c:\cbn\a.txt
;; /c/cbn/a.txt
;; a
;;; TODO a diff soln with expansion https://superuser.com/a/331898


;This is perfect. I did some more characters to avoid... re-search-forward "/nfs[^ \t\n,\'\"]*" .. there's probably more that I will find, but it's easy enough to add. – Gregory Aug 14 '10 at 17:40
(defun buttonize-buffer ()
  "turn all file paths into buttons"
  (interactive)
; for forward slash paths
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward "\\(ftp:/\\|.:\\|~\\|https?:/\\)?/[^\t\n\",]*" nil t)
      (make-button (match-beginning 0) (match-end 0) :type 'find-file-button)))

	  ; for backaward slash paths
(save-excursion
    (goto-char (point-min))
    (while (re-search-forward "\\(.:\\|~\\)?\\\\[^\t\n\",]*" nil t)
      (make-button (match-beginning 0) (match-end 0) :type 'find-file-button))))

	  ; TODO buttonize-buffer to support mulitline files

;; https://superuser.com/questions/331895/how-to-get-emacs-to-highlight-and-link-file-paths
                                        ; /cygdrive/c/cbn_gits/port_files.py
										  (use-package ffap
  :defer t) 
(defun buttonize-buffer-smart-guess ()
  "Turn all file paths and URLs into buttons."
  (interactive)

  (deactivate-mark)
  (let (token guess beg end reached bound len)
    (save-excursion
      (setq reached (point-min))
      (goto-char (point-min))
      (while (re-search-forward ffap-next-regexp nil t)
        ;; There seems to be a bug in ffap, Emacs 23.3.1: `ffap-file-at-point'
        ;; enters endless loop when the string at point is "//".
        (setq token (ffap-string-at-point))
        (unless (string= "//" (substring token 0 2))
          ;; Note that `ffap-next-regexp' only finds some "indicator string" for a
          ;; file or URL. `ffap-string-at-point' blows this up into a token.
          (save-excursion
            (beginning-of-line)
            (when (search-forward token (point-at-eol) t)
              (setq beg (match-beginning 0)
                    end (match-end 0)
                    reached end))
            )
          (message "Found token %s at (%d-%d)" token beg (- end 1))
          ;; Now let `ffap-guesser' identify the actual file path or URL at
          ;; point.
          (when (setq guess (ffap-guesser))
            (message "  Guessing %s" guess)
            (save-excursion
              (beginning-of-line)
              (when (search-forward guess (point-at-eol) t)
                (setq len (length guess) end (point) beg (- end len))
                ;; Finally we found something worth buttonizing. It shall have
                ;; at least 2 chars, however.
                (message "    Matched at (%d-%d]" beg (- end 1))
                (unless (or (< (length guess) 2))
                  (message "      Buttonize!")
                  (make-button beg end :type 'find-file-button))
                )
              )
            )
          ;; Continue one character after the guess, or the original token.
          (goto-char (max reached end))
          (message "Continuing at %d" (point))
          )
        )
      )
    )
 )
; (add-hook 'find-file-hook 'buttonize-buffer)   ; uncomment to add to find file
;; A nicer solution is to "lazily buttonize" buffers:

(defun buttonize-current-buffer-on-idle (&optional secs)
  "Idle-timer (see \\[run-with-idle-timer]) that buttonizes filenames and URLs.
SECS defaults to 60 seconds idle time."
  (interactive)
  (run-with-idle-timer (or secs 60) t 'buttonize-buffer))

; (add-hook 'after-init-hook 'buttonize-current-buffer-on-idle)
(provide 'buttonize-buffer)