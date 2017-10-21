
(message "loading cbn-helm-config")
;load master first
;; (require 'helm-ag)

(setq all-func-reversed (list))
(setq all-func (list))
(setq this-func-string nil)
(setq this-func nil)

(with-eval-after-load  'helm-ag
  (require 'helm-do-ag-fork-modified)
)
;helm-mini is better than helm-buffers-list
 ;; (define-key evil-normal-state-map (kbd "b") 'helm-buffers-list)
(cibin/global-set-key '("C-x b" . cibin/helm-mini))
(define-key evil-normal-state-map (kbd "b") 'cibin/helm-mini)
(evil-define-key 'normal dired-mode-map (kbd "b") 'cibin/helm-mini)

;(helm-locate "def")

(defun cibin/helm-mini()
  (interactive)
  ;; TODO make this onetime instead of runnig in every calls
  (bind-all-helm-ivy-keys)

(setq all-func '(dummy cibin/find-related-files-helm-saved-input cibin/counsel-find cibin/counsel-locate cibin/helm-find-files ))
(setq all-func-reversed '(cibin/helm-mini))
(helm-mini))

(defun cibin/helm-do-ag-Extension-here-cwd-switchable()
  (interactive)
(cibin/helm-do-ag-Extension-recurse-cwd nil)
)

(defun cibin/counsel-find()
(interactive)
(counsel-find "sf"
             "cat ~/all_files.db|/usr/local/bin/fzy -e%s|head -n 50|sed -e \"s/\\/cygdrive\\/\\(.\\)\\//\\1:\\//\"" saved-helm-input)
;; (global-set-key (kbd "C-x R") (lambda () (interactive) (counsel-find "snf " "bash -ic 'searchnotes . |fzy -e%s|head -n 50' 2>/dev/null" )))

  )


(defun cibin/counsel-locate()
(interactive)
 (counsel-locate saved-helm-input)
  )


(defun cibin/swiper-all()
  (interactive)
  (require 'swiper)
 (swiper-all saved-helm-input)
)

(setq all-func nil )

(defun cibin/swiper()
(interactive)

  (require 'swiper)
(bind-all-helm-ivy-keys)
(setq all-func '(dummy cibin/swiper-all cibin/helm-do-ag-Extension-here-cwd-with-saved-input cibin/helm-do-ag-Extension-recurse-cwd-with-saved-input cibin/swiper cibin/swiper-all cibin/helm-do-ag-Extension-here-cwd-with-saved-input cibin/helm-do-ag-Extension-recurse-cwd-with-saved-input))
(setq all-func-reversed '(cibin/swiper))
(swiper saved-helm-input)
)
(defun bind-all-helm-ivy-keys()
  (with-eval-after-load 'swiper
(define-key swiper-map (kbd "C-o") 'try-prev-function)
  (define-key swiper-map (kbd "C-l") 'try-next-function))

  (with-eval-after-load 'swiper-all
(define-key swiper-all-map (kbd "C-o") 'try-prev-function)
(define-key swiper-all-map (kbd "C-l") 'try-next-function))

(with-eval-after-load 'helm-do-ag
(define-key helm-do-ag-map (kbd "C-o") 'try-prev-function)
(define-key helm-do-ag-map (kbd "C-l") 'try-next-function))


;; (define-key ido-common-completion-map (kbd "C-l") 'try-next-function)
;; (define-key ido-completion-map (kbd "C-l") 'try-next-function)
;; (define-key ido-file-completion-map (kbd "C-l") 'try-next-function)
;; (define-key ido-buffer-completion-map (kbd "C-l") 'try-next-function)
;; (define-key ido-mode-map  "\C-l" 'try-next-function)

;; (define-key minibuffer-local-completion-map  "\C-l" 'try-next-function)
(define-key  ivy-minibuffer-map "\C-l" 'try-next-function)
(define-key ivy-minibuffer-map (kbd "C-l") 'try-next-function)

(define-key  ivy-minibuffer-map "\C-o" 'try-prev-function)
(define-key ivy-minibuffer-map (kbd "C-o") 'try-prev-function)

)

(with-eval-after-load 'helm
(setq
        ;; move to end or beginning of source when reaching top or bottom
        ;; of source
helm-move-to-line-cycle-in-source nil
)
;; (define-key helm-map (kbd "C-h") 'delete-backward-char)

(define-key helm-map (kbd "<left>") 'backward-char)
(define-key helm-map (kbd "<right>") 'forward-char)



;; (define-key helm-map (kbd "<right>") 'forward-char)
;; (define-key global-map (kbd "M-y") 'helm-show-kill-ring)
;; (define-key helm-map (kbd "C-o") 'helm-recentf)
;; (define-key helm-map (kbd "C-o") 'helm-resume-select-buffer)
;; (define-key helm-map (kbd "C-o") 'helm-resume-list-buffers-after-quit)
;; (define-key global-map [remap find-file] 'helm-find-files)
;; (defvar hf-helm-resume-next-key (kbd "C-o"))
;; (defvar hf-helm-resume-prev-key (kbd "C-i"))

(define-key helm-map (kbd "C-l") 'try-next-function)
;; (define-key helm-map (kbd "C-k") 'set-pattern)
)

(with-eval-after-load 'helm-ag
;; TODO
;; (define-key helm-ag-map (kbd "C-l") 'helm-ag--up-one-level)
    (define-key helm-ag-map (kbd "C-l") 'try-next-function)
)
(defun bind-ido-keys()


)
;; (add-hook 'ido-setup-completion-map #'bind-ido-keys)
;; (add-hook 'ido-setup-hook #'bind-ido-keys)
;; (add-hook 'ido-define-mode-map-hook #'bind-ido-keys)
;; (helm-run-after-exit FUNCTION &rest ARGS)
;; helm-run-after-exit exits current helm session, and then runs FUNCTION, so this is what you want:


(defun es/helm-mini-or-projectile-find-file ()
  (interactive)
  (if (helm-alive-p)
      (helm-run-after-exit #'helm-for-files)
    (helm-mini)))
;; To call this command from a helm session, you need to bind a key to it since you can't use helm-M-x, e.g.,

(bind-key "C-c C-p" #'es/helm-mini-or-projectile-find-file)


(defun cbn-helm-next()
  (interactive)
  (message "%s" helm-pattern)
  (helm-run-after-exit #'helm-for-files)
  )

;(define-key helm-map (kbd "C-o") 'cbn-helm-next)

;; (helm-find-files "c:/Users")
;; (helm-find-files-l "c:/Users")
;; helm-set-pattern
;; helm-pattern

(defun cibin/helm-find-files()
  ;; (helm-find-files-1 saved-helm-input)
  ;; (helm-find-files-1 ido-text)
  (helm-find-files-1 ivy--old-text)
  )

(defun cibin/helm-do-ag-Extension-here-cwd-with-saved-input()
(require 'helm-do-ag)
  (cibin/helm-do-ag-Extension-here-cwd saved-helm-input)
)

(defun cibin/helm-do-ag-Extension-recurse-cwd-with-saved-input()
(require 'helm-do-ag)

  (cibin/helm-do-ag-Extension-recurse-cwd saved-helm-input)
)

(defun cibin/find-related-files-helm-saved-input()
  (interactive)
(setq all-func '(dummy  cibin/counsel-find cibin/counsel-locate cibin/helm-find-files ))
(setq all-func-reversed '(cibin/helm-mini))

  (cibin-find-related-files saved-helm-input)
)

(setq saved-helm-input "")

(defun try-next-function()
(interactive)
(setq all-func (cdr all-func))
(add-to-list 'all-func-reversed (car all-func))
(message (format "%s" all-func-reversed))
(message (format "trying.. %s %s"  saved-helm-input (car all-func)))
(setq this-func-string (car all-func))
(message (format "try.. %s %s"  saved-helm-input this-func-string))
(fset 'this-func (car all-func))
;; (run-function 'this-func 'this-func-string)
(run-function)
)

(defun try-prev-function()
  (interactive)
(setq all-func-reversed (cdr all-func-reversed))
(add-to-list 'all-func (car all-func-reversed))
(setq this-func-string (car all-func-reversed))
(fset 'this-func (car all-func-reversed))
;; (run-function this-func this-func-string)
(run-function)
)

;; (defun run-function(this-func this-func-string)
(defun run-function()
  ;; (setq saved-helm-input helm-input)
  (message "inside")
(message (format "trying inside.. %s %s"  saved-helm-input this-func-string))
(if (helm-alive-p)
    (progn (setq saved-helm-input helm-input)
(message "helm exit")
       (helm-run-after-exit this-func-string)
)

(progn
(setq saved-helm-input ivy--old-text)
(message "ivy is quit")
(ivy-quit-and-run (this-func))
)
)

)



;; https://oremacs.com/2015/07/16/callback-quit/
;; Suppose that I've called find-file when ivy-mode is active. Typically, I'd select a file and press C-m to open it. However, sometimes I just want to see the selected file in dired instead of opening it. This code is from before ivy multi-action interface, it plainly binds a command in ivy-minibuffer-map:

;; Sometimes, when you are in callback-function, you might want to abandon the function that called you, useful-command in this case, and call a different function, with the current context.
;; Here's what I've come up with to do just that:

(defmacro ivy-quit-and-run (&rest body)
  "Quit the minibuffer and run BODY afterwards."
  `(progn
     (put 'quit 'error-message "")
     (run-at-time nil nil
                  (lambda ()
                    (put 'quit 'error-message "Quit")
                    ,@body))
     (minibuffer-keyboard-quit)))


; to prevent helm async from hanging emacs
(setq helm-input-idle-delay .1)
(setq helm-cycle-resume-delay 2)
(setq helm-follow-input-idle-delay 1)

(cibin/global-set-key '("C-x p" . cibin/find-related-files-helm-saved-input))

(provide 'cbn-helm-config)
