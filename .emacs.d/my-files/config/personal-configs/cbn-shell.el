(message "loading cbn-shell")
;;; Shell mode
(setq ansi-color-names-vector ; better contrast colors
      ["black" "red4" "green4" "yellow4"
       "blue3" "magenta4" "cyan4" "white"])
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
; I also use these settings to turn off word wrap and to make the prompt read-only:

(add-hook 'shell-mode-hook 
     '(lambda () (toggle-truncate-lines 1)))
(setq comint-prompt-read-only t)

(use-package ido
:defer t)
(use-package cl-lib
:defer t)
(use-package shell
:defer t)
;(require 'ido)
;(require 'cl-lib)
;(require 'shell)

(defvar my-dir-selected nil "Flag to indicate that user has selected the directory")

(defun my-filter-cd-input (current-input)
  "Takes current user input for `cd' the a list
    whose car is the 'maximum possible directory path'
    and cdr is remaining string.

    Examples:
    '~/.emacs.d/in => ('~./emacs.d/' 'in')
    '/home/gue' => ('/home/' 'gue')
    '~/../' => ('~/../' '')"
  (let* ((unquoted-input (shell-unquote-argument current-input))
     (components (split-string unquoted-input "/"))
         (directory-parts (butlast components))
         (possible-prefix (car (last components))))
    (list (if (string= possible-prefix "")
              unquoted-input
            (concat (mapconcat 'identity directory-parts "/")
                    (when directory-parts "/")))
          possible-prefix)))

(defun my-complete-directory-name (directory current-input)
  "Prompts user for directories in `directory', `current-input'
    is the string entered by the user till now"
  (let* ((filtered-input (my-filter-cd-input current-input))
         (directory-path (car filtered-input))
         (partial-input (cadr filtered-input))
         (directory-choices (mapcar 'file-name-nondirectory
                                    (condition-case nil
                                        (cl-remove-if-not 'file-directory-p
                                                          (directory-files (concat directory directory-path) t))
                                      ('file-error (list)))))
         (selected-name (ido-completing-read "Directory: "
                                             directory-choices
                                             nil nil partial-input)))
    (comint-delete-input)
    (insert (concat "cd " 
            (shell-quote-argument (concat directory-path selected-name "/"))))))

(defun my-prompt-for-dir-or-fallback ()
  "If current shell command is `cd' prompt for directory
    using ido otherwise fallback to normal completion"
  (interactive)
  (let* ((user-input (buffer-substring-no-properties (comint-line-beginning-position)
                                                     (point-max))))
    (if (and (>= (length user-input) 3)
             (string= (substring user-input 0 3) "cd "))
        (progn 
          (setq my-dir-selected nil)
          (while (not my-dir-selected)
            (my-complete-directory-name default-directory 
                    (buffer-substring-no-properties (+ (comint-line-beginning-position) 3) 
                                    (point-max))))
          (comint-send-input))
      (call-interactively 'completion-at-point))))

;; TODO re enable (define-key shell-mode-map (kbd "<tab>") 'my-prompt-for-dir-or-fallback)

(add-hook 'ido-setup-hook 'ido-my-keys)

(defun ido-my-keys ()
  "Add my keybindings for ido."
  (define-key ido-completion-map (kbd "<C-return>") (lambda ()
                                                        (interactive)
                                                        (setq my-dir-selected t)
                                                        (ido-exit-minibuffer))))
														
														
														

; make completion buffers disappear after 3 seconds.
(add-hook 'completion-setup-hook
  (lambda () (run-at-time 3 nil
    (lambda () (delete-windows-on "*Completions*")))))

;; run a few shells.
; (shell "*shell5*")
; (shell "*shell7*")

; C-5, 6, 7 to switch to shells
(global-set-key [(control \5)]
  (lambda () (interactive) (switch-to-buffer "*shell5*")))
(global-set-key [(control \6)]
  (lambda () (interactive) (switch-to-buffer "*shell6*")))
(global-set-key [(control \7)]
  (lambda () (interactive) (switch-to-buffer "*shell7*")))
  
  
; Running a shell command on current file

; TODO for dired also http://stackoverflow.com/questions/10121944/passing-emacs-variables-to-minibuffer-shell-commands

; In vim, it's pretty common to run commands like 
; :!gcc % 
; It's pretty simple and the syntax is really easy to remember, ":" for command mode, "!" to run something, and in the command "%" will be replaced by your filename. 

(defun shell-execute ()
; http://puntoblogspot.blogspot.in/2013/04/running-shell-command-on-current-file.html
	(interactive)
	(let ((file-buffer (or (buffer-file-name) ""))
	(command (read-shell-command "Shell command: " nil nil nil)))
	(shell-command (replace-regexp-in-string "%" file-buffer command))))
; todo check if hk needs a change
(cibin/global-set-key '("M-!" . shell-execute))



(cibin/global-set-key '("<f1>" . shell-here))


;; interpret ANSI color codes in compilation buffers
(require 'ansi-color)
(defun colorize-compilation-buffer ()
  (when (eq major-mode 'compilation-mode)
    (ansi-color-apply-on-region compilation-filter-start (point-max))))
(add-hook 'compilation-filter-hook 'colorize-compilation-buffer)
(provide 'cbn-shell)
