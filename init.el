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
;;; * Fully fledged org environment: agenda, capture, roam, babel

;;; Code:

; First, the threshold for garbage collection is increased
(setq gc-cons-threshold (* 50 1000 1000))

; Here we set the module directory and the custom file
(add-to-list 'load-path (expand-file-name "~/GIT/Kymacs/modules"))
(setq custom-file (expand-file-name "~/.emacs.d/custom.el"))
(load custom-file)

(require 'startup-settings)
(require 'package-setup)
(require 'general-appearance)
(require 'ergonomics-pack)
(require 'crafted-editing)
(require 'evil-setup)
(require 'completion-pack)
(require 'project-pack)
(require 'orgmode-pack)
(require 'python-pack)
(require 'julia-pack)
(require 'treemacs-pack)

;; resetting garbage threshold
(setq gc-cons-threshold (* 2 1000 1000))
;; init.el ends here
