(setq user-full-name "Tomasz Mieloch")
(setq user-mail-address "tomasz@mieloch.net")

(setenv "PATH" (concat "/usr/local/bin:/opt/local/bin:/usr/bin:/bin" (getenv "PATH")))
(require 'cl)

(add-to-list 'load-path "~/.emacs.d/elisp")

;;; packages

(load "package")
(package-initialize)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)

(setq package-archive-enable-alist '(("melpa" deft magit)))


(defvar tm/packages '(auctex
                      auto-complete
                      coffee-mode
                      color-theme-solarized
                      emmet-mode
                      expand-region
                      flycheck
                      gist
                      git-gutter
                      google-contacts
                      haml-mode
                      htmlize
                      js2-mode
                      magit
                      markdown-mode
                      neotree
                      org
                      projectile
                      projectile-rails
                      reftex
                      restclient
                      rvm
                      slim-mode
                      smartparens
                      smex
                      undo-tree
                      yaml-mode
                      yasnippet)
  "Default packages")


(defun tm/packages-installed-p ()
  (loop for pkg in tm/packages
        when (not (package-installed-p pkg)) do (return nil)
        finally (return t)))

(unless (tm/packages-installed-p)
  (message "%s" "Refreshing package database...")
  (package-refresh-contents)
  (dolist (pkg tm/packages)
    (when (not (package-installed-p pkg))
      (package-install pkg))))



;;; editor setup

(if window-system
    (x-focus-frame nil))

(setq mac-command-modifier 'meta
      mac-option-modifier 'none
      default-input-method "MacOSX")

(load-theme 'solarized t)

(tool-bar-mode -1)

(menu-bar-mode t)

(scroll-bar-mode -1)

(global-linum-mode -1)

(column-number-mode t)

(setq inhibit-splash-screen t
      initial-scratch-message nil
      initial-major-mode 'org-mode)

(setq default-frame-alist '((left . 500) (width . 120) (height . 70)))


(setq make-backup-files nil)

(setq auto-save-default nil)

(setq undo-limit 3600)

(setq-default indent-tabs-mode nil)

(setq tab-width 2)

(set-default-font "Inconsolata-14")

(setq-default cursor-type 'hbar)


(global-visual-line-mode 1); Proper line wrapping

(setq ring-bell-function 'ignore)

(delete-selection-mode t)
(transient-mark-mode t)
(setq x-select-enable-clipboard t)


;; scroll one line at a time (less "jumpy" than defaults)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
;(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time

(setq echo-keystrokes 0.1
      use-dialog-box nil
      visible-bell t)

(show-paren-mode t); Matches parentheses and such in every mode

(defalias 'yes-or-no-p 'y-or-n-p)

(setq uniquify-buffer-name-style 'forward)

(setq require-final-newline t)


;; Global keybindings
(global-set-key (kbd "C-;") 'comment-or-uncomment-region)
(global-set-key (kbd "M-/") 'hippie-expand)
(define-key global-map (kbd "RET") 'newline-and-indent)
(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "M-z") 'zap-up-to-char)

(global-set-key (kbd "C-s") 'isearch-forward-regexp)
(global-set-key (kbd "C-r") 'isearch-backward-regexp)
(global-set-key (kbd "C-M-s") 'isearch-forward)
(global-set-key (kbd "C-M-r") 'isearch-backward)


;;; ido
(ido-mode t)
(ido-everywhere t)
(setq ido-enable-flex-matching t
      ido-use-filename-at-point nil
      ido-auto-merge-work-directories-length 0
      ; ido-auto-merge-delay-time 9
      ido-use-virtual-buffers t)

(setq ido-default-buffer-method 'selected-window)

;; Display ido results vertically, rather than horizontally
(setq ido-decorations (quote ("\n-> " "" "\n   " "\n   ..." "[" "]" " [No match]" " [Matched]" " [Not readable]" " [Too big]" " [Confirm]")))
(defun ido-disable-line-truncation () (set (make-local-variable 'truncate-lines) nil))
(add-hook 'ido-minibuffer-setup-hook 'ido-disable-line-truncation)
(defun ido-define-keys () ;; C-n/p is more intuitive in vertical layout
  (define-key ido-completion-map (kbd "C-n") 'ido-next-match)
  (define-key ido-completion-map (kbd "C-p") 'ido-prev-match))
(add-hook 'ido-setup-hook 'ido-define-keys)


;;; css
(setq css-indent-offset 2)
(add-hook 'css-mode-hook '(lambda ()
                            (local-set-key (kbd "RET") 'newline-and-indent)))

;;; calendar setup
(setq calendar-week-start-day 0
      calendar-day-name-array ["niedziela" "poniedziałek" "wtorek" "środa"
                               "czwartek" "piątek" "sobota"]
      calendar-month-name-array ["styczeń" "luty" "marzec" "kwiecień" "maj"
                                 "czerwiec" "lipiec" "sierpień" "wrzesień"
                                 "październik" "listopad" "grudzień"])

;;; ruby-mode
(add-hook 'ruby-mode-hook
          '(lambda ()
             (define-key ruby-mode-map (kbd "RET") 'reindent-then-newline-and-indent)
             (electric-indent-mode)))

;; Rake files are ruby, too, as are gemspecs, rackup files, etc.
(add-to-list 'auto-mode-alist '("\\.rake$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.gemspec$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.ru$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Rakefile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Capfile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Vagrantfile$" . ruby-mode))

;;;Textmate like Command-RET
(defun tm-mate-command-return ()
  "TextMate like Command-RET"
  (interactive)
  (move-end-of-line nil)
  (newline-and-indent))

(global-set-key (kbd "M-RET") 'tm-mate-command-return)


;;; aspell
(setq ispell-program-name "aspell"
      ispell-dictionary "polish")

;;; magit
(global-set-key (kbd "C-x g") 'magit-status)


                                        ; org
(setq org-log-done t
      org-todo-keywords '((sequence "TODO" "INPROGRESS" "DONE"))
      org-todo-keyword-faces '(("INPROGRESS" . (:foreground "blue" :weight bold))))
(add-hook 'org-mode-hook
          (lambda ()
            (flyspell-mode)))

(global-set-key (kbd "C-c a") 'org-agenda)
(setq org-agenda-show-log t
      org-agenda-todo-ignore-scheduled t
      org-agenda-todo-ignore-deadlines t
      org-agenda-start-on-weekday 0)
(setq org-agenda-files (list "~/Dropbox/org/personal.org"
                             "~/Dropbox/org/groupon.org"))



;;; smex
(setq smex-save-file (expand-file-name ".smex-items" user-emacs-directory))
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)

;;; auto-complete
(ac-config-default)


;;; indentation and buffer clenaup

(defun untabify-buffer ()
  (interactive)
  (untabify (point-min) (point-max)))

(defun indent-buffer ()
  (interactive)
  (indent-region (point-min) (point-max)))

(defun cleanup-buffer ()
  "Perform a bunch of operations on the whitespace content of a buffer."
  (interactive)
  (indent-buffer)
  (untabify-buffer)
  (delete-trailing-whitespace))

(defun cleanup-region (beg end)
  "Remove tmux artifacts from region."
  (interactive "r")
  (dolist (re '("\\\\│\·*\n" "\W*│\·*"))
    (replace-regexp re "" nil beg end)))

(global-set-key (kbd "C-x M-t") 'cleanup-region)
(global-set-key (kbd "C-c n") 'cleanup-buffer)



;;; rvm
(rvm-use-default)

;;; yaml
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.yaml$" . yaml-mode))


;;; js2-mode
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

(setq js2-mode-hook
      '(lambda () (progn
                    (set-variable 'js2-basic-offset 2))))


;;; neotree
(global-set-key [f8] 'neotree-toggle)

;;; projectile
(projectile-global-mode)

;; projectile-rails
(add-hook 'projectile-mode-hook 'projectile-rails-on)


;;; markdown
(defun markdown-preview-file ()
  "use Marked 2 to preview the current file"
  (interactive)
  (shell-command
   (format "open -a 'Marked 2.app' %s"
           (shell-quote-argument (buffer-file-name))))
  )
(global-set-key "\C-cm" 'markdown-preview-file)

;;; macros
(global-set-key [f10]  'start-kbd-macro)
(global-set-key [f11]  'end-kbd-macro)
(global-set-key [f12]  'call-last-kbd-macro)

;;; git-gutter
(global-git-gutter-mode +1)

                                        ; custom set variables
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(coffee-tab-width 2))


;;; sierotki.el
(require 'sierotki)
(turn-on-tex-magic-space-in-tex-modes)


;;; tildify
(setq tildify-pattern-alist
      '((t "\\([,:;(][ \t]*[a]\\|\\<[AOIUWZaoiuwz]\\)\\([ \t]+\\|[ \t]*\n[ \t]*\\)\\(\\w\\|[([{\\]\\|<[a-zA-Z]\\)" 2)))

;;; AUCTeX
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(eval-after-load "tex"
  '(add-to-list 'TeX-command-list
                '("LuaLaTeX" "lualatex %s"
                  TeX-run-command nil nil) t))


;;; Skim.app
(setq LaTeX-command "latex -synctex=1")

(setq TeX-view-program-selection '((output-pdf "PDF Viewer")))
(setq TeX-view-program-list
      '(("PDF Viewer" "/Applications/Skim.app/Contents/SharedSupport/displayline -g -b %n %o %b")))



;;; yasnippet
(setq yas/indent-line 'fixed)


;;; expand-region
(global-set-key (kbd "C-=") 'er/expand-region)


;;; undo-tree
;(global-undo-tree-mode 1)
(defalias 'redo 'undo-tree-redo)
(global-set-key (kbd "M-z") 'undo) ; 【Ctrl+z】
(global-set-key (kbd "C-M-z") 'redo) ; 【Ctrl+Shift+z】;

                                        ; smartparens
(smartparens-global-mode t)
