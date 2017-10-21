;; http://oremacs.com/swiper/#example---counsel-locate
;; https://github.com/abo-abo/swiper/issues/385

(require 'counsel)
(defun counsel-locate-function (str)
  (if (< (length str) 3)
      (counsel-more-chars 3)
    (counsel--async-command
     (format "locate %s '%s'"
             (mapconcat #'identity counsel-locate-options " ")
             (counsel-unquote-regex-parens
              (ivy--regex str))))
    '("" "working...")))

;;;###autoload
(defun counsel-locate (&optional initial-input)
  "Call the \"locate\" shell command.
INITIAL-INPUT can be given as the initial minibuffer input."
  (interactive)
  (ivy-read "Locate: " #'counsel-locate-function
            :initial-input initial-input
            :dynamic-collection t
            :history 'counsel-locate-history
            :action (lambda (file)
                      (with-ivy-window
                        (when file
                          (find-file file))))
            :unwind #'counsel-delete-process
            :caller 'counsel-locate))

(defcustom counsel-locate-options (if (eq system-type 'darwin)
                                      '("-i")
                                    '("-i" "--regex")
                                    ;; '("")
                                    )
  "Command line options for `locate`."
  :group 'ivy
  :type  '(repeat string))


(global-set-key (kbd "C-x R") (lambda () (interactive) (counsel-find "snf " "bash -ic 'searchnotes . |fzy -e%s|head -n 50' 2>/dev/null" )))

(defun counsel-find-function (str)
  (if (< (length str) 3)
      (counsel-more-chars 3)
    (let ((cmd (format bash-cmd str)
            ;; (format
              ;; "lfind %s ! -readable -maxdepth 1 -prune -o -iname \"%s*\" -print"
                                        ; NOTE: some versions of `find' may require parentheses,
              ; like this: \( ! -readable -prune \)
              ;; default-directory
              ;; (counsel-unquote-regex-parens
               ;; (ivy--regex str))

             ;; "c:/cygwin64/home/cibin/delete.sh %s" str
             ;; "bash -ic 'searchnotes . |fzy -e%s|head -n 50' 2>/dev/null" str
             ;; "cat \"c:/Users/cibin/Downloads/all_files.db\"|/usr/local/bin/fzy -e%s|head -n 50|sed -e \"s/\\/cygdrive\\/\\(.\\)\\//\\1:\\//\"" str
           ;; )
          ))
      (message "cmd: %s" cmd)
      (counsel--async-command cmd))
    '("" "working...")
    ))
;; (counsel-find "ls")
;;;###autoload
(defun counsel-find (prompt bash-cmd &optional initial-input)
  "Use GNU find, counsel and ivy  to present all paths
   in a directory tree that match the REGEX input"
  (interactive)
(defvar bash-cmd bash-cmd)
(ivy-read
(format "%s : " prompt)
 #'counsel-find-function
            :initial-input initial-input
            :dynamic-collection t
            :history 'counsel-find-history
            :action (lambda (file)
                      (with-ivy-window
                        (when file
                          (find-file file))))
            :unwind #'counsel-delete-process
            :caller 'counsel-find))

(with-eval-after-load 'counsel
(counsel-set-async-exit-code 'counsel-find 1 "Nothing found")
)
(provide 'custom-ivy)
