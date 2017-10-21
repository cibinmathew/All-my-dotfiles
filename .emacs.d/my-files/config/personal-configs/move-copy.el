 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; move file here                                                         ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; http://pragmaticemacs.com/emacs/quickly-move-a-file-to-the-current-directory/
(use-package dash
:defer t)
(use-package swiper
:defer t
:config
(progn
; Extending swiper
; With swiper, the following key bindings can be defined to insert the current symbol/word at point to the swiper minibuffer:
(define-key swiper-map (kbd "C-.")
  (lambda () (interactive) (insert (format "\\<%s\\>" (with-ivy-window (thing-at-point 'symbol))))))
(define-key swiper-map (kbd "M-.")
  (lambda () (interactive) (insert (format "\\<%s\\>" (with-ivy-window (thing-at-point 'word))))))	

  ))
  
;(require 'dash)
;(require 'swiper)

;; start directory
(defvar bjm/move-file-here-start-dir (expand-file-name (format "C://Users//%s//Downloads" user-login-name)))

(defun bjm/move-file-here ()
  "Move file from somewhere else to here.
The file is taken from a start directory set by `bjm/move-file-here-start-dir' and moved to the current directory if invoked in dired, or else the directory containing current buffer. The user is presented with a list of files in the start directory, from which to select the file to move, sorted by most recent first."
  (interactive)
  (let (file-list target-dir file-list-sorted start-file start-file-full)
    ;; clean directories from list but keep times
    (setq file-list
          (-remove (lambda (x) (nth 1 x))
                   (directory-files-and-attributes bjm/move-file-here-start-dir)))

    ;; get target directory
    ;; http://ergoemacs.org/emacs/emacs_copy_file_path.html
    (setq target-dir
          (if (equal major-mode 'dired-mode)
              (expand-file-name default-directory)
            (if (null (buffer-file-name))
                (user-error "ERROR: current buffer is not associated with a file.")
              (file-name-directory (buffer-file-name)))))

  ;; sort list by most recent
  ;;http://stackoverflow.com/questions/26514437/emacs-sort-list-of-directories-files-by-modification-date
  (setq file-list-sorted
        (mapcar #'car
                (sort file-list
                      #'(lambda (x y) (time-less-p (nth 6 y) (nth 6 x))))))

  ;; use ivy to select start-file
  (setq start-file (ivy-read
                    (concat "Move selected file to " target-dir ":")
                    file-list-sorted
                    :re-builder #'ivy--regex
                    :sort nil
                    :initial-input nil))

  ;; add full path to start file and end-file
  (setq start-file-full
        (expand-file-name start-file bjm/move-file-here-start-dir))
  (setq end-file
        (expand-file-name (file-name-nondirectory start-file) target-dir))
  (rename-file start-file-full end-file)
  (message "moved %s to %s" start-file-full end-file)))
(provide 'move-copy)