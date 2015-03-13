(setq exec-path (append exec-path '("C:\\Program Files (x86)\\Git\\bin")))

;; Turn off mouse interface early in startup to avoid momentary display
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

;; No splash screen please ... jeez
(setq inhibit-startup-message t)

(setq settings-dir
      (expand-file-name "settings" user-emacs-directory))

;; Set up load path
(add-to-list 'load-path settings-dir)

(require 'setup-el-get)

(setq my:el-get-packages
      '(clojure-mode
        solarized-emacs
        rainbow-delimiters
        cider
        midje-mode
        helm
        markdown-mode
        multiple-cursors
        expand-region
        popup
        dsvn
        magit
        js2-mode
        yasnippet
        smartparens
        exec-path-from-shell
        projectile
        undo-tree
        moz-repl
        ace-jump-mode
        dired+
        bookmark+
        iy-go-to-char
        key-chord
        keep-buffers
        ace-window
        hydra-head
        framemove
        company
	))

(el-get 'sync my:el-get-packages)

(cond
 ((eq window-system 'ns)
  (require 'setup-mac))
 ((eq window-system 'w32)
  (require 'setup-win32))
 ((eq window-system 'x)
  (require 'setup-x11)))

;; Functions (load all files in defuns-dir)
(setq defuns-dir (expand-file-name "defuns" user-emacs-directory))
(dolist (file (directory-files defuns-dir t "\\w+"))
  (when (file-regular-p file)
    (load file)))

(require 'setup-defaults)
(require 'setup-dired)
(require 'setup-helm)
(require 'setup-projectile)
(require 'setup-clojure)
(require 'setup-company)
(require 'setup-markdown)
(require 'setup-mc)
(require 'setup-hydra)
(require 'setup-svn)
(require 'setup-js2)
(require 'setup-org)

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file)
