(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

(provide 'setup-js2)

(autoload 'moz-minor-mode "moz" "Mozilla Minor and Inferior Mozilla Modes" t)

(add-hook 'javascript-mode-hook 'javascript-custom-setup)
(defun javascript-custom-setup ()
  (moz-minor-mode 1))
