;; 0-1-general-appearance.el -*- lexical-binding: t; -*-

;; Emacs is put on fullscreen by default
(add-to-list 'default-frame-alist '(fullscreen . fullscreen))

;; Basic configuration option, startup page
(defun setup-general-appearance ()
  (setq inhibit-startup-message t)
  (scroll-bar-mode -1)
  (tool-bar-mode -1)
  (tooltip-mode -1)
  (set-fringe-mode 10))
(add-hook 'after-init-hook 'setup-general-appearance)

;; basic appearance of prog mode - line numbers and indicator column
(setq-default display-fill-column-indicator-column 88)
(add-hook 'prog-mode-hook 'display-fill-column-indicator-mode)
(add-hook 'prog-mode-hook 'column-number-mode)
;; Turn on line numbers
(column-number-mode)
(global-display-line-numbers-mode t)
(dolist
  (mode '(org-mode-hook term-mode-hook eshell-mode-hook))
  (add-hook mode (lambda() (display-line-numbers-mode 0))))

;; Font
(set-face-attribute 'default nil :font "Roboto Mono" :height 130)
;; Set the fixed pitch face
(set-face-attribute 'fixed-pitch nil :font "Roboto Mono" :height 130)
;; Set the variable pitch face
(set-face-attribute 'variable-pitch nil :font "Source Sans Pro" :height 150 :weight 'regular)

;; icons (does not work for some reason)
(use-package all-the-icons)

;; Themes and colors
(use-package doom-themes
;;  :init (load-theme 'doom-solarized-light t)
  :init (load-theme 'doom-solarized-light t)
  :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Enable custom neotree theme (all-the-icons must be installed!)
  (doom-themes-neotree-config)
  ;; or for treemacs users
  (setq doom-themes-treemacs-theme "doom-colors")
  (doom-themes-treemacs-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

(use-package moody
  :config
  (setq x-underline-at-descent-line t)
  (moody-replace-mode-line-buffer-identification)
  (moody-replace-vc-mode)
  (moody-replace-eldoc-minibuffer-message-function))

(use-package rainbow-delimiters
  :hook
  (prog-mode . rainbow-delimiters-mode))

(provide 'general-appearance)
;; 0-1-general-appearance.el ends here
