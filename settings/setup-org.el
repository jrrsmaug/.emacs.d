;; org-mode
(setq-default ispell-program-name "aspell")
(add-hook 'org-mode-hook 'turn-on-flyspell 'append)
(require 'ox-latex)
(unless (boundp 'org-latex-classes)
  (setq org-latex-classes nil))
(add-to-list 'org-latex-classes
             '("nccs-doc"
               "\\documentclass{scrartcl}
                \\usepackage[T1]{fontenc}
                \\usepackage[scaled]{beraserif}
                \\usepackage[scaled]{berasans}
                \\usepackage[scaled]{beramono}
                \\usepackage[ngerman]{babel}
                \\usepackage[ansinew]{inputenc}
                \\usepackage{hyperref}
                \\hypersetup{colorlinks,citecolor=black,filecolor=black,linkcolor=blue,urlcolor=blue}
                \\usepackage{fancyhdr}
                \\pagestyle{fancy}
                \\addtocontents{toc}{\\protect\\thispagestyle{fancy}}
                \\renewcommand{\\headrulewidth}{0pt}
                \\lhead{} \\chead{} \\rhead{\\includegraphics[width=5cm]{logo.jpg}} \\lfoot{} \\cfoot{\\thepage} \\rfoot{}
                \\setlength{\\parindent}{0em}"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

(provide 'setup-org)
