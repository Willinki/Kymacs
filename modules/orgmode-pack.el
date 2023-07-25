;; orgmode-pack.el -*- lexical-binding: t; -*-
(defun dw/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (auto-fill-mode 0)
  (visual-line-mode 1)
  (setq org-startup-indented t)
  (setq evil-auto-indent nil))

(use-package org
  :hook (org-mode . dw/org-mode-setup)
  :config
  (advice-add 'org-refile :after 'org-save-all-org-buffers)
  (setq org-startup-with-inline-images t)
  (setq org-image-actual-width (/ (display-pixel-width) 2))
  (setq org-ellipsis " ▾")
  (setq org-agenda-prefix-format
	'((agenda . " %i %-12:c%?-12t% s")
	  (todo   . " ")
	  (tags   . " %i %-12:c")
	  (search . " %i %-12:c")))
  (setq org-highlight-latex-and-related '("native" "latex"))
  (setq org-format-latex-options (plist-put org-format-latex-options :scale 1.5))
  (setq org-agenda-start-with-log-mode t)
  (setq org-log-done 'time)
  (setq org-log-intro-drawer t)
  (setq org-src-fontify-natively t)
  (setq org-fontify-done-headlines t)
  (setq org-src-preserve-indentation t)
  (setq org-agenda-time-grid
	'((daily today require-timed)
	  (800 1000 1200 1400 1600 1800 2000)
	  " ┄┄┄┄┄ " "┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄"))
  (setq org-agenda-current-time-string
	"⭠ now ─────────────────────────────────────────────────")
  (setq org-directory "~/Documents/org")
  (setq org-cite-global-bibliography (list "~/Documents/org/biblio.bib"))
  (setq org-agenda-files (list "inbox.org" "agenda.org"))
  (setq org-archive-location  "~/.emacs.d/archive.org::* Archived tasks" )
  (setq org-todo-keywords
	'((sequence "TODO(t)" "PRIORITY(p!)" "WAIT(w@/!)" "|" "DONE(d)" "CANCELED(c@)")
	  (sequence "INTERESTING(i)" "EXPLORING(e)" "|" "DONE(d)" "ABANDONED(a@)")))
  (setq org-todo-keyword-faces
	'(("TODO" . org-todo)
	  ("PRIORITY" . (:foreground "red" :weight bold))
	  ("WAIT" . org-todo)
	  ("DONE" . org-done)
	  ("CANCELED" . org-done)
	  ("INTERESTING" . (:foreground "green" :weight bold))
	  ("ABANDONED" . org-done)))
  (setq org-tag-alist
	'(("@home" . ?H)
	  ("@uni" . ?U)
	  ("@work" . ?W)
	  ("lesson" . ?L)
	  ("seminar" . ?S)
	  ("presentation" . ?P)
	  ("conference" . ?C)
	  ("meeting" . ?m)
	  ("study" . ?s)
	  ("code" . ?c)
	  ("write" . ?w)
	  ("review" . ?r)
	  ("read" . ?l)))
  (setq org-agenda-custom-commands
	'(("d" "Dashboard"
	   ((agenda "" ((org-deadline-warning-days 40)))
	    (todo "PRIORITY"
		  ((org-agenda-overriding-header "Current priorities")))
	    (tags-todo "@meeting"
		       ((org-agenda-overriding-header "Next meetings")
			(org-agenda-span 14)))
	    (tags-todo "lesson|seminar|presentation|conference"
		       ((org-agenda-overriding-header "Next events")
			(org-agenda-span 14)))
	    (todo "EXPLORING"
		  ((org-agenda-overriding-header "Keep reading")))
	    (todo "INTERESTING"
		  ((org-agenda-overriding-header "Other Readings for you")))))))
  (setq org-capture-templates
	`(("f" "File related task" entry (file "inbox.org")
	   "* TODO %?\n  Entered on %U\n  Useful file: %a\n  %i" :kill-buffer t)
	  ("t" "General task" entry (file "inbox.org")
	   "* TODO %?\n Entered on %U\n %i" :kill-buffer t)
	  ("m" "Meeting" entry  (file+headline "agenda.org" "Future")
	   "* %? :meeting:\n SCHEDULED: <%<%Y-%m-%d %a %H:00>>" :kill-buffer t)
	  ("n" "Note" entry  (file "notes.org")
	   "* Note (%a)\n" : kill-buffer t)
	  ("r" "Reading" entry (file "inbox.org")
	   "* INTERESTING %?\n  %U\n  %a\n Link to the reading:\n %i" :kill-buffer t)))
  (with-eval-after-load 'org-faces
    (dolist
      (face '((org-level-1 . 1.5) (org-level-2 . 1.3) (org-level-3 . 1.1)
              (org-level-4 . 1.0) (org-level-5 . 1.0) (org-level-6 . 1.0)
              (org-level-7 . 1.0) (org-level-8 . 1.0)))
      (set-face-attribute (car face) nil :font "Source Sans Pro" :weight 'semi-bold :height (cdr face))
      (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
      (set-face-attribute 'org-table nil                 :inherit 'fixed-pitch)
      (set-face-attribute 'org-formula nil               :inherit 'fixed-pitch)
      (set-face-attribute 'org-code nil                  :inherit '(shadow fixed-pitch))
      (set-face-attribute 'org-table nil                 :inherit '(shadow fixed-pitch))
      (set-face-attribute 'org-verbatim nil              :inherit '(shadow fixed-pitch))
      (set-face-attribute 'org-special-keyword nil       :inherit '(font-lock-comment-face fixed-pitch))
      (set-face-attribute 'org-meta-line nil             :inherit '(font-lock-comment-face fixed-pitch))
      (set-face-attribute 'org-checkbox nil              :inherit 'fixed-pitch)
      (set-face-attribute 'line-number nil               :inherit 'fixed-pitch)
      (set-face-attribute 'line-number-current-line nil  :inherit 'fixed-pitch))))

(use-package visual-fill-column
  :hook (org-mode . efs/org-mode-visual-fill))
  (setq org-refile-targets
	'(("~/Documents/org/inbox.org" :maxlevel . 1)
	  ("~/Documents/org/agenda.org" :maxlevel . 1)
	  ("~/Documents/org/archive.org" :maxlevel . 1)
	  ("~/Documents/org/notes.org" :maxlevel . 1)))


(defun efs/org-mode-visual-fill ()
  (setq visual-fill-column-width 115
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package org-journal
  :ensure t
  :defer t
  :init
  (setq org-journal-prefix-key "C-c j ")
  :config
  (setq org-journal-dir "~/Documents/org/journal/"
        org-journal-date-format "%A, %d %B %Y"))

(define-key global-map (kbd "C-c i") 'org-capture)
(define-key global-map (kbd "C-c a") 'org-agenda)

;;
;; org babel
;;
(org-babel-do-load-languages
  'org-babel-load-languages
  '((emacs-lisp . t)
    (python . t)))
(setq org-confirm-babel-evaluate nil)
;;; display/update images in the buffer after I evaluate
(add-hook 'org-babel-after-execute-hook 'org-display-inline-images 'append)

;;
;; org tempo
;;
(require 'org-tempo)
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
(add-to-list 'org-structure-template-alist '("py" . "src python"))

(provide 'orgmode-pack)
;; orgmode-pack.el ends here
