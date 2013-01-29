;; Likely to work only with Emacs24

(menu-bar-mode -1)
(tool-bar-mode -1)
(setq x-select-enable-clipboard t)
;; (set-foreground-color "Cornsilk")
;; (set-background-color "grey30")
(set-default-font "Ubuntu Mono 13")
(set-cursor-color "Orchid")
(setq inhibit-startup-message t)
(setq make-backup-files         nil)
(setq auto-save-list-file-name  nil)
(setq auto-save-default         nil)
(setq ansi-color-names-vector ; better contrast colors
      ["black" "red3" "green3" "yellow3"
       "light steel blue" "magenta3" "cyan3" "white"])
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
(fset 'yes-or-no-p 'y-or-n-p)
(toggle-scroll-bar -1)
(setq column-number-mode t)
(windmove-default-keybindings)
(global-auto-revert-mode t)
(setq size-indication-mode t)

;; set up unicode
(prefer-coding-system       'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)
(setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))

;; tabs, indents, etc.
(setq c-basic-indent 2)
(setq tab-width 4)
(setq tab-stop-list 
      '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64 68 72))
(setq-default indent-tabs-mode nil)
(setq-default fill-column 72)
(setq auto-fill-mode 1)

(show-paren-mode 1)
(defadvice show-paren-function (after show-matching-paren-offscreen
                                      activate)
  (interactive)
  (let ((matching-text nil))
    (if (char-equal (char-syntax (char-before (point))) ?\))
        (setq matching-text (blink-matching-open)))
    (if (not (null matching-text))
        (message matching-text))))

(defadvice comint-simple-send (around allow_clear_command activate)
  "If the input is the word \"clr\", erase buffer."
  (if (string-equal "clr" string)
      (progn
	(kill-word -1)
	(forward-line 0)
	(delete-region 1 (point))
	(end-of-buffer))
    ad-do-it))

(add-hook 'comint-output-filter-functions 
	  'comint-watch-for-password-prompt)

(add-to-list 'auto-mode-alist '("\\.json$" . js-mode))
(setq semantic-idle-scheduler-idle-time 0)

(require 'ido)
(ido-mode t)

(global-set-key [f6] 'goto-line)
(global-set-key [f8] 'other-window)
(global-set-key [f9] (lambda () (interactive) (kill-buffer nil)))
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

(add-to-list 'load-path "~/.emacs.d/rhtml")
(require 'rhtml-mode)

(require 'org-install)
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(setq org-log-done t)
(setq org-agenda-files (list "~/org/chores.org"
                             "~/org/goals.org"))
(setq org-mobile-directory "~/org/mobile")

(load-theme 'zenburn t)

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