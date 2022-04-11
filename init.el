
					; Other custom changes:
; - I disable paredit default bindings because they were conflicting with xref-find-references
; as per https://stackoverflow.com/questions/16605571/why-cant-i-change-paredit-keybindings
; disable it by commenting out line 81 in core/prelude-edior.el

; set custom.el as customizations file
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

(setq package-archives
      '(("gnu" . "http://elpa.gnu.org/packages/")
        ("marmalade" . "http://marmalade-repo.org/packages/")
        ("melpa" . "https://melpa.org/packages/")))

; check if package is installed, and installed it if not. Credit https://stackoverflow.com/questions/31079204/emacs-package-install-script-in-init-file
; define the list of packages we may want to make sure are installed
(setq package-list
      '(use-package elpy flycheck yasnippet yasnippet-snippets py-autopep8 blacken magit treemacs-projectile lsp-mode zenburn-theme))

(require 'package)
(package-initialize)

; fetch the list of packages available
(unless package-archive-contents
  (package-refresh-contents))

; install the missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

; set threshold for garbage collector to be triggered
(setq gc-cons-threshold 50000000)
(setq large-file-warning-threshold 100000000)

; various aesthetic configs
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(menu-bar-mode -1)
(toggle-scroll-bar -1)
(tool-bar-mode -1)
(global-hl-line-mode +1)
(line-number-mode +1)
(global-display-line-numbers-mode 1)
(column-number-mode t)
(setq inhibit-startup-screen t)

(setq frame-title-format
      '((:eval (if (buffer-file-name)
       (abbreviate-file-name (buffer-file-name))
       "%b"))))


(fset 'yes-or-no-p 'y-or-n-p)

; reload file automatically if edited outside of emacs
(global-auto-revert-mode t)


(defadvice split-window (after split-window-after activate)
  (other-window 1))

; show file path in title
(setq frame-title-format
      '((:eval (if (buffer-file-name)
       (abbreviate-file-name (buffer-file-name))
       "%b"))))

(setq scroll-margin 0
      scroll-conservatively 100000
      scroll-preserve-screen-position 1)


;; set personal theme directory
(add-to-list 'custom-theme-load-path (expand-file-name "themes"
                                                       user-emacs-directory))

(load-theme 'zenburn t)

(use-package smartparens
  :ensure t
  :diminish smartparens-mode
  :config
  (progn
    (require 'smartparens-config)
    (smartparens-global-mode 1)
    (show-paren-mode t)))

(use-package which-key
  :ensure t
  :diminish which-key-mode
  :config
  (which-key-mode +1))


(use-package flycheck
  :ensure t
  :diminish flycheck-mode
  :config
  (add-hook 'after-init-hook #'global-flycheck-mode))


(use-package projectile
  :ensure t
  :diminish projectile-mode
 )


(use-package helm
  :ensure t
  :defer 2
  :bind
  ("M-x" . helm-M-x)
  ("C-x C-f" . helm-find-files)
  ("M-y" . helm-show-kill-ring)
  ("C-x b" . helm-mini)
  :config
  (require 'helm-config)
  (helm-mode 1)
  (setq helm-split-window-inside-p t
    helm-move-to-line-cycle-in-source t)
  (setq helm-autoresize-max-height 0)
  (setq helm-autoresize-min-height 20)
  (helm-autoresize-mode 1)
)

(use-package lsp-mode
  :hook ((python-mode . lsp)
         (sh-mode . lsp)
         )
  :config
  (lsp-register-custom-settings
   '(("pyls.plugins.pyls_mypy.enabled" t t)
     ("pyls.plugins.pyls_mypy.live_mode" nil t)
     ("pyls.plugins.pyls_black.enabled" t t)
     ("pyls.plugins.pyls_isort.enabled" t t)))
  :custom
  (lsp-eldoc-enable-hover t)
  )

(use-package lsp-ui
            :disabled t
            :config
            (add-hook 'lsp-mode-hook 'lsp-ui-mode)
 )

(use-package markdown-mode
             :ensure t
             :mode ("README\\.md\\'" . gfm-mode)
             :init (setq markdown-command "multimarkdown"))

(use-package yasnippet
  :custom
  (yas-verbosity 2)
  (yas-wrap-around-region t)

  :config
  (yas-reload-all)
  (yas-global-mode))


(use-package yasnippet-snippets
  :after yasnippet)

(use-package elpy
  :ensure t
  :init
  (elpy-enable))

(require 'py-autopep8)
(add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)

;; Enable Flycheck - and have elpy use it
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))


(dolist (hook '(text-mode-hook))
  (add-hook hook (lambda () (flyspell-mode 1))))
(dolist (hook '(change-log-mode-hook log-edit-mode-hook))
  (add-hook hook (lambda () (flyspell-mode -1))))

;; Use IPython for REPEL
;; (setq python-shell-interpreter "jupyter"
;;       python-shell-interpreter-args "console --simple-prompt"
;;       python-shell-prompt-detect-failure-warning nil)
;; (add-to-list 'python-shell-completion-native-disabled-interpreters
;;              "jupyter")

; the changes below make white spaces shown when whitespace-mode is enabled
; credit https://emacs.stackexchange.com/questions/9571/enable-whitespace-mode-with-prelude-in-c-mode
;; (add-to-list 'whitespace-style 'space-mark)
;; (add-to-list 'whitespace-style 'tab-mark)
;; (add-to-list 'whitespace-style 'newline-mark)

; custom keybindings
(global-set-key (kbd "C-x k") 'kill-this-buffer)
(global-set-key (kbd "M-i") 'imenu)
(global-set-key (kbd "C-S-<backspace>") 'kill-whole-line)
(global-set-key [remap dabbrev-expand] 'hippie-expand)
(global-set-key (kbd "<f8>") 'treemacs)
(global-set-key (kbd "C-M-g") 'elpy-goto-definition)


(use-package ein
  :bind (:map ein:execute
	      ("C-c C-c" . ein:worksheet-execute-cell-and-got-next)))

                                        ; projectile keybinding

(projectile-mode +1)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

(eval-after-load "smartparens-mode"
  '(progn
     (define-key paredit-mode-map (kbd "M-?") nil)
     (global-set-key (kbd "M-?") 'xref-find-references)
     ))


(setq path-to-ctags "/opt/local/bin/ctags")

(defun create-tags (dir-name)
  "Create tags file."
  (interactive "DDirectory: ")
  (shell-command
   (format "%s -f TAGS -e -R %s" path-to-ctags (directory-file-name dir-name)))
  )

(defadvice find-tag (around refresh-etags activate)
  "Rerun etags and reload tags if tag not found and redo find-tag.
   If buffer is modified, ask about save before running etags."
  (let ((extension (file-name-extension (buffer-file-name))))
    (condition-case err
        ad-do-it
      (error (and (buffer-modified-p)
                  (not (ding))
                  (y-or-n-p "Buffer is modified, save it? ")
                  (save-buffer))
             (er-refresh-etags extension)
             ad-do-it))))

(defun er-refresh-etags (&optional extension)
  "Run etags on all peer files in current dir and reload them silently."
  (interactive)
  (shell-command (format "etags *.%s" (or extension "el")))
  (let ((tags-revert-without-query t))  ; don't query, revert silently
    (visit-tags-table default-directory nil)))

; if the emacs server is not running start it
(require 'server)
(if (not (server-running-p)) (server-start))
