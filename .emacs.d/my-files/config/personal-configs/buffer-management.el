(message "loading buffer-management")
;; Ensure ibuffer opens with point at the current buffer's entry.
(defadvice ibuffer
  (around ibuffer-point-to-most-recent) ()
  "Open ibuffer with cursor pointed to most recent buffer name."
  (let ((recent-buffer-name (buffer-name)))
    ad-do-it
    (ibuffer-jump-to-buffer recent-buffer-name)))
(ad-activate 'ibuffer)

;; ask-before-killing-buffer-if-running-or-modified
;; kill-all-other-buffers-if-not-modified
;; kill-buffer-if-not-modified = builtin
;; kill-buffer-and-if-many-kill-window-too

(defun kill-buffer-and-if-many-kill-window-too () (interactive)
       ;; TODO
       ;; (message (format "ask   %s" (ask-before-killing-buffer-if-running-or-modified)))
      ;; (when (ask-before-killing-buffer-if-running-or-modified)
        ;; (kill-this-buffer)
(kill-this-buffer-if-not-modified)
(when (not (one-window-p))
  (delete-window))
         ;; )
       ;; (ask-before-killing-buffer-if-running-or-modified)
       (message "kill-buffer-and-if-many-kill-window-too"))


(defun kill-all-other-buffers-if-not-modified ()
  "Kill all other buffers."
  (interactive)
    (setq buffers-to-kill (delq (current-buffer) (buffer-list)))
  (mapc 'kill-buffer-if-not-modified buffers-to-kill))
  
(defun kill-this-buffer-if-not-modified ()
  (interactive)
  ; taken from menu-bar.el
  (if (menu-bar-non-minibuffer-window-p)
      (kill-buffer-if-not-modified (current-buffer))
    (abort-recursive-edit)))


;; TODO make this run not just for current buffer
;; http://amitp.blogspot.in/2007/03/emacs-dont-kill-unsaved-buffers.html
(defun ask-before-killing-buffer-if-running-or-modified ()
(interactive)
  (let ((buffer (current-buffer)))
    (cond
     ;; (
      ;; (equal (buffer-name) "*scratch*")
      ;; Never kill *scratch*
      ;; nil)
     ((and buffer-file-name (buffer-modified-p))
      ;; If there's a file associated with the buffer, 
      ;; make sure it's saved
      (y-or-n-p (format "Buffer %s modified; kill anyway? " 
                    (buffer-name))))
     ((get-buffer-process buffer)
      ;; If there's a process associated with the buffer, 
      ;; make sure it's dead
      (y-or-n-p (format "Process %s active; kill anyway? "
                    (process-name (get-buffer-process buffer)))))
     (t t)
     )))
;; (add-to-list 'kill-buffer-query-functions 'ask-before-killing-buffer)





;; (message "%s" 
     ;; (delete (current-buffer) (seq-filter #'buffer-file-name (buffer-list))))

(defun cibin-next-modified-buffer ()
  (interactive)
  (next-buffer)
  (let ((i 0))
    (while (< i 20)
      (if (not (and buffer-file-name (buffer-modified-p)))
          (progn (next-buffer)
                 (setq i (1+ i)))
        (progn (setq i 100))))))

(defun cibin-previous-modified-buffer ()
  (interactive)
  (previous-buffer)
  (let ((i 0))
    (while (< i 20)
      (if (not (and buffer-file-name (buffer-modified-p)))
          (progn (previous-buffer)
                 (setq i (1+ i)))
        (progn (setq i 100))))))
(cibin/global-set-key '("<f11>" . cibin-next-modified-buffer))
(cibin/global-set-key '("S-<f11>" . cibin-previous-modified-buffer))

;; in helm-mini, to enable fuzzy matching, add the following settings: 
(setq helm-buffers-fuzzy-matching t
      helm-recentf-fuzzy-match    t)

(defun kill-buffers-from-same-folder-recursively()
                                        ; http://stackoverflow.com/questions/32822036/how-to-kill-all-buffers-with-buffer-file-in-a-certain-location

  (interactive)
(setq this (file-name-directory buffer-file-name))
(mapc (lambda (buffer)
(setq file-name (buffer-file-name buffer))
                                        ; todo to handle dired
                                        ; (let ((file-name
               ;(or (buffer-file-name buffer)
                   ;; In dired-mode we need `dired-directory' which
                   ;; might be a list and may not be fully expanded.
                ;   (with-current-buffer buffer
                 ;    (and (eq major-mode 'dired-mode)
                  ;        (expand-file-name
                   ;        (if (consp dired-directory)
                    ;           (car dired-directory)
                     ;        dired-directory)))))
                 ;    ))

          (when (and file-name
           (string-prefix-p (file-name-directory (buffer-file-name buffer)) file-name t))
            ; todo kill buffer ; (kill-this-buffer-if-not-modified)
            ;(kill-buffer buffer)
            (kill-buffer-if-not-modified buffer)
            ) 
            )      (buffer-list))
      )


(defun cibin/helm-find-files ()
  (interactive)
  (helm :sources '(
 helm-source-files-in-current-dir
 helm-source-findutils
                   helm-source-recentf
                   helm-source-buffers-list
                   helm-source-locate

 ;; helm-source-buffer-not-found
                   ;helm-source-google-suggest
    helm-source-bookmarks
    helm-source-file-cache
                   )
        :buffer "*helm all the things*")
        )

(setq helm-mini-default-sources '(helm-source-buffers-list
 helm-source-files-in-current-dir
                                  helm-source-recentf
                                  helm-source-bookmarks
                                  helm-source-buffer-not-found))
;; helm-for-files
;; http://pragmaticemacs.com/emacs/find-and-open-files-from-anywhere-with-helm-for-files/
;; limit max number of matches displayed for speed
    (setq helm-candidate-number-limit 100)
    ;; ignore boring files like .o and .a
    ;; TODO disabled for now (setq helm-ff-skip-boring-files t)

;; Update: On helm version >=2.4.0 this is now the default.
;; (setq helm-locate-command "locate %s -e -A --regex %s")

;; replace locate with spotlight on Mac
    ;; (setq helm-locate-command "mdfind -name %s %s"))
    ;; (setq helm-locate-command "locate-with-mdfind %.0s %s")

;; http://amitp.blogspot.in/2012/10/emacs-helm-for-finding-files.html
(setq helm-idle-delay 0.1)
(setq helm-input-idle-delay 0.1)
;; TODO disabling helm-boring-file-regexp-list for now
; (loop for ext in '("\\.swf$" "\\.elc$" "\\.pyc$")
      ; do (add-to-list 'helm-boring-file-regexp-list ext))

; or only in evil’s normal state:
										


;; File finding
; https://github.com/emacs-helm/helm/blob/master/helm-files.el


;;; helm-for-files > helm-multi-files > helm-find-files
(cibin/global-set-key '("C-x C-f" . cibin/helm-find-files))
(cibin/global-set-key '("M-o" . cibin/helm-find-files))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Custom splitting functions ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; I added these snippets to my .emacs so that when I split the screen with C-x 2 or C-x 3, it opens the previous buffer instead of giving me two panes with the same buffer:
(defun vsplit-last-buffer ()
  (interactive)
  (split-window-vertically)
  (other-window 1 nil)
  (switch-to-next-buffer)
  )
  
(defun hsplit-last-buffer ()
  (interactive)
   (split-window-horizontally)
  (other-window 1 nil)
  (switch-to-next-buffer)
  )

(cibin/global-set-key '("C-x 2" . vsplit-last-buffer))
(cibin/global-set-key '("C-x 3" . hsplit-last-buffer))


(defun find-next-file-in-current-directory (&optional backward)
  "Find the next file (by name) in the current directory.
;; https://emacs.stackexchange.com/a/12164
With prefix arg, find the previous file."
  (interactive "P")
  (when buffer-file-name
    (let* ((file (expand-file-name buffer-file-name))
           (files (cl-remove-if (lambda (file) (cl-first (file-attributes file)))
                                (sort (directory-files (file-name-directory file) t nil t) 'string<)))
           (pos (mod (+ (cl-position file files :test 'equal) (if backward -1 1))
                     (length files))))
      (find-file (nth pos files)))))

(defun buffer/switch-in-directory ()
  "Switch between buffers in same directory."
  (interactive)
  (helm
   :prompt "Buffer switch: "
   :sources  `((
		(name       . "Dir: ")                                 
		(candidates . ,(mapcar (lambda (b) (cons (buffer-name b) b))
		   ;; filter buffers not in this directory (code bellow)
		   (remove-if-not  (lambda (b)
				 (buffer/with-file-in-directory-p
				  (or (file-name-directory (buffer-file-name))
					  default-directory
					  )
				  b
				  ))
			  (buffer-list)
			  )))
		(action     . switch-to-buffer)
		))))

(defun cbn/ibuffer()
  (interactive)

  (ibuffer)
  (spacemacs/maximize-horizontally)
  )
(provide 'buffer-management)
