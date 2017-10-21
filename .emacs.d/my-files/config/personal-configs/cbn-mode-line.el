(message "loading cbn-mode-line")
; http://amitp.blogspot.in/2011/08/emacs-custom-mode-line.html#more



; to have the name of the file as the name of the window:
;; (setq frame-title-format '(buffer-file-name "Emacs: (%f)" "Emacs: %b"))
;; (setq frame-title-format `(,(user-login-name) "@" ,(system-name) "     ", (global-mode-string) "     %f" ))
  (setq frame-title-format
        '(
          "Emacs: ("
          (:eval (if (buffer-file-name)
                  (abbreviate-file-name (buffer-file-name))
                    "(%f) %b"))
      ")"
      (:eval (if (buffer-modified-p) 
                 "  •"))
      "         [ "
      (:eval (format "%s" major-mode ))
      "/ %m ]                 "
      (:eval (if (< 15 (length (format "%s" (car command-history) ))) (subseq (format "%s" (car command-history) ) 1 (- (length (format "%s" (car command-history) )) 15))(format "%s" (car command-history) ) ) )

      (:eval
   (format "    |   %s "  last-command)
   ;; (format "%s        |   %s " (car command-history) last-command)
 (global-mode-string  global-mode-string)
 ;; (format "%s" last-command ) 
 )
"                           | %s"
      )
 )
;(setq frame-title-format mode-line-format)
;( set-frame-parameter        nil 'title (format-mode-line mode-line-format))
                                        ; Don't move back the cursor one position when exiting insert mode



 ; todo: length of this line
; enhanced status bar(slower) show count of occurence of present word
;; Mode line setup


(defvar my-mode-line-buffer-line-count nil)
(make-variable-buffer-local 'my-mode-line-buffer-line-count)
(setq-default
 mode-line-format
 '( 
;; "l:"
 ;; (:eval
 ;; (propertize      (format "%s" (car command-history)) 'face 'mode-line-stats-face)
 ;; (propertize      (format "%s" last-command ) 'face 'mode-line-stats-face)
;; )
"%e" mode-line-front-space
        (:eval
			  (propertize "%n "  'face 'mode-line-selection-face) ; narrow
			  )
			  ; "%Z "
                ;; Standard info about the current buffer
                mode-line-mule-info
                mode-line-client
                ; mode-line-modified
   ; read-only or modified status

                
   ;; (:eval
    ;; (propertize
     ;; 'face 'mode-line-modified-face))


                  ;; (:eval
    ;; (cond (buffer-read-only
           ;; (propertize      (format "%s" major-mode ) 'face 'mode-line-read-only-face))
           ;; (if (buffer-modified-p)
           ;; (propertize      (format "%s*" major-mode ) 'face 'mode-line-modified-face)
           ;; (propertize      (format "%s " major-mode ) 'face 'mode-line-stats-face)
          ;; ))
 (:eval   (cond (buffer-read-only (propertize " RO " 'face 'mode-line-modified-face))
nil
          (t "  ")))
		mode-line-remote
    " | "
	; show percentage
    (-4 "%p%")
" "
    ;; " L%l"
 (:eval   (propertize " L%l " 'face 'mode-line-selection-face) )
	 (:eval 
                         (let ((str ""))
                           (when (and (not (buffer-modified-p)) my-mode-line-buffer-line-count)
                             (setq str (concat str "/" my-mode-line-buffer-line-count)))
                           str))
 ;; show column number
   ;; ":" (:eval (propertize "%3c" 'face (if (>= (current-column) 80) 'mode-line-80col-face 'mode-line-position-face)))   

   " | "
	(:propertize "All: len %i %IB" face mode-line-stats-face)
	; (:eval 
		; (setq lineCount 0)
		; (setq lineCount (count-lines (point-min) (point-max)))
		; (propertize lineCount 'face 'mode-line-stats-face)
		; (propertize (format "lines: %s" lineCount) 'face 'mode-line-stats-face)
	; )
	
	; (size-indication-mode ("/" (-5 "%I")))QS
	; Position, including warning for 80 columns
	; (line-number-mode ("%4l" (column-number-mode ":%3c")))
   ;; (:propertize "%4l:" face mode-line-position-face)
						
						
	" | "						
  ; for selected text
	    (:eval 
		  ; (if (region-active-p)
		  (if (use-region-p)
			(progn 
				(setq posBegin (region-beginning))
				(setq posEnd (region-end))
				(setq wordCount 0)
				(goto-char posBegin)
				(while (and (< (point) posEnd)
					(re-search-forward "\\w+\\W*" posEnd t))
				(setq wordCount (1+ wordCount)))

				(setq lineCount (count-lines posBegin posEnd))
				(setq charCnt (- posEnd posBegin))

				 (propertize (format " Sel: C%s | L%s | W%s " charCnt lineCount wordCount) 'face 'mode-line-selection-face)
			 
			 )))
			" "	
   ; emacsclient [default -- keep?]
   mode-line-client
   "  "
  	                                        ; )


	(:eval
	; TODO check if it is causing performance lag, (update only when a new file is opened/closed)
		(progn (setq count-buffer_c (count-buffers))
			(propertize (format " %s files" count-buffer_c) 'face 'mode-line-selection-face)
		)
	)
	" "
	; TODO disabled for now
   ; directory and buffer/file name
   ; (:propertize (:eval (shorten-directory default-directory 60))
                ; face mode-line-folder-face)
; filename
   ;; (:propertize "%b"                face mode-line-filename-face)
 ;; " %s " ; subprocess status
 
   ; mode indicators: vc, recursive edit, major mode, minor modes, process, global
   (vc-mode vc-mode)
   (flycheck-mode flycheck-mode-line) ; Flycheck status
   " %["
   (:propertize mode-name
                face mode-line-filename-face)
   "%]   <<"
   (:eval (propertize (format-mode-line minor-mode-alist)
                      'face 'mode-line-minor-mode-face))
   " >> "
   (:propertize mode-line-process
                face mode-line-process-face)
   ;; (global-mode-string global-mode-string)

   ;;TODO
   ;;(:eval (propertize   (global-mode-string global-mode-string) 'face 'mode-line-minor-mode-face))
	(multiple-cursors-mode mc/mode-line) ; Number of cursors
   "    "
   ; nyan-mode uses nyan cat as an alternative to %p
   ; (:eval (when nyan-mode (list (nyan-create))))
   ))
(defvar jep:modeline-subs
  '(
    ("C:/Users/cibin/Downloads" . "Downloads/")
    ("c:/Users/cibin/" . "HOME/")    
    ("c:/Users/cibin/Desktop/" . "Desktop/")    
    ("c:/cbn_gits/AHK/" . "AHK")    
    ("/$" . "")
    ))
 
(defun jep:modeline-dir-abbrev (output)
  (str-replace-all output jep:modeline-subs))
 
 (defun str-replace-all (str pats)
  (if (null pats)
      str
    (let* ((pat (car pats))
       (lhs (car pat))
       (rhs (cdr pat)))
      (replace-regexp-in-string lhs rhs (str-replace-all str (cdr pats))))))

(defun count-buffers (&optional display-anyway)

  "return the number of buffers."
  (let ((buf-count (length (buffer-list))))
  ; (message "sdfasd")
    (setq total_buffer_count buf-count)))
	
;; Helper function
(defun shorten-directory (dir max-length)
  "Show up to `max-length' characters of a directory name `dir'."
  (let ((path (reverse (split-string (abbreviate-file-name dir) "/")))
        (output ""))
    (when (and path (equal "" (car path)))
      (setq path (cdr path)))
    (while (and path (< (length output) (- max-length 4)))
      (setq output (concat (car path) "/" output))
      (setq path (cdr path)))
    (when path
      (setq output (concat ".../" output))
	  
	  )
	  ; TODO
	  ; if dir is C:/users/username.... shorten it to HOME/
	  (setq output (jep:modeline-dir-abbrev output))
      (setq output (concat output "/"))
    output)
)
	
	
; if you update the line count all the time and have a large buffer it can make Emacs somewhat unresponsive since it's counting lines over and over. I wrote this to take a lazy approach to counting: it only does it when the file is first read in or after you save/revert it. If the buffer is modified it doesn't lie about the line count, it simply isn't shown until you save again.
; http://stackoverflow.com/a/8191130
	(defun my-mode-line-count-lines ()
  (setq my-mode-line-buffer-line-count (int-to-string (count-lines (point-min) (point-max)))))
  
  
(add-hook 'find-file-hook 'my-mode-line-count-lines)
(add-hook 'after-save-hook 'my-mode-line-count-lines)
(add-hook 'after-revert-hook 'my-mode-line-count-lines)
(add-hook 'dired-after-readin-hook 'my-mode-line-count-lines)


;; Extra mode line faces
(make-face 'mode-line-read-only-face)
(make-face 'mode-line-modified-face)
(make-face 'mode-line-folder-face)
(make-face 'mode-line-filename-face)
(make-face 'mode-line-position-face)
(make-face 'mode-line-mode-face)
(make-face 'mode-line-minor-mode-face)
(make-face 'mode-line-process-face)
(make-face 'mode-line-80col-face)
(make-face 'mode-line-stats-face)
(make-face 'mode-line-selection-face)

(set-face-attribute 'mode-line nil
    :foreground "gray60" :background "gray20"
    :inverse-video nil
    :box '(:line-width 6 :color "gray20" :style nil))
(set-face-attribute 'mode-line-inactive nil
    :foreground "gray80" :background "gray40"
    :inverse-video nil
    :box '(:line-width 6 :color "gray40" :style nil))

(set-face-attribute 'mode-line-read-only-face nil
    :inherit 'mode-line-face
    :foreground "#4271ae"
    :box '(:line-width 2 :color "#4271ae"))
(set-face-attribute 'mode-line-modified-face nil
    :inherit 'mode-line-face
    :foreground "#c82829"
    :background "#ffffff"
    :box '(:line-width 2 :color "#c82829"))
(set-face-attribute 'mode-line-folder-face nil
    :inherit 'mode-line-face
    :foreground "gray60")
(set-face-attribute 'mode-line-filename-face nil
    :inherit 'mode-line-face
    :foreground "#eab700"
    :weight 'bold)
(set-face-attribute 'mode-line-stats-face nil
	:inherit 'mode-line-face
    :foreground "#eab700"
    :weight 'bold)
(set-face-attribute 'mode-line-position-face nil
    :inherit 'mode-line-face
    :family "Menlo" :height 90)
(set-face-attribute 'mode-line-mode-face nil
    :inherit 'mode-line-face
    :foreground "gray80")
(set-face-attribute 'mode-line-minor-mode-face nil
    :inherit 'mode-line-mode-face
    :foreground "white40"
    ;; :foreground "gray40"
    :height 100)
(set-face-attribute 'mode-line-process-face nil
    :inherit 'mode-line-face
    :foreground "#718c00")
(set-face-attribute 'mode-line-80col-face nil
    :inherit 'mode-line-position-face
    :foreground "black" :background "#eab700")
(set-face-attribute 'mode-line-selection-face nil
    :inherit 'mode-line-position-face
    :foreground "black" :background "#ffb780")
(provide 'cbn-mode-line)
