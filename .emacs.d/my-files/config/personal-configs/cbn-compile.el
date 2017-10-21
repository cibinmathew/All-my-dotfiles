(message "loading cbn-compile")

;; TODO check Xah-lee.... run for F8
(cibin/global-set-key '("<f8>" . quickrun))
;TODO ;; (cibin/global-set-key '("<M-f8>" . quickrun-region))
;(cibin/global-set-key '("<C-f8>" . helm-quickrun))
(cibin/global-set-key '("<C-f8>" . cibin/eval-this-line))
(cibin/global-set-key '("<C-f9>" . cbn-debug))
(defun cibin/eval-this-line () (interactive)
       (end-of-line)
       (call-interactively 'eval-last-sexp)
       (next-line)
)


;; (require 'isend)
 (setq isend-skip-empty-lines nil)
  (setq isend-strip-empty-lines nil)
  (setq isend-delete-indentation t)
  (setq isend-end-with-empty-line t)

  (use-package realgud
  :ensure t
  :defer t
  :commands (realgud:gdb
             realgud:ipdb
             realgud:pdb))
			 

   		 
			 
(defun cbn-debug ()
	(interactive)
	;(require 'realgud) ; lazy loading
	
	;; (menu-bar-mode 1)
	;; (tool-bar-mode 1)
	(setq fname (buffer-file-name))
	(message (buffer-file-name))
	(setq old-buffer (current-buffer))
	(message (format "pdb %s" fname))
	(realgud:pdb (format "pdb %s" buffer-file-name))
	;OR but error
	; (realgud:run-process "pdb" "pdb" '("pdb" "C:/Users/cibin/Downloads/delete.py") realgud:pdb-minibuffer-history)
	(message "waiting for shell")
	(sleep-for 3)
	(message "associatiing")
  (other-window 1)
	(switch-to-buffer old-buffer)
	(isend-associate (format "*pdb %s shell*" old-buffer ))
	(message "associated")
	;; (switch-to-buffer old-buffer)
)


;; (realgud:run-process "pdb" "C:/Users/cibin/Downloads/delete.py" '("python -m pdb" "") realgud:pdb-minibuffer-history)
;; (realgud:run-process "python -m C:/Python27/Lib/pdb.py" "C:/Users/cibin/Downloads/delete.py" '("pdb" "") realgud:pdb-minibuffer-history)
;; PDB command line


(defun user-python-debug-buffer ()
  "Run default python debugger on current buffer."
  (interactive)
  (setq command (format "python -u -m pdb %s " (file-name-nondirectory buffer-file-name)))
  (let ((command-with-args (read-string "Debug command: " command nil nil nil)))
    (pdb command-with-args)))
(provide 'cbn-compile)