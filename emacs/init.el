(setq use-package-always-demand t)

(use-package envrc
  :hook (emacs-startup . envrc-global-mode))

(use-package general)

(use-package +core
  :no-require t

  :custom
  (auth-sources '("~/sys/secrets/authinfo.gpg"))
  (auto-save-no-message t)
  (auto-save-visited-interval 3)
  (auto-save-visited-mode t)
  (column-number-mode t)
  (gc-cons-threshold 100000000)
  (global-auto-revert-mode t)
  (indent-tabs-mode nil)
  (inhibit-startup-echo-area-message t)
  (inhibit-startup-message t)
  (inhibit-startup-screen t)
  (left-fringe-width 16)
  (make-backup-files nil)
  (mode-line-format '("%e"
                      mode-line-front-space
                      (:propertize
                       ("" mode-line-modified mode-line-remote mode-line-window-dedicated)
                       display (min-width (6.0)))
                      mode-line-frame-identification mode-line-buffer-identification
                      (project-mode-line project-mode-line-format) (vc-mode vc-mode) "  "
                      mode-line-misc-info
                      mode-line-format-right-align
                      mode-line-position))
  (read-process-output-max (* 2 1024 1024))
  (recentf-mode t)
  (right-fringe-width 16)
  (ring-bell-function 'ignore)
  (save-place-mode t)
  (savehist-mode t)

  :custom-face
  (default ((t (:background "#000000"))))
  (mode-line ((t (:background "#101010"))))

  :general
  (:states '(normal visual)
   "SPC"   nil)
  (:states '(normal visual)
   :prefix "SPC"
   "SPC"   '(execute-extended-command :wk "M-x"))
  (:states 'normal
   "C-s"   'save-buffer
   "s-j"   'next-buffer
   "s-k"   'previous-buffer
   "q"     'bury-buffer)
  (:states 'normal
   :prefix "SPC"
   "0"     '(delete-window           :wk "close this window")
   "1"     '(delete-other-windows    :wk "keep this window")
   "Q"     '(save-buffers-kill-emacs :wk "quit")
   "e"     '(nil                     :wk "eval")
   "g"     '(nil :wk "go")
   "s"     '(project-eshell          :wk "shell")
   "w"     '(nil                     :wk "window")
   "wd"    '(delete-frame            :wk "delete")
   "wn"    '(make-frame-command      :wk "new")
   "wo"    '(other-window            :wk "other")))

(use-package +help
  :no-require t

  :general
  (:states 'normal
   :prefix "SPC"
   "h"  '(nil              :wk "help")
   "hf" '(helpful-callable :wk "callable")
   "hk" '(helpful-key      :wk "key")
   "hi" '(consult-info     :wk "info")
   "hm" '(consult-man      :wk "man")
   "hv" '(helpful-variable :wk "variable")))

(use-package +vc
  :no-require t

  :general
  (:states 'normal
   :prefix "SPC"
   "v"     '(nil   :wk "vc")
   "vr"    '(vc-region-history :wk "region history")
   "vv"    '(magit-project-status :wk "magit")))

(use-package centered-cursor-mode
  :init (global-centered-cursor-mode))

(use-package consult
  :general
  (:states 'normal
   :prefix "SPC"
   "/"     '(consult-ripgrep        :wk "find text in project")
   "F"     '(consult-buffer         :wk "find")
   "b"     '(consult-buffer         :wk "buffer")
   "f"     '(consult-project-buffer :wk "find in project")
   "y"     '(consult-imenu          :wk "imenu"))

  :config
  (setq +consult-source-project-files
        `(:category file
          :name "Project File"
          :items ,(lambda ()
                    (let* ((default-directory (consult--project-root))
                           (in (process-lines "fd" "--color=never" "--strip-cwd-prefix=always" "--type=file"))
                           out)
                      (dolist (f in (reverse out))
                        (setq out (cons (file-relative-name f) out)))))
          :action ,(lambda (f)
                     (find-file (file-name-concat (consult--project-root) f)))))

  (setq consult-project-buffer-sources '(consult--source-project-buffer +consult-source-project-files)))

(use-package corfu
  :custom
  (corfu-auto t)

  :init
  (global-corfu-mode 1))

(use-package diff-hl
  :custom
  (diff-hl-show-staged-changes nil)

  :general
  (:states 'normal
   :prefix "SPC"
   "vs"    '(diff-hl-stage-dwim :wk "stage hunk(s)"))

  :init
  (global-diff-hl-mode))

(use-package embark
  :custom
  (embark-indicators '(embark-minimal-indicator embark-highlight-indicator))

  :general
  (:states 'normal 
   ";" 'embark-act)
  (:keymaps 'embark-symbol-map
   "h" 'helpful-symbol))

(use-package embark-consult
  :hook (embark-collect-mode . consult-preview-at-point-mode))

(use-package eshell
  :custom
  (eshell-prefer-lisp-functions t))

(use-package evil
  :preface
  (setq evil-want-C-u-scroll t)
  (setq evil-want-keybinding nil)

  :custom
  (evil-mode-line-format nil)
  (evil-shift-width 2)
  (evil-undo-system 'undo-fu)
  (evil-want-minibuffer t)

  :general
  (:states 'normal
   "s"     'evil-avy-goto-char-timer)

  :init
  (evil-mode 1))

(use-package evil-cleverparens
  :hook emacs-lisp-mode)

(use-package evil-collection
  :custom
  (evil-collection-setup-minibuffer t)

  :config
  (evil-collection-init))

(use-package evil-commentary
  :hook evil-mode)

(use-package evil-goggles
  :hook
  (evil-mode
   (evil-mode . evil-goggles-use-diff-faces)))

(use-package evil-indent-plus
  :config
  (evil-indent-plus-default-bindings))

(use-package evil-matchit
  :config
  (evilmi-load-plugin-rules '(ruby-ts-mode) '(simple ruby))

  :hook (evil-mode . global-evil-matchit-mode))

(use-package evil-surround
  :hook (evil-mode . global-evil-surround-mode))

(use-package forge
  :custom
  (forge-add-default-bindings nil)

  :custom-face
  (forge-pullreq-open ((t (:foreground "#458588")))))

(use-package helpful
  :init
  (add-to-list 'display-buffer-alist '("\\`\\*helpful" . ((display-buffer-same-window)
                                                          (reusable-frames . 0)))))
(use-package inf-ruby
  :preface
  (defvar +rails-console-production-command)

  (defun +rails-console-development ()
    (interactive)
    (let ((default-directory (project-root (project-current))))
      (inf-ruby-console-run "rails console" "rails-development")))

  (defun +rails-console-production ()
    (interactive)
    (let ((default-directory (project-root (project-current))))
      (inf-ruby-console-run +rails-console-production-command "rails-production")))

  :general
  (:states 'normal
   :prefix "SPC"
   "g"     '(nil :wk "go")
   "gd"    '(+rails-console-development :wk "dev console")
   "gp"    '(+rails-console-production  :wk "prod console")))

(use-package js
  :mode ("\\.\\(?:js\\)" . js-ts-mode))

(use-package json-ts-mode
  :mode ("\\.\\(?:json\\)"))

(use-package lsp-mode
  :custom
  (lsp-elixir-server-command '("elixir-ls"))
  (lsp-headerline-breadcrumb-enable nil)
  (lsp-warn-no-matched-clients nil)

  :hook (prog-mode . lsp-deferred))

(use-package lsp-ui
  :custom
  (lsp-ui-doc-delay 1.5))

(use-package magit
  :general
  (:keymaps '(magit-status-mode-map)
   "SPC" nil)

  :init
  (dolist (regex '("\\`magit-revision:" "\\`magit-log:" "\\`magit:"))
    (add-to-list 'display-buffer-alist `(,regex . ((display-buffer-same-window) (reusable-frames . 0))))))

(use-package marginalia
  :init (marginalia-mode 1))

(use-package nix-ts-mode
  :mode "\\.nix\\'")

(use-package orderless
  :custom
  (completion-styles '(orderless basic)))

(use-package prodigy
  :preface
  (defun +prodigy-set-up-for-project ()
    (hack-dir-local-variables-non-file-buffer)

    (let (lst)
      (setq prodigy-services
            (dolist (srv prodigy-services lst)
              (setq lst (cons (plist-put srv :cwd default-directory) lst)))))

    (prodigy-refresh))

  :general
  (:states 'normal
   :prefix "SPC"
   "gr" '(prodigy :wk "services"))

  :hook
  (prodigy-mode . +prodigy-set-up-for-project))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package ruby-ts-mode
  :mode ("\\.\\(?:rb\\)" "\\`Gemfile\\'"))

(use-package smartparens
  :config
  (require 'smartparens-config)

  :hook
  (prog-mode . smartparens-mode)
  (emacs-lisp-mode . smartparens-strict-mode))

(use-package undo-fu-session
  :init (undo-fu-session-global-mode 1))

(use-package vertico
  :custom
  (vertico-cycle t)

  :init (vertico-mode 1))

(use-package web-mode
  :custom
  (web-mode-code-indent-offset 2)
  (web-mode-css-indent-offset 2)
  (web-mode-markup-indent-offset 2)

  :mode "\\.html\\.erb\\'")

(use-package which-key
  :init (which-key-mode 1))
