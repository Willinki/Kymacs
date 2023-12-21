;;; rust-pack.el --- rust configuration      -*- lexical-binding: t; -*-

;; Copyright (C) 2022
;; SPDX-License-Identifier: MIT

;; Author: Davide Badalotti
;; Keywords: rust

;;; Commentary:

;; Rust development environment configuration.

(use-package rust-mode
  :defer t
  :config
  (add-hook 'rust-mode-hook 'eglot-ensure))


(use-package cargo-mode
  :defer t
  :config
  (add-hook 'rust-mode-hook 'cargo-minor-mode)
  (setq compilation-scroll-output t))

(provide 'rust-pack)
;;; rust-pack.el ends here
