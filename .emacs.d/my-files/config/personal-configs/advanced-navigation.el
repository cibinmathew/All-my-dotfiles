(message "loading advanced navigation")
; (autoload 'bm-toggle   "bm" "Toggle bookmark in current buffer." t)
; (autoload 'bm-next     "bm" "Goto bookmark."                     t)
; (autoload 'bm-previous "bm" "Goto previous bookmark."            t)
(cibin/global-set-key '("<C-f2>" . bm-toggle))
(global-set-key (kbd "<M-f2>") (lambda () (interactive)
								(setq bm-cycle-all-buffers t)
								(bm-next)
								(setq bm-cycle-all-buffers nil)))

(cibin/global-set-key '("<f2>" .   'bm-next))
(cibin/global-set-key '("<S-f2>" . bm-previous))

; Click on fringe to toggle bookmarks, and use mouse wheel to move between them.

(global-set-key (kbd "<left-fringe> <wheel-down>") 'bm-next-mouse)
(global-set-key (kbd "<left-fringe> <wheel-up>") 'bm-previous-mouse)
(global-set-key (kbd "<left-fringe> <mouse-1>") 'bm-toggle-mouse)

; If you would like to cycle through bookmarks in all open buffers, add the following line:
(setq bm-cycle-all-buffers nil)
; cycle
(setq bm-wrap-search t)
;; save bookmarks
         (setq-default bm-buffer-persistence t)

         ;; Restoring bookmarks when on file find.
         (add-hook 'find-file-hooks 'bm-buffer-restore)


         (add-hook 'after-save-hook #'bm-buffer-save)

         ;; Restoring bookmarks
         (add-hook 'find-file-hooks   #'bm-buffer-restore)
         (add-hook 'after-revert-hook #'bm-buffer-restore)

		 
		 
		 (provide 'advanced-navigation)