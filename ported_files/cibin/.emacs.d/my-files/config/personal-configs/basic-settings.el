﻿(message "loading basic-settings")

(defun minibuffer-keyboard-quit ()
	"http://stackoverflow.com/a/10166400
	Abort recursive edit.
In Delete Selection mode, if the mark is active, just deactivate it;
then it takes a second \\[keyboard-quit] to abort the minibuffer."
(interactive)
(if (and delete-selection-mode transient-mark-mode mark-active)
	(setq deactivate-mark  t)
	(when (get-buffer "*Completions*") (delete-windows-on "*Completions*"))
	(abort-recursive-edit)))
	
	(provide 'basic-settings)