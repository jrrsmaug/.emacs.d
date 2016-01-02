;; setup unicode
(prefer-coding-system       'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)

;; Allow pasting selection outside of Emacs
(setq x-select-enable-clipboard t)

;; Auto refresh buffers
(global-auto-revert-mode 1)

;; Also auto refresh dired, but be quiet about it
(setq global-auto-revert-non-file-buffers t)
(setq auto-revert-verbose nil)

;; Answering just 'y' or 'n' will do
(defalias 'yes-or-no-p 'y-or-n-p)

(global-linum-mode 1)
(require 'server)
(unless (server-running-p)
  (server-start))
(desktop-save-mode 1)

(require 'undo-tree)
(global-undo-tree-mode)

(global-set-key (kbd "C-x k") 'kill-this-buffer)

(set-face-attribute 'default nil :font "Menlo for Powerline-10")

(provide 'setup-defaults)
