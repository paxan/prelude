;; There's something similar (but fancier) in vc-git.el: vc-git-grep
;; -I means don't search through binary files
;;
;; --no-color is needed, oddly enough, to convince Emacs to properly
;; colorize the git grep output.
(defcustom git-grep-switches "--extended-regexp -I -n --no-color"
  "Switches to pass to `git grep'."
  :type 'string)

(defcustom git-grep-default-work-tree (expand-file-name "~/src")
  "Top of your favorite git working tree.  \\[git-grep] will search from here if it cannot figure out where else to look."
  :type 'directory
  )

(when (require 'vc-git nil t)           ;for vc-git-root

  ;; Uncomment this to try out the built-in-to-Emacs function.
  ;;(defalias 'git-grep 'vc-git-grep)

  (defun git-grep-get-shell-command (case-sensitive)
    (let ((root (vc-git-root default-directory)))
      (when (not root)
        (message "git-grep: %s doesn't look like a git working tree; searching from %s instead" default-directory git-grep-default-work-tree)
        (setq root git-grep-default-work-tree))
      (list (read-shell-command "Run git-grep (like this): "
                                (format (concat
                                         "cd %s && "
                                         "git grep %s%s -e %s")
                                        root
                                        git-grep-switches
                                        (if case-sensitive "" " --ignore-case")
                                        (let ((thing (thing-at-point 'symbol)))
                                          (or (and thing (progn
                                                           (set-text-properties 0 (length thing) nil thing)
                                                           (shell-quote-argument thing)))
                                              "")))
                                'git-grep-history))))

  (defun git-grep (command-args)
    (interactive (git-grep-get-shell-command nil))
    (let ((grep-use-null-device nil))
      (grep command-args)))

  (defun git-grep-cs (command-args)
    (interactive (git-grep-get-shell-command t))
    (let ((grep-use-null-device nil))
      (grep command-args))))
