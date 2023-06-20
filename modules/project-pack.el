;;;; project-pack.el --- Starting configuration for project management  -*- lexical-binding: t; -*-

;; Copyright (C) 2022
;; SPDX-License-Identifier: MIT

;; Author: System Crafters Community

;;; Commentary

;; Provides default settings for project management with project.el

;;; Code:

(require 'project)
(add-hook 'after-init-hook (lambda () (project-remember-projects-under "~/GIT/")))

;; magit
(use-package magit
  :commands (magit-status magit-get-current-branch)
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(provide 'project-pack)
;;; project-pack.el ends here
