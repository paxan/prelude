(prelude-ensure-module-deps
 '(nrepl
   rainbow-delimiters))


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


;; Highlights trailing whitespace in modes of my choice!
(mapc (lambda (hooksym)
        (add-hook hooksym
                  (lambda ()
                    (setq show-trailing-whitespace t))))
      '(clojure-mode-hook
        lisp-mode-hook
        java-mode-hook
        js-mode-hook
        python-mode-hook
        ruby-mode-hook))

;; Go preferences
(add-hook 'go-mode-hook
          (lambda ()
            (setq white-space-style '(face empty trailing))))

;; Rainbow!
(after "rainbow-delimiters-autoloads"
  (setq-default frame-background-mode 'dark)
  (let ((hooks '(emacs-lisp-mode-hook
                 clojure-mode-hook
                 js-mode
                 lisp-mode-hook
                 python-mode-hook
                 ruby-mode-hook)))
    (dolist (hook hooks)
      (add-hook hook 'rainbow-delimiters-mode-enable)))

  (after 'nrepl
    (add-hook 'nrepl-mode-hook 'rainbow-delimiters-mode-enable)))


;; flycheck
(after 'flycheck
  (set-face-attribute 'flycheck-error nil :underline "red")
  (set-face-attribute 'flycheck-warning nil :underline "yellow"))


;; GUI goodies
(load-theme 'manoj-dark)
(when window-system
  (set-frame-font "Monaco-15" t)
  (scroll-bar-mode -1))


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


;; Javascript
(after 'js
  (setq js-indent-level 2)
  (define-key js-mode-map (kbd ",") 'self-insert-command)
  (define-key js-mode-map (kbd "RET") 'reindent-then-newline-and-indent)
  (font-lock-add-keywords 'js-mode `(("\\(function *\\)("
                                      (0 (progn (compose-region (match-beginning 1)
                                                                (match-end 1)
                                                                "ƒ")
                                                nil))))))
