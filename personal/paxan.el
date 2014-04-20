(prelude-ensure-module-deps
 '(cider
   rainbow-delimiters))


;; http://milkbox.net/note/single-file-master-emacs-configuration/
(defmacro after (mode &rest body)
  "`eval-after-load' MODE evaluate BODY."
  (declare (indent defun))
  `(eval-after-load ,mode
     '(progn ,@body)))


;; I ain't guru, OK?
(setq prelude-guru nil)


;; Enable fullscreen toggling via M-Enter.
(when (and (eq system-type 'darwin) window-system)
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

;; Clojure preferences
(add-hook 'clojure-mode-hook
          (lambda ()
            (setq whitespace-style (delq 'lines-tail whitespace-style))))

;; Go preferences
(add-hook 'go-mode-hook
          (lambda ()
            (setq whitespace-style '(face empty trailing))
            (setq tab-width 4)))
(add-hook 'go-mode-hook 'projectile-on)
(add-hook 'projectile-switch-project-hook
          (lambda ()
            (message "GOPATH set to the project dir: %s"
                     (setenv "GOPATH"
                             (expand-file-name
                              (directory-file-name (projectile-project-root)))))))

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

  (after 'cider
    (add-hook 'cider-mode-hook 'rainbow-delimiters-mode-enable)))


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
