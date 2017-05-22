; how hellow are you
; how hellow are you
; how hellow are you
; how hellow are you
; how hellow are you

;; TODO
(defun select-column-till-next-blank-line()
  (interactive)
  (setq start (point))
(set-mark-command nil)
  (setq hpos (- (point) (point-at-bol)))
(re-search-forward "\n[\t\n ]*\n+" nil "NOERROR")
  (if (search-backward-regexp "\n[\t\n ]*\n+" nil "NOERROR")
          (progn (skip-chars-backward "\n\t "))
        (progn (goto-char (point-min)))
        )
(move-to-column hpos t)
  ;; (setq end (point))
(set-mark end)
(set-mark start)
  (activate-mark)
  ;; (call-interactively 'evil-visual-block)
  ;; (evil-visual-block)
 ;; (setq deactivate-mark nil)
)


;; (global-set-key (kbd "C-S-n") 'select-column-till-next-blank-line)

(defun next-line-non-empty-column (arg)
  "Find next line, on the same column, skipping those that would
end up leaving point on a space or newline character."
  (interactive "p")
  (let* ((hpos (- (point) (point-at-bol)))
         (re (format "^.\\{%s\\}[^\n ]" hpos)))
    (cond ((> arg 0)
           (forward-char 1) ; don't match current position (can only happen at column 0)
           (re-search-forward re))
          ((< arg 0)
           (forward-char -1)           ; don't match current position.
           (re-search-backward re)
           (goto-char (match-end 0))))
    ;; now point is after the match, let's go back one column.
    (forward-char -1)))
(defun previous-line-non-empty-column (arg)
  ""
  (interactive "p")
  (next-line-non-empty-column (- arg)))

;; (global-set-key (kbd "C-S-n") 'next-line-non-empty-column)
;; (global-set-key (kbd "C-S-p") 'previous-line-non-empty-column)



;; For parens you can do M-(. For brackets/braces/quotes you could do: 
(global-set-key (kbd "M-[") 'insert-pair)
(global-set-key (kbd "M-{") 'insert-pair)
(global-set-key (kbd "M-\"") 'insert-pair)
;; Note that if you don't have a region highlighted, it will just insert the pair of whatevers and put the cursor in between them. Also handy for deleting matching whatevers is

(global-set-key (kbd "M-)") 'delete-pair)

;; OR
;; https://github.com/nivekuil/corral
(global-set-key (kbd "M-9") 'corral-parentheses-backward)
;; (global-set-key (kbd "M-0") 'corral-parentheses-forward)
 (global-set-key (kbd "M-[") 'corral-brackets-backward)
 (global-set-key (kbd "M-]") 'corral-brackets-forward)
(global-set-key (kbd "M-{") 'corral-braces-backward)
(global-set-key (kbd "M-}") 'corral-braces-forward)
(global-set-key (kbd "M-\"") 'corral-double-quotes-backward)
;; The wrapping algorithm tries to follow these rules:

;; If the point is over a word, it will always wrap around that word.
;; Otherwise, backward and forward commands should have different effects.

(use-package corral
  :config
  (defhydra hydra-corral (:columns 4)
    "Corral"
    ("(" corral-parentheses-backward "Back")
    (")" corral-parentheses-forward "Forward")
    ("[" corral-brackets-backward "Back")
    ("]" corral-brackets-forward "Forward")
    ("{" corral-braces-backward "Back")
    ("}" corral-braces-forward "Forward")
    ("." hydra-repeat "Repeat"))
  )
  (global-set-key (kbd "C-c c") #'hydra-corral/body)


;; http://irreal.org/blog/?p=330
;; sort by rectangle
;; sort by column sort-columns

;; https://www.masteringemacs.org/article/sorting-text-line-field-regexp-emacs
;; sort-fields
;; sort-lines
;; sort-regex-fields



(setq exec-path (append exec-path '("c:/cygwin64/bin")))
(setq find-program "C:\\cygwin64\\bin\\find.exe")

(defun cibin/normal-mode()

  (interactive)
  (message "normal mode")
  ;; (linum-mode 1)
(global-linum-mode 1)
  )

(defun cibin/essential-mode()

  (interactive)
  (message "essential mode")
(linum-mode -1)
(nlinum-mode -1)
(global-nlinum-mode -1)
(line-number-mode -1)
(global-linum-mode -1)
  )

(defun cibin/faster-mode()

  (interactive)
  (message "faster mode")
(linum-mode -1)
(nlinum-mode -1)
;; (global-nlinum-mode-mode -1)
(line-number-mode -1)
(global-linum-mode -1)
(font-lock-mode -1)


;; (ignore-errors
 (with-demoted-errors
(unload-feature 'ispell t)
(unload-feature 'org-settings t)
(unload-feature 'realgud t)
(unload-feature 'filecache t)
(unload-feature 'neotree t)
(unload-feature 'keyfreq t)
;(unload-feature 'tabbar t)
;; (unload-feature 'popwin t)
(unload-feature 'corral t)
(unload-feature 'elpy t)
(unload-feature 'nlinum t)
)
)

(defun write-file-to-temp-file ()
  (interactive)
  (setq filepath  "~/.emacs.d/my-files/emacs-temporary/scratch-buffer.txt")
  (write-region (point-min) (point-max) filepath)
  )

(defun return-filepath()
  (interactive)
(if (equal major-mode 'dired-mode)
             (expand-file-name default-directory)
(progn  (if (not (and buffer-file-name (file-exists-p buffer-file-name)))
    (write-file-to-temp-file)
  (buffer-file-name)
  ))
)
)
(defun return-source-path()
  (interactive)
(if (equal major-mode 'dired-mode)
             (expand-file-name default-directory)
(progn  (if (not (and buffer-file-name (file-exists-p buffer-file-name)))
    (write-file-to-temp-file)
 (file-name-directory (buffer-file-name))
  ))
)
)
(provide 'added-april)
