(require 'package)
(add-to-list 'package-archives '("gnu"   . "https://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-and-compile
  (setq use-package-always-ensure t
        use-package-expand-minimally t))

(load "~/.emacs.rc/rc.el")
(load "~/.emacs.rc/misc-rc.el")
(load "~/.emacs.rc/org-mode-rc.el")
(load "~/.emacs.rc/autocommit-rc.el")

;; Look
(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)
(column-number-mode 1)
(show-paren-mode 1)
(electric-pair-mode 1)
(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)
(set-face-attribute 'default nil :height 200)
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(unless (package-installed-p 'gruvbox-theme)
  (package-install 'gruvbox-theme))

 (load-theme 'gruvbox-dark-soft t)

(unless (package-installed-p 'lsp-mode)
  (package-install 'lsp-mode))

(use-package lsp-mode
  :init
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         (c-mode . lsp))
  :commands lsp)

;; company
(unless (package-installed-p 'company)
	(package-install 'company))

(use-package company
  :after lsp-mode
  :hook (prog-mode . company-mode)
  :bind (:map company-active-map
         ("<tab>" . company-complete-selection))
        (:map lsp-mode-map
         ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

(setq neo-theme (if (display-graphic-p) 'icons))

;; neotree
(unless (package-installed-p 'neotree)
	(package-install 'neotree)
	(package-install 'all-the-icons))

(setq neo-theme (if (display-graphic-p) 'icons))
(setq neo-smart-open t)
(global-set-key [f8] 'neotree-toggle)

;; Simpleclip
(unless (package-installed-p 'simpleclip)
  	(package-install 'simpleclip))

(global-set-key (kbd "C-c C-c") 'simpleclip-copy)
(global-set-key (kbd "C-c C-v") 'simpleclip-paste)

;; Download Evil
(unless (package-installed-p 'evil)
  (package-install 'evil))

;; Enable Evil
(require 'evil)
(evil-mode 1)

;;    
;; Epitech configuration
;;
(add-to-list 'load-path "~/.emacs.d/lisp")
(load "site-start.d/epitech-init.el")

(setq-default indent-tabs-mode nil)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(company simpleclip rust-mode org-cliplink neotree magit gruber-darker-theme go-mode evil dash-functional all-the-icons)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )