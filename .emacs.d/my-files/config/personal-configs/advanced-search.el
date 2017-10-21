;; https://github.com/kaushalmodi/.emacs.d/blob/master/setup-files/setup-ag.el
;; check function in ag.el
;; helm-ag


;;TODO check ag/kill-process
(message "loading advanced-search")

(use-package ag
  :defer t
:config
(progn

(bind-keys
     :map ag-mode-map
      ("i" . wgrep-change-to-wgrep-mode)
      ("/" . isearch-forward)
      ("n" . next-error-no-select)
      ("p" . previous-error-no-select)
      ("q" . ag-kill-buffers))

  )
  )
;; TODO update definition when ag.el is updated
(defun cibin/ag-files-cwd (string file-type directory)
  "Search using ag in a given DIRECTORY for a given search STRING,
limited to files that match FILE-TYPE. STRING defaults to
the symbol under point.
If called with a prefix, prompts for flags to pass to ag."
  (interactive (list (read-from-minibuffer "Search string: " (ag/dwim-at-point))
                     (ag/read-file-type)
                     ;; (read-directory-name "Directory: ")
                     (return-source-path)
                     ))
  (apply #'ag/search string directory file-type))


(defun cibin/helm-do-ag-cwd ()
  (interactive)
 ;; (setq helm-ag-base-command "lfind  . -iname sea|grep sea ")
  ;; (setq helm-ag-command-option  "")
  (setq helm-ag-command-option (concat "-n"))
  ;; (setq helm-ag-command-option (concat "-G" (get-file-extension)  "$"))
;; (setq helm-do-ag--extensions '(".e" ".txt"))
;; (setq helm-do-ag--extensions '("\\.txt\\'" "\\.mkd\\'"))
  (let ((rootdir (return-source-path)))
    (unless rootdir
      (error "Could not find the project root. Create a git, hg, or svn repository there first. "))
    (helm-do-ag rootdir )
    ))

;; TODO  query parameter added on helm-do-ag-fork-modified.el functionality
(defun cibin/helm-do-ag-Extension-here-cwd (&optional query)
  (interactive)
  (setq helm-ag-command-option (concat "-n -G" (get-file-extension)  "$"))
  (let ((rootdir (return-source-path)))
    (unless rootdir
      (error "Could not find the project root. Create a git, hg, or svn repository there first. "))
    (helm-do-ag rootdir nil query)))

(defun cibin/helm-do-ag-Extension-recurse-cwd (&optional query)
  (interactive)
  (setq helm-ag-command-option (concat "-G" (get-file-extension)  "$"))
  (let ((rootdir (return-source-path)))
    (unless rootdir
      (error "Could not find the project root. Create a git, hg, or svn repository there first. "))
    (helm-do-ag rootdir nil query)))

;; TODO check regex option
(defun modi/ag-regexp-cwd (string)
      "SEARCH using ag in the CURRENT DIRECTORY for a given search REGEXP,
with REGEXP defaulting to the symbol under point.
If called with a prefix, prompts for flags to pass to ag."
      (interactive
       (list (read-from-minibuffer "Search regexp in current dir: "
                                   (ag/dwim-at-point))))
      (ag/search string (return-source-path) :regexp t))

 ;; Redefine the ag-regexp function where the default search pattern is
    ;; word at point



(defun ag-regexp (string directory)
      "Search using ag in a given DIRECTORY for a given search REGEXP,
with REGEXP defaulting to the symbol under point.
Search using ag in a given directory for a given regexp.
If called with a prefix, prompts for flags to pass to ag."
      (interactive (list (read-from-minibuffer "Search regexp: " (ag/dwim-at-point))
                         (read-directory-name "Directory: ")))
      (ag/search string directory :regexp t))


;; (message (format "%s" (ag/read-file-type)))
;; (:file-type python)
;; (let* ((all-types-with-extensions (ag/get-supported-types))
         ;; (all-types (mapcar 'car all-types-with-extensions))
         ;; (file-type
          ;; (completing-read "Select file type: "
                           ;; (append '("custom (provide a PCRE regex)") all-types)))
         ;; (file-type-extensions
          ;; (cdr (assoc file-type all-types-with-extensions))))
    ;; (if file-type-extensions
        ;; (list :file-type file-type)
      ;; (list :file-regex
            ;; (read-from-minibuffer "Filenames which match PCRE: "
                                  ;; (ag/buffer-extension-regex)))))
(with-eval-after-load 'helm
(define-key helm-map  (kbd "C-f")  'helm-next-source)
(define-key helm-map  (kbd "C-j")  'helm-previous-source)
)

;; (flex-isearch-mode 1) vs flx-isearch-mode
;; Flx isearch uses lewang/flx, a library that uses sophistocated heuristics to sort matches. It's awesome. Use it.
;; This was heavily inspired by emacsmirror/flex-isearch, a cool idea that lacks the intelligent sorting flx provides.
 (flx-isearch-mode 1)
(define-key evil-normal-state-map "/" 'flx-isearch-forward)
(define-key evil-normal-state-map "*" 'evil-search-forward)
(with-eval-after-load 'swiper
(define-key evil-normal-state-map "?" 'swiper-all))
(define-key isearch-mode-map "\C-s" 'flex-isearch-forward)
(define-key isearch-mode-map "\C-r" 'isearch-toggle-regexp)



;; https://stackoverflow.com/questions/285660/automatically-wrapping-i-search
(defadvice isearch-search (after isearch-no-fail activate)
  (unless isearch-success
(message "wrapping search .....")
    (ad-disable-advice 'isearch-search 'after 'isearch-no-fail)
    (ad-activate 'isearch-search)
    (isearch-repeat (if isearch-forward 'forward))
    (ad-enable-advice 'isearch-search 'after 'isearch-no-fail)
    (ad-activate 'isearch-search)))


;; https://stackoverflow.com/questions/202803/searching-for-marked-selected-text-in-emacs?rq=1
(defun jrh-isearch-with-region ()
  "Use region as the isearch text."
  (when mark-active
    (let ((region (funcall region-extract-function nil)))
      (deactivate-mark)
      (isearch-push-state)
      (isearch-yank-string region))))

(add-hook 'isearch-mode-hook #'jrh-isearch-with-region)

;; http://blog.binchen.org/posts/complete-line-with-ivy-mode.html
(defun counsel-escape (keyword)
  (setq keyword (replace-regexp-in-string "\\$" "\\\\\$" keyword))
  (replace-regexp-in-string "\"" "\\\\\"" keyword))

(defun counsel-replace-current-line (leading-spaces content)
  (beginning-of-line)
  (kill-line)
  (insert (concat leading-spaces content))
  (end-of-line))

(defun counsel-git-grep-complete-line ()
  (interactive)
  (let* (cmd
        (cur-line (buffer-substring-no-properties (line-beginning-position)
                                                  (line-end-position)))
        (default-directory (locate-dominating-file
                            default-directory ".git"))
        keyword
        (leading-spaces "")
        collection)
    (setq keyword (counsel-escape (if (region-active-p)
                                      (buffer-substring-no-properties (region-beginning)
                                                                      (region-end))
                                    (replace-regexp-in-string "^[ \t]*" "" cur-line))))
    ;; grep lines without leading/trailing spaces
    (setq cmd (format "git --no-pager grep -I -h --no-color -i -e \"^[ \\t]*%s\" | sed s\"\/^[ \\t]*\/\/\" | sed s\"\/[ \\t]*$\/\/\" | sort | uniq" keyword))
    (when (setq collection (split-string (shell-command-to-string cmd) "\n" t))
      (if (string-match "^\\([ \t]*\\)" cur-line)
          (setq leading-spaces (match-string 1 cur-line)))
      (cond
       ((= 1 (length collection))
        (counsel-replace-current-line leading-spaces (car collection)))
       ((> (length collection) 1)
        (ivy-read "lines:"
                  collection
                  :action (lambda (l)
                            (counsel-replace-current-line leading-spaces l))))))
    ))
(cibin/global-set-key '("C-x C-l" . counsel-git-grep-complete-line))


(defvar search-directory  nil)
(defvar search-extension nil)

(defun cibin/helm-do-ag-All-Project (&optional query)
  (interactive)
  (setq search-extension (read-from-minibuffer "extension: "))
  (setq helm-ag-command-option (concat "-G" search-extension  "$"))
  (setq search-directory (read-directory-name "Directory: " (format "c:/users/%s/Downloads/Projects" user-login-name)))
(helm-do-ag-search-template search-directory)
)

(defun cibin/helm-do-ag-All-Project-repeat-search (&optional query)
  (interactive)
  ;; (setq search-extension (read-from-minibuffer "extension: "))
  (setq helm-ag-command-option (concat "-G" search-extension  "$"))
 ;; (setq search-directory (read-directory-name "Directory: " (format "c:/users/%s/Downloads/" user-login-name)))
(message (format "Searching '.%s' files in '%s'" search-extension search-directory ))
(helm-do-ag-search-template search-directory)
)

(cibin/global-set-key '("C-x P" . cibin/helm-do-ag-All-Project))
(cibin/global-set-key '("C-x M-P" . cibin/helm-do-ag-All-Project-repeat-search))

(defun helm-do-ag-search-template (search-directory)

  (let ((rootdir search-directory))
    (unless rootdir
      (error "Could not find the project root. Create a git, hg, or svn repository there first. "))
    (helm-do-ag rootdir nil query)))

; (message search-directory)

(provide 'advanced-search)
