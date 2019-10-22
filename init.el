
;; Add modes and deactivate modes

(add-to-list 'default-frame-alist '(fullscreen . maximized))
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-language-environment 'utf-8)
(set-selection-coding-system 'utf-8)

(menu-bar-mode -1)
(scroll-bar-mode -1)

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.

(package-initialize)
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cua-mode t nil (cua-base))
 '(cua-prefix-override-inhibit-delay 0.5)
 '(mode-line-format
   (quote
    ("%e" mode-line-front-space mode-line-mule-info mode-line-client mode-line-modified mode-line-remote mode-line-frame-identification mode-line-buffer-identification "   " mode-line-position mode-line-misc-info
     (vc-mode vc-mode)
     "  " mode-line-modes mode-line-end-spaces)))
 '(org-export-backends (quote (ascii html icalendar latex md odt)))
 '(package-selected-packages
   (quote
    (ht editorconfig fzf rg expand-region use-package magit comment-dwim-2 elpy ag jedi monokai-theme web-mode python-mode)))
 '(python-shell-interpreter "python3")
 '(send-mail-function (quote smtpmail-send-it)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(unless (package-installed-p 'monokai-theme)
  (package-refresh-contents)
  (package-install 'monokai-theme))

(require 'use-package)
(require 'monokai-theme)
(setq use-package-always-ensure t)

;; python and jedi bindings
;; (add-hook 'python-mode-hook 'jedi:setup t)
;; (setq jedi:complete-on-dot t)
;; (add-hook 'python-mode-hook 'jedi:ac-setup t)

;; buffer related shortcurts
(global-set-key (kbd "M-p") 'previous-buffer)
(global-set-key (kbd "M-n") 'next-buffer)
(global-set-key (kbd "C-x =") 'er/expand-region)
(global-set-key (kbd "M-;") 'comment-dwim-2)
(global-set-key (kbd "M-k") 'kill-this-buffer)
(global-set-key (kbd "C-c g") 'magit-status)

(setq org-src-fontify-natively t)

(windmove-default-keybindings)
(desktop-save-mode 1)
(global-linum-mode 1)
(show-paren-mode 1)

(use-package monokai-theme
  :ensure t)

(load-theme 'monokai t)

(setq ag-reuse-buffers 't)

;; hg annotate
(setq vc-hg-annotate-switches "-dqun")

(use-package editorconfig
  :ensure t
  :config
  (editorconfig-mode 1))

(use-package python-mode
  :ensure t)

(setq python-indent-offset 4)
(add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.pyx\\'" . python-mode))
(add-hook 'before-save-hook 'delete-trailing-whitespace)

(use-package ag
  :ensure t)

(use-package rg
  :ensure t)

(use-package magit
  :ensure t)

(use-package jedi
  :ensure t)

(use-package elpy
  :ensure t)

(defun next-code-buffer ()
  (interactive)
  (let (( bread-crumb (buffer-name) ))
    (next-buffer)
    (while
        (and
         (string-match-p "^\*" (buffer-name))
         (not ( equal bread-crumb (buffer-name) )) )
      (next-buffer))))
(global-set-key [remap next-buffer] 'next-code-buffer)

(defun previous-code-buffer ()
  (interactive)
  (let (( bread-crumb (buffer-name) ))
    (previous-buffer)
    (while
        (and
         (string-match-p "^\*" (buffer-name))
         (not ( equal bread-crumb (buffer-name) )) )
      (previous-buffer))))
(global-set-key [remap previous-buffer] 'previous-code-buffer)

(org-babel-do-load-languages
 'org-babel-load-languages '((calc . t) (python . t) (C . t) (clojure . t)))

(defalias 'yes-or-no-p 'y-or-n-p)

;; eww customisations
(setq shr-color-visible-luminance-min 70)

;; set isearch as dired search
(setq dired-isearch-filenames t)

(setq-default fill-column 120)

;; (setq my/terminal-buffer "*terminal*")

(which-function-mode)

(tool-bar-mode -1)

;; (term "/bin/zsh")

(use-package ht)

(when (eq system-type 'darwin)
  (eval-after-load 'paredit
    '(progn
       ;; C-left
       (define-key paredit-mode-map (kbd "M-[ 5 d")
                   'paredit-forward-barf-sexp)
       ;; C-right
       (define-key paredit-mode-map (kbd "M-[ 5 c")
                   'paredit-forward-slurp-sexp)
       ;; ESC-C-left
       (define-key paredit-mode-map (kbd "ESC M-[ 5 d")
                   'paredit-backward-slurp-sexp)
       ;; ESC-C-right
       (define-key paredit-mode-map (kbd "ESC M-[ 5 c")
	 'paredit-backward-barf-sexp))))

(add-to-list 'exec-path "/usr/local/bin")

(define-abbrev-table 'python-mode-abbrev-table
  '(("ipdb" "import ipdb; ipdb.set_trace()")
    ("pdb" "import pdb; pdb.set_trace()")
    ("bt" "breakpoint()")))

(set-default 'abbrev-mode t)

(setq save-abbrevs nil)

(rg-define-search rg-foo
  "Search for thing at point in files matching the current file"
  :query ask
  :files all
  :dir ask)

(defun python-bugs-url ()
  (interactive)
  (let ((commit-message (magit-rev-format "%B"
	 				  (magit-rev-parse
	 				   (magit-branch-or-commit-at-point))))
	(bugs-base-url "https://bugs.python.org/issue")
	(pr-base-url "https://github.com/python/cpython/pull/")
	(bugs-pr-regex "bpo-\\([0-9]+\\).*\\(GH-\\|#\\)\\([0-9]+\\)"))
    (when (string-match bugs-pr-regex commit-message)
      (let ((bug-url (concat bugs-base-url (match-string 1 commit-message)))
	    (pr-url (concat pr-base-url (match-string 3 commit-message))))
	(browse-url bug-url)
	(browse-url pr-url)))))

(magit-define-popup-action 'magit-log-popup
  ?z
  "Open bug in browser"
  'python-bugs-url)
