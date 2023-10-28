;;; html-pack.el -*- lexical-binding: t; -*-

;; Author: Davide Badalotti

;; Commentary

;; What to do with html mode and css mode.

;;; Code:

(add-hook 'html-mode-hook #'eglot-ensure)
(add-hook 'css-mode-hook #'eglot-ensure)
(provide 'html-pack)
;;; html-pack.el ends here
