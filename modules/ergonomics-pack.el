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


(provide 'ergonomics-pack)
;; ergonomics-pack.el ends here
