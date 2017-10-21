(message "overriden-functions")
;; overriden functions
;; check when new release is done, the functionality is not broken or got added into builtins


;; overriden to add initial-input feature
(defun swiper-all (&optional initial-input)
  "Run `swiper' for all open buffers."
  (interactive)
  (let* ((swiper-window-width (- (frame-width) (if (display-graphic-p) 0 1)))
         (ivy-format-function #'swiper--all-format-function))
    (ivy-read "swiper-all: " 'swiper-all-function
              :action 'swiper-all-action
              :unwind #'swiper--cleanup
              :update-fn (lambda ()
                           (swiper-all-action (ivy-state-current ivy-last)))
              :dynamic-collection t
              :keymap swiper-all-map
             
                 :initial-input initial-input
              :caller 'swiper-multi)))

(provide 'overridden-functions)
