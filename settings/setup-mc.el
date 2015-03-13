(require 'multiple-cursors)
(require 'expand-region)
(require 'ace-jump-mode)

(global-set-key (kbd "M-8") 'er/expand-region)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

(require 'key-chord)
(key-chord-mode 1)

(key-chord-define-global "fg" 'iy-go-to-char)
(key-chord-define-global "hj" 'iy-go-to-char-backward)

(key-chord-define-global "df" 'ace-jump-word-mode)
(key-chord-define-global "jk" 'ace-jump-char-mode)

(provide 'setup-mc)
