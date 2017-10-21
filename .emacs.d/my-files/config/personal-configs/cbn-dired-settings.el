(message "loading cbn-dired-settings")
; http://www.cibinmathew.com
; github.com/cibinmathew

; (require 'dired+)

; tuts:
; http://ergoemacs.org/emacs/emacs_dired_tips.html
; ( hide/unhide details
; o open in other
; a up
; s sort
; f = enter open
; R rename
; q quit
; <
; >
; !

; todo:
; make s search 
; / as narrowing
; a as M-x
; u up 
; or f as up

; hf hide files
; hd hide dir
; ho hide old
; ff show only this filetype
; 
; fejpg only jpg

; r cycle recent folders
; R refresh
; o open in new 
; q quit and focus to old
; use avy goto
; copy file name
; path
; gz go to uncompressed folder


; (setq ls-lisp-use-insert-directory-program t)      ;; use external ls
; (setq insert-directory-program "c:/cygwin64/bin/ls.exe") ;; ls program name



(cibin/global-set-key '("<f6>" . dired))

(use-package dired
 
  :config
  (add-hook 'dired-mode-hook 'tool-bar-mode))
  
    (use-package dired-aux
  :defer t)
;(require 'dired-aux)
; https://www.emacswiki.org/emacs/NeoTree
; refer for more tuts
 ;(require 'neotree)
 ; TODO set another key if needed
  ; (global-set-key [f6] 'neotree-toggle)
  
  ; Every time when the neotree window is opened, let it find current file and jump to node.
   (setq neo-smart-open t)

   (setq neo-theme (if (display-graphic-p) 'icons 'arrow))
  
;;narrow dired to match filter
(use-package dired-narrow
  :ensure t
  :bind (:map dired-mode-map
              ("s" . dired-narrow-fuzzy)))
			  

; Hide permissions and owners to make file lists less noisy (from Xah Lee's blog)

(add-hook 'dired-mode-hook
          (lambda ()
            (dired-hide-details-mode 1)
(toggle-truncate-lines 1)
            ))

			  
; (autoload 'dired-jump "dired-x"   "Jump to Dired buffer corresponding to current buffer." t)

; (autoload 'dired-jump-other-window "dired-x"   "Like \\[dired-jump] (dired-jump) but in other window." t)

; (cibin/global-set-key '("C-x C-d" . dired-jump))
; (cibin/global-set-key '("C-x 4 C-d" . dired-jump-other-window))

; human-readable sizes and sort by size
; (setq dired-listing-switches "-alh")
; (setq dired-listing-switches "-agG")
(setq dired-listing-switches "-laGh1vp --group-directories-first")
; l: Is the only mandatory one.
; a: Means to list invisible files.
; G: Don't show group information. These days, when there are more laptops than people, the group info is rarely useful.
; h: Human readable sizes, such as M for mebibytes.
; 1v: Affects the sorting of digits, hopefully in a positive way.
; Sort Directories First
; (setq dired-listing-switches "-aBhl  --group-directories-first")


; to get the total/available numbers in MB. This worked on my Linux system, but the available portion failed to work on my Windows box:
(setq directory-free-space-args "-Pm")
(defadvice insert-directory (after insert-directory-adjust-total-by-1024 activate)
  "modify the total number by dividing it by 1024"
  (save-excursion
(save-match-data
  (goto-char (point-min))
  (when (re-search-forward "^ *total used in directory \\([0-9]+\\) ")
    (replace-match (number-to-string (/ (string-to-number (match-string 1)) 1024)) nil nil nil 1)))))
	

; Showing symlinks differently

; Just like with ls, if you want an "@" appended to the end of file names if they're symlinks, you can set the following:

(setq dired-ls-F-marks-symlinks t)


; Instead of a hard delete, move a file to the trash

; This one is great, does what it says:

(setq delete-by-moving-to-trash t)




; Old stuff

    ; Binding r to dired-start-process is covered here.
    ; Binding e to ediff-files is mentioned here.
    ; Binding z to dired-get-size is covered here.
    ; Binding ` to dired-open-term is covered here.

; Jump to a file with ido
(define-key dired-mode-map "i" 'ido-find-file)
(define-key dired-mode-map "e" 'other-window)

(define-key dired-mode-map "u" 'dired-find-file-other-window)

 ; (evil-define-key 'normal dired-mode-map "h" 'dired-up-directory)
  ; (evil-define-key 'normal dired-mode-map "l" 'dired-find-alternate-file)

  ; (evil-define-key 'normal dired-mode-map "c" 'dired-create-directory)

  ; (evil-define-key 'normal dired-mode-map "q" 'kill-this-buffer)
  
  
                                        ; Move to the parent directory
                                        ; open in same buffer
;; to reuse the buffer
;; (define-key dired-mode-map (kbd "RET") 'dired-find-alternate-file) ; was dired-advertised-find-filely)
(define-key dired-mode-map (kbd "RET") 'cibin/dired-find-file-literally)

; h will keep the old Dired buffers around. To fix this, we need to write a function that will jump up one directory, and close the old Dired buffer.

; (defun my-dired-up-directory ()
  ; "Take dired up one directory, but behave like dired-find-alternate-file"
  ; (interactive)
  ; (let ((old (current-buffer)))
    ; (dired-up-directory)
    ; (kill-buffer old)
    ; ))
; Rebinding h to our new function makes buffer navigation behave much closer to other Vim-like file browsers.

; (evil-define-key 'normal dired-mode-map "h" 'my-dired-up-directory)


; Move up and down
(define-key dired-mode-map "j" 'dired-next-line)
(define-key dired-mode-map "k" 'dired-previous-line)

; Emacs' adaptation of find
(define-key dired-mode-map "F" 'find-name-dired)

; Ignore unimportant files
(define-key dired-mode-map (kbd "M-o") 'dired-omit-mode)

(define-key dired-mode-map (kbd "f") 'dired-sort-toggle)


(define-key dired-mode-map (kbd "l") 'diredp-find-file-reuse-dir-buffer)
(define-key dired-mode-map (kbd "I")'ao/dired-omit-switch)

(key-chord-define dired-mode-map (kbd "gg") 'ao/dired-back-to-top)	
(define-key dired-mode-map (kbd "G") 'ao/dired-jump-to-bottom)

(key-chord-define dired-mode-map (kbd "gt") 'dired-show-only-txt)	
(key-chord-define dired-mode-map (kbd "gk") 'dired-show-only-this)	

(define-key dired-mode-map (kbd "%^") 'dired-flag-garbage-files)

; Flag garbage files
; Huh, I always thought this was the default binding. I have no idea where this came from, but I use this plus x to get rid of the garbage produced by a LaTeX run:

(setq dired-garbage-files-regexp
      "\\.idx\\|\\.run\\.xml$\\|\\.bbl$\\|\\.bcf$\\|.blg$\\|-blx.bib$\\|.nav$\\|.snm$\\|.out$\\|.synctex.gz$\\|\\(?:\\.\\(?:aux\\|bak\\|dvi\\|log\\|orig\\|rej\\|toc\\|pyg\\)\\)\\'")


; This little function is essential if you want to do perform some operation on all files in the current directory and its sub directories that match a pattern. Basically the same thing that you would do with the UNIX find, just better.

; This will toggle the display of unimportant files, like:

(setq dired-omit-files "\\(?:.*\\.\\(?:aux\\|log\\|synctex\\.gz\\|run\\.xml\\|bcf\\|am\\|in\\)\\'\\)\\|^\\.\\|-blx\\.bib")

  
	  
;;;; https://gist.github.com/synic/5c1a494eaad1406c5519  
	  
(defvar ao/v-dired-omit t
  "If dired-omit-mode enabled by default. Don't setq me.")

(defun ao/dired-omit-switch ()
  "This function is a small enhancement for `dired-omit-mode', which will
   \"remember\" omit state across Dired buffers."
  (interactive)
  (if (eq ao/v-dired-omit t)
      (setq ao/v-dired-omit nil)
    (setq ao/v-dired-omit t))
  (ao/dired-omit-caller)
  (when (equal major-mode 'dired-mode)
    (revert-buffer)))

(defun ao/dired-omit-caller ()
  (if ao/v-dired-omit
      (setq dired-omit-mode t)
    (setq dired-omit-mode nil)))

(defun ao/dired-back-to-top()
  "Move to the first file."
  (interactive)
  (beginning-of-buffer)
  (dired-next-line 2))

(defun ao/dired-jump-to-bottom()
  "Move to last file."
  (interactive)
  (end-of-buffer)
  (dired-next-line -1))

; Inside user-config in spacemacs:

  ;; Dired
  
    (use-package dired+
  :defer t)
    (use-package dired-x
  :defer t)
  ;(require 'dired-x) ; Enable dired-x
  ;(require 'dired+)  ; Enable dired+
  (setq-default dired-omit-files-p t)  ; Don't show hidden files by default
  (setq dired-omit-files (concat dired-omit-files "\\|^\\..+$\\|\\.pyc$"))
  (add-hook 'dired-mode-hook 'ao/dired-omit-caller)
  (define-key evil-normal-state-map (kbd "_") 'projectile-dired)
  (define-key evil-normal-state-map (kbd "-") 'dired-jump)
  (setq diredp-hide-details-initially-flag nil)
  (advice-add 'spacemacs/find-dotfile :around 'ao/find-dotfile)
 
			 
; https://davidcapello.com/blog/emacs/emacs-how-to-locate-the-current-buffer-in-windows-explorer/
(defun locate-current-file-in-explorer ()
  (interactive)
  (cond
   ;; In buffers with file name
   ((buffer-file-name)
    (shell-command (concat "explorer /e,/select,\"" (replace-regexp-in-string "/" "\\\\" (buffer-file-name)) "\"")))
   ;; In dired mode
   ((eq major-mode 'dired-mode)
    (shell-command (concat "explorer /e,\"" (replace-regexp-in-string "/" "\\\\" (dired-current-directory)) "\"")))
   ;; In eshell mode
   ((eq major-mode 'eshell-mode)
    (shell-command (concat "explorer /e,\"" (replace-regexp-in-string "/" "\\\\" (eshell/pwd)) "\"")))
   ;; Use default-directory as last resource
   (t
    (shell-command (concat "explorer /e,\"" (replace-regexp-in-string "/" "\\\\" default-directory) "\"")))))
	
	; run the application associated with the current buffer file type (e.g. if you use this function in an .html file, the file will be opened with your default web browser):

(defun open-current-file-with-associated-app ()
  (interactive)
  (shell-command (concat "cmd /c \"start " (buffer-file-name) "\"")))

  (defun xah-dired-sort ()
  "Sort dired dir listing in different ways.
Prompt for a choice.
URL `http://ergoemacs.org/emacs/dired_sort.html'
Version 2015-07-30"
  (interactive)
  (let (-sort-by -arg)
    (setq -sort-by (ido-completing-read "Sort by:" '( "date" "size" "name" "dir")))
    (cond
     ((equal -sort-by "name") (setq -arg "-Al --si --time-style long-iso "))
     ((equal -sort-by "date") (setq -arg "-Al --si --time-style long-iso -t"))
     ((equal -sort-by "size") (setq -arg "-Al --si --time-style long-iso -S"))
     ((equal -sort-by "dir") (setq -arg "-Al --si --time-style long-iso --group-directories-first"))
     (t (error "logic error 09535" )))
(dired-sort-other -arg )))


; http://stackoverflow.com/a/2860779
; https://www.emacswiki.org/emacs/DiredSortBySizeAndExtension
;(require 'ls-lisp)
    (use-package ls-lisp
  :defer t)

    ;; (defun ls-lisp-format-time (file-attr time-index now)
    ;;   "################")

(defun ls-lisp-format-file-size (file-size human-readable)
  "This is a redefinition of the function from `dired.el'. This
fixes the formatting of file sizes in dired mode, to support very
large files. Without this change, dired supports 8 digits max,
which is up to 10gb.  Some files are larger than that.
"
  (if (or (not human-readable)
          (< file-size 1024))
      (format (if (floatp file-size) " %11.0f" " %11d") file-size)
    (do ((file-size (/ file-size 1024.0) (/ file-size 1024.0))
         ;; kilo, mega, giga, tera, peta, exa
         (post-fixes (list "k" "M" "G" "T" "P" "E") (cdr post-fixes)))
        ((< file-size 1024) (format " %10.0f%s"  file-size (car post-fixes))))))
		
;; Redefine the sorting in dired to flip between sorting on name, size,
;; time, and extension,  rather than simply on name and time.
(defun dired-sort-toggle ()
  ;; Toggle between sort by date/name.  Reverts the buffer.
  (interactive)
  (setq dired-actual-switches
        (let (case-fold-search)

          (cond

           ((string-match " " dired-actual-switches) ;; contains a space
            ;; New toggle scheme: add/remove a trailing " -t" " -S",
            ;; or " -U"

            (cond

             ((string-match " -t\\'" dired-actual-switches)
              (concat
               (substring dired-actual-switches 0 (match-beginning 0))
               " -X"))

             ((string-match " -X\\'" dired-actual-switches)
              (concat
               (substring dired-actual-switches 0 (match-beginning 0))
               " -S"))

             ((string-match " -S\\'" dired-actual-switches)
              (substring dired-actual-switches 0 (match-beginning 0)))

             (t
              (concat dired-actual-switches " -t"))))

           (t
            ;; old toggle scheme: look for a sorting switch, one of [tUXS]
            ;; and switch between them. Assume there is only ONE present.
            (let* ((old-sorting-switch
                    (if (string-match (concat "[t" dired-ls-sorting-switches "]")
                                      dired-actual-switches)
                        (substring dired-actual-switches (match-beginning 0)
                                   (match-end 0))
                      ""))

                       (new-sorting-switch
                        (cond
                         ((string= old-sorting-switch "t")
                          "X")
                         ((string= old-sorting-switch "X")
                          "S")
                         ((string= old-sorting-switch "S")
                          "")
                         (t
                          "t"))))
                  (concat
                   "-l"
                   ;; strip -l and any sorting switches
                   (dired-replace-in-string (concat "[-lt"
                                                    dired-ls-sorting-switches "]")
                                            ""
                                            dired-actual-switches)
                   new-sorting-switch))))))

  (dired-sort-set-modeline)
  (revert-buffer))
  
 
(defun dired-sort-set-modeline ()
 "This is a redefinition of the fn from `dired.el'. This one
properly provides the modeline in dired mode, supporting the new
search modes defined in the new `dired-sort-toggle'.
"
  ;; Set modeline display according to dired-actual-switches.
  ;; Modeline display of "by name" or "by date" guarantees the user a
  ;; match with the corresponding regexps.  Non-matching switches are
  ;; shown literally.
  (when (eq major-mode 'dired-mode)
    (setq mode-name
          (let (case-fold-search)
            (cond ((string-match "^-[^t]*t[^t]*$" dired-actual-switches)
                   "Dired by time")
                  ((string-match "^-[^X]*X[^X]*$" dired-actual-switches)
                   "Dired by ext")
                  ((string-match "^-[^S]*S[^S]*$" dired-actual-switches)
                   "Dired by sz")
                  ((string-match "^-[^SXUt]*$" dired-actual-switches)
                   "Dired by name")
                  (t
                   (concat "Dired " dired-actual-switches)))))
    (force-mode-line-update)))
 

; Opening files
; This is mostly stolen from here. Uses nohup to spawn child processes without annoying new buffers. First, we define a list of default programs.
; ! (dired-do-shell-command) does not know (by default) how to handle some filetypes.
(setq dired-guess-shell-alist-user
      '(("\\.pdf\\'" "evince")
        ("\\.\\(?:djvu\\|eps\\)\\'" "zathura")
        ("\\.\\(?:jpg\\|jpeg\\|png\\|gif\\|xpm\\)\\'" "eog")
        ("\\.\\(?:xcf\\)\\'" "gimp")
        ("\\.\\(?:csv\\|odt\\|ods\\)\\'" "libreoffice")
        ("\\.\\(?:mp4\\|mp3\\|mkv\\|avi\\|flv\\|ogv\\)\\(?:\\.part\\)?\\'"
         "vlc")
        ("\\.html?\\'" "firefox")))
; Now, define a new function to start a process in the background.

(defvar dired-filelist-cmd
  '(("vlc" "-L")))

(defun dired-start-process (cmd &optional file-list)
  (interactive
   (let ((files (dired-get-marked-files
                 t current-prefix-arg)))
     (list
      (dired-read-shell-command "Open with: "
                                current-prefix-arg files)
      files)))
  (let (list-switch)
    (start-process
     cmd nil shell-file-name
     shell-command-switch
     (format
      "nohup 1>/dev/null 2>/dev/null %s \"%s\""
      (if (and (> (length file-list) 1)
               (setq list-switch
                     (cadr (assoc cmd dired-filelist-cmd))))
          (format "%s %s" cmd list-switch)
        cmd)
      (mapconcat #'expand-file-name file-list "\" \"")))))
	  
(defun dired-show-only-this(regexp)
   (interactive "sFiles to show (regexp): ")
   
   (dired-show-only regexp)
   )
(defun dired-show-only-txt()
   (interactive) ; "sFiles to show (regexp): ")
   (message "ghghgh")
   (dired-show-only "txt")
   )
(defun dired-show-only(regexp)
   (dired-mark-files-regexp (concat ".*" regexp "$"))
   (dired-toggle-marks)
   (dired-do-kill-lines)
)

;;; sort by different criterias


(defun kill-dired-buffers ()
     (interactive)
     (mapc (lambda (buffer) 
           (when (eq 'dired-mode (buffer-local-value 'major-mode buffer)) 
             (kill-buffer buffer))) 
         (buffer-list)))
		 
		 ; Switch between buffers in same directory
; Usage: M-x buffer/switch-in-directory

; This command switches between buffer with files that are in current directory.

(defun buffer/with-file-in-directory-p (directory buf)
  "Check if a buffer has file associated and is is in DIRECTORY.
Parameters:
- directory  string         - root directory 
- buf        buffer object  - buffer object"
  (and (buffer-file-name buf) ;; check if buffer has a file associated 
       (string-prefix-p (expand-file-name directory)
                        (expand-file-name (buffer-file-name buf)
                                            ))))



				

				
				
				; Asynchronous Dired
; You can make the copy and rename/move commands in dired by installing the async package. From there, all you need to do is:

;(require 'dired-async)

    (use-package dired-async
  :defer t)
; And the commands will automatically by asynchronous

  
  
  (define-key dired-mode-map (kbd "u") 'my-dired-up-directory)
  ; Rebinding h to our new function makes buffer navigation behave much closer to other Vim-like file browsers.

(evil-define-key 'normal dired-mode-map "h" 'my-dired-up-directory)
(evil-define-key 'normal dired-mode-map "J" 'cibin/next-sibling-directory)
(evil-define-key 'normal dired-mode-map "K" 'cibin/prev-sibling-directory)
(evil-define-key 'normal dired-mode-map "l" 'diredp-find-file-reuse-dir-buffer)

; (evil-define-key 'normal dired-mode-map "L" 'view only)


(evil-define-key 'normal dired-mode-map "r" 'bjm/ivy-dired-recent-dirs)


(define-key dired-mode-map (kbd "r") 'bjm/ivy-dired-recent-dirs)
(define-key dired-mode-map (kbd "J") 'cibin/next-sibling-directory)
(define-key dired-mode-map (kbd "K") 'cibin/prev-sibling-directory)

  

; One problem with this config is that while l will use dired-find-alternate-file, h will keep the old Dired buffers around. To fix this, we need to write a function that will jump up one directory, and close the old Dired buffer.

(defun my-dired-up-directory ()
  "Take dired up one directory, but behave like dired-find-alternate-file"
  (interactive)
  (let ((old (current-buffer)))
    (dired-up-directory)
    (kill-buffer old)
    ))

	
	
	
;; 
;; This one looks nice, although it only works on systems with /usr/bin/du, which actually comprise 100% of the systems that I use:
(defun dired-get-size ()
  (interactive)
  (let ((files (dired-get-marked-files)))
    (with-temp-buffer
      (apply 'call-process "du" nil t nil "-sch" files)
      ;; (apply 'call-process "/usr/bin/du" nil t nil "-sch" files)
      (message
       "Size of all marked files: %s"
       (progn
         (re-search-backward "\\(^[ 0-9.,]+[A-Za-z]+\\).*total$")
         (match-string 1))))))
;; On doing a search, turns out that I got this code from the wiki at some point. I can confirm that, unlike some of the other code on the wiki, this one still works as advertised: you can use it on a directory or on a series of marked files and directories.

(define-key dired-mode-map (kbd "z") 'dired-get-size)

(defun cibin/next-sibling-directory()
(interactive)
(my-dired-up-directory)
;; (dired-next-subdir)
; (dired-find-file)
(diredp-next-dirline 1)
(dired-find-alternate-file)
)


(defun cibin/prev-sibling-directory()
(interactive)
(my-dired-up-directory)
;; (dired-next-subdir)
; (dired-find-file)
(diredp-prev-dirline 1)
(dired-find-alternate-file)
)

;;; sort by different criterias


(defun dired-sort-criteria (criteria)
  "sort-dired by different criteria by Robert Gloeckner "
  (interactive 
   (list 
    (or (completing-read "criteria [name]: "
			 '("size(S)" "extension(X)" "creation-time(ct)"
			   "access-time(ut)" "time(t)" "name()"))
	"")))
  (string-match ".*(\\(.*\\))" criteria)
  (dired-sort-other
   (concat dired-listing-switches 
	   (match-string 1 criteria))))


;; Buffer Management
;; When disabling the mode you can choose to kill the buffers that were opened while browsing the directories.
(setq ranger-cleanup-on-disable t)

;; Parent Window Options

;; You can set the number of folders to nest to the left, adjusted by z- and z+.

(setq ranger-parent-depth 1)
;; You can set the size of the parent windows as a fraction of the frame size.

(setq ranger-width-parents 0.12)
;; When increasing number of nested parent folders, set max width as fraction of frame size to prevent filling up entire frame with parents.

(setq ranger-max-parent-width 0.12)

;; Preview Window Options

;; Set the default preference to preview selected file.

(setq ranger-preview-file t)
;; You can choose to show previews literally, or through find-file, toggled by zi.

(setq ranger-show-literal t)
;; You can set the size of the preview windows as a fraction of the frame size.

(setq ranger-width-preview 0.55)
;; You probably don't want to open certain files like videos when previewing. To ignore certain files when moving over them you can customize the following to your liking:
(setq ranger-excluded-extensions '("mkv" "iso" "mp4"))

;; To set the max files size (in MB), set the following parameter:
(setq ranger-max-preview-size 2)

;; The preview function is also able to determine if the file selected is a binary file. If set to t, these files will not be previewed.
(setq ranger-dont-show-binary t)


(defun cibin-apply-default-major-mode ()
(interactive)
(set-auto-mode)
(remove-dos-eol)
)

  (defun remove-dos-eol ()
  "Do not show ^M in files containing mixed UNIX and DOS line endings.
;http://stackoverflow.com/questions/730751/hiding-m-in-emacs"

  (interactive)
  (setq buffer-display-table (make-display-table))
(aset buffer-display-table ?\^M []))


(defun cibin/dired-find-file-literally ()
(interactive)
  (set-buffer-modified-p nil)
  (let ((file  (dired-get-file-for-visit)))
    (if (file-directory-p file) (find-alternate-file file) 
	;(op:dired-find-file-literally)
	(find-file-literally file)
	)))


	(defun dir-structure ()
  (interactive)
    (setq cmd-string (format "c:/cbn_gits/misc/filesystem-to-tree.py %s" (return-filepath)))
(call-process-shell-command cmd-string nil "*Shell Command Output*" t)
(switch-to-buffer "*Shell Command Output*")
    )


(defun dir-structure-all ()
  (interactive)
    (setq cmd-string (format "c:/cbn_gits/misc/filesystem-to-tree.py -f %s" (return-filepath)))
(call-process-shell-command cmd-string nil "*Shell Command Output*" t)
(switch-to-buffer "*Shell Command Output*")
    )

	
(provide 'cbn-dired-settings)
