;;; KYMACS
;;; My own vanilla-emacs distro. @Willinki

;;; Commentary:
;;; based on the extremely helpful videos by https://systemcrafters.cc and other
;;; resources found around the web.  This Emacs distribution is aimed at students
;;; whose workflow includes programming and taking notes.  Also it is made for MacOS

;;; Features:
;;; * Most programming related packages: magit, projectile, conda, lsp-mode, etc...
;;; * Enhanced vanilla Emacs experience (swiper, counsel, helpful, etc..) based on the
;;; tutorials made by system crafters (Emacs from scratch).
;;; * Language support: bash, lisp, python, c++, R, Julia, Latex
;;; * Fully fledged org environment: agenda, capture, roam

;;; Code:
;; First, the threshold for garbage collection is increased
(setq gc-cons-threshold (* 50 1000 1000))
;; here we keep out custom variables
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)
;; Emacs is put on fullscreen by default
(add-to-list 'default-frame-alist '(fullscreen . fullscreen))

;; Reset super, hyper and meta
(setq mac-command-modifier 'meta) ; make cmd key do Meta
(setq mac-option-modifier 'super) ; make opt key do Super
(setq mac-control-modifier 'control) ; make Control key do Control
(setq ns-function-modifier 'hyper)  ; make Fn key do Hyper

;; Reset PATH
(setenv "PATH" (concat (getenv "PATH") ":/usr/local/texlive/2021/bin/universal-darwin/:/opt/homebrew/bin/"))
(setq exec-path (append exec-path '(":/usr/local/texlive/2021/bin/universal-darwin/:/opt/homebrew/bin/")))

;; Theme package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))
; initialize use-package on non linux
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)
;;(setq use-package-verbose t)

;; Basic configuration option, startup page
(setq inhibit-startup-message t)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10)
(add-hook 'prog-mode-hook #'display-fill-column-indicator-mode)
(setq-default display-fill-column-indicator-column 88)
;(menu-bar-mode -1)  ;disables menu bar, does not allow to go full screen

;; Turn on line numbers
(column-number-mode)
(global-display-line-numbers-mode t)
(dolist (mode '(org-mode-hook
		term-mode-hook
		eshell-mode-hook))
  (add-hook mode (lambda() (display-line-numbers-mode 0))))

;; Increasing line height
(defun set-bigger-spacing ()
  (setq-local default-text-properties '(line-spacing 0.10 line-height 1.10)))
(add-hook 'text-mode-hook 'set-bigger-spacing)
(add-hook 'prog-mode-hook 'set-bigger-spacing)
(add-hook 'org-mode-hook 'set-bigger-spacing)

; Font
(set-face-attribute 'default nil :font "JetBrains Mono" :height 130)
;; Set the fixed pitch face
(set-face-attribute 'fixed-pitch nil :font "JetBrains Mono" :height 130)
;; Set the variable pitch face
(set-face-attribute 'variable-pitch nil :font "ETBembo" :height 160 :weight 'regular)
;; to define mode specific key-bindings
(define-key emacs-lisp-mode-map (kbd "C-x M-t") 'counsel-load-Initialize)

;; Set backup files in another directory
(setq backup-directory-alist `(("." . "~/.emacs.d/saves/")))
(setq backup-by-copying t)
(setq delete-old-versions t
  kept-new-versions 6
  kept-old-versions 2
  version-control t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                     ADDITIONAL PACKAGES                                   ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; First appearance, ergonomics
;;
(use-package swiper
  :after ivy)

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-C)
         ("done-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

(use-package all-the-icons
  :if (display-graphic-p))

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)))
(setq doom-modeline-icon t)
(setq doom-modeline-buffer-file-name-style 'relative-from-project)

(use-package rainbow-delimiters)
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.5))

(use-package counsel
  :bind (("M-x" . counsel-M-x)
	 ("C-x b" . counsel-ibuffer)
	 ("C-x C-f" . counsel-find-file)
	 ("C-c t" .  counsel-org-tag)
	 :map minibuffer-local-map
	 ("C-r" . 'counsel-minibuffer-history))
  :config
  (setq ivy-initial-inputs-alist nil))

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(use-package helpful
  ;:commands (helpful-callable helpful-variable helpful-command helpful-key)
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

;;
;; Themes and colors
;;
(use-package doom-themes
  :init (load-theme 'doom-city-lights t)
  :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Enable custom neotree theme (all-the-icons must be installed!)
  (doom-themes-neotree-config)
  ;; or for treemacs users
  (setq doom-themes-treemacs-theme "doom-city-lights") ; use "doom-colors" for less minimal icon theme
  (doom-themes-treemacs-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

;;
;; Evil mode and related
;;
(use-package general
  :config
  (general-evil-setup t))

(general-define-key
 "C-M-j" 'counsel-switch-buffer)

(use-package evil
  :init
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package evil-nerd-commenter
  :bind ("M-/" . evilnc-comment-or-uncomment-lines))

;;
;; Git, projectile, Github
;;
(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  ;; NOTE: Set this to the folder where you keep your Git repos!
  (when (file-directory-p "~/GIT")
    (setq projectile-project-search-path '("~/GIT")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :config (counsel-projectile-mode)
  :after projectile)

(use-package magit
  :commands (magit-status magit-get-current-branch)
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(use-package forge
  :after magit)

;;
;; Eshell
;;
(defun efs/configure-eshell ()
  ;; Save command history when commands are entered
  (add-hook 'eshell-pre-command-hook 'eshell-save-some-history)

  ;; Truncate buffer for performance
  (add-to-list 'eshell-output-filter-functions 'eshell-truncate-buffer)

  ;; Bind some useful keys for evil-mode
  (evil-define-key '(normal insert visual) eshell-mode-map (kbd "C-r") 'counsel-esh-history)
  (evil-define-key '(normal insert visual) eshell-mode-map (kbd "<home>") 'eshell-bol)
  (evil-normalize-keymaps)

  (setq eshell-history-size         10000
        eshell-buffer-maximum-lines 10000
        eshell-hist-ignoredups t
        eshell-scroll-to-bottom-on-input t))

(use-package eshell
  :hook (eshell-first-time-mode . efs/configure-eshell))

(use-package eshell-git-prompt
  :after eshell
  :config
  (eshell-git-prompt-use-theme 'powerline))

(with-eval-after-load 'esh-opt
  (setq eshell-destroy-buffer-when-process-dies t)
  (setq eshell-visual-commands '("htop" "zsh" "vim")))

(use-package exec-path-from-shell
  :after eshell
  :config
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))

;;
;; Dired
;;
(use-package dired
  :ensure nil
  :commands (dired dired-jump)
  :config
  (setq dired-dwim-target t)
  (when (string= system-type "darwin")
    (setq insert-directory-program "/opt/homebrew/bin/gls"))
  (evil-collection-define-key 'normal 'dired-mode-map
      "h" 'dired-single-up-directory
      "l" 'dired-single-buffer)
  :custom ((dired-listing-switches "-agho --group-directories-first")))

(use-package dired-single
  :after dired)

(use-package all-the-icons-dired
  :hook (dired-mode . all-the-icons-dired-mode))

(use-package dired-open
  :after dired
  :config
  (setq dired-open-extensions '(("png" . "feh")
                                ("mkv" . "mpv"))))

(use-package dired-hide-dotfiles
  :hook (dired-mode . dired-hide-dotfiles-mode)
  :config
  (evil-collection-define-key 'normal 'dired-mode-map
    "H" 'dired-hide-dotfiles-mode))
(setq delete-by-moving-to-trash t)

;;
;; Pdf tools
;;
(use-package pdf-tools
  :ensure t
  :defer 1
  :config
  (pdf-tools-install))

;;
;; Dashboard
;;
(use-package page-break-lines
  :ensure t)
(use-package dashboard
  :ensure t
  :after page-break-lines
  :init
  (setq initial-buffer-choice (lambda () (get-buffer "*dashboard*")))
  (setq dashboard-agenda-release-buffers t)
  (setq dashboard-banner-logo-title "Welcome to Kymacs")
  (setq dashboard-items '((recents  . 5)
                        (bookmarks . 5)
                        (projects . 5)
                        (agenda . 5)))
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  (setq dashboard-set-navigator t)
  (setq dashboard-week-agenda t)
  (setq dashboard-center-content t)
  (setq dashboard-startup-banner 'logo)
  :config
  (dashboard-setup-startup-hook))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                            org mode                                       ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun dw/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (auto-fill-mode 0)
  (visual-line-mode 1)
  (setq evil-auto-indent nil))

(use-package org
  :hook (org-mode . dw/org-mode-setup)
  :config
  (setq org-startup-with-inline-images t)
  (setq org-image-actual-width (/ (display-pixel-width) 2))
  (setq org-ellipsis " ▾")
  (setq org-agenda-start-with-log-mode t)
  (setq org-log-done 'time)
  (setq org-log-intro-drawer t)
  (setq org-agenda-files
	'("~/AGENDA.org"))
  (setq org-src-fontify-natively t)
  (setq org-fontify-done-headlines t)
  (setq org-src-preserve-indentation t)
  (setq org-todo-keywords
	'((sequence "TODO(t)" "PRIORITY(p!)" "WAIT(w@/!)" "|" "DONE(d)" "CANCELED(c@)")
	  (sequence "INTERESTING(i)" "EXPLORING(e)" "|" "SEEN(s)" "ABANDONED(a@)")))
  (setq org-todo-keyword-faces
	'(("TODO" . org-todo)
	  ("PRIORITY" . "red")
	  ("WAIT" . org-todo)
	  ("DONE" . org-done)
	  ("CANCELED" . org-done)
	  ("INTERESTING" . (:foreground "green" :weight bold))
	  ("EXPLORING" . (:foreground "green" :weight bold))
	  ("SEEN" . org-done)
	  ("ABANDONED" . org-done)))
  (with-eval-after-load 'org-faces
    (dolist
      (face '((org-level-1 . 1.3)
              (org-level-2 . 1.2)
              (org-level-3 . 1.1)
              (org-level-4 . 1.1)
              (org-level-5 . 1.1)
              (org-level-6 . 1.1)
              (org-level-7 . 1.1)
              (org-level-8 . 1.1)))
      (set-face-attribute (car face) nil :font "ETBembo" :weight 'semi-bold :height (cdr face))
      (set-face-attribute 'org-block nil    :foreground nil :inherit 'fixed-pitch)
      (set-face-attribute 'org-table nil    :inherit 'fixed-pitch)
      (set-face-attribute 'org-formula nil  :inherit 'fixed-pitch)
      (set-face-attribute 'org-code nil     :inherit '(shadow fixed-pitch))
      (set-face-attribute 'org-table nil    :inherit '(shadow fixed-pitch))
      (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
      (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
      (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
      (set-face-attribute 'org-checkbox nil  :inherit 'fixed-pitch)
      (set-face-attribute 'line-number nil :inherit 'fixed-pitch)
      (set-face-attribute 'line-number-current-line nil :inherit 'fixed-pitch)))
  ;; Save Org buffers after refiling!
  (advice-add 'org-refile :after 'org-save-all-org-buffers)
  (setq org-tag-alist
    '(("@home" . ?H)
       ("@work" . ?W)
       ("@lesson" . ?L)
       ("@seminar" . ?S)
       ("@presentation" . ?P)
       ("@conference" . ?C)
       ("idea" . ?i)
       ("reading" . ?e)
       ("eventually" . ?t)
       ("library" . ?l)))
  
  (setq org-agenda-custom-commands
	'(("d" "Dashboard"
	   ((agenda "" ((org-deadline-warning-days 40)))
	    (todo "PRIORITY"
		  ((org-agenda-overriding-header "Current priorities")))
	    (todo "EXPLORING"
		  ((org-agenda-overriding-header "Keep reading")))
	    (todo "INTERESTING"
		  ((org-agenda-overriding-header "Other Readings for you")))))))
	  
  (setq org-capture-templates
	`(("f" "File related todo" entry (file+olp "~/AGENDA.org" "Inbox")
	   "* TODO %?\n  %U\n  %a\n  %i" :kill-buffer t)
	  ("F" "File related priority" entry (file+olp "~/AGENDA.org" "Inbox")
	   "* PRIORITY %?\n  %U\n  %a\n  %i" :kill-buffer t)
	  ("t" "General task" entry (file+olp "~/AGENDA.org" "Inbox")
	   "* TODO %?\n %i" :kill-buffer t)
	  ("p" "General priority" entry (file+olp "~/AGENDA.org" "Inbox")
	   "* PRIORITY %?\n %i" :kill-buffer t)
	  ("r" "Reading" entry (file+olp "~/AGENDA.org" "Inbox")
	   "* INTERESTING %?\n  %U\n  %a\n  %i" :kill-buffer t)))

  (setq org-archive-location  "~/.emacs.d/archive.org::* Archived tasks" ))

(font-lock-add-keywords 'org-mode
			'(("^ *\\([-]\\) "
			    (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

(defun efs/org-mode-visual-fill ()
  (setq visual-fill-column-width 115
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . efs/org-mode-visual-fill))
  (setq org-refile-targets
    '(("~/AGENDA.org" :maxlevel . 1)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                     language support and packages                         ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Org babel
;;
(org-babel-do-load-languages
  'org-babel-load-languages
  '((emacs-lisp . t)
    (ipython . t)
    (python . t)
    (shell . t)))

(setq org-confirm-babel-evaluate nil)
;;; display/update images in the buffer after I evaluate
(add-hook 'org-babel-after-execute-hook 'org-display-inline-images 'append)

;; This is needed as of Org 9.2
(require 'org-tempo)
(add-to-list 'org-structure-template-alist '("sh" . "src shell"))
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
(add-to-list 'org-structure-template-alist '("py" . "src python"))
(add-to-list 'org-structure-template-alist '("ipy" . "src ipython :results output"))
(add-to-list 'org-structure-template-alist '("ipyd" . "src ipython :results raw drawer"))

;;
;; Lsp mode, general settings
;;
(defun efs/lsp-mode-setup ()
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (lsp-headerline-breadcrumb-mode))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook (lsp-mode . efs/lsp-mode-setup)
  :init
  (setq lsp-keymap-prefix "C-c l")  ;; Or 'C-l', 's-l'
  :config
  (lsp-enable-which-key-integration t))


(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'bottom)
  (setq lsp-ui-doc-show-with-cursor t))

(use-package lsp-treemacs
  :after lsp)

(use-package lsp-ivy
  :after lsp)

;;
;; Company mode
;;
(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind (:map company-active-map
         ("<tab>" . company-complete-selection))
        (:map lsp-mode-map
         ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

(use-package company-box
  :hook (company-mode . company-box-mode))

;;
;; Flycheck, dap mode
;;
(use-package flycheck
  :ensure t
  :defer 0
  :config (global-flycheck-mode))

(use-package dap-mode
  :commands dap-debug)

;;
;; Conda support
;;
(use-package conda
  :bind (("M-§" . conda-env-activate))
  :config
  (setq conda-env-home-directory "/opt/homebrew/Caskroom/miniforge/base/")
  (conda-env-initialize-interactive-shells)
  (conda-env-initialize-eshell))

;;
;; General latex stuff
;;
(use-package lsp-latex
  :mode "\\.tex\\'"
  :config
  (setq lsp-latex-texlab-executable "/opt/homebrew/bin/texlab"))

;; For bibtex
(with-eval-after-load "tex-mode"
 (add-hook 'tex-mode-hook 'lsp)
 (add-hook 'latex-mode-hook 'lsp))
(with-eval-after-load "bibtex"
 (add-hook 'bibtex-mode-hook 'lsp))

(use-package auctex
  :ensure t
  :mode ("\\.tex\\'" . latex-mode)
  :commands (latex-mode LaTeX-mode plain-tex-mode)
  :init
  (progn
    (add-hook 'LaTeX-mode-hook #'LaTeX-preview-setup)
    (add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
    (add-hook 'LaTeX-mode-hook #'flyspell-mode)
    (add-hook 'LaTeX-mode-hook #'turn-on-reftex)
    (setq TeX-auto-save t
          TeX-parse-self t
          TeX-save-query nil
          TeX-PDF-mode t)
    (setq-default TeX-master nil)
    ))

(use-package company-auctex
  :ensure t
  :after auctex
  :config
  (company-auctex-init)
)
(setq latex-run-command "pdflatex"
      TeX-view-program-selection '((output-pdf "PDF Tools"))
      TeX-view-program-list
      '(("PDF Tools" TeX-pdf-tools-sync-view)))
(defun visual-tex-mode ()
      "Improves appearance of tex buffer"
      (interactive)
      (setq visual-fill-column-width 100
            visual-fill-column-center-text t
	    visual-fill-column-enable-sensible-window-split t)
      (visual-fill-column-mode 1))
(defun visual-tex-mode-off ()
      "Improves appearance of tex buffer"
      (interactive)
      (setq visual-fill-column-width 100
            visual-fill-column-center-text t
	    visual-fill-column-enable-sensible-window-split t)
      (visual-fill-column-mode 0))

;;
;; Python
;;
(use-package python-mode
  :ensure t
  :hook (python-mode . lsp-deferred)
  :custom
  ;; NOTE: Set these if Python 3 is called "python3" on your system!
  (python-shell-interpreter "python3")
  (dap-python-executable "python3")
  (dap-python-debugger 'debugpy)
  :config
  (require 'dap-python))
(setq-default lsp-pylsp-plugins-autopep8-enabled t)

(use-package python-black
  :demand t
  :after python-mode
  :hook (python-mode . python-black-on-save-mode-enable-dwim))

;;
;; R-lang
;;
(use-package ess
  :mode "\\.R\\'"
  :ensure t)
(setq inferior-ess-r-program "/usr/local/bin/R")

;;
;; Ipython
;;
(use-package ob-ipython)


;; lastly we reset the threshold
(setq gc-cons-threshold (* 2 1000 1000))

