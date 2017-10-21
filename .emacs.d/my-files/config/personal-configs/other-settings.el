(message "loading other-settings")
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


    (let ((dir (ido-completing-read "choose recent directory? "
				  recent-dirs )))
      (dired dir))
	  ))

(cibin/global-set-key '("C-x C-d" . bjm/ivy-dired-recent-dirs))

;; make the left fringe 4 pixels wide and the right disappear
(fringe-mode '(20 . 8))


;; SCROLLING
(menu-bar-mode 1)
(when (display-graphic-p)
	(tool-bar-mode 1)
	(scroll-bar-mode 1)
(set-scroll-bar-mode 'left)
  )

;; Smooth scrolling
;; Scroll one line at a time, less 'jumpy' than the default.
;; scroll one line at a time (less "jumpy" than defaults)
(setq mouse-wheel-scroll-amount '(3 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 3) ;; keyboard scroll one line at a time
;;keep cursor at same position when scrolling
(setq scroll-preserve-screen-position 1)


;;TODO see if this works
;;ensure that M-v always undoes C-v, so you can go back exactly.
(setq scroll-preserve-screen-position 'always)
;; we use yascroll for the scrollbar instead
; (require 'yascroll)
; (global-yascroll-bar-mode 1)
; (setq yascroll:delay-to-hide nil)

; Scrolling behavior
; Emacs’s default scrolling behavior, like a lot of the default Emacs experience, is pretty idiosyncratic. The following snippet makes for a smoother scrolling behavior when using keyboard navigation.
;; TODO disabling for now
;; (setq redisplay-dont-pause t
      ;; scroll-margin 4
      ;; scroll-step 1
      ;; scroll-conservatively 10000
      ;; scroll-preserve-screen-position 1)

                                        ; Scroll smoothly rather than by paging
;; (setq scroll-step 1)
;; If you want the text to scroll one line at a time when you move the cursor past the top or bottom of the window, use the following setting:
 (setq scroll-conservatively 10000)
;; Unfortunately, the text still jumps sometimes, in a really irritating way. I haven’t been able to work out why or how to stop it.
;; → here’s a fix: http://zhangda.wordpress.com/2009/05/21/customize-emacs-automatic-scrolling-and-stop-the-cursor-from-jumping-around-as-i-move-it/
   (setq scroll-margin 5
      scroll-conservatively 0
      scroll-up-aggressively 0.01
      scroll-down-aggressively 0.01)
    (setq-default scroll-up-aggressively 0.01
      scroll-down-aggressively 0.01)

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

  ; (cibin/global-set-key '("C-c s" . fc/toggle-shell))
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
  ; (cibin/global-set-key '("<C-down>" . mc/mark-next-like-this))
  ; (cibin/global-set-key '("<C-up>" . mc/unmark-next-like-this))
  ; (cibin/global-set-key '("<C-mouse-1>" . mc/add-cursor-on-click))
; (global-unset-key (kbd "M-<down-mouse-1>"))
; (cibin/global-set-key '("M-<mouse-1>" . mc/add-cursor-on-click))

  ; )

(setq shift-select-mode t)

; http://ergoemacs.org/emacs/emacs_make_modern.html
; save minibuffer history
(savehist-mode 1)

; (setq backup-by-copying t) ; stop emacs's backup changing the file's creation date of the original file?
(defvar --backup-directory (concat user-emacs-directory "my-emacs-backup"))

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

;; Automatically save and restore sessions
(setq desktop-dirname             "~/.emacs.d/my-files/desktop/"
      desktop-base-file-name      "emacs.desktop"
      desktop-base-lock-name      "lock"
      desktop-path                (list desktop-dirname)
      desktop-save                t
      desktop-files-not-to-save   "^$" ;reload tramp paths
      desktop-load-locked-desktop nil)
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
        ("pictures" . "~/Pictures/" )
        ("download" . "~/Downloads/" )
        ;; more here
        ) )

	(set-face-attribute 'vertical-border nil :foreground (face-attribute 'fringe :background))

(setq inhibit-startup-message t)
(setq inhibit-splash-screen t)
(setq  initial-major-mode 'org-mode)
(setq initial-scratch-message nil)
(setq initial-buffer-choice "~/")
(setq x-select-enable-clipboard t)

(use-package dired-aux
:defer t)
;(require 'dired-x)
;(require 'dired-aux)

(use-package dired-x
:defer t)

(setq dired-guess-shell-alist-user
      '(("\\.pdf\\'" "evince")
        ("\\.\\(?:djvu\\|eps\\)\\'" "zathura")
        ("\\.\\(?:jpg\\|jpeg\\|png\\|gif\\|xpm\\)\\'" "eog")
        ("\\.\\(?:xcf\\)\\'" "gimp")
        ("\\.\\(?:csv\\|odt\\|ods\\)\\'" "libreoffice")
        ("\\.\\(?:mp4\\|mp3\\|mkv\\|avi\\|flv\\|ogv\\)\\(?:\\.part\\)?\\'"
         "vlc")
        ("\\.html?\\'" "firefox")))


(global-set-key [C-right] 'geosoft-forward-word)
(global-set-key [C-left] 'geosoft-backward-word)
(global-set-key [f4] 'bubble-buffer)

; to make sure case is preserved when expanding
(setq dabbrev-case-replace nil)

(global-set-key [S-return]   'open-next-line)
(global-set-key [C-return] 'open-previous-line-move-down)
(global-set-key [M-return] 'open-previous-line)

(cibin/global-set-key '("C-o" . open-next-line))
(cibin/global-set-key '("M-o" . open-previous-line))

; The following makes you lose vim commands, but gives you back basic emacs commands, like C-y to paste in insert mode or C-r to search backward:



  ; golden-ratio

; Give the working window more screen estate.
  (use-package golden-ratio
  :diminish golden-ratio-mode
  :config (progn
            (add-to-list 'golden-ratio-extra-commands 'ace-window)
            (golden-ratio-mode 1)

            (defun my/helm-alive-p ()
      (if (boundp 'helm-alive-p)
          (symbol-value 'helm-alive-p)))

    ;; Inhibit helm
    (add-to-list 'golden-ratio-inhibit-functions #'my/helm-alive-p)
            ))


; volatile-highlights
; Highlights recently copied/pasted text.

(use-package volatile-highlights
  :diminish volatile-highlights-mode
  :config (volatile-highlights-mode t))




; Large file warning
; Whenever, a large file (by Emacs standards) is opened, it asks for confirmation whether we really want to open it but the problem is the limit for this file is set pretty low. Let’s increase it a bit so that it doesn’t prompt so often.

(setq large-file-warning-threshold (* 5 1024 1024))

; vlf (view large files)
; VLF lets me handle things like 2gb files gracefully.
;; (require 'vlf-setup)
;; (setq vlf-application 'dont-ask)
(use-package vlf-setup
 :defer t
  :config
   (progn
     (setq vlf-application 'dont-ask)

  ;(define-key vlf-mode-map "." 'nsh/hydra-large-files-vlf/body)

     )
   )

(defun my-find-file-check-make-large-file-read-only-hook ()
  "If a file is over a given size, make the buffer read only."
  (when (> (buffer-size) (* 1024 1024))
    (setq buffer-read-only t)
    (buffer-disable-undo)
    (fundamental-mode)))
(add-hook 'find-file-hook 'my-find-file-check-make-large-file-read-only-hook)

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


				  (cibin/global-set-key '("C-c b c" . quick-calc))


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

(cibin/global-set-key '("C-c b b" . bjm-comment-box))
(cibin/global-set-key '("M-z" . zzz-up-to-char))


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
(cibin/global-set-key '("C-z" . undo)) ; 【Ctrl+z】
(cibin/global-set-key '("C-S-z" . redo)) ; 【Ctrl+Shift+z】;  Mac style



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


(defun hop-one-transpose ()
  "Transpose words that are separated by a single word."
  (interactive)
  (transpose-words 2)
  (backward-word 3)
  (forward-char)
  (transpose-words 1))

(cibin/global-set-key '("C-x M-t" . hop-one-transpose))
(defun my-kill-thing-at-point (thing)
  "Kill the `thing-at-point' for the specified kind of THING."
  (let ((bounds (bounds-of-thing-at-point thing)))
    (if bounds
        (kill-region (car bounds) (cdr bounds))
      (message "No %s at point" thing)
      ;; (error "No %s at point" thing)
      )))


                              ; open all files with same extension
;; (cibin/global-set-key '("C-x l " . open-similar-files-in-folder))
;; (cibin/global-set-key '("C-x l " . open-similar-files-in-folder-recursively))

(defun open-similar-files-in-folder() (interactive) (message  "opening all similar")(find-file (format "*.%s" (file-name-extension (buffer-file-name))) t)
                                (message  "opened all similar files of extension"))
(defun open-similar-files-in-folder-recursively() (interactive) (message  "opening all similar Recursively")

       (setq all-files (directory-files-recursive  (file-name-directory buffer-file-name) (format "\\%s$" (file-name-extension (buffer-file-name)))  2 "\\(rip\\|stage\\)"))
;; (setq all-files (directory-files-recursive "c:/cbn_gits/AHK/paste_collector" "\\.ahk$" 2 "\\(rip\\|stage\\)"))
;; (message "%s" all-files)
(if (y-or-n-p  (format "%s files. Proceed?" (length all-files)))
    (progn
(dolist (file all-files)
 (if (not (file-directory-p file))
 (find-file-noselect file)
 ))
(message  "opened all similar files of extension"))


  (progn
(message "cancelled")
  )))

; (mapc #'find-file-noselect
   ; (directory-files "~/git/LeoUfimtsev.github.io/org/" nil "\\.org$"))



   ;; subword-mode remaps most key bindings but not these.
(global-set-key [(control right)] 'subword-forward)
(global-set-key [(control left)] 'subword-backward)




; customization options
(custom-set-variables

'(read-file-name-completion-ignore-case t)

'(diff-default-read-only nil)  ; don't make diff mode (for patches) read-only
  '(diff-switches "-u --ignore-all-space")


  '(undo-limit 1000000)  ; 1M (default is 80K)
  '(undo-strong-limit 1500000)  ; 1.5M (default is 120K)
  '(undo-outer-limit 2000000)  ; 2M

 '(kill-read-only-ok t)  ; C-k in read-only buffer doesn't error


)

;; automatically close buffers that haven't been displayed in more than n days
;(require 'midnight)
(use-package midnight
:defer t)
(custom-set-variables '(clean-buffer-list-delay-general 2))


; From https://github.com/purcell/emacs.d/blob/master/lisp/init-auto-complete.el - Exclude very large buffers from dabbrev
(defun sanityinc/dabbrev-friend-buffer (other-buffer)
  (< (buffer-size other-buffer) (* 1 1024 1024)))

(setq dabbrev-friend-buffer-function 'sanityinc/dabbrev-friend-buffer)
(setq hippie-expand-try-functions-list
      '(yas-hippie-try-expand
        try-expand-all-abbrevs
        try-complete-file-name-partially
        try-complete-file-name
        try-expand-dabbrev
        try-expand-dabbrev-from-kill
        try-expand-dabbrev-all-buffers
        try-expand-list
        try-expand-line
        try-complete-lisp-symbol-partially
        try-complete-lisp-symbol))

(defun lorem ()
  "Insert a lorem ipsum."
  (interactive)
  (insert "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do "
          "eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim"
          "ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut "
          "aliquip ex ea commodo consequat. Duis aute irure dolor in "
          "reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla "
          "pariatur. Excepteur sint occaecat cupidatat non proident, sunt in "
          "culpa qui officia deserunt mollit anim id est laborum."
		  )
		  )
(progn
;; from xah
;; set arrow keys in isearch. left/right is backward/forward, up/down is history. press Return to exit
    (define-key isearch-mode-map (kbd "<up>") 'isearch-ring-retreat )
    (define-key isearch-mode-map (kbd "<down>") 'isearch-ring-advance )

    (define-key isearch-mode-map (kbd "<left>") 'isearch-repeat-backward)
    (define-key isearch-mode-map (kbd "<right>") 'isearch-repeat-forward)

    (define-key minibuffer-local-isearch-map (kbd "<left>") 'isearch-reverse-exit-minibuffer)
    (define-key minibuffer-local-isearch-map (kbd "<right>") 'isearch-forward-exit-minibuffer)
	)

;;IBUFFER Hacks
; http://martinowen.net/blog/2010/02/03/tips-for-emacs-ibuffer.html
(setq ibuffer-saved-filter-groups
  (quote (("default"

            ("dired" (mode . dired-mode))
 ("emacs-config" (or (filename . ".emacs.d")
			     (filename . "emacs-config")))
         ("martinowen.net" (filename . "martinowen.net"))
	 ("Org" (or (mode . org-mode)
		    (filename . "OrgMode")))
         ("Web Dev" (or (mode . html-mode)
			(mode . css-mode)))
	 ("Subversion" (name . "\*svn"))
	 ("Magit" (name . "\*magit"))

            ("Mail"
              (or  ;; mail-related buffers
               (mode . message-mode)
               (mode . mail-mode)
               ;; etc.; all your mail related modes
               ))
            ("MyProject1"
              (filename . "src/myproject1/"))
            ("MyProject2"
              (filename . "src/myproject2/"))
            ("Programming" ;; prog stuff not already in MyProjectX
              (or
                (mode . c-mode)
                (mode . perl-mode)
                (mode . python-mode)
;                (mode . emacs-lisp-mode)
                ;; etc
                ))
	 ("Emacs " (or (name . "\*Help\*")
		     (name . "\*Apropos\*")
		     (name . "\*Messages\*")
		     (name . "\*\*")
		     (name . "\*\*")
		     (name . "\*info\*")))

            ("ERC"   (mode . erc-mode))))))

(add-hook 'ibuffer-mode-hook
  (lambda ()
    (ibuffer-switch-to-saved-filter-groups "default")))
(setq ibuffer-show-empty-filter-groups nil)


; ibuffer-auto-mode
; ibuffer-auto-mode is a minor mode that automatically keeps the buffer list up to date. I turn it on in my ibuffer-mode-hook:

(add-hook 'ibuffer-mode-hook
	  '(lambda ()
	     (ibuffer-auto-mode 1)
	     (ibuffer-switch-to-saved-filter-groups "default")))





(defun cibin-apply-major-mode ()
  "apply major mode "
  (interactive)
  (let (
         (-suffix-map
          `(
            ("py" . "python-mode")
            ("sh" . "bash")
            ("org" . "org-mode")
            ("txt" . "text-mode")
            ("ahk" . "ahk-mode")
            ))
         -fname
         -fSuffix
         -prog-name
         -cmd-str)


    (setq -fname (buffer-file-name))
    (setq -fSuffix (file-name-extension -fname))
    (setq -prog-name (cdr (assoc -fSuffix -suffix-map)))
                                        ; apply the mode from variable
    (funcall (intern -prog-name))
))
    ;; (add-to-list 'auto-mode-alist '("\\.xml$" . web-mode))
    (add-to-list 'auto-mode-alist '("\\.xml$" . nxml-mode))
    (add-to-list 'auto-mode-alist '("\\.bashrc$" . shell-mode))
;; TODO    ;; (add-to-list 'auto-mode-alist '("\\.readme.md" . shell-mode))

(blink-cursor-mode 1)
;; uses package "scratch"
; if you use M-x scratch it will launch a scratch buffer for the current mode. So in my org-mode buffer
(autoload 'scratch "scratch" nil t)

;; TODO disabling for now as error
(global-eldoc-mode -1)


(menu-bar-mode 1)

;; vkill
;; Visually kill programs and processes, I use helm-occur here (thanks John Wiegley!) because it makes selecting things much easier.

(use-package vkill
  :defer t
  :commands vkill
  :bind ("C-x L" . vkill-and-helm-occur)
  :init
  (defun vkill-and-helm-occur ()
    (interactive)
    (vkill)
    (my/turn-on-hl-line-mode)
    (call-interactively #'helm-occur)))
;(require 'keyfreq)
(use-package keyfreq
:defer t)
(setq keyfreq-excluded-commands
      '(self-insert-command
        abort-recursive-edit
        forward-char
        backward-char
        previous-line
        next-line))
(keyfreq-mode 1)
(keyfreq-autosave-mode 1)

;; auto select buffer on mouse focus
(setq mouse-autoselect-window t)

;; TODO disabling for now
(global-eldoc-mode -1)

;; http://blog.binchen.org/posts/new-git-timemachine-ui-based-on-ivy-mode.html
(defun my-git-timemachine-show-selected-revision ()
  "Show last (current) revision of file."
  (interactive)
  (let* ((collection (mapcar (lambda (rev)
                    ;; re-shape list for the ivy-read
                    (cons (concat (substring-no-properties (nth 0 rev) 0 7) "|" (nth 5 rev) "|" (nth 6 rev)) rev))
                  (git-timemachine--revisions))))
    (ivy-read "commits:"
              collection
              :action (lambda (rev)
                        ;; compatible with ivy 9+ and ivy 8
                        (unless (string-match-p "^[a-z0-9]*$" (car rev))
                          (setq rev (cdr rev)))
                        (git-timemachine-show-revision rev)))))

(defun my-git-timemachine ()
  "Open git snapshot with the selected version.  Based on ivy-mode."
  (interactive)
  (unless (featurep 'git-timemachine)
    (require 'git-timemachine))
  (git-timemachine--start #'my-git-timemachine-show-selected-revision))



;; Remove trailing whitespace
(add-hook 'before-save-hook 'delete-trailing-whitespace)


(spacemacs/set-leader-keys "<SPC>" 'helm-M-x)



(provide 'other-settings)
