(message "loading cbn-hydra")
;; it modifies the existing hk's
;; many hydra's taken from https://sriramkswamy.github.io/dotemacs/
;; more available at https://github.com/abo-abo/hydra/blob/master/hydra-examples.el

(defhydra cibin/hydra-ibuffer-main (:color pink :hint nil)
                                        ; https://github.com/abo-abo/hydra/wiki/Ibuffer
  "
 ^Navigation^     | ^Mark^          | ^Actions^           | ^View^         | ^misc^
-^----------^-----+-^----^----------+-^-------^-----------+-^----^---------+--^----^-------
  _k_:    ʌ       | _m_: mark       | _D_: delete         | _g_: refresh   | _q_: 
 _RET_: visit     | _u_: unmark     | _S_: save           | _s_: sort      | _W_: kill-all-other-buffers-if-not-modified
  _j_:    v       | _*_: specific   | _a_: all actions    | _/_: filter    | _/_: 
                | _*_: specific   | _=_: diff           | _/_: filter    | _/_: 
"
;; -^----------^-+-^----^--------+-^-------^--------+-^----^-------
  ("=" ibuffer-forward-line)
  ("j" ibuffer-forward-line)
  ("RET" ibuffer-visit-buffer :color blue)
  ("k" ibuffer-backward-line)

  ("m" ibuffer-mark-forward)
  ("u" ibuffer-unmark-forward)
  ("*" hydra-ibuffer-mark/body :color blue)

  ("D" ibuffer-do-delete)
  ("S" ibuffer-do-save)
  ("a" hydra-ibuffer-action/body :color blue)

  ("g" ibuffer-update)
  ("s" hydra-ibuffer-sort/body :color blue)
  ("/" hydra-ibuffer-filter/body :color blue)
  ("W" kill-all-other-buffers-if-not-modified :color blue)

  ("o" ibuffer-visit-buffer-other-window "other window" :color blue)
  ; ("q" ibuffer-quit "quit ibuffer" :color blue)
  ("q" quit-window "quit ibuffer" :color blue)
  ("." nil "toggle hydra" :color blue))

(defhydra hydra-ibuffer-mark (:color teal :columns 5
                              :after-exit (hydra-ibuffer-main/body))
  "Mark"
  ("*" ibuffer-unmark-all "unmark all")
  ("M" ibuffer-mark-by-mode "mode")
  ("m" ibuffer-mark-modified-buffers "modified")
  ("u" ibuffer-mark-unsaved-buffers "unsaved")
  ("s" ibuffer-mark-special-buffers "special")
  ("r" ibuffer-mark-read-only-buffers "read-only")
  ("/" ibuffer-mark-dired-buffers "dired")
  ("e" ibuffer-mark-dissociated-buffers "dissociated")
  ("h" ibuffer-mark-help-buffers "help")
  ("z" ibuffer-mark-compressed-file-buffers "compressed")
  ("b" hydra-ibuffer-main/body "back" :color blue))

