;; 0-startup-settings.el -*- lexical-binding:t; -*-

;; Commentary:
;; Just some functionality to be set at startup, not appearance related
;;

;; here we keep out custom variables

;; Reset super, hyper and meta
(setq mac-command-modifier 'meta) ; make cmd key do Meta
(setq mac-option-modifier 'super) ; make opt key do Super
(setq mac-control-modifier 'control) ; make Control key do Control
(setq ns-function-modifier 'hyper)  ; make Fn key do Hyper

;; Set backup files in another directory
(setq backup-directory-alist `(("." . "~/.emacs.d/saves/")))
(setq backup-by-copying t)
(add-to-list 'exec-path "/opt/homebrew/bin/")
(setq delete-old-versions t
  kept-new-versions 6
  kept-old-versions 2
  version-control t)

(provide 'startup-settings)
;; 0-startup-settings.el ends here
