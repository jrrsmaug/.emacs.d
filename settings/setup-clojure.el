(eval-after-load 'clojure-mode
  '(font-lock-add-keywords
    'clojure-mode `(("(\\(fn\\)[\[[:space:]]"
                     (0 (progn (compose-region (match-beginning 1)
                                               (match-end 1) "λ")
                               nil))))))
(eval-after-load 'clojure-mode
  '(font-lock-add-keywords
    'clojure-mode `(("\\(#\\)("
                     (0 (progn (compose-region (match-beginning 1)
                                               (match-end 1) "ƒ")
                               nil))))))

(eval-after-load 'clojure-mode
  '(font-lock-add-keywords
    'clojure-mode `(("\\(#\\){"
                     (0 (progn (compose-region (match-beginning 1)
                                               (match-end 1) "∈")
                               nil))))))

; indentation for midje facts - extracted from mijde-mode
(eval-after-load 'clojure-mode
  '(define-clojure-indent
     (fact 'defun)
     (facts 'defun)
     (against-background 'defun)
     (provided 0)))

(require 'clojure-mode)

(require 'smartparens-config)
(sp-use-smartparens-bindings)

(require 'rainbow-delimiters)

(setq auto-mode-alist (append '(("\\.cljs$" . clojure-mode))
                              auto-mode-alist))

(dolist (x '(scheme emacs-lisp lisp clojure))
  (add-hook (intern (concat (symbol-name x) "-mode-hook")) 'smartparens-strict-mode)
  (add-hook (intern (concat (symbol-name x) "-mode-hook")) 'rainbow-delimiters-mode))

(require 'cider)
(defun live-windows-hide-eol ()
  "Do not show ^M in files containing mixed UNIX and DOS line endings."
  (interactive)
  (setq buffer-display-table (make-display-table))
  (aset buffer-display-table ?\^M []))

(when (eq system-type 'windows-nt)
  (add-hook 'nrepl-mode-hook 'live-windows-hide-eol))

(add-hook 'cider-repl-mode-hook
          (lambda ()
            (cider-turn-on-eldoc-mode)
            (turn-on-smartparens-strict-mode)))

(add-hook 'cider-mode-hook
          (lambda ()
            (cider-turn-on-eldoc-mode)
            (turn-on-smartparens-strict-mode)))

(provide 'setup-clojure)
