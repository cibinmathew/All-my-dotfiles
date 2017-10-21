;; other major mode settings

;; ini files 
;; https://github.com/Lindydancer/ini-mode
;; There doesn't appear to be a bundled mode for windows-style .ini files, and as of <2016-10-15 Sat> no package in melpa. I'm using a downloaded copy of ini-mode from GitHub.

;; TODO disabled as ;; config-windows-mode is better than ini-mode 
;; (load-file "~/.emacs.d/my-files/config/others/ini-mode.el")


(add-to-list 'auto-mode-alist '("\\.xml$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.readme.md$" . text-mode))
(add-to-list 'auto-mode-alist '("\\.bashrc$" . shell-mode))
(add-to-list 'auto-mode-alist '("\\.bash_profile$" . shell-mode))

(provide 'major-mode-settings)