(defhydra hydra-ibuffer-action (:color teal :columns 4
                                :after-exit
                                (if (eq major-mode 'ibuffer-mode)
                                    (hydra-ibuffer-main/body)))
  "Action"
  ("A" ibuffer-do-view "view")
  ("E" ibuffer-do-eval "eval")
  ("F" ibuffer-do-shell-command-file "shell-command-file")
  ("I" ibuffer-do-query-replace-regexp "query-replace-regexp")
  ("H" ibuffer-do-view-other-frame "view-other-frame")
  ("N" ibuffer-do-shell-command-pipe-replace "shell-cmd-pipe-replace")
  ("M" ibuffer-do-toggle-modified "toggle-modified")
  ("O" ibuffer-do-occur "occur")
  ("P" ibuffer-do-print "print")
  ("Q" ibuffer-do-query-replace "query-replace")
  ("R" ibuffer-do-rename-uniquely "rename-uniquely")
  ("T" ibuffer-do-toggle-read-only "toggle-read-only")
  ("U" ibuffer-do-replace-regexp "replace-regexp")
  ("V" ibuffer-do-revert "revert")
  ("W" ibuffer-do-view-and-eval "view-and-eval")
  ("X" ibuffer-do-shell-command-pipe "shell-command-pipe")
  ("b" nil "back"))

(defhydra hydra-ibuffer-sort (:color amaranth :columns 3)
  "Sort"
  ("i" ibuffer-invert-sorting "invert")
  ("a" ibuffer-do-sort-by-alphabetic "alphabetic")
  ("v" ibuffer-do-sort-by-recency "recently used")
  ("s" ibuffer-do-sort-by-size "size")
  ("f" ibuffer-do-sort-by-filename/process "filename")
  ("m" ibuffer-do-sort-by-major-mode "mode")
  ("b" hydra-ibuffer-main/body "back" :color blue))

(defhydra hydra-ibuffer-filter (:color amaranth :columns 4)
  "Filter"
  ("m" ibuffer-filter-by-used-mode "mode")
  ("M" ibuffer-filter-by-derived-mode "derived mode")
  ("n" ibuffer-filter-by-name "name")
  ("c" ibuffer-filter-by-content "content")
  ("e" ibuffer-filter-by-predicate "predicate")
  ("f" ibuffer-filter-by-filename "filename")
  (">" ibuffer-filter-by-size-gt "size")
  ("<" ibuffer-filter-by-size-lt "size")
  ("/" ibuffer-filter-disable "disable")
  ("b" cibin/hydra-ibuffer-main/body "back" :color blue))
;(require 'cc-mode)

    (use-package cc-mode
  :defer t)
;(require 'ibuffer)

    (use-package ibuffer
  :defer t
  :config
  (progn
(define-key ibuffer-mode-map "." 'cibin/hydra-ibuffer-main/body)
))
; (eval-after-load 'ibuffer

; Key binding:
; (define-key ibuffer-mode-map (kbd "s p") 'ibuffer-do-sort-by-pathname)
; (define-key ibuffer-mode-map (kbd ".") 'cibin/hydra-ibuffer-main/body)
; Automatically open the hydra with Ibuffer.
; (add-hook 'ibuffer-mode-hooks #'cibin/hydra-ibuffer-main/body)

; )
; Key binding:

; Optional:

; Automatically open the hydra with Ibuffer.
(add-hook 'ibuffer-hook #'cibin/hydra-ibuffer-main/body)

; todo move this hook to some other file
(add-hook 'ibuffer-hook (lambda () (setq truncate-lines t)))


;;** Example 4: toggle rarely used modes
(when (bound-and-true-p hydra-examples-verbatim)
  (defvar whitespace-mode nil)
  (global-set-key
   (kbd "C-c C-v")
   (defhydra hydra-toggle-simple (:color blue)
     "toggle"
     ("a" abbrev-mode "abbrev")
     ("d" toggle-debug-on-error "debug")
     ("f" auto-fill-mode "fill")
     ("t" toggle-truncate-lines "truncate")
     ("w" whitespace-mode "whitespace")
     ("q" nil "cancel"))))

	 ;; Quickrun

;; This is for Quickrun functionality.

(defhydra hydra-quickrun (:color blue
                             :hint nil)
  "
-----------------------------------------------------------ADVANCED----------------------------
 _s_: quickrun     _a_: with arg    _c_: compile only          _p_: debug HYDRA        _q_: quit
 _r_: run region   _s_: shell       _R_: replace region
                   _eb_: eval buffer
                  _er_: eval region
                  _el_: eval line(C-<F8>)

"
;; TODO integrate quickrun, edebug, python

  ("eb" eval-buffer)
  ("er" eval-region)
("el" cibin/eval-this-line)
    ("h" helm-quickrun "helm")
    ("q" quickrun "run")
    ("r" quickrun-region "region")
    ("a" quickrun-with-arg "with-arg")
    ("s" quickrun-shell "shell")
    ("c" quickrun-compile-only "compile")
    ("R" quickrun-replace-region "replace")
    ("p" sk/hydra-debug/body "sk/hydra-debug" :color blue))

(cibin/global-set-key '("C-c q" . hydra-quickrun/body))

(defhydra sk/hydra-debug (;; :pre (load-library "realgud")
                          :color blue
                          :hint nil)
  "
 _g_: c-gdb         _p_: py-pdb        _i_: py-ipdb        _q_: quit
 _G_: realgud-gdb   _P_: realgud-pdb   _I_: realgud-ipdb
"
  ("g" gdb)
  ("G" realgud:gdb)
  ("p" pdb)
  ("P" realgud:pdb)
  ("i" ipdb)
  ("I" realgud:ipdb)
  ("q" nil :color blue))




(defhydra hydra-marked-items (dired-mode-map "")
  "
"
;; TODO add this to above %(async-shell-command-to-string \"du -hs\" (lambda (s) (message \"Directory size: %s\" s)))
;; marked items: %(length (dired-get-marked-files)) Size: %(cdrw-get-size))
  ("j" dired-next-line "down")
  ("m" dired-mark "mark")
	("k" dired-previous-line "up" )
	("." nil "toggle hydra" :color blue)

  )
  (define-key dired-mode-map "." 'hydra-marked-items/body)


; undo-tree-visualizer-mode-map
(defhydra hydra-undo-tree (undo-tree-visualizer-mode-map "")
  "
  undo-tree
"
  ("d" 'undo-tree-visualizer-toggle-diff "DIFF")
	("." nil "toggle hydra" :color blue)

  )


 (defun cdrw-get-size ()
  (interactive)
  (let ((sum 0)
        (files (dired-get-marked-files)))
   (dolist (file files (format "%.1fM" sum))
    (incf sum (/ (nth 8 (car
      (directory-files-and-attributes (file-name-directory file) nil
        (regexp-quote (file-name-nondirectory file))))) 1048576.0)))))



; (defhydra cibinn/hydra-dired-main (:color pink :hint nil)
  ; "
 ; ^Navigation^ | ^Mark^        | ^Actions^        | ^View^
; -^----------^-+-^----^--------+-^-------^--------+-^----^-------
  ; _g_:    ʌ   | _l_: mark     | ^ ^              | ^ ^
; -^----------^-+-^----^--------+-^-------^--------+-^----^-------
; "
; ("g" text-scale-increase "in" :color blue)
; ("l" text-scale-decrease "out")
; )
; (add-hook 'dired-mode-hook #'cibinn/hydra-dired-main/body)




(defhydra hydra-cibin-misc (:color blue :columns 4 :post (redraw-display))
        "hydra-toggle-mode"
        ("RET" redraw-display "<quit>")
        ("a" cibin-apply-major-mode "cibin-apply-major-mode")
        ("b" cibin-apply-default-major-mode "apply-major-mode")
        ("c" csv-mode "csv-mode")
        ("h" html-mode "html-mode")
        ("j" jinja2-mode "jinja2-mode")
        ("k" markdown-mode "markdown-mode")
        ("l" lineum-mode "lineum-mode")
        ("m" moinmoin-mode "moinmoin-mode")
        ("o" org-mode "org-mode")
        ("p" python-mode "python-mode")
        ("r" R-mode "R-mode")
        ("s" sql-mode "sql-mode")
        ("t" text-mode "text-mode")
        ("v" visual-line-mode "visual-line-mode")
        ("w" web-mode "web-mode")
        ("y" yaml-mode "yaml-mode")
        )
     (cibin/global-set-key '("C-x l" . hydra-cibin-misc/body))
  (if (require 'hydra nil 'noerror)
    (progn
      (defhydra hydra-search (:color blue :columns 4)
        "hydra-search"
        ("RET" helm-swoop "helm-swoop")
        ("b" helm-swoop-back-to-last-point "helm-swoop-back-to-last-point")
        ("f" file-file-in-project "find-file-in-project")
        ("m" helm-multi-swoop "helm-multi-swoop")
        ("M" helm-multi-swoop-all "helm-multi-swoop-all")
        ("o" occur "occur-dwim")
        ("O" occur-dwim "occur")
        ("r" vr/isearch-backward "vr/isearch-backward")
        ("s" vr/isearch-forward "vr/isearch-forward"))
      (cibin/global-set-key '("C-c s" . hydra-search/body))
	  )
  (message "** hydra is not installed"))

  (if (require 'hydra nil 'noerror)
    (progn (defhydra hydra-replace (:color blue)
             "hydra-replace"
             ("RET" replace-string "replace-string")
             ("r" vr/replace "vr/replace")
             ("q" query-replace "query-replace")
             ("Q" vr/query-replace "vr/query-replace"))

           (cibin/global-set-key '("C-c r" . hydra-replace/body))
		   )
  (message "** hydra is not installed"))

;; http://bnbeckwith.com/bnb-emacs/
  (defmacro toggle-setting-string (setting)
  `(if (and (boundp ',setting) ,setting) '[x] '[_]))
(bind-key
 "C-x t"
(defhydra hydra-toggle (:color amaranth)
   "
_c_ column-number                 : %(toggle-setting-string column-number-mode)   _b_ orgtbl-mode    : %(toggle-setting-string orgtbl-mode)
_e_ debug-on-error                : %(toggle-setting-string debug-on-error)   _s_ orgstruct-mode : %(toggle-setting-string orgstruct-mode)  _m_   hide mode-line : %(toggle-setting-string bnb/hide-mode-line-mode)
_u_ debug-on-quit                 : %(toggle-setting-string debug-on-quit)   _d_ diff-hl-mode   : %(toggle-setting-string diff-hl-mode)
_f_ auto-fill                     : %(toggle-setting-string auto-fill-function)   _B_ battery-mode   : %(toggle-setting-string display-battery-mode)
_t_ truncate-lines(long line wrap): %(toggle-setting-string truncate-lines)   _l_ highlight-line : %(toggle-setting-string hl-line-mode)
_r_ read-only                     : %(toggle-setting-string buffer-read-only)   _n_ line-numbers   : %(toggle-setting-string linum-mode)
_w_ whitespace                    : %(toggle-setting-string whitespace-mode)   _N_ relative lines : %(if (eq linum-format 'linum-relative) '[x] '[_])
_j_ next-line      _k_ previous-line        _a_ : cibin/faster-mode      _g_:  cibin/normal-mode  _o_ : cibin/essential-mode
_G_: golden ratio
"
   
   ("B" display-battery-mode nil)
   ("N" linum-relative-toggle nil)
   ("X" bnb/transparency-previous nil)
   ("a" cibin/faster-mode nil)
   ("b" orgtbl-mode nil)
   ("d" diff-hl-mode nil)
   ("c" column-number-mode nil)
   ("e" toggle-debug-on-error nil)
   ("f" auto-fill-mode nil)
   ("g" cibin/normal-mode nil)
   ("G" spacemacs/toggle-golden-ratio nil)
   ("j" next-line nil)
   ("k" previous-line nil)
   ("l" hl-line-mode nil)
   ("m" bnb/hide-mode-line-mode nil)
   ("n" linum-mode nil)
   ("o" cibin/essential-mode nil)
   ("r" dired-toggle-read-only nil)
   ("s" orgstruct-mode nil)
   ("t" toggle-truncate-lines nil)
   ("u" toggle-debug-on-quit nil)
   ("w" whitespace-mode nil)
   ("x" bnb/transparency-next nil)
   ("q" nil)))


   (defhydra sk/hydra-expand (:pre (er/mark-word)
                           :color red
                           :hint nil)
  "
 _a_: add    _r_: reduce   _q_: quit
 "
  ("a" er/expand-region :color blue)
  ("r" er/contract-region :color blue)
  ("q" nil :color blue))

  (defhydra hydra-org (:color blue :hint nil)
  ;; Navigation^
  ;; ---------------------------------------------------------
    "
  _j_ next heading        _h_ next heading (same level)
  _k_ prev heading        _l_ prev heading (same level)
  _u_p higher heading     _g_o to
  ----------
  "
    ("j" outline-next-visible-heading)
    ("k" outline-previous-visible-heading)
    ("h" org-forward-heading-same-level)
    ("l" org-backward-heading-same-level)
    ("u" outline-up-heading)
    ("g" org-goto :exit t))

  (defhydra hydra-global-org (:color blue
                            :hint nil)
  "
Timer^^        ^Clock^         ^Capture^
--------------------------------------------------
s_t_art        _w_ clock in    _c_apture
 _s_top        _o_ clock out   _l_ast capture
_r_eset        _j_ clock goto
"
  ("t" org-timer-start)
  ("s" org-timer-stop)
  ;; Need to be at timer
  ("r" org-timer-set-timer)
  ("w" (org-clock-in '(4)))
  ("o" org-clock-out)
  ;; Visit the clocked task from any buffer
  ("j" org-clock-goto)
  ("c" org-capture)
  ("l" org-capture-goto-last-stored))



(with-eval-after-load 'org

  ; (define-key org-mode-map (kbd "?") 'hydra-org/body)
  	(evil-define-key 'normal org-mode-map  (kbd "?")'hydra-org/body)
;; TODO disabling for now
;; (add-hook 'org-mode-hook #'hydra-org/body)
)


; Flycheck
; Flycheck is an amazing syntax-checking package for Emacs, and I’m a fan of helm-flycheck for navigation. Here’s the hydra I use for quickly navigating between warnings and errors which Flycheck reports, with quick access to helm-flycheck:

;; (use-package helm-flycheck
  ;; :config
  ;; (define-key flycheck-mode-map (kbd "C-c ! h") 'helm-flycheck)
  ;; (key-chord-define-global "QF"
   ;; (defhydra flycheck-hydra ()
     ;; "errors"
     ;; ("n" flycheck-next-error "next")
     ;; ("p" flycheck-previous-error "previous")
     ;; ("h" helm-flycheck "helm" :color blue)
     ;; ("q" nil "quit"))))
	 (defhydra hydra-help (:color blue :columns 8)
  "Help"
  ("f" describe-function "function")
  ("F" Info-goto-emacs-command-node "goto command")
  ("v" describe-variable "variable")
  ("m" describe-mode "mode")
  ("@" describe-face "face")
  ("k" describe-key "key")
  ("t" describe-theme "theme")
  ("b" describe-bindings "bindings")
  ("p" describe-package "package")
  ("d" helm-dash "dash")
  ("." helm-dash-at-point "dash at point"))

  ; mix with quickrun
  (defhydra hydra-eval (:color blue :columns 8)
  "Eval"
  ("e" eval-expression "expression")
  ("d" eval-defun "defun")
  ("b" eval-buffer "buffer")
  ("l" eval-last-sexp "last sexp")
  ("1" async-shell-command "shell-command"))


(defhydra my-git-hydra (:hint nil :exit t)
  "
git:
MUTABLE       
             _l_ → log              _f_ → file            staging:  _a_ → +hunk  _A_ → +buffer
_C_ → commit   _d_ → [[diff/hydra]]   _z_ → stash                     _r_ → -hunk  _R_ → -buffer
_P_ → push     _b_ → blame            _m_ → merge
               _s_ : status
_t_ : [[time]] _D_ : diff pop
.
"
  ("s" magit-status)
  ("b" magit-blame-popup)
  ("f" magit-file-popup)
  ("z" magit-status-popup)
  ("l" magit-log-popup)
  ("d" cibin/diff-hydra/body)
  ("D" magit-diff-popup)
  ("C" nil) ; magit-commit-popup)
  ("m" magit-merge-popup)
  ("P" nil) ; magit-push-popup)
  ("a" git-gutter+-stage-hunks)
  ("r" git-gutter+-revert-hunk)
  ("A" git-gutter+-stage-whole-buffer)
  ("t" hydra-git-timemachine/body) 
  ("R" git-gutter+-unstage-whole-buffer))

(use-package avy
  :config
  (use-package link-hint)
  (cibin/global-set-key '("M-g g" . avy-goto-line))
  (defhydra hydra-avy (global-map "M-g" :color blue)
    "avy-goto"
    ("c" avy-goto-char "char")
    ("C" avy-goto-char-2 "char-2")
    ("w" avy-goto-word-1 "word")
    ("s" avy-goto-subword-1 "subword")
    ("u" link-hint-open-link "open-URI")
    ("U" link-hint-copy-link "copy-URI")))
; https://github.com/nivekuil/corral



(defhydra sk/hydra-rectangle (:pre (rectangle-mark-mode 1)
                              :color pink
                              :hint nil)
  "
  [TODO]paste         delete             string
 _p_: paste           _r_: replace       _I_: insert
 _y_: copy            _o_: open          _V_: reset
 _d_: kill            _n_: number        _q_: quit
"     
  ("h" backward-char nil)
  ("l" forward-char nil)
  ("k" previous-line nil)
  ("j" next-line nil)
  ("y" copy-rectangle-as-kill)
  ("d" kill-rectangle)
  ("x" clear-rectangle)
  ("o" open-rectangle)
  ("p" yank-rectangle)
  ("r" string-rectangle)
  ("n" rectangle-number-lines)
  ("I" string-insert-rectangle)
  ("V" (if (region-active-p)
           (deactivate-mark)
         (rectangle-mark-mode 1)) nil)
  ("q" keyboard-quit :color blue))
;; Key binding
(bind-keys*
  ("M-m V" . sk/hydra-rectangle/body))


;; Multiple cursors hydra

(defhydra sk/hydra-multiple-cursors (:color red
                                     :hint nil)
  "
  _k_: prev         _j_: next         _a_: all     _b_: beg of lines   _q_: quit
  _K_: skip prev    _J_: skip next    _d_: defun   _e_: end of lines
  _p_: unmark prev  _n_: unmark next  _r_: regexp  _l_: lines
"
  ("j" mc/mark-next-like-this)
  ("J" mc/skip-to-next-like-this)
  ("n" mc/unmark-next-like-this)
  ("k" mc/mark-previous-like-this)
  ("K" mc/skip-to-previous-like-this)
  ("p" mc/unmark-previous-like-this)
  ("a" mc/mark-all-like-this :color blue)
  ("d" mc/mark-all-like-this-in-defun :color blue)
  ("r" mc/mark-all-in-region-regexp :color blue)
  ("b" mc/edit-beginnings-of-lines)
  ("e" mc/edit-ends-of-lines)
  ("l" mc/edit-lines :color blue)
  ("q" nil :color blue))
;; Key binding
;; (bind-keys*
  ;; ("C-t" . sk/hydra-multiple-cursors/body))


;; TODO make it work for all languages
(defhydra sk/hydra-for-py (:color blue
                           :hint nil)
  "
 ^Send^                     ^Navigate^                    ^Virtualenv^      ^Testing^                                        ^Format^
^^^^^^^^^^--------------------------------------------------------------------------------------------------------------------------------
 _r_: region    _s_: start    _d_: definition    _F_: file    _V_: pyenv        _ta_: test all    _tm_: test mod    _pd_: pdb dir    _c_: create-doc
 _b_: buffer    _S_: switch   _a_: assignment    _B_: back    _u_: pyenv set    _td_: test dir    _to_: test one    _pm_: pdb mod    _y_: yapf
 _f_: func                  _v_: reference     _D_: doc     _U_: pyenv unset  _tf_: test fail   _pa_: pdb all     _po_: pdb one    _q_: quit
"
  ("r" python-shell-send-region)
  ("b" python-shell-send-buffer)
  ("f" python-shell-send-defun)
  ("s" run-python)
  ("S" python-shell-switch-to-shell)
  ("d" anaconda-mode-find-definitions :color red)
  ("D" anaconda-mode-show-doc :color red)
  ("a" anaconda-mode-find-assignments :color red)
  ("v" anaconda-mode-find-references :color red)
  ("F" anaconda-mode-find-file :color red)
  ("B" anaconda-mode-go-back :color red)
  ("V" pyenv-mode :color red)
  ("u" pyenv-mode-set)
  ("U" pyenv-mode-unset)
  ("ta" pytest-all)
  ("td" pytest-directory)
  ("tf" pytest-failed)
  ("tm" pytest-module)
  ("to" pytest-one)
  ("pa" pytest-pdb-all)
  ("pd" pytest-pdb-directory)
  ("pm" pytest-pdb-module)
  ("po" pytest-pdb-one)
  ("c" sphinx-doc)
  ("y" py-yapf-buffer)
  ("q" nil :color blue))
;; Key binding
(bind-keys*
  ("M-m s p" . sk/hydra-for-py/body))
;; Modal binding
;; (modalka-define-kbd "s p" "M-m s p")
;; Which key modal explanation

(which-key-add-key-based-replacements
  "s p" "python code")

;;; Web

; There are two hydras we use for Web editing - one for JavaScript specifically and one for web mode.

(defhydra sk/hydra-for-js (:color blue
                           :hint nil)
  "
 ^Node^                                ^Tern^                                  ^Json^
^^^^^^^^^^-----------------------------------------------------------------------------------------
 _r_: region    _s_: start    _l_: load    _d_: definition    _h_: highlight refs    _j_: path
 _b_: buffer    _S_: switch              _n_: def by name   _u_: use-server        _q_: quit
 _x_: sexp      _e_: exec                _t_: type          _D_: doc
"
  ("r" nodejs-repl-send-region)
  ("b" nodejs-repl-send-buffer)
  ("x" nodejs-repl-send-last-sexp)
  ("s" nodejs-repl)
  ("S" nodejs-repl-switch-to-repl)
  ("e" nodejs-repl-execute)
  ("l" nodejs-repl-load-file :color red)
  ("d" tern-find-definition :color red)
  ("n" tern-find-definition-by-name :color red)
  ("t" tern-get-type :color red)
  ("D" tern-get-docs :color red)
  ("u" tern-use-server :color red)
  ("h" tern-highlight-refs)
  ("R" tern-rename-variable)
  ("j" jsons-print-path)
  ("q" nil :color blue))
(defhydra sk/hydra-for-web (:color red
                            :hint nil)
  "
 ^Server^           ^HTML^                ^Skewer^
^^^^^^^^^^------------------------------------------------------------------------------------------------------------------------------
 _w_: httpd start   _i_: html real-time   _j_: js eval     _r_: run            _f_: eval func              _l_: load buffer      _p_: phantomjs
 _W_: httpd stop                        _h_: html eval   _s_: start          _e_: eval last exp          _b_: bower load       _P_: phantomjs kill
                                      _c_: css eval    _S_: list clients   _E_: eval print last exp    _B_: bower refresh    _q_: quit
"
  ("w" httpd-start :color blue)
  ("W" httpd-stop :color blue)
  ("i" impatient-mode :color blue)
  ("j" skewer-mode)
  ("h" skewer-html-mode)
  ("c" skewer-css-mode)
  ("r" run-skewer)
  ("s" skewer-repl :color blue)
  ("S" list-skewer-clients :color blue)
  ("f" skewer-eval-defun :color blue)
  ("e" skewer-eval-last-expression :color blue)
  ("E" skewer-eval-print-last-expression :color blue)
  ("l" skewer-load-buffer :color blue)
  ("b" skewer-bower-load :color blue)
  ("B" skewer-bower-refresh)
  ("p" skewer-run-phantomjs :color blue)
  ("P" skewer-phantomjs-kill)
  ("q" nil :color blue))

(defun flush-blank-lines (start end) (interactive "r") (flush-lines "^\\s-*$" start end nil))

;;; https://www.masteringemacs.org/article/removing-blank-lines-buffer
(defun collapse-blank-lines (start end) (interactive "r") (replace-regexp "^\n\\{2,\\}" "\n" nil start end))
(defun my-delete-leading-whitespace (start end)
          "Delete whitespace at the beginning of each line in region."
          (interactive "*r")
          (save-excursion
            (if (not (bolp)) (forward-line 1))
            (delete-whitespace-rectangle (point) end nil)))


(defhydra cibin/hydra-for-formatt (:color red
                               :hint nil)

 
"

_w_: format             _f_: cibin/hydra-for-format/body
_v_: validate
_O_: ordered

_t_: tree TODO          _q_: quit
_p_: get Path TODO
_o_: object viewer TODO
_r_: Remove whitespace TODO
-----------
"
  ("O" json-pretty-print-buffer-ordered)
  ("b" cibin/hydra-for-format/body :color blue)
  ("f" cibin/hydra-for-format/body :color blue)
  ("q" nil :color blue)
  ("w" beautify-json)
  ("v" beautify-json)
  ("b" nil)
  ("r" nil)
  ("o" nil)
  ("p" nil)
  ("t" nil)
  )


(defhydra cibin/hydra-for-format (:color red
                               :hint nil)

 
  "
convert/format file
 ^^^-blanks ---------------  ------whitespace----------------- ------dupes----------------------------   ---actions
 _r_: collapse-blank-lines   _t_: delete-trailing-whitespace    _d_: delete-duplicate-lines(incl blank   _a_: select All 
 _F_: flush-blank-lines      _l_: my-delete-leading-whitespace  _h_: hlt-highlight-line-dups-region      _wa_: toggle whitespace indicators   _e_: other window
 _b_: delete-blank-lines     _k_: keep-lines     _k_: leading, blanks,                                   _t_: truncate toggle                 _v_: [[diff]]
                           _xx_: flush-lines                                                         _t_: stats                          _xa_: diff-files-lines
 _i_: indent                _ww_: collapse multiple spaces                                             _n_: quikrun hydra to & back  _q_: quit
 _f_: [[json format]]
_z_: eol unix/win
-----------
"

("f" cibin/hydra-for-formatt/body :color blue)
  ("r" collapse-blank-lines)
  ("c" nil)
  ("i" nil)
  ("xx" flush-lines)
  ("h" hlt-highlight-line-dups-region)
  ("e" other-window)
  ("j" nil)
  ("n" nil)
  ("z" nil)
  ("k" keep-lines)
  ("b" delete-blank-lines)
  ("a" mark-whole-buffer)
  ("d" delete-duplicate-lines)
  ("F" flush-blank-lines)
  ("t" delete-trailing-whitespace)
  ("l" my-delete-leading-whitespace)
  ("wa" whitespace-mode)
  ("v" cibin/diff-hydra/body :color blue)
  ("xa" diff-files-lines)
  ;; ("xb" diff-files-lines)
  ("ww" nil )
  ("q" nil :color blue)
 )
(bind-keys*
  ("C-x f" . cibin/hydra-for-format/body))

;;REMOVE after cibin/hydra.... is ready
(defhydra sk/hydra-for-format (:color red
                               :hint nil)
  "
 ^Beautify^
^^^^^^^^^^--------------------------------------
 _h_: html        _c_: css       _j_: js        _q_: quit
 _H_: html buf    _C_: css buf   _J_: js buf
"
  ("h" web-beautify-html)
  ("H" web-beautify-html-buffer)
  ("c" web-beautify-css)
  ("C" web-beautify-css-buffer)
  ("j" web-beautify-js)
  ("J" web-beautify-js-buffer)
  ("q" nil :color blue))
; Key binding
(bind-keys*
  ("M-m s j" . sk/hydra-for-js/body)
  ("M-m s w" . sk/hydra-for-web/body)
  ("M-m s f" . sk/hydra-for-format/body))
; Modal binding
; (modalka-define-kbd "s j" "M-m s j")
; (modalka-define-kbd "s w" "M-m s w")
; (modalka-define-kbd "s f" "M-m s f")
; Which key modal explanation

(which-key-add-key-based-replacements
  "s j" "javscript code"
  "s w" "web code"
  "s f" "format code")

(defhydra cibin/hydra-zoom ()
  ;; (:color red 
                               ;; :hint nil)
  "
^BUFFER^   ^FRAME^    ^ACTION^
_f_: +     _T_: +     _0_: reset
_d_: -     _S_: -     _q_: quit
_
"
;; make the help more beautiful

  ("T" zoom-frm-in)
  ("S" zoom-frm-out)
  ("0" zoom-frm-unzoom)
  ("q" nil :color blue)
  ("f" cibin/text-scale-increase "in")
  ("g" cibin/text-scale-increase "in")
  ("=" cibin/text-scale-increase "in")
  ("h" cibin/text-scale-increase "global in")
  ("l" cibin/text-scale-decrease "out")
  ("d" cibin/text-scale-decrease "out")
  ("g" cibin/text-scale-decrease "global out")
  ("-" cibin/text-scale-decrease "out"))
;; TODO https://www.emacswiki.org/emacs/GlobalTextScaleMode
  (cibin/global-set-key '("C-x -" . cibin/hydra-zoom/body))
  (cibin/global-set-key '("C-x =" . cibin/hydra-zoom/body))


(defhydra cibin/search (:color blue 
                               :hint nil)
  "
 project|| directory |    ^All buffers  ^                     ^All^                                             ^bash^
^^^^^^^^^^--------                -----------------------------------------------------------------------------------------------------------
 _sa_: swiper-all                 _r_: cibin/helm-do-ag-Extension-recurse-cwd     _u_: cibin-search-in-files-advgrep-here        _q_: quit
 _d_: helm-do-ag-this-file        _h_: cibin/helm-do-ag-Ext'n-here-cwd    	      _c_: cibin-search-in-common-files-bash
 _/_: my-multi-occur-in-matc..    _b_: cibin/helm-do-ag-cwd(all ext)              _l_: cibin-search-in-text-files-related-bash
 _o_: occur                       _y_: cibin/ag-files-cwd (ext\? dir\\?)
 _j_: helm-ag                     _w_: ag-files                                   _p_: ag-project-at-point
 _ss_: swiper
--------------------
"
;; TODO ;; (cibin/global-set-key '("M-s r" . )) ; recurse
; linked
("a" helm-do-ag-buffers)
("d" helm-do-ag-this-file)

("/" my-multi-occur-in-matching-buffers)

("b" cibin/helm-do-ag-cwd)

("c" cibin-search-in-common-files-bash)
("h" cibin/helm-do-ag-Extension-here-cwd-switchable)
("j" helm-ag);; extension ; If you use helm-ag command, you can specify option like -G\.js$ search_pattern, or if you use helm-do-ag, you can use C-u prefix for specifying extension.
("l" cibin-search-in-text-files-related-bash)
("o" occur)

("p" ag-project-at-point)
     
("w" ag-files) ; advanced (string file-type directory))
("r" cibin/helm-do-ag-Extension-recurse-cwd)
("sa" swiper-all)
("ss" cibin/swiper)
("y" cibin/ag-files-cwd) 
("u" cibin-search-in-files-advgrep-here)
 ("q" nil :color blue))
  (cibin/global-set-key '("M-s" . cibin/search/body))
(define-key dired-mode-map  (kbd "M-s") 'cibin/search/body)






(defhydra cibin/replace (:color blue 
                               :hint nil)
  "
 ^All  ^                     ^Query??^              ^here^                             ^bash^
^^^^^^^^^^--------------------+-----------------------------------------------------------------------------------------------------------------
 _s_: replace-string     _e_: query-replace(! all, . this)          _b_: cibin/helm-do-ag-cwd(all ext) _h_: cibin-search-in-files-advgrep-here        _q_: quit
 _d_: replace-regexp     _r_: query-replace-regexp    _p_: ag-project-at-point           _c_: cibin-search-in-common-files-bash
 _/_: my-multi-occur-in-matc..                          _w_: ag-files                      _l_: cibin-search-in-text-files-related-bash
------
"
;; TODO ;; (cibin/global-set-key '("M-s r" . )) ; recurse
; linked
  ("e" query-replace)
  ("r" query-replace-regexp)
  ("s" replace-string)
  ("d" replace-regexp)
("d" helm-do-ag-this-file)

("a" helm-do-ag-buffers)
("/" my-multi-occur-in-matching-buffers)

("b" cibin/helm-do-ag-cwd)

("h" cibin-search-in-files-advgrep-here)
("c" cibin-search-in-common-files-bash)
("l" cibin-search-in-text-files-related-bash)

("p" ag-project-at-point)
     
("w" ag-files) ; advanced (string file-type directory))
("y" cibin/ag-files-cwd) 
("j" helm-ag);; extension ; If you use helm-ag command, you can specify option like -G\.js$ search_pattern, or if you use helm-do-ag, you can use C-u prefix for specifying extension.
 ("q" nil :color blue))
  (cibin/global-set-key '("M-r" . cibin/replace/body))
(define-key dired-mode-map  (kbd "M-r") 'cibin/replace/body)






(defhydra cibin/open (:color blue 
                           ;; :idle 0.5
                             )
 "

  _sr_ : open-similar-files-in-folder-recursively       _d_  : xah-open-in-desktop             _tt_  : dir-structure -Tree       _r_  : ranger-mode
  _n_  : find-next-file-in-current-directory            _o_  : cibin/xah-open-file-at-cursor   _ta_  : dir-structure all -Tree
  _b_  : buffer/switch-in-directory                     _e_  : in-external-app
  _g_  : bjm/ivy-dired-recent-dirs                        
  _j_  : dired-jump                                     _f_  : ffap
                                                      _F_  : File-cache-ido-find-file
  _m_  : buffer/switch-in-directory                     _p_  : cibin-find-related-files	
---
 "
           ;; ( "n" buffer/switch-in-directory)
          ( "sr"  open-similar-files-in-folder-recursively :color blue)
          ( "tt"  dir-structure :color blue)
          ( "ta"  dir-structure-all :color blue)


           ( "n"   find-next-file-in-current-directory :color blue)	
           ( "b"   buffer/switch-in-directory :color blue)

           ;; TODO not correct
           ( "d"   xah-open-in-desktop :color blue)
           ( "g"   bjm/ivy-dired-recent-dirs :color blue)
           ( "j"   dired-jump :color blue)
           ( "F"   File-cache-ido-find-file :color blue)
           ;; ( "f"   xah open file fast)
           ;; TODO external app or antother function
           ( "e"   spacemacs/open-file-or-directory-in-external-app :color blue)
           ( "p"   cibin-find-related-files :color blue)
           ( "m"   buffer/switch-in-directory :color blue)	
           ( "o"   cibin/xah-open-file-at-cursor :color blue)
           ( "f"   ffap :color blue)
           ( "r"   ranger-mode :color blue)
           ( "sh"  open-similar-files-in-folder :color blue)
           )

(evil-define-key 'normal dired-mode-map "o" nil)
(with-eval-after-load 'org
 
(evil-define-key 'normal org-mode-map "o" nil)
(define-key org-mode-map  "o" nil)
(evil-define-key 'normal org-mode-map  "o" 'cibin/open/body)
)
(define-key dired-mode-map  "o" nil)
(define-key evil-normal-state-map  "o" nil)

(define-key dired-mode-map "o" 'cibin/open/body)
(define-key evil-normal-state-map  "o" 'cibin/open/body)

;TODO
(defun cibin/vdiff-buffers()
  (interactive)
  ; (call-interactively 'vdiff-buffers)
(vdiff-buffers (find-file-noselect (buffer-file-name)) (find-file-noselect (buffer-file-name-other)))
 (vdiff-hydra/body)
  )
(defun buffer-file-name-other()
  "return other file name or temporary file name if not visiting a file "
  (interactive)
      (other-window -1)
      (setq aother-buffer (return-filepath))
(other-window -1)
(message (format "%s" aother-buffer))
       )

(defhydra cibin/hydra-all (:color blue
                           ;; :idle 0.5
 :foreign-keys run                            )
 "
_q_: quit
_a_ : format
"
 ("a" cibin/hydra-for-format/body :color blue)
 ("q" nil)
 )
"
foreign keys:
a= all; e
g hjkl

"
(defhydra hydra-git-timemachine (:color red 
                                        :idle .1
                                        :pre (git-timemachine-mode 1)
                                        ;; :post (git-timemachine-mode -1)
                             )
"
TIME-Machine:    PROJECTILE: %(projectile-project-root)
 
_d_ : [[diff]]        
_a_ : all history commits
_g_ : [[git]]
_n_ : next
_p_ : prev
_b_ : blame
                         _q_: quit
.
 "
 ("n" git-timemachine-show-next-revision)
 ("a" my-git-timemachine)
 ("p" git-timemachine-show-previous-revision)
 ("g" my-git-hydra/body)
 ("t" git-timemachine)
 ("=" nil)
 ("b" magit-blame)
 ("d" cibin/diff-hydra/body :color blue)
 ("q" nil )
          )



(defhydra cibin/diff-hydra (:color blue
                           ;; :idle 0.5
                             )
 "
DIFF 
_r_ : A-B (todo)              _=_ : common lines (TODO)
_v_ : vdiff                   _b_: vdiff buffers L&R (todo)       _q_: quit
_g_ : [[git]]
_t_ : [[timemachine]]
_f_ vdiff with file
_F_ diff with file
.
 "
 ("v" cibin/vdiff-buffers)
 ("g" my-git-hydra/body)
 ("t" hydra-git-timemachine/body)
 ("=" nil)
 ("b" nil)
 ("r" diff-files-lines)
 ("f" vdiff-current-file)
 ("F" diff-buffer-with-file)
 ("q" nil)
 )

(defhydra nsh/hydra-large-files-vlf (:color pink :hint nil)
  "
  C-c C-v

   _s_: search forward
   _r_: search backward
   _o_: occur
   _g_: goto line"

  ("s" vlf-re-search-forward)
  ("r" vlf-re-search-backward)
  ("o" vlf-occur)
  ("g" vlf-goto-line)
  ("." nil "toggle hydra" :color blue)
  )
;; activation key used in use-package definition

; (eval-after-load "vlf-setup"
  ; (define-key vlf-mode-map "." 'nsh/hydra-large-files-vlf/body)
  ; )


(defhydra cibin/hydra-tips (:color blue )
                               ;; :hint nil)
  "
_a_: quickrun(C-c q)
_b_: cibin-misc(C-x l)
_c_: search (C-c s)
_d_: diff
_g_: git
_r_: replace
_e_: zoom
_f_: format (C-x f)
_g_: search (M-s)

"
  
("a" hydra-quickrun/body "C-c q : hydra-quickrun/body   ")
("b" hydra-cibin-misc/body "C-x l : hydra-cibin-misc/body ")
("c" hydra-search/body "C-c s : hydra-search/body     ")
("d" cibin/diff-hydra/body " : cibin/diff-hydra/body    ") 
("r" hydra-replace/body "C-c r : hydra-replace/body    ") 
("e" cibin/hydra-zoom/body "C-x - : cibin/hydra-zoom/body ")
("f" cibin/hydra-for-format/body "C-x f : cibin/hydra-for-format/body ")
("s" cibin/search/body "M-s   : cibin/search/body     ")
("g" my-git-hydra/body "   : my-git-hydra/body     ")
("q" nil)
)

  (cibin/global-set-key '("C-x y" . cibin/hydra-tips/body))



(defhydra cibin/fast-search (
                             :timeout 2
; :pre evil-search-word-forward
)
  ;; (:color red 
                               ;; :hint nil)
  "
^BUFFER^   ^FRAME^    ^ACTION^
_8_: next _9_: prev      allNext prev
"
; _d_: -     _S_: -     _q_: quit
;; make the help more beautiful

  ("8" evil-search-word-forward "forward")
  ("9" evil-search-word-backward "back")
  )

;; TODO link this hydra 


;;; Mark Text and Regions

(use-package expand-region
  :config
  (use-package change-inner)
  (defun ejmr-mark-line ()
    "Mark the current line."
    (interactive)
    (end-of-line)
    (set-mark (point))
    (beginning-of-line))

(defhydra hydra-mark (:color blue :idle 1.0 :columns 4
:body-pre (er/expand-region 1)
                               )
    "Mark                       search"
    ("d" er/mark-defun "Defun / Function")
    ("f" er/mark-defun "Defun / Function")
    ("w" er/mark-word "Word")
    ("u" er/mark-url "Url")
    ("e" mark-sexp "S-Expression")
    ("E" er/mark-email "Email")
    ("b" mark-whole-buffer "Buffer")
    ("l" ejmr-mark-line "Line")
    ("s" er/mark-sentence "Sentence")
    ("p" er/mark-text-paragraph "Paragraph")
    ("g" mark-page "Page")
    ("S" er/mark-symbol "Symbol")
    ("P" er/mark-symbol-with-prefix "Prefixed symbol")
    ("q" er/mark-inside-quotes "Inside Quotes")
    ("Q" er/mark-outside-quotes "Outside Quotes")
    ("(" er/mark-inside-pairs "Inside Pairs")
    ("[" er/mark-inside-pairs "Inside Pairs")
    ("{" er/mark-inside-pairs "Inside Pairs")
    (")" er/mark-outside-pairs "Outside Pairs")
    ("]" er/mark-outside-pairs "Outside Pairs")
    ("}" er/mark-outside-pairs "Outside Pairs")
    ;; ("t" er/expand-region "expand")
    ("t" hydra-mark/body "expand")
    ;; ("t" er/mark-inner-tag "Inner Tag")
    ("T" er/mark-outer-tag "Outer Tag")
    ("c" er/mark-comment "Comment")
    ("a" er/mark-html-attribute "HTML Attribute")
    ("i" change-inner "Inner")
    ("o" change-outer "Outer")
    ("m" nil "**MORE on sel TEXT**")
    ("." er/expand-region "Expand Region" :exit nil)
    ("," er/contract-region "Contract Region" :exit nil))
  ; (bind-key "SPC" #'hydra-mark/body ejmr-custom-bindings-map)
  )



(define-key evil-normal-state-map  "t" 'hydra-mark/body)
(define-key evil-visual-state-map   (kbd "t") 'hydra-mark/body)









 ;; https://github.com/bling/dotemacs/blob/72e932093a274510bcd4da9063e861d85c89fc74/config/init-hydras.el 
 ;;awesome hydras

  ;;; TODO add this to C-x C-b and another hydra

(defhydra my-buffer-hydra (:hint nil :exit t)
  "
   buffers:   _b_ → buffers          _k_ → kill buffer             _f_ → reveal in finder
              _m_ → goto messages    _e_ → erase buffer            ^ ^
              _s_ → goto scratch     _E_ → erase buffer (force)    ^ ^
"
  ("s" my-goto-scratch-buffer)
  ("k" kill-this-buffer)
  ("f" reveal-in-osx-finder)
  ("m" (switch-to-buffer "*Messages*"))
  ("b" (my-switch-action #'switch-to-buffer :ivy #'my-ivy-mini :helm #'helm-mini))
  ("e" erase-buffer)
  ("E" (let ((inhibit-read-only t)) (erase-buffer))))





(setq my-errors-hydra/flycheck nil)
(defun my-errors-hydra/target-list ()
  "https://github.com/bling/dotemacs/blob/72e932093a274510bcd4da9063e861d85c89fc74/config/init-hydras.el"
  (if my-errors-hydra/flycheck
      'flycheck
    'emacs))
(defhydra my-errors-hydra (:hint nil)
  "
   errors:  navigation                 flycheck
            -----------------------    ---------------
            _j_ → next error             _l_ → list errors
            _k_ → previous error         _?_ → describe checker
            _t_ → toggle list (%(my-errors-hydra/target-list))
"
  ("j" (if my-errors-hydra/flycheck
           (call-interactively #'flycheck-next-error)
         (call-interactively #'next-error)))
  ("k" (if my-errors-hydra/flycheck
           (call-interactively #'flycheck-previous-error)
         (call-interactively #'previous-error)))
  ("t" (setq my-errors-hydra/flycheck (not my-errors-hydra/flycheck)))
  ("?" flycheck-describe-checker)
  ("l" flycheck-list-errors :exit t))

;; TODO link this (also clean)
(defhydra hydra-text (:color amaranth)
  "
^Major Modes^    ^Minor Modes^    ^Actions^
^───────────^────^───────────^────^───────^──────────
[_T_] Text       [_D_] Darkroom   [_s_] Sort Lines
[_A_] AsciiDoc   [_$_] Flyspell   [_a_] Align Regexp
[_M_] Markdown   [_u_] Auto Fill  [_p_] Delete Duplicates^^
[_G_] GFM                       [_r_] Rectangle Commands^^
[_F_] Fountain                  [_n_] Underline With Character
[_I_] Indirect Edit
^^
"
  ("T" text-mode)
  ("n" underline-with-char :color blue)
  ("I" edit-indirect-region :color blue)
  ("A" adoc-mode)
  ("a" align-regexp)
  ("M" markdown-mode)
  ("F" fountain-mode)
  ("G" gfm-mode)
  ("D" darkroom-mode)
  ("$" flyspell-mode)
  ("s" sort-lines)
  ("u" auto-fill-mode)
  ("p" delete-duplicate-lines)
  ("r" hydra-rectangle/body)
  ("q" nil :color blue))


(defhydra goto (:color blue :hint nil)
  "
Goto:
^Char^              ^Word^                ^org^                    ^search^
^^^^^^^^---------------------------------------------------------------------------
_c_: 2 chars        _w_: word by char     _h_: headline in buffer  _o_: helm-occur
_C_: char           _W_: some word        _a_: heading in agenda   _p_: helm-swiper
_L_: char in line   _s_: subword by char  _q_: swoop org buffers   _f_: search forward
^  ^                _S_: some subword     ^ ^                      _b_: search backward
-----------------------------------------------------------------------------------
_B_: helm-buffers       _l_: avy-goto-line
_m_: helm-mini          _i_: ace-window
_R_: helm-recentf

_n_: Navigate           _._: mark position _/_: jump to mark
"
  ("c" avy-goto-char-2)
  ("C" avy-goto-char)
  ("L" avy-goto-char-in-line)
  ("w" avy-goto-word-1)
  ;; jump to beginning of some word
  ("W" avy-goto-word-0)
  ;; jump to subword starting with a char
  ("s" avy-goto-subword-1)
  ;; jump to some subword
  ("S" avy-goto-subword-0)

  ("l" avy-goto-line)
  ("i" ace-window)

  ("h" helm-org-headlines)
  ("a" helm-org-agenda-files-headings)
  ("q" helm-multi-swoop-org)

  ("o" helm-occur)
  ("p" swiper-helm)

  ("f" isearch-forward)
  ("b" isearch-backward)

  ("." org-mark-ring-push :color red)
  ("/" org-mark-ring-goto :color blue)
  ("B" helm-buffers-list)
  ("m" helm-mini)
  ("R" helm-recentf)
  ("n" hydra-navigate/body))

;; M-g has someother bindings already in spacemacs 
;; (cibin/global-set-key '("M-g" . goto/body))

;;; hydra for file/buffer, jump/goto, error/compile, toggle, format, 


; (-define-keys evil-normal-state-map
;     ("SPC SPC" #'execute-extended-command "M-x")
;     ("SPC t" #'my-toggle-hydra/body "toggle...")
;     ("SPC q" #'my-quit-hydra/body "quit...")
;     ("SPC e" #'my-errors-hydra/body "errors...")
;     ("SPC b" #'my-buffer-hydra/body "buffers...")
;     ("SPC j" #'my-jump-hydra/body "jump...")
;     ("SPC f" #'my-file-hydra/body "files...")
;     ("SPC s" #'my-search-hydra/body "search...")
;     ("SPC l" #'my-jump-hydra/lambda-l-and-exit "lines(current)")
;     ("SPC L" #'my-jump-hydra/lambda-L-and-exit "lines(all)")
;     ("SPC o" #'my-jump-hydra/lambda-i-and-exit "outline")
;     ("SPC '" #'my-new-eshell-split "shell")
;)



(provide 'cbn-hydra)

