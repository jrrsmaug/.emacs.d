(require 'mediawiki)
(setq mediawiki-site-alist
      (append '(("NovumWiki" "http://wiki.novum-online.de/dokuwiki/" "" "" "Hauptseite")
		("NovumIntranet" "http://intranet.novum-online.de/wiki/" "" "" "Hauptseite"))
	      mediawiki-site-alist))
(setq mediawiki-mode-hook (lambda ()
                            (visual-line-mode 1)))

(provide 'setup-mediawiki)
