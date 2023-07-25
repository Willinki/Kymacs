;;; julia-pack.el --- python configuration      -*- lexical-binding: t; -*-

;; Copyright (C) 2022
;; SPDX-License-Identifier: MIT

;; Author: System Crafters Community, Davide Badalotti
;; Keywords: python

;;; Commentary:
;;; Julia very basic configuration with snail and vterm
;;; Code:
(use-package julia-mode
   :ensure t)

(use-package julia-repl
   :ensure t
   :hook (julia-mode . julia-repl-mode)
   :init
   (setenv "JULIA_NUM_THREADS" "8")
   :config
   (define-key julia-repl-mode-map (kbd "<M-RET>") 'julia-repl-send-line)
   (define-key julia-repl-mode-map (kbd "<S-return>") 'julia-repl-send-buffer))

(use-package julia-snail
  :ensure t
  :hook (julia-mode . julia-snail-mode))

(use-package markdown-mode
  :ensure t
  :mode ("README\\.md\\'" . gfm-mode)
  :init (setq markdown-command "multimarkdown")
  :bind (:map markdown-mode-map
         ("C-c C-e" . markdown-do)))

(use-package eglot-jl
  :ensure t
  :config
  (setq eglot-connect-timeout 120))

(add-hook 'julia-mode-hook #'eglot-ensure)
(eglot-jl-init)
(provide 'julia-pack)
;;; julia-pack.el ends here
