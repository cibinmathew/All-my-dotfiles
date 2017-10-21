
(message "loading cbn-auto-complete")
; enable it globally you should use
(global-auto-complete-mode -1)

(ac-config-default)
; But it uses auto-complete-mode-maybe, which turn AC on only those listed in ac-modes. You can add them manually just like this
(add-to-list 'ac-modes 'text-mode)
(custom-set-variables
	'(ac-auto-show-menu    0.2)
	'(ac-delay             0.2)
	'(ac-menu-height       20)
	'(ac-auto-start t)
	'(ac-auto-start 3)
	'(ac-use-quick-help t)
	'(ac-show-menu-immediately-on-auto-complete t)
	'(ac-ignore-case 'smart)
	'(ac-candidate-limit 30)
	'(ac-source-files-in-current-dir)
	'(ac-source-filename)
	'(ac-source-words-in-same-mode-buffers)
	'(ac-source-yasnippet)
	'(ac-fuzzy-complete t)
	'(ac-use-fuzzy t)
	'(ac-fuzzy-enable t)
	'(ac-dwim t)
	'(ac-use-menu-map t)
)
(cibin/global-set-key '("M-I" . ac-fuzzy-complete))
;; Default settings
(define-key ac-menu-map "\C-n" 'ac-next)
(define-key ac-menu-map "\C-p" 'ac-previous)
(define-key ac-menu-map  (kbd "<S-tab>") 'ac-previous)

(defun cibin-apply-Company-auto-complete-minor-mode()
(interactive)
(with-eval-after-load 'company

  (company-flx-mode +1)
 (setq company-flx-limit 50)
 (setq company-idle-delay 0.1)
 (setq company-minimum-prefix-length 1)

 ;; company grouped backends
(setq company-backends nil)
 ;; (add-to-list 'company-backends '( company-dabbrev company-capf company-dabbrev-code) company-capf)
 (add-to-list 'company-backends ' company-dabbrev )
(global-company-mode t)
)
)

(defun cibin-apply-AC-auto-complete-minor-mode()
(interactive)
(require 'flx-ido)
(ido-mode 1)[flx-ido]
(ido-everywhere 1)
(flx-ido-mode 1)
(ido-vertical-mode 1)
;; disable ido faces to see flx highlights.
(setq ido-enable-flex-matching t)
(setq ido-use-faces nil)

)
; http://ergoemacs.org/misc/emacs_abbrev_shell_elisp.html

(defcustom xah-shell-abbrev-alist nil "alist of xah's shell abbrevs")

(setq xah-shell-abbrev-alist
      '(
        ("rsync1" . "rsync -z -r -v -t --chmod=Dugo+x --chmod=ugo+r --delete --exclude='*~' --exclude='.bash_history' --exclude='logs/'  --rsh='ssh -l u80781' ~/web/ u80781@s30097.example.com:~/")

        ("ssh" . "ssh -l u80781 xahlee.org ")
        ("img1" . "convert -quality 85% ")
        ("imgScale" . "convert -scale 50% -quality 85% ")
        ("img256" . "convert +dither -colors 256 ")
        ("imgBatch" . "find . -name \"*png\" | xargs -l -i basename \"{}\" \".png\" | xargs -l -i  convert -quality 85% \"{}.png\" \"{}.jpg\"")
        ("img-bmp2png" . "find . -name \"*bmp\" | xargs -l -i basename \"{}\" \".bmp\" | xargs -l -i  convert \"{}.bmp\" \"{}.png\"")

        ("grep" . "grep -r -F 'xxx' --include='*html' ~/web")

        ("rm empty" . "find . -type f -empty")
        ("chmod file" . "find . -type f -exec chmod 644 {} ';'")
        ("rm~" . "find . -name \"*~\" -exec rm {} ';'")
        ("findEmptyDir" . "find . -depth -empty -type d")
        ("rmEmptyDir" . "find . -depth -empty -type d -exec rmdir {} ';'")
        ("chmod2" . "find . -type d -exec chmod 755 {} ';'")
        ("lynx" . "lynx -dump -assume_local_charset=utf-8 -display_charset=utf-8 -width=100")
        ("vp" . "feh --randomize --recursive --auto-zoom --action \"gvfs-trash '%f'\" --geometry 1600x1000 ~/Pictures/ &")))

(defun xah-shell-commands (*cmd-abbrev)
  "insert shell command from a list of abbrevs.

URL `http://ergoemacs.org/misc/emacs_abbrev_shell_elisp.html'
version 2015-02-05"
  (interactive
   (list
    (ido-completing-read "shell abbrevs:" (mapcar (lambda (x) (car x)) xah-shell-abbrev-alist) "PREDICATE" "REQUIRE-MATCH")))
  (progn
    (insert (cdr (assoc *cmd-abbrev xah-shell-abbrev-alist)))))
(provide 'cbn-auto-complete)
