;; ergonomics-pack.el -*- lexical-binding: t; -*-

;; this removes unwanted behaviour of files
(use-package no-littering)

;; solaire mode
(use-package solaire-mode
  :ensure t
  :config
  (solaire-global-mode +1))

;; vterm as default terminal
(use-package vterm
  :commands vterm
  :config
  (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *")
  (setq vterm-shell "zsh")
  (setq vterm-max-scrollback 10000))

;; mini-buffer as rofi
(use-package mini-frame
  :ensure t
  :init
  (mini-frame-mode)
  :defer 0)
(custom-set-variables
 '(mini-frame-show-parameters
   '((top . 0.35)
     (width . 0.6)
     (left . 0.5))))

;; some options for dired
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
  :custom
  ((dired-listing-switches "-agho --group-directories-first")))

(use-package dired-single
  :after dired)

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

(use-package zoom
  :custom
  (zoom-mode 1))

(setq scroll-step 1)
(setq scroll-conservatively 10000)
(setq auto-window-vscroll nil)


(provide 'ergonomics-pack)
;; ergonomics-pack.el ends here
