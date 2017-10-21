

(defun duplicate-current-line-or-region (arg)
  "Duplicates the current line or region ARG times.
If there's no region, the current line will be duplicated. However, if
there's a region, all lines that region covers will be duplicated."
  (interactive "p")
  (let (beg end (origin (point)))
    (if (and mark-active (> (point) (mark)))
        (exchange-point-and-mark))
    (setq beg (line-beginning-position))
    (if mark-active
        (exchange-point-and-mark))
    (setq end (line-end-position))
    (let ((region (buffer-substring-no-properties beg end)))
      (dotimes (i arg)
        (goto-char end)
        (newline)
        (insert region)
        (setq end (point)))
      (goto-char (+ origin (* (length region) arg) arg)))))

(cibin/global-set-key '("C-c d" . duplicate-current-line-or-region))


 
(defun my-backward-kill-word ()
  (interactive)
  (setq word-delimiter-regexp "[-\s\"\(\):\;'=]")
  (setq word-delimiter-regexp-negated "[^-\s\"\(\):\;'=]+")

  (if (looking-at word-delimiter-regexp)

	(let ((p (point)))
		(if (looking-at "\\(.\\)\\1+")
			
			; select all repeated characters
			(progn
				(re-search-forward "\\(.\\)\\1+" nil :no-error)
			 ; (backward-char)
			 
		   )

		   ; delete adjacent special chars one by one
		   (setq p (+ (point) 1))

		   )
			(kill-region (point) p )
		   )

		; delete till next special char if at starting of an alphabet
		(let ((p (point)))
			;    (re-search-forward "[\w]+" nil :no-error)
			; TODO subwords are not considered here
			(re-search-forward word-delimiter-regexp-negated nil :no-error)
			;(backward-char)
			(kill-region p (point))
     )

	; delete the word
	   ; (kill-word 1)
	   ; (forward-word)
	   ;(re-search-forward "\\w+")
   )
)
(cibin/global-set-key '("M-d" . my-backward-kill-word)) 
; ----(cibin/global-set-key '("M-d" . my-backward-kill-word)) 

(defun cbn-delete-char (arg)
  "Delete characters forward until encountering the end of a word.
With argument, do this that many times.
This command does not push text to `kill-ring'."


; TODO backspace, but delete if at end of file
  (interactive "p")
  (delete-region
   (point)
   (progn
     (forward-char arg)
     (point))))

(define-key evil-normal-state-map (kbd "x") 'cbn-delete-char)


;; (cibin/global-set-key '("M-K" . join-lines))
(cibin/global-set-key '("M-K" . pull-this-line-up))
(cibin/global-set-key '("M-J" . pull-next-line-join-region-lines))

(defun pull-this-line-up()
"pull the next line onto the end of the current line, compressing whitespace."
(interactive)
(previous-logical-line 1)
  (move-end-of-line 1) 
  (kill-line)
  (just-one-space)
;; (move-end-of-line 1)
)

;; TODO remove if pull-next-line-join-lines is working fine
(defun pull-next-line()
"pull the next line onto the end of the current line, compressing whitespace."
  (interactive) 
  (move-end-of-line 1) 
  (kill-line)
  (just-one-space))

(defun  pull-next-line-join-region-lines(n)
;; https://medium.com/@4d47/join-lines-in-emacs-cc40a55e4539
  "Join N lines."
  (interactive "p")
    (if (use-region-p)
      (let ((fill-column (point-max)))
        (fill-region (region-beginning) (region-end)))
      (dotimes (_ (abs n))
        (delete-indentation (natnump n))))
  (move-end-of-line 1) 
    )
(defun cibin/toggle-maximize-buffer () (interactive) (spacemacs/toggle-maximize-buffer)(message "spacemacs/toggle-maximize-buffer"))


(provide 'basic-settings2)