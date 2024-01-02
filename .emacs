(require 'package)
(add-to-list 'package-archives '("gnu"   . "https://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'load-path "/usr/local/share/emacs/site-lisp/mu4e")
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
;; Auto-refresh dired on file change
(add-hook 'dired-mode-hook 'auto-revert-mode)

(unless (package-installed-p 'gruvbox-theme)
  (package-install 'gruvbox-theme))
(load-theme 'gruvbox-dark-soft t)

(setq-default display-fill-column-indicator-column 79)  ; 80 column indicator - Emacs columns are 0-based...
(global-display-fill-column-indicator-mode 1)

(unless (package-installed-p 'lsp-mode)
  (package-install 'lsp-mode))

(use-package lsp-mode
  :init
  :config
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         (c-mode . lsp)
         (python-mode . lsp))
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

;; emacs gdb
(fmakunbound 'gdb)
(fmakunbound 'gdb-enable-debug)

(unless (package-installed-p 'gdb-mi)
	(package-install 'gdb-mi))

(use-package gdb-mi
  :init
  (fmakunbound 'gdb)
  (fmakunbound 'gdb-enable-debug))

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

(defun my-untabify-all-lines ()
  "Select all lines in the buffer and run 'untabify' on them."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (push-mark (point-max) t t)
    (untabify (region-beginning) (region-end))))

(global-set-key (kbd "C-c C-x") 'my-untabify-all-lines)

;;    
;; Epitech configuration
;;
(add-to-list 'load-path "~/.emacs.d/lisp")
(load "site-start.d/epitech-init.el")

;; example configuration for mu4e
(require 'mu4e)

;; use mu4e for e-mail in emacs
(setq mail-user-agent 'mu4e-user-agent)

;; the next are relative to the root maildir
;; (see `mu info`).
;; instead of strings, they can be functions too, see
;; their docstring or the chapter 'Dynamic folders'
(setq mu4e-sent-folder   "/sent"
      mu4e-drafts-folder "/drafts"
      mu4e-trash-folder  "/trash")

;; the maildirs you use frequently; access them with 'j' ('jump')
(setq mu4e-maildir-shortcuts
    '((:maildir "/archive" :key ?a)
      (:maildir "/inbox"   :key ?i)
      (:maildir "/work"    :key ?w)
      (:maildir "/sent"    :key ?s)))

;; the headers to show in the headers list -- a pair of a field
;; and its width, with `nil' meaning 'unlimited'
;; (better only use that for the last field.
;; These are the defaults:
(setq mu4e-headers-fields
    '( (:date          .  25)    ;; alternatively, use :human-date
       (:flags         .   6)
       (:from          .  22)
       (:subject       .  nil))) ;; alternatively, use :thread-subject

(add-to-list 'mu4e-bookmarks
    ;; ':favorite t' i.e, use this one for the modeline
   '(:query "maildir:/inbox" :name "Inbox" :key ?i :favorite t))

;; program to get mail; alternatives are 'fetchmail', 'getmail'
;; isync or your own shellscript. called when 'U' is pressed in
;; main view.

;; don't keep message buffers around
(setq message-kill-buffer-on-exit t)

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
