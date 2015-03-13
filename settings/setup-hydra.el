(defhydra hydra-window (:color red
                        :hint nil)
  "
 Split: _v_ert _x_:horz _|_:->vert ___:->horz
Delete: _o_nly  _rc_ ace  _rw_indow  _rb_uffer  _rf_rame
  Move: _s_wap
Frames: _f_rame new  _rf_ delete
  Misc: _m_ark a_c_e
Buffer: _b_uffers"
  ("a" windmove-left)
  ("s" windmove-down)
  ("w" windmove-up)
  ("d" windmove-right)
  ("A" hydra-move-splitter-left)
  ("S" hydra-move-splitter-down)
  ("W" hydra-move-splitter-up)
  ("D" hydra-move-splitter-right)
  ("|" (lambda ()
         (interactive)
         (split-window-right)
         (windmove-right)))
  ("_" (lambda ()
         (interactive)
         (split-window-below)
         (windmove-down)))
  ("v" split-window-right)
  ("x" split-window-below)
  ("o" delete-other-windows :exit t)
  ("c" ace-window :exit t)
  ("f" new-frame :exit t)
  ("s" ace-swap-window)
  ("rc" ace-delete-window)
  ("rw" delete-window)
  ("rb" kill-this-buffer)
  ("rf" delete-frame :exit t)
  ("q" nil)
  ("b" helm-buffers-list)
  ("m" headlong-bookmark-jump))

(key-chord-define-global "ww" 'hydra-window/body)

(require 'windmove)
(require 'framemove)
(setq framemove-hook-into-windmove t)

(defun hydra-move-splitter-left (arg)
  "Move window splitter left."
  (interactive "p")
  (if (let ((windmove-wrap-around))
        (windmove-find-other-window 'right))
      (shrink-window-horizontally arg)
    (enlarge-window-horizontally arg)))

(defun hydra-move-splitter-right (arg)
  "Move window splitter right."
  (interactive "p")
  (if (let ((windmove-wrap-around))
        (windmove-find-other-window 'right))
      (enlarge-window-horizontally arg)
    (shrink-window-horizontally arg)))

(defun hydra-move-splitter-up (arg)
  "Move window splitter up."
  (interactive "p")
  (if (let ((windmove-wrap-around))
        (windmove-find-other-window 'up))
      (enlarge-window arg)
    (shrink-window arg)))

(defun hydra-move-splitter-down (arg)
  "Move window splitter down."
  (interactive "p")
  (if (let ((windmove-wrap-around))
        (windmove-find-other-window 'up))
      (shrink-window arg)
    (enlarge-window arg)))

(provide 'setup-hydra)
