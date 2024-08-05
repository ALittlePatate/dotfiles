(require 'package)
(add-to-list 'package-archives '("gnu"   . "https://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'load-path "/usr/local/share/emacs/site-lisp/mu4e")
(package-initialize)

(setq make-backup-files nil)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-and-compile
  (setq use-package-always-ensure t
        use-package-expand-minimally t))

(unless (package-installed-p 'benchmark-init)
  (package-refresh-contents)
  (package-install 'benchmark-init))

(require 'benchmark-init)
;; To disable collection of benchmark data after init is done.
(add-hook 'after-init-hook 'benchmark-init/deactivate)

;; shell
(global-set-key (kbd "C-c RET") (lambda () (interactive) (ansi-term "/bin/zsh")))

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
  (add-hook 'lsp-mode-hook 'lsp-ui-mode)
  :custom
  ;; what to use when checking on-save. "check" is default, I prefer clippy
  (lsp-rust-analyzer-cargo-watch-command "clippy")
  (lsp-eldoc-render-all t)
  (lsp-idle-delay 0.6)
  ;; enable / disable the hints as you prefer:
  (lsp-inlay-hint-enable t)
  ;; These are optional configurations. See https://emacs-lsp.github.io/lsp-mode/page/lsp-rust-analyzer/#lsp-rust-analyzer-display-chaining-hints for a full list
  (lsp-rust-analyzer-display-lifetime-elision-hints-enable "skip_trivial")
  (lsp-rust-analyzer-display-chaining-hints t)
  (lsp-rust-analyzer-display-lifetime-elision-hints-use-parameter-names nil)
  (lsp-rust-analyzer-display-closure-return-type-hints t)
  (lsp-rust-analyzer-display-reborrow-hints nil)
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         (c-mode . lsp)
         (python-mode . lsp))
  :commands lsp)

;;https://robert.kra.hn/posts/rust-emacs-setup/
(use-package rustic
  :ensure
  :bind (:map rustic-mode-map
              ("M-j" . lsp-ui-imenu)
              ("M-?" . lsp-find-references)
              ("C-c C-c l" . flycheck-list-errors)
              ("C-c C-c a" . lsp-execute-code-action)
              ("C-c C-c r" . lsp-rename)
              ("C-c C-c q" . lsp-workspace-restart)
              ("C-c C-c Q" . lsp-workspace-shutdown)
              ("C-c C-c s" . lsp-rust-analyzer-status))
  :config
  ;; uncomment for less flashiness
  ;; (setq lsp-eldoc-hook nil)
  ;; (setq lsp-enable-symbol-highlighting nil)
  ;; (setq lsp-signature-auto-activate nil)

  ;; comment to disable rustfmt on save
  (setq rustic-format-on-save t)
  (add-hook 'rustic-mode-hook 'rk/rustic-mode-hook))

(defun rk/rustic-mode-hook ()
  ;; so that run C-c C-c C-r works without having to confirm, but don't try to
  ;; save rust buffers that are not file visiting. Once
  ;; https://github.com/brotzeit/rustic/issues/253 has been resolved this should
  ;; no longer be necessary.
  (when buffer-file-name
    (setq-local buffer-save-without-query t))
  (add-hook 'before-save-hook 'lsp-format-buffer nil t))

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

;; Use keybindings
(use-package grip-mode
  :ensure t
  :bind (:map markdown-mode-command-map
         ("g" . grip-mode)))

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

;; exwm
(unless (package-installed-p 'exwm)
  (package-install 'exwm))

(require 'exwm)
(require 'exwm-config)
;;(exwm-config-example)

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

(setq-default indent-tabs-mode nil)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t)
 '(package-selected-packages
   '(benchmark-init company simpleclip rust-mode org-cliplink neotree magit gruber-darker-theme go-mode evil dash-functional all-the-icons)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
