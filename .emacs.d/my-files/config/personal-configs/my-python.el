; Not lazy loading 
 ; (autoload 'python-mode "python-mode" "Python Mode." t)
 ; (add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
 ; (add-to-list 'interpreter-mode-alist '("python" . python-mode))
 

; (require 'python)
;;; ELPY
; instructions at
; http://onthecode.com/post/2014/03/06/emacs-on-steroids-for-python-elpy-el.html



;; Fixing a key binding bug in elpy
(define-key yas-minor-mode-map (kbd "C-c k") 'yas-expand)
;; Fixing another key binding bug in iedit mode
(define-key global-map (kbd "C-c o") 'iedit-mode)

(setenv "PYTHONPATH" "/cygdrive/c/Program Files (x86)/Python35-32/python")


  (add-hook 'python-mode-hook (lambda () (aggressive-indent-mode -1)(elpy-enable)))

;	
(use-package elpy
  :mode ("\\.py\\'" . python-mode)
  ; :mode ("\\.py\\'" . elpy-mode)
  
  :config
  (when (require 'flycheck nil t)
    (remove-hook 'elpy-modules 'elpy-module-flymake)
    (remove-hook 'elpy-modules 'elpy-module-yasnippet)
    (remove-hook 'elpy-mode-hook 'elpy-module-highlight-indentation)
    ;; (add-hook 'elpy-mode-hook 'flycheck-mode) ;; TODO disabled for now
    )
  ; (elpy-enable) ; TODO disabled for now
  (setq elpy-rpc-backend "jedi"))
  (provide 'my-python)
