;; latex-pack.el -*- lexical-binding: t; -*-
;; Author: System Crafters Community

;; Commentary

;; Configure AUCTEX for editing LaTeX files.  Provides customization
;; for various environments to provide some useful additions related
;; to drawing graphs and mathematical diagrams, and code listings.

;;; Code:

(defgroup crafted-latex '()
  "LaTeX configuration for Crafted Emacs."
  :tag "Crafted LaTeX"
  :group 'crafted)

(defcustom crafted-latex-latexp (executable-find "latex")
  "Fully qualified path to the `latex' executable"
  :tag "`latex' executable location"
  :group 'crafted-latex
  :type 'string)

(defcustom crafted-latex-latexmkp (executable-find "latexmk")
  "Fully qualified path to the `latexmk' executable"
  :tag "`latexmk' executable location"
  :group 'crafted-latex
  :type 'string)

(defcustom crafted-latex-use-pdf-tools t
  "Use pdf-tools as the pdf reader
   (this is automatic if you load `crafted-pdf-reader')"
  :tag "Use pdf-tools as pdf reader"
  :group 'crafted-latex
  :type 'boolean)

;; Hooks
(add-hook 'doc-view-mode-hook 'auto-revert-mode)
;; latex-pack.el ends here
