; http://www.cibinmathew.com
; github.com/cibinmathew

; todo: http://gregorygrubbs.com/emacs/10-tips-emacs-windows/

; Execute runemacs.exe or emacsclientw.exe. On your Linux and OS X
; systems, the binary names or emacs and emacsclient: just use the
; windows-specific wrappers included in the standard port when on MS Windows.
; Add Cygwin /bin to exec-path.
      (if (file-directory-p "c:/cygwin64/bin")
      (add-to-list 'exec-path "c:/cygwin64/bin"))
	  
	  
;; open recent directory, requires ivy (part of swiper)
;; borrows from http://stackoverflow.com/questions/23328037/in-emacs-how-to-maintain-a-list-of-recent-directories
(defun bjm/ivy-dired-recent-dirs ()
  "Present a list of recently used directories and open the selected one in dired"
  (interactive)
  (let ((recent-dirs
         (delete-dups
          (mapcar (lambda (file)
                    (if (file-directory-p file) file (file-name-directory file)))
                  recentf-list))))

				  
				  
				; (ivy-read "Directory: "
                         ; recent-dirs
                         ; :re-builder #'ivy--regex
                         ; :sort nil
                         ; :initial-input nil)  
				  
				  
    (let ((dir (ido-completing-read "choose recent dire? " 
				  recent-dirs )))
      (dired dir))
	  ))

(global-set-key (kbd "C-x C-d") 'bjm/ivy-dired-recent-dirs)

;; make the left fringe 4 pixels wide and the right disappear
(fringe-mode '(20 . 8))

	
; Scrolling behavior
; Emacs’s default scrolling behavior, like a lot of the default Emacs experience, is pretty idiosyncratic. The following snippet makes for a smoother scrolling behavior when using keyboard navigation.
(setq redisplay-dont-pause t
      scroll-margin 4 
      scroll-step 1
      scroll-conservatively 10000
      scroll-preserve-screen-position 1)

                                        ; Scroll smoothly rather than by paging

(setq scroll-step 1)
                                        ; When the cursor moves past the top or bottom of the window, scroll one line at a time rather than jumping. I don't like having to find my place in the file again.
(setq scroll-conservatively 10000)

(message "checkpoint 67")	

(electric-pair-mode 1) ; automatically insert right brackets when left one is typed?
(show-paren-mode 1) ; turn on bracket match highlight
(setq show-paren-delay 0)

; Use Tab to Indent or Complete
; (setq tab-always-indent complete)
; https://www.emacswiki.org/emacs/TabCompletion
; Completion on <tab>

; The following functions define the global behavior of the <tab> key. Modified from here. We want to

; Check if in minibuffer, if yes, use minibuffer-complete.
; Check if there are snippets, if yes, execute the snippet
; Check for company-completions, if yes, enter company.
; If there are no snippets or completions, indent the line.
(defun check-expansion ()
  (save-excursion
    (if (looking-at "\\_>") t
      (backward-char 1)
      (if (looking-at "\\.") t
        (backward-char 1)
        (if (looking-at "->") t nil)))))

(defun do-yas-expand ()
  (let ((yas-fallback-behavior 'return-nil))
    (yas-expand)))

(defun tab-indent-or-complete ()
  (interactive)
  (if (minibufferp)
      (minibuffer-complete)
    (if (or (not yas-minor-mode) ;; xxx change this to point to right var
            (null (when (looking-at "\\_>") (do-yas-expand))))
        (if (check-expansion)
            (company-complete-common)
          (indent-for-tab-command)))))

(define-key prog-mode-map [tab] 'tab-indent-or-complete)
(define-key prog-mode-map (kbd "TAB") 'tab-indent-or-complete)

;;;;;;;;;;;;
; shell-mode

; (pkg-config "shell"
  ; > may show up in some prompts
  ; (setq shell-prompt-pattern "^[^#$%\n]*[#$%>] *")

  ; (global-set-key (kbd "C-c s") 'fc/toggle-shell)
  ; (defun fc/toggle-shell ()
    ; "Switch between the last active buffer and the shell."
    ; (interactive)
    ; (if (eq major-mode 'shell-mode)
        ; (let ((buf (catch 'return
                     ; (dolist (buf (cdr (buffer-list)))
                       ; (when (not (string-prefix-p " " (buffer-name buf)))
                         ; (throw 'return buf)))
                     ; nil)))
          ; (when buf
            ; (switch-to-buffer buf)))
      ; (shell)))

  ; (define-key shell-mode-map (kbd "C-c C-y") 'fc/shell-switch-dir)
  ; (defun fc/shell-switch-dir ()
    ; "Switch `shell-mode' to the `default-directory' of the last buffer."
    ; (interactive)
    ; (when (eq major-mode 'shell-mode)
      ; (let* ((dir (catch 'return
                    ; (dolist (buf (buffer-list))
                      ; (with-current-buffer buf
                        ; (when buffer-file-name
                          ; (throw 'return
                                 ; (expand-file-name default-directory))))))))
        ; (goto-char (process-mark (get-buffer-process (current-buffer))))
        ; (insert (format "cd %s" (shell-quote-argument dir)))
        ; (let ((comint-eol-on-send nil))
          ; (comint-send-input))))))

;;;;;;;;;;;;;
;; subword.el

; (use-package "subword"
  ; (global-subword-mode)
  ; (let ((elt (assq 'subword-mode minor-mode-alist)))
    ; (when elt
      ; (setcdr (assq 'subword-mode minor-mode-alist) '("")))))

	  
;;;;;;;;;;;;;;;;;;;;;;;;
;; Multiple Cursors Mode

; (use-package "multiple-cursors"
; :config
  ; (global-set-key (kbd "<C-down>") 'mc/mark-next-like-this)
  ; (global-set-key (kbd "<C-up>") 'mc/unmark-next-like-this)
  ; (global-set-key (kbd "<C-mouse-1>") 'mc/add-cursor-on-click)
; (global-unset-key (kbd "M-<down-mouse-1>"))
; (global-set-key (kbd "M-<mouse-1>") 'mc/add-cursor-on-click)
  
  ; )

(setq shift-select-mode t)

; http://ergoemacs.org/emacs/emacs_make_modern.html 
; save minibuffer history
(savehist-mode 1)

; (setq backup-by-copying t) ; stop emacs's backup changing the file's creation date of the original file?
(defvar --backup-directory (concat user-emacs-directory "emacs-backup"))

(if (not (file-exists-p --backup-directory))
        (make-directory --backup-directory t))

(setq backup-directory-alist `(("." . ,--backup-directory)))

(setq make-backup-files t               ; backup of a file the first time it is saved.
      backup-by-copying t               ; don't clobber symlinks
      version-control t                 ; version numbers for backup files
      delete-old-versions t             ; delete excess backup files silently
      delete-by-moving-to-trash t
      kept-old-versions 6               ; oldest versions to keep when a new numbered backup is made (default: 2)
      kept-new-versions 9               ; newest versions to keep when a new numbered backup is made (default: 2)
      auto-save-default t               ; auto-save every buffer that visits a file
      auto-save-timeout 20              ; number of seconds idle time before auto-save (default: 30)
      auto-save-interval 200            ; number of keystrokes between auto-saves (default: 300)
      )
	  
;; make backup to a designated dir, mirroring the full path

;; backup in one place. flat, no tree structure
; (setq backup-directory-alist '(("" . "~/.emacs.d/emacs-backup")))
; all backups are placed in one place
; This will create backup files flat in the given dir, and the backup file names will have “!” characters in place of the directory separator.
; (setq make-backup-file-name-function 'my-backup-file-name)


(defun my-backup-file-name (fpath)
"Return a new file path of a given file path.
If the new path's directories does not exist, create them."
  (let* (
        (backupRootDir "~/.emacs.d/emacs-backup/")
        (filePath (replace-regexp-in-string "[A-Za-z]:" "" fpath )) ; remove Windows driver letter in path, ➢ for example: “C:”
        (backupFilePath (replace-regexp-in-string "//" "/" (concat backupRootDir filePath "~") ))
        )
    (make-directory (file-name-directory backupFilePath) (file-name-directory backupFilePath))
    backupFilePath
  )
)


(desktop-save-mode 1) ; save/restore opened files from last session
(global-visual-line-mode 1) ; soft line wrap ; 1 for on, 0 for off.


(require 'ido) ; part of emacs

(defvar xah-filelist nil "Association list of file/dir paths. Used by `xah-open-file-fast'. Key is a short abbrev string, Value is file path string.")
(defvar python-shell-interpreter "C:/Python27/python.exe")
(setq xah-filelist
      '(
        ("3emacs" . "~/.emacs.d/" )
        ("git" . "~/git/" )
        ("todo" . "~/todo.org" )
        ("keys" . "~/git/my_emacs_init/my_keybinding.el" )
        ("download" . "~/Downloads/" )
        ("pictures" . "~/Pictures/" )
        ;; more here
        ) )

(menu-bar-mode -1)
(when (display-graphic-p)
	(tool-bar-mode -1)
	(scroll-bar-mode 1))

	(set-face-attribute 'vertical-border nil :foreground (face-attribute 'fringe :background))

(setq inhibit-startup-message t)
(setq inhibit-splash-screen t)
(setq  initial-major-mode 'org-mode)
(setq initial-scratch-message nil)
(setq initial-buffer-choice "~/")
(setq x-select-enable-clipboard t)

(setq scroll-step            1
      scroll-conservatively  10000)

(require 'dired-x)
(require 'dired-aux)

(setq dired-guess-shell-alist-user
      '(("\\.pdf\\'" "evince")
        ("\\.\\(?:djvu\\|eps\\)\\'" "zathura")
        ("\\.\\(?:jpg\\|jpeg\\|png\\|gif\\|xpm\\)\\'" "eog")
        ("\\.\\(?:xcf\\)\\'" "gimp")
        ("\\.\\(?:csv\\|odt\\|ods\\)\\'" "libreoffice")
        ("\\.\\(?:mp4\\|mp3\\|mkv\\|avi\\|flv\\|ogv\\)\\(?:\\.part\\)?\\'"
         "vlc")
        ("\\.html?\\'" "firefox")))
		

(global-set-key [(control x) (control r)] 'rename-this-file)

; enable drag-stuff globally, use:
(drag-stuff-global-mode 1)
(global-set-key (kbd "M-p") 'drag-stuff-up)
(global-set-key (kbd "M-n") 'drag-stuff-down)
(global-set-key (kbd "M-<up>") 'drag-stuff-up)
(global-set-key (kbd "M-<down>") 'drag-stuff-down)
(global-set-key (kbd "M-<left>") 'drag-stuff-left)
(global-set-key (kbd "M-<right>") 'drag-stuff-right)

; (global-set-key (kbd "M-p") 'move-line-region-up)
; (global-set-key (kbd "M-n") 'move-line-region-down)
; (global-set-key (kbd "M-<up>") 'move-line-region-up)
; (global-set-key (kbd "M-<down>") 'move-line-region-down)
; (global-set-key (kbd "M-<up>") 'move-line-up)
; (global-set-key (kbd "M-<down>") 'move-line-down)

; (global-set-key (kbd "M-<up>") 'move-region-up)
; (global-set-key (kbd "M-<down>") 'move-region-down)


(global-set-key [?\C-h] 'delete-backward-char)
; (global-set-key [?\C-x ?h] 'help-command)    ;; overrides mark-whole-buffer

; kill the current visible buffer without confirmation unless the buffer has been modified. In this last case, you have to answer y/n.

(global-set-key [(control x) (k)] 'kill-this-buffer)


(global-set-key [C-right] 'geosoft-forward-word)
(global-set-key [C-left] 'geosoft-backward-word) 
(global-set-key [f4] 'bubble-buffer) 
		
; to make sure case is preserved when expanding
(setq dabbrev-case-replace nil)		

(global-set-key [S-return]   'open-next-line)
(global-set-key [C-return] 'open-previous-line-move-down)
(global-set-key [M-return] 'open-previous-line)

(global-set-key (kbd "C-o") 'open-next-line)
(global-set-key (kbd "M-o") 'open-previous-line)


(define-key evil-normal-state-map (kbd "C-e") 'evil-end-of-line)
(define-key evil-normal-state-map (kbd "C-a") 'smart-line-beginning)

(global-set-key (kbd "C-e") 'evil-end-of-line)
(global-set-key (kbd "C-a") 'smart-line-beginning)
(global-set-key [home] 'smart-line-beginning)

;	
(use-package elpy
  :mode ("\\.py\\'" . elpy-mode)
  :init
  (add-hook 'python-mode-hook (lambda () (aggressive-indent-mode -1)))
  :config
  (when (require 'flycheck nil t)
    (remove-hook 'elpy-modules 'elpy-module-flymake)
    (remove-hook 'elpy-modules 'elpy-module-yasnippet)
    (remove-hook 'elpy-mode-hook 'elpy-module-highlight-indentation)
    (add-hook 'elpy-mode-hook 'flycheck-mode))
  ; (elpy-enable) ; disabled for now
  (setq elpy-rpc-backend "jedi"))
  
  ; golden-ratio

; Give the working window more screen estate. 
  (use-package golden-ratio
  :diminish golden-ratio-mode
  :config (progn
            (add-to-list 'golden-ratio-extra-commands 'ace-window)
            (golden-ratio-mode 1)))
			

; volatile-highlights
; Highlights recently copied/pasted text.

(use-package volatile-highlights
  :diminish volatile-highlights-mode
  :config (volatile-highlights-mode t))


  
  
; Large file warning

; Whenever, a large file (by Emacs standards) is opened, it asks for confirmation whether we really want to open it but the problem is the limit for this file is set pretty low. Let’s increase it a bit so that it doesn’t prompt so often.

(setq large-file-warning-threshold (* 5 1024 1024))

; window-numbering
;(setq window-numbering-assign-func (lambda () (when (equal (buffer-name) "*scratch*") 9)))
	  
	  
	  
;; adjust transpose-chars to switch previous two characters
; As an example, with the modified behaviour, using C-t with the point at the end of the string teh changes it to the, while the original behaviour gives you te h (unless you are at the end of a line, in which case you get the). Repeated use of the modified version simply toggles back and forth
(global-set-key (kbd "C-t")
                (lambda () (interactive)
                  (backward-char)
                  (transpose-chars 1)))
; TODO: note that transpose-words is replaced by org-transpose-words on M-t in org-mode so you would have to adjust that too.
(global-set-key (kbd "M-t")
                (lambda () (interactive)
                  (backward-word)
                  (transpose-words 1)))
				  
				  
				  (global-set-key (kbd "C-c b c") 'quick-calc)
				  
				  
				  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; change case of letters                                                 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; http://ergoemacs.org/emacs/modernization_upcase-word.html
(defun toggle-letter-case ()
  "Toggle the letter case of current word or text selection.
Toggles between: “all lower”, “Init Caps”, “ALL CAPS”."
  (interactive)
  (let (p1 p2 (deactivate-mark nil) (case-fold-search nil))
    (if (region-active-p)
        (setq p1 (region-beginning) p2 (region-end))
      (let ((bds (bounds-of-thing-at-point 'word) ) )
        (setq p1 (car bds) p2 (cdr bds)) ) )

    (when (not (eq last-command this-command))
      (save-excursion
        (goto-char p1)
        (cond
         ((looking-at "[[:lower:]][[:lower:]]") (put this-command 'state "all lower"))
         ((looking-at "[[:upper:]][[:upper:]]") (put this-command 'state "all caps") )
         ((looking-at "[[:upper:]][[:lower:]]") (put this-command 'state "init caps") )
         ((looking-at "[[:lower:]]") (put this-command 'state "all lower"))
         ((looking-at "[[:upper:]]") (put this-command 'state "all caps") )
         (t (put this-command 'state "all lower") ) ) )
      )

    (cond
     ((string= "all lower" (get this-command 'state))
      (upcase-initials-region p1 p2) (put this-command 'state "init caps"))
     ((string= "init caps" (get this-command 'state))
      (upcase-region p1 p2) (put this-command 'state "all caps"))
     ((string= "all caps" (get this-command 'state))
      (downcase-region p1 p2) (put this-command 'state "all lower")) )
    )
  )

;;set this to M-c
(global-set-key "\M-c" 'toggle-letter-case)



; Persistent scratch
; Persist the *scratch* buffer every 5 minutes, so we don't lose any possibly important data if/when Emacs crashes.1

(defun save-persistent-scratch ()
  "Write the contents of *scratch* to the file name
`persistent-scratch-file-name'."
  (with-current-buffer (get-buffer-create "*scratch*")
    (write-region (point-min) (point-max) "~/.emacs-persistent-scratch")))

(defun load-persistent-scratch ()
  "Load the contents of `persistent-scratch-file-name' into the
  scratch buffer, clearing its contents first."
  (if (file-exists-p "~/.emacs-persistent-scratch")
      (with-current-buffer (get-buffer "*scratch*")
        (delete-region (point-min) (point-max))
        (insert-file-contents "~/.emacs-persistent-scratch"))))

(push #'load-persistent-scratch after-init-hook)
(push #'save-persistent-scratch kill-emacs-hook)

(if (not (boundp 'save-persistent-scratch-timer))
    (setq save-persistent-scratch-timer
          (run-with-idle-timer 300 t 'save-persistent-scratch)))

;;keep cursor at same position when scrolling
(setq scroll-preserve-screen-position 1)

; M-x comment-box.   
; M-x bjm-comment-box.   
(defun bjm-comment-box (b e)
"Draw a box comment around the region but arrange for the region to extend to at least the fill column. Place the point after the comment box."

(interactive "r")

(let ((e (copy-marker e t)))
  (goto-char b)
  (end-of-line)
  (insert-char ?  (- fill-column (current-column)))
  (comment-box b e 1)
  (goto-char e)
  (set-marker e nil)))

(global-set-key (kbd "C-c b b") 'bjm-comment-box)
(global-set-key (kbd "M-z") #'zzz-up-to-char)


; undo-tree is a version of the same Vim’s feature for Emacs
; Emacs’s undo system allows you to recover any past state of a buffer (the standard undo/redo system loses any “redoable” states whenever you make an edit). However, Emacs’s solution, to treat “undo” itself as just another editing action that can be undone, can be confusing and difficult to use.
; Both the loss of data with standard undo/redo and the confusion of Emacs’ undo stem from trying to treat undo history as a linear sequence of changes. undo-tree-mode instead treats undo history as what it is: a branching tree of changes (the same system that Vim has had for some time now). This makes it substantially easier to undo and redo any change, while preserving the entire history of past states.

(message "checkpoint 35")
(use-package undo-tree
  :ensure t
  :diminish undo-tree-mode

  :init (global-undo-tree-mode t)
  :config
  (progn
    (global-undo-tree-mode)
    (setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/my-files/emacs-tmp/undo"))
          undo-tree-visualizer-timestamps t
          undo-tree-visualizer-diff t))
		  
    (define-key undo-tree-map (kbd "C-/") 'undo-tree-undo)		  
    (define-key undo-tree-map (kbd "C-x u") 'undo-tree-visualize)
		  )
 
(defalias 'redo 'undo-tree-redo)
(global-set-key (kbd "C-z") 'undo) ; 【Ctrl+z】
(global-set-key (kbd "C-S-z") 'redo) ; 【Ctrl+Shift+z】;  Mac style

  
  
; fixmee is for quickly navigate to FIXME and TODO notices in Emacs.

; Binding	Call	Do
; C-c f	fixmee-goto-nextmost-urgent	Go to the next TODO/FIXME
; C-c F	fixmee-goto-prevmost-urgent	Go to the previous TODO/FIXME
; C-c v	fixmee-view-listing	View the list of TODOs
; M-n	fixmee-goto-next-by-position	Go to the next TODO/FIXME (above a TODO)
; M-p	fixmee-goto-previous-by-position	Go to the next TODO/FIXME (above a TODO)
(message "checkpoint 36")


; (use-package fixmee
  ; :ensure t
  ; :diminish fixmee-mode
  ; :commands (fixmee-mode fixmee-view-listing)
  ; :init
  ; (add-hook 'prog-mode-hook 'fixmee-mode))

  
  
; (use-package button-lock
  ; :diminish button-lock-mode)	  
  
  
(message "checkpoint 37")

 ; Highlight (too) long lines, and key-words

;;Fontify -------------------------------------
;;Highlight columns longer than 79 lines
(when (> (display-color-cells) 16)         ;if not in CLI
  (add-hook 'prog-mode-hook
            (lambda ()
              (font-lock-add-keywords nil '(("^[^\n]\\{79\\}\\(.*\\)$" 1 font-lock-warning-face t)))
              (font-lock-add-keywords nil '(("\\<\\(FIXA\\|TEST\\|TODO\\|FIXME\\|BUG\\|NOTE\\)"
                                             1 font-lock-warning-face prepend)))
              (font-lock-add-keywords nil '(("\\<\\(__FUNCTION__\\|__PRETTY_FUNCTION__\\|__LINE__\\)"
                                             1 font-lock-preprocessor-face prepend)))
           )))
;;--------------------------------------------


; recentf
; Set up keeping track of recent files, up to 2000 of them.
; If emacs has been idle for 10 minutes, clean up the recent files. Also save the list of recent files every 5 minutes.
; This also only enables recentf-mode if idle, so that emacs starts up faster.

(use-package recentf
  :defer t
  :init
  (progn
    (setq recentf-max-saved-items 100
          recentf-exclude '("/auto-install/" ".recentf" "/repos/" "/elpa/"
                            "\\.mime-example" "\\.ido.last" "COMMIT_EDITMSG"
                            ".gz"
                            "~$" "/tmp/" "/ssh:" "/sudo:" "/scp:")
          recentf-auto-cleanup 600)
    (when (not noninteractive) (recentf-mode 1))

    (defun recentf-save-list ()
      "Save the recent list.
Load the list from the file specified by `recentf-save-file',
merge the changes of your current session, and save it back to
the file."
      (interactive)
      (let ((instance-list (cl-copy-list recentf-list)))
        (recentf-load-list)
        (recentf-merge-with-default-list instance-list)
        (recentf-write-list-to-file)))

    (defun recentf-merge-with-default-list (other-list)
      "Add all items from `other-list' to `recentf-list'."
      (dolist (oitem other-list)
        ;; add-to-list already checks for equal'ity
        (add-to-list 'recentf-list oitem)))

    (defun recentf-write-list-to-file ()
      "Write the recent files list to file.
Uses `recentf-list' as the list and `recentf-save-file' as the
file to write to."
      (condition-case error
          (with-temp-buffer
            (erase-buffer)
            (set-buffer-file-coding-system recentf-save-file-coding-system)
            (insert (format recentf-save-file-header (current-time-string)))
            (recentf-dump-variable 'recentf-list recentf-max-saved-items)
            (recentf-dump-variable 'recentf-filter-changer-current)
            (insert "\n \n;;; Local Variables:\n"
                    (format ";;; coding: %s\n" recentf-save-file-coding-system)
                    ";;; End:\n")
            (write-file (expand-file-name recentf-save-file))
            (when recentf-save-file-modes
              (set-file-modes recentf-save-file recentf-save-file-modes))
            nil)
        (error
         (warn "recentf mode: %s" (error-message-string error)))))))
		 
; Indicate trailing empty lines in the GUI:
(set-default 'indicate-empty-lines t)
(setq show-trailing-whitespace t)


; kill the minibuffer when mouse lose the focus
(defun stop-using-minibuffer ()
  "kill the minibuffer"
  (when (and (>= (recursion-depth) 1) (active-minibuffer-window))
    (abort-recursive-edit)))

(add-hook 'mouse-leave-buffer-hook 'stop-using-minibuffer)