(require 'helm-config)

(global-set-key (kbd "C-c h") 'helm-command-prefix)
(global-unset-key (kbd "C-x c"))

(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(global-set-key (kbd "C-x b") 'helm-mini)
(global-set-key (kbd "C-x C-b") 'helm-buffers-list)
(global-set-key (kbd "C-x C-f") 'helm-find-files)

(defun helm-ff-expand-dir (candidate)
  (let* ((follow        (buffer-local-value
                         'helm-follow-mode
                         (get-buffer-create helm-buffer)))
         (insert-in-minibuffer #'(lambda (fname)
                                  (with-selected-window (minibuffer-window)
                                    (unless follow
                                      (delete-minibuffer-contents)
                                      (set-text-properties 0 (length fname)
                                                           nil fname)
                                      (insert fname))))))
    (if (file-directory-p candidate)
        (progn
          (when (string= (helm-basename candidate) "..")
            (setq helm-ff-last-expanded helm-ff-default-directory))
          (funcall insert-in-minibuffer (file-name-as-directory
                                         (expand-file-name candidate))))
        (helm-exit-minibuffer))))

(defun helm-ff-persistent-expand-dir ()
  (interactive)
  (helm-attrset 'expand-dir 'helm-ff-expand-dir)
  (helm-execute-persistent-action 'expand-dir))

(helm-mode 1)

(define-key helm-find-files-map (kbd "RET") 'helm-ff-persistent-expand-dir)

(when (executable-find "ack")
  (setq helm-grep-default-command "ack -Hn --no-group %e %p %f"
        helm-grep-default-recurse-command "ack -H --no-group %e %p %f"))

(provide 'setup-helm)
