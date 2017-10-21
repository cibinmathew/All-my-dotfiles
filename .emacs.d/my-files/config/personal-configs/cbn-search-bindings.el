(message "loading cbn-search-bindings")
; http://www.cibinmathew.com
; github.com/cibinmathew



(use-package flx-ido
  :ensure t
  :defer t)


(ivy-mode 1)
(setq ivy-use-virtual-buffers t)

(setq ivy-count-format "%d/%d ") 
(setq ivy-display-style 'fancy)
;;advise swiper to recenter on exit . The other tweak I have made is to get swiper to recenter the display when it exits – I found it a little unpredictable where the point was going to be after I finished swiper. This is done with a little bit of advice
(defun bjm-swiper-recenter (&rest args)
  "recenter display after swiper"
  (recenter)
  )
(advice-add 'swiper :after #'bjm-swiper-recenter)

(cibin/global-set-key '("C-c C-r" . ivy-resume))
; (cibin/global-set-key '("<f6>" . ivy-resume))
; (cibin/global-set-key '("M-x" . counsel-M-x))
; (cibin/global-set-key '("C-x C-f" . counsel-find-file))
; (cibin/global-set-key '("<f1> f" . counsel-describe-function))
; (cibin/global-set-key '("<f1> v" . counsel-describe-variable))
; (cibin/global-set-key '("<f1> l" . counsel-find-library))
; (cibin/global-set-key '("<f2> i" . counsel-info-lookup-symbol))
; (cibin/global-set-key '("<f2> u" . counsel-unicode-char))
; (cibin/global-set-key '("C-c g" . counsel-git))
; (cibin/global-set-key '("C-c j" . counsel-git-grep))
; (cibin/global-set-key '("C-c k" . counsel-ag))
; (cibin/global-set-key '("C-x l" . counsel-locate))
; (cibin/global-set-key '("C-S-o" . counsel-rhythmbox))
; (define-key read-expression-map (kbd "C-r") 'counsel-expression-history)



; https://www.emacswiki.org/emacs/SearchAtPoint

; If swiper is used, the following key bindings can be defined to simulate “*” in Vim with a better interface:
  (define-key evil-normal-state-map (kbd "8") 'evil-search-word-forward)
(define-key evil-normal-state-map (kbd "8") 'cibin/fast-search-activate)
(defun cibin/fast-search-activate()
(interactive)
  (evil-search-word-forward)
  (cibin/fast-search/body)
  )
  ;; (define-key evil-normal-state-map (kbd "9") 'evil-search-word-backward)
  (define-key evil-normal-state-map (kbd "*")
    (lambda () (interactive) (swiper (format "\\<%s\\>" (thing-at-point 'symbol)))))
  (define-key evil-normal-state-map (kbd "#")
    (lambda () (interactive) (swiper (format "\\<%s\\>" (thing-at-point 'word)))))
	



                                        ; TODO
(cibin/global-set-key '("C-s" . ora-swiper)	)
(cibin/global-set-key '("\C-s" . avy-goto-char-timer))	
; ora-swiper is better than my-search-method-according-to-numlines
; (global-set-key "\C-s" 'my-search-method-according-to-numlines)

;;; remove ;; (global-set-key "\C-s" (lambda () (interactive) (swiper (format "\\<%s\\>" (thing-at-point 'word)))))

;; Use regex searches by default.
; (cibin/global-set-key '("C-s" . isearch-forward-regexp))
(cibin/global-set-key '("C-r" . vr/query-replace))
;; (define-key global-map (kbd "C-c l") 'vr/replace)
(define-key evil-normal-state-map (kbd "C-r") 'vr/query-replace)
(cibin/global-set-key '("C-M-s" . isearch-forward-regexp))
(cibin/global-set-key '("C-M-r" . isearch-backward-regexp))


;; Activate occur easily inside isearch
(define-key isearch-mode-map (kbd "C-o")
  (lambda () (interactive)
    (let ((case-fold-search isearch-case-fold-search))
      (occur (if isearch-regexp isearch-string (regexp-quote isearch-string))))))

	  
;; make isearch treat space dash underscore newline as same
(setq search-whitespace-regexp "[-_ \n]")
; put isearch-dabbrev.el somewhere in your load-path and add these lines to your .emacs:

    (use-package isearch-dabbrev
  :defer t)
(eval-after-load "isearch"
  '(progn
     ;(require 'isearch-dabbrev)
	 
     (define-key isearch-mode-map (kbd "<tab>") 'isearch-dabbrev-expand)))
	
	
; http://karl-voit.at/2016/04/09/chosing-emacs-search-method/
 (defun my-search-method-according-to-numlines ()
    "Determines the number of lines of current buffer and chooses a search method accordingly"
    (interactive)
    (if (< (count-lines (point-min) (point-max)) 20000)
        (swiper)
      (isearch-forward)
      )
    )
(defun ora-swiper ()
  (interactive)
  (if (and (buffer-file-name)
           (not (ignore-errors
                  (file-remote-p (buffer-file-name))))
           (if (eq major-mode 'org-mode)
               (> (buffer-size) 60000)
             (> (buffer-size) 300000)))
      (progn
        (save-buffer)
        (counsel-grep))
    ;; swiper without default word
     (swiper--ivy (swiper--candidates))
; or
    ;; TODO autoselect word
    ;; (swiper (format "\\<%s\\>" (thing-at-point 'word)))
    ;; (swiper (format "%s" (thing-at-point 'word)))
	))

	
;; TODO
; (defun joe-duckduckgo-search (browser)
(defun joe-duckduckgo-search ()
  "Search DuckDuckGo from Emacs."
  ; (interactive)
  (setq myWord
	(if (region-active-p)
	(buffer-substring-no-properties (region-beginning) (region-end))
	(thing-at-point 'symbol)))
	


  
	
  (let ((search
        (concat "https://google.com/?q="
                (read-from-minibuffer "sDuckDuckGo: " myWord))))
				(message "%s" myWord)
    ; (if browser
        (browse-url search)
      (browse-web search)
	  ;)
	  ))
	  
	  

;; http://stackoverflow.com/questions/2641211/emacs-interactively-search-open-buffers
(defun my-multi-occur-in-matching-buffers (regexp &optional allbufs)
  "Show lines matching REGEXP in all file-visiting buffers.

Given a prefix argument, search in ALL buffers."
  (interactive (occur-read-primary-args))
  (multi-occur-in-matching-buffers "." regexp allbufs))

;Enable highlight-symbol-mode (usually done conditionally depending on major mode, as in this example), and set highlight-symbol-on-navigation-p.
; (add-hook 'prog-mode-hook (lambda () (highlight-symbol-mode)))
; (setq highlight-symbol-on-navigation-p t)
; (global-set-key [f3] 'highlight-symbol-next)
; (global-set-key [(shift f3)] 'highlight-symbol-prev)




; Emulate Evil's * command with Swiper.
(global-set-key (kbd "C-M-s") 	(lambda () 		(interactive)
		(swiper (word-at-point))))
		
		
(provide 'cbn-search-bindings)
