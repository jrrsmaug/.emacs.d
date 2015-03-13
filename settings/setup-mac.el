(set-face-attribute 'default nil :font "-apple-Menlo-medium-normal-normal-*-14-*-*-*-m-0-iso10646-")
(setq shell-file-name "/bin/bash")
(exec-path-from-shell-initialize)

(setq mac-command-modifier 'meta)
(setq mac-option-modifier nil)

(setq tramp-default-method "ssh")

(provide 'setup-mac)
