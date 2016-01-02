(require 'ox)
(require 'ox-ascii)

;; Define the backend itself
(org-export-define-derived-backend 'confluence 'ascii
  :translate-alist '((bold . org-confluence-bold)
		     (example-block . org-confluence-example-block)
		     (fixed-width . org-confluence-fixed-width)
		     (footnote-definition . org-confluence-empty)
		     (footnote-reference . org-confluence-empty)
		     (headline . org-confluence-headline)
		     (italic . org-confluence-italic)
                     (item . org-confluence-item)
		     (link . org-confluence-link)
		     (property-drawer . org-confluence-property-drawer)
		     (section . org-confluence-section)
		     (src-block . org-confluence-src-block)
		     (strike-through . org-confluence-strike-through)
		     (table . org-confluence-table)
		     (table-cell . org-confluence-table-cell)
		     (table-row . org-confluence-table-row)
		     (template . org-confluence-template)
		     (underline . org-confluence-underline)
		     (verbatim . org-confluence-code)
		     (code . org-confluence-code)))

;; All the functions we use
(defun org-confluence-bold (bold contents info)
  (format "*%s*" contents))

(defun org-confluence-empty (empty contents info)
  "")

(defun org-confluence-example-block (example-block contents info)
  ;; FIXME: provide a user-controlled variable for theme
  (let ((content (org-export-format-code-default example-block info)))
    (org-confluence--block "none" "Confluence" content)))

(defun org-confluence-italic (italic contents info)
  (format "_%s_" contents))

(defun org-confluence-item (item contents info)
  (concat (make-string (1+ (org-confluence--li-depth item)) ?\-)
          " "
          (org-trim contents)))

(defun org-confluence-code (code contents info)
  (format "\{\{%s\}\}" (org-element-property :value code)))

(defun org-confluence-fixed-width (fixed-width contents info)
  (format "\{\{%s\}\}" contents))

(defun org-confluence-headline (headline contents info)
  (let ((low-level-rank (org-export-low-level-p headline info))
        (text (org-export-data (org-element-property :title headline)
                               info))
        (level (org-export-get-relative-level headline info)))
    ;; Else: Standard headline.
    (format "h%s. %s\n%s" level text
            (if (org-string-nw-p contents) contents
              ""))))

(defun org-confluence-link (link desc info)
  (let ((raw-link (org-element-property :raw-link link)))
    (concat "["
            (when (org-string-nw-p desc) (format "%s|" desc))
            (cond
             ((string-match "^confluence:" raw-link)
              (replace-regexp-in-string "^confluence:" "" raw-link))
             (t
              raw-link))
            "]")))

(defun org-confluence-property-drawer (property-drawer contents info)
  (and (org-string-nw-p contents)
       (format "\{\{%s\}\}" contents)))

(defun org-confluence-section (section contents info)
  contents)

(defun org-confluence-src-block (src-block contents info)
  ;; FIXME: provide a user-controlled variable for theme
  (let* ((lang (org-element-property :language src-block))
         (language (if (string= lang "sh") "bash" ;; FIXME: provide a mapping of some sort
                     lang))
         (content (org-export-format-code-default src-block info)))
    (org-confluence--block language "Emacs" content)))

(defun org-confluence-strike-through (strike-through contents info)
  (format "-%s-" contents))

(defun org-confluence-table (table contents info)
  contents)

(defun org-confluence-table-row  (table-row contents info)
  (concat
   (if (org-string-nw-p contents) (format "|%s" contents)
     "")
   (when (org-export-table-row-ends-header-p table-row info)
     "|")))

(defun org-confluence-table-cell  (table-cell contents info)
  (let ((table-row (org-export-get-parent table-cell)))
    (concat
     (when (org-export-table-row-starts-header-p table-row info)
       "|")
     contents "|")))

(defun org-confluence-template (contents info)
  (let ((depth (plist-get info :with-toc)))
    (concat (when depth "\{toc\}\n\n") contents)))

(defun org-confluence-underline (underline contents info)
  (format "+%s+" contents))

(defun org-confluence--block (language theme contents)
  (concat "\{code:theme=" theme
          (when language (format "|language=%s" language))
          "}\n"
          contents
          "\{code\}\n"))

(defun org-confluence--li-depth (item)
  "Return depth of a list item; -1 means not a list item"
  ;; FIXME check whether it's worth it to cache depth
  ;;       (it gets recalculated quite a few times while
  ;;       traversing a list)
  (let ((depth -1)
        (tag))
    (while (and item
                (setq tag (car item))
                (or (eq tag 'item) ; list items interleave with plain-list
                    (eq tag 'plain-list)))
      (when (eq tag 'item)
        (incf depth))
      (setq item (org-export-get-parent item)))
    depth))

;; main interactive entrypoint
(defun org-confluence-export-as-confluence
  (&optional async subtreep visible-only body-only ext-plist)
  "Export current buffer to a text buffer.

If narrowing is active in the current buffer, only export its
narrowed part.

If a region is active, export that region.

A non-nil optional argument ASYNC means the process should happen
asynchronously.  The resulting buffer should be accessible
through the `org-export-stack' interface.

When optional argument SUBTREEP is non-nil, export the sub-tree
at point, extracting information from the headline properties
first.

When optional argument VISIBLE-ONLY is non-nil, don't export
contents of hidden elements.

When optional argument BODY-ONLY is non-nil, strip title, table
of contents and footnote definitions from output.

EXT-PLIST, when provided, is a property list with external
parameters overriding Org default settings, but still inferior to
file-local settings.

Export is done in a buffer named \"*Org CONFLUENCE Export*\", which
will be displayed when `org-export-show-temporary-export-buffer'
is non-nil."
  (interactive)
  (org-export-to-buffer 'confluence "*org CONFLUENCE Export*"
    async subtreep visible-only body-only ext-plist (lambda () (text-mode))))

(provide 'ox-confluence)

(defun goto-longest-line (beg end)
  "Go to the first of the longest lines in the region or buffer.
If the region is active, it is checked.
If not, the buffer (or its restriction) is checked.

Returns a list of three elements:

 (LINE LINE-LENGTH OTHER-LINES LINES-CHECKED)

LINE is the first of the longest lines measured.
LINE-LENGTH is the length of LINE.
OTHER-LINES is a list of other lines checked that are as long as LINE.
LINES-CHECKED is the number of lines measured.

Interactively, a message displays this information.

If there is only one line in the active region, then the region is
deactivated after this command, and the message mentions only LINE and
LINE-LENGTH.

If this command is repeated, it checks for the longest line after the
cursor.  That is *not* necessarily the longest line other than the
current line.  That longest line could be before or after the current
line.

To search only from the current line forward, not throughout the
buffer, you can use `C-SPC' to set the mark, then use this
\(repeatedly)."
  (interactive
   (if (or (not mark-active)  (not (< (region-beginning) (region-end))))
       (list (point-min) (point-max))
     (if (< (point) (mark))
         (list (point) (mark))
       (list (mark) (point)))))
  (when (and (not mark-active) (= beg end)) (error "The buffer is empty"))
  (when (and mark-active (> (point) (mark))) (exchange-point-and-mark))
  (when (< end beg) (setq end (prog1 beg (setq beg end))))
  (when (eq this-command last-command)
    (forward-line 1) (setq beg (point)))
  (goto-char beg)
  (when (eobp) (error "End of buffer"))
  (cond ((<= end (save-excursion (goto-char beg) (forward-line 1) (point)))
         (let ((inhibit-field-text-motion  t))  (beginning-of-line))
         (when (and (> emacs-major-version 21) (require 'hl-line nil t))
           (let ((hl-line-mode  t))  (hl-line-highlight))
           (add-hook 'pre-command-hook #'hl-line-unhighlight nil t))
         (let ((lineno  (line-number-at-pos))
               (chars   (let ((inhibit-field-text-motion t))
                          (save-excursion (end-of-line) (current-column)))))
           (message "Only line %d: %d chars" lineno chars)
           (let ((visible-bell  t))  (ding))
           (setq mark-active  nil)
           (list lineno chars nil 1)))
        (t
         (let* ((start-line                 (line-number-at-pos))
                (max-width                  0)
                (line                       start-line)
                (inhibit-field-text-motion  t)
                long-lines col)
           (when (eobp) (error "End of buffer"))
           (while (and (not (eobp)) (< (point) end))
             (end-of-line)
             (setq col  (current-column))
             (when (>= col max-width)
               (setq long-lines  (if (= col max-width)
                                     (cons line long-lines)
                                   (list line))
                     max-width   col))
             (forward-line 1)
             (setq line  (1+ line)))
           (setq long-lines  (nreverse long-lines))
           (let ((lines  long-lines))
             (while (and lines (> start-line (car lines))) (pop lines))
             (goto-char (point-min))
             (when (car lines) (forward-line (1- (car lines)))))
           (when (and (> emacs-major-version 21) (require 'hl-line nil t))
             (let ((hl-line-mode  t))  (hl-line-highlight))
             (add-hook 'pre-command-hook #'hl-line-unhighlight nil t))
           (when (interactive-p)
             (let ((others  (cdr long-lines)))
               (message "Line %d: %d chars%s (%d lines measured)"
                (car long-lines) max-width
                (concat
                 (and others
                      (format ", Others: {%s}" (mapconcat
                                                (lambda (line) (format "%d" line))
                                                (cdr long-lines) ", "))))
                (- line start-line))))
           (list (car long-lines) max-width (cdr long-lines) (- line start-line))))))

(defun org-set-ascii-text-width ()
  (save-excursion (setq org-ascii-text-width
                        10000)))

(setq org-ascii-text-width
      10000)

(add-hook 'before-save-hook
          (lambda () (if (eq major-mode 'org-mode)
                         (org-set-ascii-text-width))))

