(message "loading org-settings")
; (use-package org
  ; :mode (("\\.org$" . org-mode))
  ; :ensure org-plus-contrib
  ; :ensure t
  ; :config

  (progn
    ;; config stuff
    
	
	
;; http://ergoemacs.org/emacs/emacs_org_babel_literate_programing.html


;;  `auto'  Org will look at the surrounding headings/items and try to make an intelligent decision whether to insert a blank line or not.
(setf org-blank-before-new-entry '((heading . nil) (plain-list-item . nil)))


;; todo good one 
; (setq org-agenda-files
      ; (append
       ; (file-expand-wildcards "~/work/org/*.org")
       ; (file-expand-wildcards "~/personal/org/*.org")))
	   
	   
(setq org-agenda-files (list (format "C:/Users/%s/Downloads/todo-notes.org" user-login-name)                            
                        (format "C:/Users/%s/Downloads/todo-stats-notes.org" user-login-name)                           
                        (format "C:/Users/%s/Downloads/work-notes.org" user-login-name)                           
                             "~/.emacs.d/my-files/org/work.org"))
							 
							 
							 ;; todo remove non-existent files
							; (setq org-agenda-files (mapcar (lambda (file) (if (file-exists-p file) file) 'org-agenda-files )))
 
; (eval-after-load "org"
  ; (setq org-agenda-files
        ; (delq nil (mapcar (if (file-exists-p file)
                              ; file)
                          ; org-agenda-files))))
						  
						  
;; set maximum indentation for description lists
(setq org-list-description-max-indent 5)
(use-package org-bullets
  :init
  (setq org-bullets-bullet-list '("◉" "●" "•" "￭" "▪" "▶" "♦" "►" "■" "○" "◎" "￼" "✭" "►" "◇" "♥" "●" "◇" "✚" "✜" "☯" "◆" "♠" "♣" "♦" "☢" "❀" "◆" "◖" "▶" "▸" "●" "•" "▪" "▶" "♦" "►" "■" "○" ))
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
)



(defun cibin/org-insert-heading-respect-content()
  (interactive)
  "insert new heading below"
 (org-insert-heading-respect-content nil)
 (evil-insert-state)
  )

(defun cibin/org-meta-return()
  (interactive)
  (beginning-of-line)
  (org-meta-return)
 (evil-insert-state)
  )
(defun cibin/org-new-subheading()
  (interactive)
  (end-of-line)
  (org-meta-return)
(org-metaright)
 (evil-insert-state)
  )
(defun cibin/org-new-heading()
  (interactive)
  (end-of-line)
  (org-meta-return)
 (evil-insert-state)
;(org-metaright)
  )

(global-set-key (kbd "C-c o") 
                (lambda () (interactive) (find-file "~/organizer.org")))
	   ; The pipe is optional, but if it is present, the task states following it will all be considered by Org to mean “complete

;; (setq org-todo-keywords  '((sequence "TODO" "INFO" "IN-PROGRESS" "WAITING" "|" "DONE" "LATER") ))
(setq org-todo-keywords '((sequence " TODO(t)" "|" " ✔  DONE(d)" " LATER")
(sequence " IN-PROGRESS(p)" "|")
(sequence " WAITING(w)" "|")
(sequence "|" " ✘ CANCELED(c)")))


; TODO evil-org.el
;; normal state shortcuts

(with-eval-after-load 'org
;; prevent demoting heading also shifting text inside sections
(setq org-adapt-indentation nil)
(message "check point 1")
(setq org-startup-idented t)
  (define-key org-mode-map (kbd "C-S-L") 'org-metaright)
  (define-key org-mode-map (kbd "C-S-H") 'org-metaleft)
  (define-key org-mode-map (kbd "C-M-p") 'org-metaup)
  (define-key org-mode-map  (kbd "C-M-n") 'org-metadown)
  
  
  ;; override dragg-stuff
  
  (define-key org-mode-map (kbd "M-S-<up>") 'org-metaup)
  (define-key org-mode-map  (kbd "M-S-<down>") 'org-metadown) 

  (define-key org-mode-map (kbd "M-<left>") 'cibin/org-do-promote)
  (define-key org-mode-map  (kbd "M-<right>") 'org-do-demote) 


	(define-key org-mode-map (kbd "M-r") 'org-toggle-heading)
  (define-key org-mode-map (kbd "M-e") 'other-window) ;; bring back this key
	(define-key org-mode-map [S-return] 'cibin/org-new-subheading)
	(define-key org-mode-map [C-return] 'cibin/org-new-heading)
	(define-key org-mode-map [M-return] 'cibin/org-meta-return)
	(evil-define-key 'normal org-mode-map [C-return] 'cibin/org-new-heading)
	(evil-define-key 'normal org-mode-map [M-return] 'cibin/org-meta-return)
  (evil-define-key 'normal org-mode-map
  "gh" 'outline-up-heading
  "gj" (if (fboundp 'org-forward-same-level) ;to be backward compatible with older org version
	   'org-forward-same-level  'org-forward-heading-same-level)
  "gk" (if (fboundp 'org-backward-same-level)
	   'org-backward-same-level 'org-backward-heading-same-level)

  "go" 'outline-previous-heading
  "gl" 'outline-next-visible-heading
  "T" '(lambda () (interactive) (evil-org-eol-call (lambda() (org-insert-todo-heading nil))))
  "H" 'org-shiftleft
  ; "J" 'org-shiftdown
  "J" 'outline-next-visible-heading
  ; "K" 'org-shiftup
  "K" 'outline-previous-visible-heading
  "L" 'org-shiftright
  ;; "o" '(lambda () (interactive) (evil-org-eol-call 'clever-insert-item))
  "O" '(lambda () (interactive) (evil-org-eol-call 'org-insert-heading))
  "$" 'org-end-of-line
  "^" 'org-beginning-of-line
  "<" 'org-metaleft
  ">" 'org-metaright
  "-" 'org-cycle-list-bullet
  (kbd "<tab>") 'org-cycle
  )


(define-key org-mode-map (kbd "<f2>") (lambda () (interactive)  (my/org-toggle-heading-and-todo "DONE")))
(define-key org-mode-map  (kbd "<S-f2>") (lambda () (interactive)  (my/org-toggle-heading-and-todo "TODO")))
)
(defun cibin/org-do-promote()
(interactive)
(message "promoting again will club other headings too !!!!!")
(org-do-promote)
)
(defun my/org-toggle-heading-and-todo (arg)
  "Toggles the current line between a non-heading and TODO heading."
  (interactive)

(let ((is-heading))
    (save-excursion
      (forward-line 0)
      (when (looking-at "^\\*") 
        (setq is-heading t)))
    (if is-heading 
        (progn
          (org-todo 'none) ; remove TODO
          (org-toggle-heading) ; remove heading
        (forward-line))
      (progn
        (org-toggle-heading) ; convert to heading
        (org-todo arg) ; add TODO
(org-metaleft)
        (forward-line)
        ; (forward-line)
       ; (next-line)
       )
        )))
        ; (org-todo 'nextset)))) ; add TODO

;; Minimal outline
;; If you have read how headlines are written in org, you can notice that it is by the number of “*” before it. To make it look better, let’s indent every heading and remove all the “*” but the last one.

(setq org-startup-indented t
      org-hide-leading-stars t)
;; Images
;; The GUI Emacs has the ability to display images. But if the image is pretty large, it displays the whole thing. Let’s restrict it from doing that.

(setq org-image-actual-width '(300))

;; make org mode allow eval of some langs
(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (clojure . t)
 (C . t)
 (css . t)
 (sh . t)
 (awk . t)
 (R . t)
 (shell . t)
 (http . t)
   (python . t)
 (restclient . t)
   (ruby . t)))

;; stop emacs asking for confirmation
(setq org-confirm-babel-evaluate nil)
(setq org-src-fontify-natively t)


;; org-babel result to a separate buffer
;; There is a way to open org-babel outpupt in a separate buffer with C-o - org-open-at-point is fancy like that. The problem is, the result block is created. But there is also a command org-babel-remove-result. Combining the two, I made a little dirty hack
;; https://emacs.stackexchange.com/questions/23870/org-babel-result-to-a-separate-buffer
(defun my-babel-to-buffer ()
  "A function to efficiently feed babel code block result to a separate buffer"
  (interactive)
  (org-open-at-point)
  (org-babel-remove-result)
)

(defun my-org-mode-config ()
  "To use with `org-mode-hook'"
  (local-set-key (kbd "C-`") 'my-babel-to-buffer)
)

(add-hook 'org-mode-hook 'my-org-mode-config)


(let* ((variable-tuple (cond ((x-list-fonts "Source Sans Pro") '(:font "Source Sans Pro"))
                             ((x-list-fonts "Lucida Grande")   '(:font "Lucida Grande"))
                             ((x-list-fonts "Verdana")         '(:font "Verdana"))
                             ((x-family-fonts "Sans Serif")    '(:family "Sans Serif"))
                             (nil (warn "Cannot find a Sans Serif Font.  Install Source Sans Pro."))))
       (base-font-color     (face-foreground 'default nil 'default))
       (headline           `(:inherit default :weight bold :foreground ,base-font-color)))

  (custom-theme-set-faces 'user
                          `(org-level-8 ((t (,@headline ,@variable-tuple))))
                          `(org-level-7 ((t (,@headline ,@variable-tuple))))
                          `(org-level-6 ((t (,@headline ,@variable-tuple))))
                          `(org-level-5 ((t (,@headline ,@variable-tuple))))
                          `(org-level-4 ((t (,@headline ,@variable-tuple :height 1.15))))
                          `(org-level-3 ((t (,@headline ,@variable-tuple :height 1.2))))
                          `(org-level-2 ((t (,@headline ,@variable-tuple :height 1.2 :foreground "green"))))
                          `(org-level-1 ((t (,@headline ,@variable-tuple :height 1.2 :foreground "yellow"))))
                          `(org-document-title ((t (,@headline ,@variable-tuple :height 1.5 :underline nil))))))

)
; )

;; todo see @headline and @ variable-tuple above
  (custom-theme-set-faces 'user

'(org-agenda-date ((t (:inherit org-agenda-structure :weight semi-bold :height 1.2))) t)
'(org-date ((t (:foreground "dim gray" :underline t :height 0.8 :family "Helvetica Neue"))))
'(org-done ((t (:foreground "gray57" :weight light))))
'(org-level-1 ((t (:weight semi-bold :height 1.5 :family "Helvetica Neue"))))
'(org-level-2 ((t (:inherit outline-2 :weight semi-bold :height 1.25))))
'(org-level-3 ((t (:inherit outline-3 :weight bold :family "Helvetica Neue"))))
'(org-level-4 ((t (:inherit outline-4 :height 1.15 :family "Helvetica Neue"))))
'(org-level-5 ((t (:inherit outline-5 :height 1.0 :family "Helvetica Neue"))))

'(org-link ((t (:inherit link :weight normal))))
'(org-meta-line ((t (:inherit font-lock-comment-face :height 0.8))))
'(org-property-value ((t (:height 0.9 :family "Helvetica Neue"))) t)
'(org-special-keyword ((t (:inherit font-lock-keyword-face :height 0.8 :family "Helvetica Neue"))))
'(org-table ((t (:foreground "black" :height 0.9 :family "Menlo"))))
'(org-tag ((t (:foreground "dark gray" :weight bold :height 0.8))))
'(org-todo ((t (:foreground "#e61e22" :weight bold))))
)
