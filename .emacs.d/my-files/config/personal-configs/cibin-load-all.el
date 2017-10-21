(message "loading cbn-load-all")

;;; TODO use-package for quickrun
; (load-file "~/.emacs.d/my-files/config/others/emacs-quickrun-master/quickrun.el")
; (use-package quickrun
;   :ensure t
;   :commands (quickrun
;              quickrun-region
;              quickrun-with-arg
;              quickrun-shell
;              quickrun-compile-only
;              quickrun-replace-region))

; (load-file "~/.emacs.d/my-files/config/others/fic-ext-mode.el")
(load-file "~/.emacs.d/my-files/config/others/zzz-to-char.el")
(load-file "~/.emacs.d/my-files/config/others/vlfi-master/vlf-setup.el")

;; TODO enable if required
;; move this to use-package
(load-file "~/.emacs.d/my-files/config/others/dired-sort-menu.el")
(load-file "~/.emacs.d/my-files/config/others/dired-sort-menu+.el")
(load-file "~/.emacs.d/my-files/config/others/bm.el")
; ;(cd (format "C:/Users/%s/AppData/Roaming/.emacs.d/my-files/config/others/el-qrencode-master" user-login-name))

; (cd (format "c:/cygwin64/home/%s/.emacs.d/my-files/config/others/el-qrencode-master" user-login-name))
; (load-file "~/.emacs.d/my-files/config/others/el-qrencode-master/load.el")


(load-file "~/.emacs.d/my-files/config/others/popwin-el-master/popwin.el")



; remove ; (load-file "~/.emacs.d/my-files/config/others/windows-path.el")

;; TODO disabling for now
;(load-file "~/.emacs.d/my-files/config/personal-configs/create-filecache.el")

; to save memory, make it read only when hotkey is fired
; (file-cache-read-cache-from-file)




(add-to-list 'load-path "~/.emacs.d/my-files/config/personal-configs/")

(defun cibin-load-all-custom-bindings ()
(interactive)

(message "loading all...")

(require 'basic-settings)
(require 'basic-settings2)
(require 'cbn-functions)
(require 'cbn-shell)
(require 'my-python)
(require 'cbn-navigation)
(require 'move-copy)
(require 'cbn-compile)
(require 'cbn-search-bindings)
(require 'cbn-dired-settings)
(require 'cbn-dired-settings2)
(require 'more-custom-functions)
(require 'cbn-auto-complete)
(require 'org-settings)
(require 'cbn-dired-show)
(require 'buttonize-buffer)
(require 'other-settings)
(require 'cbn-appearance)
(require 'cbn-auto-spell)
(require 'tabbar-tweaks)
(require 'major-mode-settings)
(require 'advanced-search)
(require 'cbn-mode-line)
(require 'hydra-quick-edit)
(require 'cbn-mode-line2)
;; (require 'cbn-performance)

(require 'cbn-xah-fly-keys-functions)
(require 'added-april)
(require 'custom-ivy)
; (load-file "~/.emacs.d/my-files/config/personal-configs/cbn-xah-fly-keys.el")
(require 'cbn-hydra)
(require 'cbn-helm-config)
(require 'advanced-navigation)
(cibin-load-essential-custom-bindings)
(message "loaded all")
  )

 (defun cibin-load-essential-custom-bindings ()
(interactive)
  (message "loading all")
(require 'buffer-management)
(require 'starter-kit-bindings)
(require 'overridden-functions)
 )

(cibin-load-all-custom-bindings)
(cibin/global-set-key '("M-5" . cibin-load-all-custom-bindings))
(cibin/global-set-key '("M-6" . cibin-load-essential-custom-bindings))


(setq gc-cons-threshold (* 700 1000 1000))
