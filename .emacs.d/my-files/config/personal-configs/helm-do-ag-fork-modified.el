;; take diff with master or remove when pull request is accepted
(defun helm-do-ag--helm (&optional query)
  (let ((search-dir (if (not (helm-ag--windows-p))
                        helm-ag--default-directory
                      (if (helm-do-ag--target-one-directory-p helm-ag--default-target)
                          (car helm-ag--default-target)
                        helm-ag--default-directory))))
    (helm-attrset 'name (helm-ag--helm-header search-dir)
                  helm-source-do-ag)
    (helm :sources '(helm-source-do-ag) :buffer "*helm-ag*" :keymap helm-do-ag-map
                     :input (or query
                     (helm-ag--marked-input t)
                     (helm-ag--insert-thing-at-point helm-ag-insert-at-point))
          :history 'helm-ag--helm-history)))

  (defun helm-do-ag (&optional basedir targets query)
  (interactive)
  (require 'helm-mode)
  (helm-ag--init-state)
  (let* ((helm-ag--default-directory (or basedir default-directory))
         (helm-ag--default-target (cond (targets targets)
                                        ((and (helm-ag--windows-p) basedir) (list basedir))
                                        (t
                                         (when (and (not basedir) (not helm-ag--buffer-search))
                                           (helm-read-file-name
                                            "Search in file(s): "
                                            :default default-directory
                                            :marked-candidates t :must-match t)))))
         (helm-do-ag--extensions (when helm-ag--default-target
                                   (helm-ag--do-ag-searched-extensions)))
         (one-directory-p (helm-do-ag--target-one-directory-p
                           helm-ag--default-target)))
    (helm-ag--set-do-ag-option)
    (helm-ag--set-command-features)
    (helm-ag--save-current-context)
    (helm-attrset 'search-this-file
                  (and (= (length helm-ag--default-target) 1)
                       (not (file-directory-p (car helm-ag--default-target)))
                       (car helm-ag--default-target))
                  helm-source-do-ag)
    (if (or (helm-ag--windows-p) (not one-directory-p)) ;; Path argument must be specified on Windows
        (helm-do-ag--helm query)
      (let* ((helm-ag--default-directory
              (file-name-as-directory (car helm-ag--default-target)))
             (helm-ag--default-target nil))
        (helm-do-ag--helm query)))))
(provide 'helm-do-ag-fork-modified)
