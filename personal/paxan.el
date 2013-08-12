(prelude-ensure-module-deps
 '())


;; http://milkbox.net/note/single-file-master-emacs-configuration/
(defmacro after (mode &rest body)
  "`eval-after-load' MODE evaluate BODY."
  (declare (indent defun))
  `(eval-after-load ,mode
     '(progn ,@body)))


;; I ain't guru, OK?
(setq prelude-guru nil)


;; Un-fuck-up Meta and Super keys on OSX and enable fullscreen
;; toggling via M-Enter.
(when (and (eq system-type 'darwin) window-system)
  (prelude-swap-meta-and-super)
  (global-set-key (kbd "M-RET") 'toggle-frame-fullscreen))


;; GUI goodies
(load-theme 'manoj-dark)
(when window-system
  (set-frame-font "Monaco-15" t))


;; This tells various "git" commands not to pipe their output through
;; "less" or similar.
(setenv "PAGER" "cat")


;; At work I sometimes use a frame that's 166 characters wide.  When I
;; do that, I find that many windows split horizontally -- for
;; example, if I have a single window, displaying a buffer of source
;; code, typing C-x v d will split that window so that the new vc-dir
;; window is to the right.  I hate that.  I want that new window to be
;; below my source, not next to it.
;;
;; So this makes that not happen.
(setq split-width-threshold 500)


;; Turn on the auto-revert mode, globally.
(global-auto-revert-mode t)
