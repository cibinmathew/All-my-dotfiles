;; https://www.emacswiki.org/emacs/FlySpell


;; TODO hk:: autocorrect previous word(if flyspell mode is not on, turn it on)


 ;;; https://www.emacswiki.org/emacs/AspellWindows
(add-to-list 'exec-path "C:/Program Files (x86)/Aspell/bin/")
;We need tell emacs to use aspell, and where your custom dictionary is.
    (require 'ispell)

    (setq ispell-program-name "aspell")
    (setq ispell-personal-dictionary "C:/path/to/your/.ispell")
;Then, we need to turn it on.


;; If you’d like to use Flyspell’s menu selection in the terminal, or just prefer to use popup.el over the graphical menu, stick this somewhere in your load path:


  (defun flyspell-emacs-popup-textual (event poss word)
      "A textual flyspell popup menu."
      (require 'popup)
      (let* ((corrects (if flyspell-sort-corrections
                           (sort (car (cdr (cdr poss))) 'string<)
                         (car (cdr (cdr poss)))))
             (cor-menu (if (consp corrects)
                           (mapcar (lambda (correct)
                                     (list correct correct))
                                   corrects)
                         '()))
             (affix (car (cdr (cdr (cdr poss)))))
             show-affix-info
             (base-menu  (let ((save (if (and (consp affix) show-affix-info)
                                         (list
                                          (list (concat "Save affix: " (car affix))
                                                'save)
                                          '("Accept (session)" session)
                                          '("Accept (buffer)" buffer))
                                       '(("Save word" save)
                                         ("Accept (session)" session)
                                         ("Accept (buffer)" buffer)))))
                           (if (consp cor-menu)
                               (append cor-menu (cons "" save))
                             save)))
             (menu (mapcar
                    (lambda (arg) (if (consp arg) (car arg) arg))
                    base-menu)))
        (cadr (assoc (popup-menu* menu :scroll-bar t) base-menu))))
; and put this in your init file
;; (eval-after-load "flyspell" ;; '(progn (fset 'flyspell-emacs-popup 'flyspell-emacs-popup-textual)))
;; Now calling “flyspell-correct-word-before-point” or middle-clicking a word will create a textual popup.


;; Skipping flyspell on specific region
;; This is useful for code block in org files, but any region with clear delimiters can be skipped 
(add-to-list 'ispell-skip-region-alist '("^#+BEGIN_SRC" . "^#+END_SRC"))

(defun flyspell-check-next-highlighted-word ()
  "Custom function to spell check next highlighted word"
  (interactive)
  (flyspell-goto-next-error)
  (ispell-word)
  )

;; http://emacs.stackexchange.com/questions/14909/how-to-use-flyspell-to-efficiently-correct-previous-word
(defun flyspell-correct-previous-word (&optional words)
  "Correct word before point, reach distant words.

WORDS words at maximum are traversed backward until misspelled
word is found.  If it's not found, give up.  If argument WORDS is
not specified, traverse 12 words by default.

Return T if misspelled word is found and NIL otherwise.  Never
move point."
  (interactive "P")
  (let* ((Δ (- (point-max) (point)))
         (counter (string-to-number (or words "12")))
         (result
          (catch 'result
            (while (>= counter 0)
              (when (cl-some #'flyspell-overlay-p
                             (overlays-at (point)))
                (flyspell-correct-word-before-point)
                (throw 'result t))
              (backward-word 1)
              (setq counter (1- counter))
              nil))))
    (goto-char (- (point-max) Δ))
    result))

;; easy spell check
(eval-after-load "flyspell"
'(progn
;; (global-set-key (kbd "S-<f12>") 'ispell-word)
(global-set-key (kbd "C-t") 'flyspell-auto-correct-previous-word)
(global-set-key (kbd "C-t") 'flyspell-auto-correct-word)
;; (global-set-key (kbd "S-<f12>") 'flyspell-correct-word-before-point)
;; (global-set-key (kbd "C-S-<f12>") 'flyspell-mode)
;; (global-set-key (kbd "C-M-<f12>") 'flyspell-buffer)
;; (global-set-key (kbd "C-<f12>") 'flyspell-check-previous-highlighted-word)
;; (global-set-key (kbd "M-<f12>") 'flyspell-check-next-highlighted-word)

;; popup menu
(define-key flyspell-mode-map (kbd "S-<f12>") #'flyspell-popup-correct) ; popup w/o fuzzy
;;   (define-key flyspell-mode-map (kbd "S-<f12>") 'helm-flyspell-correct) ;fuzzy but popup at minibuffer location
;; You can also enable flyspell-popup-auto-correct-mode to popup that Popup Menu automatically with a delay (default 1.6 seconds):

(add-hook 'flyspell-mode-hook #'flyspell-popup-auto-correct-mode)

;; The last annoyance is that on Mac OS X the right mouse button does not seem to trigger [mouse-2], so you cannot right click a word to get a suggestion. This can be fixed with:
     (define-key flyspell-mouse-map [down-mouse-3] #'flyspell-correct-word)
     (define-key flyspell-mouse-map [mouse-3] #'undefined)
))


;; goto prev/next error TODO http://emacs.stackexchange.com/questions/14909/how-to-use-flyspell-to-efficiently-correct-previous-word

;; https://github.com/rolandwalker/flyspell-lazy
;; (require 'flyspell-lazy)
;; (flyspell-lazy-mode 1)



;; http://stackoverflow.com/questions/7343094/force-flyspell-to-go-to-the-end-of-the-word-when-autocorrecting-word-in-emacs
;; TODO debug this
; (eval-after-load "flyspell"
; (def-advice flyspell-auto-correct-previous-word (after flyspell-forward-word activate)
                                        ;(flyspell-goto-next-error)
; (forward-word)))