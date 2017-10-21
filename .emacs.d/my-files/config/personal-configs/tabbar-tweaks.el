(message "loading tabbartweaks")
  
; more customisations at https://www.emacswiki.org/emacs/TabBarMode
; Speed up by not using images

; Tabbar can slow down Emacs considerably, especially simply moving the cursor up or down. This can be rectified by adding this to your .emacs file, which makes Tabbar use characters to represent the three images in the top-left corner:

 (setq tabbar-use-images nil)

(require 'tabbar)
 (tabbar-mode)
 
 
; http://amitp.blogspot.in/2007/04/emacs-buffer-tabs.html
;; Note: for tabbar 2.0 use 
;; tabbar-default not tabbar-default-face,
;; tabbar-selected not tabbar-selected-face,
;; tabbar-button not tabbar-button-face,
;; tabbar-separator not tabbar-separator-face
; https://gist.github.com/3demax/1264635/91ccb6c423effd811dbdb1412b70c15e95fa700d
;; Tabbar
;(require 'tabbar)
(use-package tabbar
:defer t)
;; Tabbar settings
(set-face-attribute
 'tabbar-default nil
 :background "gray20"
 :foreground "red"
 :box '(:line-width 1 :color "gray20" :style nil))
(set-face-attribute
 'tabbar-unselected nil 
 :background "gray30"
 :foreground "white"
 :box '(:line-width 1 :color "gray30" :style nil))
(set-face-attribute
 'tabbar-modified nil
 :foreground "#ff4444"
 :background "gray0"
 :box nil)

(set-face-attribute
 'tabbar-selected nil
 :background "green"
 :foreground "black"
 :box '(:line-width 1 :color "green" :style nil))

;; (set-face-attribute 'tabbar-highlight nil :background "white" :foreground "black" :underline nil
 ;; :box '(:line-width 1 :color "white" :style nil))
(set-face-attribute
 'tabbar-selected nil
 :background "white"
 :foreground "black"
 :underline nil
 :box '(:line-width 1 :color "white" :style nil))
(set-face-attribute
 'tabbar-button nil
 :box '(:line-width 1 :color "gray25" :style nil))
(set-face-attribute
 'tabbar-separator nil
 :background "gray20"
 :height 0.3)

;; Change padding of the tabs
;; we also need to set separator to avoid overlapping tabs by highlighted tabs
(custom-set-variables
 '(tabbar-separator (quote (0.5))))
;; adding spaces
(defun tabbar-buffer-tab-label (tab)
  "Return a label for TAB.
That is, a string used to represent it on the tab bar."
  (let ((label  (if tabbar--buffer-show-groups
                    (format "[%s]  " (tabbar-tab-tabset tab))
                  (format "%s  " (tabbar-tab-value tab)))))
    ;; Unless the tab bar auto scrolls to keep the selected tab
    ;; visible, shorten the tab label to keep as many tabs as possible
    ;; in the visible area of the tab bar.
    (if tabbar-auto-scroll-flag
        label
      (tabbar-shorten
       label (max 1 (/ (window-width)
                       (length (tabbar-view
                                (tabbar-current-tabset)))))))))
 

; https://emacswiki.org/emacs/TabBarMode

 ;; Add a buffer modification state indicator in the tab label, and place a
 ;; space around the label to make it looks less crowd.
 (defadvice tabbar-buffer-tab-label (after fixup_tab_label_space_and_flag activate)
   (setq ad-return-value
         (if (and (buffer-modified-p (tabbar-tab-value tab))
                  (buffer-file-name (tabbar-tab-value tab)))
             (concat " * " (concat ad-return-value " "))
           (concat " " (concat ad-return-value " ")))))
 
 ;; Called each time the modification state of the buffer changed.
 (defun ztl-modification-state-change ()
   (tabbar-set-template tabbar-current-tabset nil)
   (tabbar-display-update))
 
 ;; First-change-hook is called BEFORE the change is made.
 (defun ztl-on-buffer-modification ()
   (set-buffer-modified-p t)
   (ztl-modification-state-change))
 (add-hook 'after-save-hook 'ztl-modification-state-change)
 
 ;; This doesn't work for revert, I don't know.
 ;;(add-hook 'after-revert-hook 'ztl-modification-state-change)
 (add-hook 'first-change-hook 'ztl-on-buffer-modification)
(provide 'tabbar-tweaks)
