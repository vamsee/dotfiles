(menu-bar-mode -1)
(tool-bar-mode -1)
(setq x-select-enable-clipboard t)
(setq inhibit-startup-message t)
(setq make-backup-files         nil)
(setq auto-save-list-file-name  nil)
(setq auto-save-default         nil)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
(fset 'yes-or-no-p 'y-or-n-p)
(toggle-scroll-bar -1)
(setq column-number-mode t)
(windmove-default-keybindings)
(global-auto-revert-mode t)
(setq size-indication-mode t)
(setq debug-on-error t)

;; From Emacs 24.1 onwards
(electric-indent-mode +1)
(global-hl-line-mode +1)
(delete-selection-mode +1)

;; set up unicode
(prefer-coding-system       'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(setq buffer-file-coding-system 'utf-8)
(setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))

;; tabs, indents, etc.
(setq c-basic-indent 2)
(setq tab-width 4)
(setq tab-stop-list 
      '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64 68 72))
(setq-default indent-tabs-mode nil)
(setq-default fill-column 72)
(setq auto-fill-mode 1)

;; limit line width to 80 cols
(require 'whitespace)
(setq whitespace-style '(face tabs lines trailing))
(global-whitespace-mode t)
(setq-default indicate-empty-lines t)
;;(add-hook 'prog-mode-hook 'whitespace-mode)

(require 'paren)
(setq show-paren-style 'parenthesis)
(show-paren-mode +1)
(defadvice show-paren-function (after show-matching-paren-offscreen
                                      activate)
  (interactive)
  (let ((matching-text nil))
    (if (char-equal (char-syntax (char-before (point))) ?\))
        (setq matching-text (blink-matching-open)))
    (if (not (null matching-text))
        (message matching-text))))

(add-hook 'comint-output-filter-functions 
	  'comint-watch-for-password-prompt)

;; (add-to-list 'auto-mode-alist '("\\.json$" . js-mode))
(setq semantic-idle-scheduler-idle-time 0)

(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)

(global-set-key [f5] 'shell)
(global-set-key [f6] 'goto-line)
(global-set-key [f7] 'deft)
(global-set-key [f8] 'other-window)
(global-set-key [f9] 'delete-other-windows)
(global-set-key [f10] (lambda () (interactive) (kill-buffer nil)))
(global-set-key [f11] 'previous-buffer)
(global-set-key [f12] 'next-buffer)

(add-to-list 'auto-mode-alist '("\\.rake$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Rakefile$" . ruby-mode))

(require 'package)
(package-initialize)
;; Add the original Emacs Lisp Package Archive
(add-to-list 'package-archives
             '("elpa" . "http://tromey.com/elpa/"))

;; Add the user-contributed repository
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))

;; Add milkypostman's repository
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)

(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))

(require 'sass-mode)
(add-to-list 'auto-mode-alist '("\\.scss$" . sass-mode))

(require 'puppet-mode)
(add-to-list 'auto-mode-alist '("\\.pp$" . puppet-mode))

(require 'rhtml-mode)

(require 'org-install)
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(setq org-log-done t)
(setq org-agenda-files (list "~/org/chores.org"
                             "~/org/projects.org"))
(setq org-directory "~/org/")
(setq org-startup-indented t)
(setq org-archive-location (concat org-directory "archive/%s_archive::"))

;; setup deft to work well with org:
(setq deft-extension "org")
(setq deft-text-mode 'org-mode)
(setq deft-directory "~/org")

;; I'm beginning to like this theme
(load-theme 'solarized-dark t)

(defun  disabled-key ()
    "Assign this to disable a key"
    (interactive)
    (print "All your arrow keys are belong to me. Have a nice day!"))

;; Disable arrow keys
(global-set-key (kbd "<up>")      'disabled-key)
(global-set-key (kbd "<down>")    'disabled-key)
(global-set-key (kbd "<left>")    'disabled-key)
(global-set-key (kbd "<right>")   'disabled-key)
(global-set-key (kbd "<C-up>")      'disabled-key)
(global-set-key (kbd "<C-down>")    'disabled-key)
(global-set-key (kbd "<C-left>")    'disabled-key)
(global-set-key (kbd "<C-right>")   'disabled-key)

(defun smart-open-line ()
  "Insert an empty line after the current line.
Position the cursor at its beginning, according to the current mode."
  (interactive)
  (move-end-of-line nil)
  (newline-and-indent))

(global-set-key [(shift return)] 'smart-open-line)

(require 'recentf)
(setq recentf-max-saved-items 100
      recentf-max-menu-items 15)
(recentf-mode +1)

(defun recentf-ido-find-file ()
  "Find a recent file using ido."
  (interactive)
  (let ((file (ido-completing-read "Choose recent file: " recentf-list nil t)))
    (when file
      (find-file file))))

(global-set-key (kbd "C-c f")  'recentf-ido-find-file)

;; display visited file path in emacs' frame title
(setq frame-title-format
      '((:eval (if (buffer-file-name)
                   (abbreviate-file-name (buffer-file-name))
                 "%b"))))

;; kill backwards from cursor
(global-set-key (kbd "C-<backspace>") (lambda ()
                                        (interactive)
                                        (kill-line 0)
                                        (indent-according-to-mode)))

;; kill whole line and move up region
(defun smart-kill-whole-line (&optional arg)
  "A simple wrapper around `kill-whole-line' that respects indentation."
  (interactive "P")
  (kill-whole-line arg)
  (back-to-indentation))

(global-set-key [remap kill-whole-line] 'smart-kill-whole-line)
(global-unset-key (kbd "C-z"))

(add-hook 'after-init-hook #'global-flycheck-mode)

(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
