(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
;;(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")

(setq make-backup-files nil)
(setq auto-save-default nil)

(package-initialize)

;; Turn off some unneeded UI elements
(menu-bar-mode -1)  ; Leave this one on if you're a beginner!
(tool-bar-mode -1)
(scroll-bar-mode -1)

(setq scroll-step            1
      scroll-conservatively  10000
      scroll-margin 7)

(global-set-key (kbd "C-=") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "C-c b k") 'kill-current-buffer)
(global-set-key (kbd "C-c s") 'shell-command)
(global-set-key (kbd "C-c b i") 'ibuffer)
(global-set-key (kbd "C-c t t") 'vterm-toggle)

(add-hook 'typescript-ts-mode-hook 'flymake-mode)

(set-face-attribute 'default nil
                    :font "monospace"
                    :height 170
                    :weight 'normal
                    :inverse-video nil
                    :slant 'normal)


(load-theme 'oxocarbon)
(set-frame-parameter nil 'alpha-background 100)
(setq column-number-mode t)

(add-hook 'prog-mode-hook #'display-fill-column-indicator-mode)

;; Display line numbers in every buffer
(global-display-line-numbers-mode 1)

(setq treesit-language-source-alist
   '((bash "https://github.com/tree-sitter/tree-sitter-bash")
     (cmake "https://github.com/uyha/tree-sitter-cmake")
     (c "https://github.com/tree-sitter/tree-sitter-c")
     (cpp "https://github.com/tree-sitter/tree-sitter-cpp")
     (css "https://github.com/tree-sitter/tree-sitter-css")
     (elisp "https://github.com/Wilfred/tree-sitter-elisp")
     (go "https://github.com/tree-sitter/tree-sitter-go")
     (html "https://github.com/tree-sitter/tree-sitter-html")
     (javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src")
     (json "https://github.com/tree-sitter/tree-sitter-json")
     (make "https://github.com/alemuller/tree-sitter-make")
     (vue "https://github.com/ikatyang/tree-sitter-vue")
     (markdown "https://github.com/ikatyang/tree-sitter-markdown")
     (python "https://github.com/tree-sitter/tree-sitter-python")
     (toml "https://github.com/tree-sitter/tree-sitter-toml")
     (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
     (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
     (yaml "https://github.com/ikatyang/tree-sitter-yaml")))

;; (use-package tide
;;   :ensure t
;;   :after (company flycheck)
;;   :hook ((typescript-ts-mode . tide-setup)
;;          (tsx-ts-mode . tide-setup)
;;          (typescript-ts-mode . tide-hl-identifier-mode)
;;          (before-save . tide-format-before-save)))

(use-package dashboard
	;; :ensure nil
	:config
	(dashboard-setup-startup-hook))

(use-package expand-region
	:bind ("C-;" . er/expand-region))

(use-package flymake-cspell
	:hook(
				(c-ts-mode . flymake-cspell-setup)
				(typescript-ts-mode . flymake-cspell-setup)
				))

(use-package ibuffer-projectile)
(add-hook 'ibuffer-hook
    (lambda ()
      (ibuffer-projectile-set-filter-groups)
      (unless (eq ibuffer-sorting-mode 'alphabetic)
        (ibuffer-do-sort-by-alphabetic))))

(use-package multiple-cursors
	:bind (
	       ("C-." . 'mc/mark-next-like-this)
	       ("C-," . 'mc/mark-previous-like-this)
	       ("C-S-c" . 'mc/edit-lines)
	       ))

(use-package which-key
;;	:ensure nil
	:init (which-key-mode))

(use-package lsp-mode
;;	:ensure nil
  :init
	(setq-default lsp-headerline-breadcrumb-enable nil)
	(setq lsp-keymap-prefix "C-c l")
  :hook (
				 (c-ts-mode . lsp)
				 (typescript-ts-mode . lsp)
         (js-json-mode . lsp)
				 ))

(use-package evil
;;	:ensure nil
	:init (evil-mode 0))

(use-package company
;;	:ensure nil
  :init
  (add-hook 'after-init-hook 'global-company-mode))

(use-package yasnippet
;;	:ensure nil
  :init
  (add-hook 'prog-mode-hook #'yas-minor-mode))

(use-package yasnippet-snippets)

(use-package beacon
;;	:ensure nil
  :init
  (beacon-mode +1))

(use-package dirvish
;;	:ensure nil
	:init
	(dirvish-override-dired-mode))

(use-package projectile
;;	:ensure nil
  :init
  (projectile-mode +1)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))

;; Example configuration for Consult
(use-package consult
;;	:ensure nil
  ;; Replace bindings. Lazily loaded due by `use-package'.
  :bind (;; C-c bindings in `mode-specific-map'
         ("C-c M-x" . consult-mode-command)
         ("C-c h" . consult-history)
         ("C-c k" . consult-kmacro)
         ("C-c m" . consult-man)
         ("C-c i" . consult-info)
         ([remap Info-search] . consult-info)
         ;; C-x bindings in `ctl-x-map'
         ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
         ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
         ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
         ("C-x t b" . consult-buffer-other-tab)    ;; orig. switch-to-buffer-other-tab
         ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
         ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ;; M-g bindings in `goto-map'
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flymake)               ;; Alternative: consult-flycheck
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings in `search-map'
         ("M-s d" . consult-find)                  ;; Alternative: consult-fd
         ("M-s c" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
         ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
         ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
         ("M-s L" . consult-line-multi)            ;; needed by consult-line to detect isearch
         ;; Minibuffer history
         :map minibuffer-local-map
         ("M-s" . consult-history)                 ;; orig. next-matching-history-element
         ("M-r" . consult-history))                ;; orig. previous-matching-history-element

  ;; Enable automatic preview at point in the *Completions* buffer. This is
  ;; relevant when you use the default completion UI.
  :hook (completion-list-mode . consult-preview-at-point-mode)

  ;; The :init configuration is always executed (Not lazy)
  :init

  ;; Optionally configure the register formatting. This improves the register
  ;; preview for `consult-register', `consult-register-load',
  ;; `consult-register-store' and the Emacs built-ins.
  (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format)

  ;; Optionally tweak the register preview window.
  ;; This adds thin lines, sorting and hides the mode line of the window.

  (advice-add #'register-preview :override #'consult-register-window)
  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  ;; Configure other variables and modes in the :config section,
  ;; after lazily loading the package.
  :config

  ;; Optionally configure preview. The default value
  ;; is 'any, such that any key triggers the preview.
  ;; (setq consult-preview-key 'any)
  ;; (setq consult-preview-key "M-.")
  ;; (setq consult-preview-key '("S-<down>" "S-<up>"))
  ;; For some commands and buffer sources it is useful to configure the
  ;; :preview-key on a per-command basis using the `consult-customize' macro.
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   consult--source-bookmark consult--source-file-register
   consult--source-recent-file consult--source-project-recent-file

   ;; :preview-key "M-."
   :preview-key '(:debounce 0.4 any))

  ;; Optionally configure the narrowing key.
  ;; Both < and C-+ work reasonably well.
  (setq consult-narrow-key "<") ;; "C-+"

  ;; Optionally make narrowing help available in the minibuffer.
  ;; You may want to use `embark-prefix-help-command' or whichl-key instead.
  ;; (define-key consult-narrow-map (vconcat consult-narrow-key "?") #'consult-narrow-help)

  ;; By default `consult-project-function' uses `project-root' from project.el.
  ;; Optionally configure a different project root function.
  ;;;; 1. project.el (the default)
  ;; (setq consult-project-function #'consult--default-project--function)
  ;;;; 2. vc.el (vc-root-dir)
  ;; (setq consult-project-function (lambda (_) (vc-root-dir)))
  ;;;; 3. locate-dominating-file
  ;; (setq consult-project-function (lambda (_) (locate-dominating-file "." ".git")))
  ;;;; 4. projectile.el (projectile-project-root)
  ;; (autoload 'projectile-project-root "projectile")
  ;; (setq consult-project-function (lambda (_) (projectile-project-root)))
  ;;;; 5. No project support
  ;; (setq consult-project-function nil)
)
;; Enable vertico
(use-package vertico
;;	:ensure nil
  :init
  (vertico-mode)

  ;; Different scroll margin
  ;; (setq vertico-scroll-margin 0)

  ;; Show more candidates
  ;; (setq vertico-count 20)

  ;; Grow and shrink the Vertico minibuffer
  ;; (setq vertico-resize t)

  ;; Optionally enable cycling for `vertico-next' and `vertico-previous'.
  ;; (setq vertico-cycle t)
  )

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :init
  (savehist-mode))

;; A few more useful configurations...
(use-package emacs
  :init
  ;; Add prompt indicator to `completing-read-multiple'.
  ;; We display [CRM<separator>], e.g., [CRM,] if the separator is a comma.
  (defun crm-indicator (args)
    (cons (format "[CRM%s] %s"
                  (replace-regexp-in-string
                   "\\`\\[.*?]\\*\\|\\[.*?]\\*\\'" ""
                  crm-separator)
                  (car args))
          (cdr args)))
  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

  ;; Do not allow the cursor in the minibuffer prompt
  (setq minibuffer-prompt-properties
        '(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

  ;; Support opening new minibuffers from inside existing minibuffers.
  (setq enable-recursive-minibuffers t)

  ;; Emacs 28 and newer: Hide commands in M-x which do not work in the current
  ;; mode.  Vertico commands are hidden in normal buffers. This setting is
  ;; useful beyond Vertico.
  (setq read-extended-command-predicate #'command-completion-default-include-p))

;; Optionally use the `orderless' completion style.
(use-package orderless
;;	:ensure nil
  :init
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (setq orderless-style-dispatchers '(+orderless-consult-dispatch orderless-affix-dispatch)
  ;;       orderless-component-separator #'orderless-escapable-split-on-space)
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(setq auto-mode-alist
      (append '(("\\.cpp\\'" . c-ts-mode)
								("\\.hpp\\'" . c-ts-mode)
								("\\.c\\'" . c-ts-mode)
								("\\.h\\'" . c-ts-mode)
								("\\.js'" . typescript-ts-mode)
								("\\.ts'" . typescript-ts-mode)
								("\\.mjs'" . typescript-ts-mode)
								("\\.es6'" . typescript-ts-mode))
							auto-mode-alist))

(add-to-list 'major-mode-remap-alist '(c++-ts-mode . c-ts-mode))
(add-to-list 'major-mode-remap-alist '(c-mode . c-ts-mode))
(add-to-list 'major-mode-remap-alist
             '(c-or-c++-ts-mode . c-ts-mode))
(add-to-list 'major-mode-remap-alist '(javascript-mode . typescript-ts-mode))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(c-basic-offset 2)
 '(c-ts-mode-indent-style 'linux)
 '(custom-safe-themes
   '("3d39093437469a0ae165c1813d454351b16e4534473f62bc6e3df41bb00ae558" "e851241d1926c2f4383201b0826076578ca18f72f58281dd15a7cc7f3d2381df" "96ca43d04079c6f4273f65174d52de6c6443f98cc745da5284242ca3733dba95" "00010488d151611d5657ad62d1ef0f25ca6354ddb09afe43918076e78c89301f" "b25b7cde93ca3acfb5b0ad92ff49fcde910eafe6f2589bea941a6f9ba71676d4" "b9826aa465617d413b4ae3ad4048b954e2104c570afac22083fdb9632221bb38" "ba5a4f070f3a6223af79e6661a77992245d474a35ecfa0aabd2010e42cf45149" "2c7fe375db3c3ab9fd26634edba5829e40b8ab6a872e082f5ac739abdfe28a92" "ccacbbcf2d5acff1d4274cb8e45200b0d29fcd4af996c240d71f95e750f74197" "d02e8b60e485333a848d301bf2ad07994b0501d46eaa687a7303c44a5626521c" "f490984d405f1a97418a92f478218b8e4bcc188cf353e5dd5d5acd2f8efd0790" "2d035eb93f92384d11f18ed00930e5cc9964281915689fa035719cab71766a15" "35c096aa0975d104688a9e59e28860f5af6bb4459fd692ed47557727848e6dfe" "28a104f642d09d3e5c62ce3464ea2c143b9130167282ea97ddcc3607b381823f" "5efa59da0b446dd939749e86fdf414ef2b666f80243999633d9e2e4fd22fd37c" "317754d03bb6d85b5a598480e1bbee211335bbf496d441af4992bbf1e777579e" "f5f80dd6588e59cfc3ce2f11568ff8296717a938edd448a947f9823a4e282b66" "ffafb0e9f63935183713b204c11d22225008559fa62133a69848835f4f4a758c" "aa688776604bbddbaba9e0c0d77e8eb5f88d94308f223d1962b6e6b902add6a0" "9d5124bef86c2348d7d4774ca384ae7b6027ff7f6eb3c401378e298ce605f83a" "f64189544da6f16bab285747d04a92bd57c7e7813d8c24c30f382f087d460a33" "93011fe35859772a6766df8a4be817add8bfe105246173206478a0706f88b33d" "7ec8fd456c0c117c99e3a3b16aaf09ed3fb91879f6601b1ea0eeaee9c6def5d9" "063095cf0fe6ed3990546ec77e5d3798a1e2ad5043350063467a71c69518bb24" "263e3a9286c7ab0c4f57f5d537033c8a5943e69d142e747723181ab9b12a5855" "702d0136433ca65a7aaf7cc8366bd75e983fe02f6e572233230a528f25516f7e" "841b6a0350ae5029d6410d27cc036b9f35d3bf657de1c08af0b7cbe3974d19ac" "f1b2de4bc88d1120782b0417fe97f97cc9ac7c5798282087d4d1d9290e3193bb" "691d671429fa6c6d73098fc6ff05d4a14a323ea0a18787daeb93fde0e48ab18b" "7c28419e963b04bf7ad14f3d8f6655c078de75e4944843ef9522dbecfcd8717d" "9f297216c88ca3f47e5f10f8bd884ab24ac5bc9d884f0f23589b0a46a608fe14" "e27c9668d7eddf75373fa6b07475ae2d6892185f07ebed037eedf783318761d7" "c1d5759fcb18b20fd95357dcd63ff90780283b14023422765d531330a3d3cec2" "4b6cc3b60871e2f4f9a026a5c86df27905fb1b0e96277ff18a76a39ca53b82e1" "2078837f21ac3b0cc84167306fa1058e3199bbd12b6d5b56e3777a4125ff6851" "456697e914823ee45365b843c89fbc79191fdbaff471b29aad9dcbe0ee1d5641" "da75eceab6bea9298e04ce5b4b07349f8c02da305734f7c0c8c6af7b5eaa9738" "dccf4a8f1aaf5f24d2ab63af1aa75fd9d535c83377f8e26380162e888be0c6a9" "77fff78cc13a2ff41ad0a8ba2f09e8efd3c7e16be20725606c095f9a19c24d3d" "aec7b55f2a13307a55517fdf08438863d694550565dee23181d2ebd973ebd6b8" "014cb63097fc7dbda3edf53eb09802237961cbb4c9e9abd705f23b86511b0a69" "0c83e0b50946e39e237769ad368a08f2cd1c854ccbcd1a01d39fdce4d6f86478" "2721b06afaf1769ef63f942bf3e977f208f517b187f2526f0e57c1bd4a000350" "b5fd9c7429d52190235f2383e47d340d7ff769f141cd8f9e7a4629a81abc6b19" "10e5d4cc0f67ed5cafac0f4252093d2119ee8b8cb449e7053273453c1a1eb7cc" "34cf3305b35e3a8132a0b1bdf2c67623bc2cb05b125f8d7d26bd51fd16d547ec" "4ade6b630ba8cbab10703b27fd05bb43aaf8a3e5ba8c2dc1ea4a2de5f8d45882" "13096a9a6e75c7330c1bc500f30a8f4407bd618431c94aeab55c9855731a95e1" "8d3ef5ff6273f2a552152c7febc40eabca26bae05bd12bc85062e2dc224cde9a" "88f7ee5594021c60a4a6a1c275614103de8c1435d6d08cc58882f920e0cec65e" "8c7e832be864674c220f9a9361c851917a93f921fedb7717b1b5ece47690c098" "81f53ee9ddd3f8559f94c127c9327d578e264c574cda7c6d9daddaec226f87bb" "7e377879cbd60c66b88e51fad480b3ab18d60847f31c435f15f5df18bdb18184" "4594d6b9753691142f02e67b8eb0fda7d12f6cc9f1299a49b819312d6addad1d" "5f128efd37c6a87cd4ad8e8b7f2afaba425425524a68133ac0efd87291d05874" "d19f00fe59f122656f096abbc97f5ba70d489ff731d9fa9437bac2622aaa8b89" "d77d6ba33442dd3121b44e20af28f1fae8eeda413b2c3d3b9f1315fbda021992" "0c860c4fe9df8cff6484c54d2ae263f19d935e4ff57019999edbda9c7eda50b8" default))
 '(desktop-save-mode nil)
 '(display-line-numbers 'relative)
 '(display-line-numbers-type 'visual)
 '(electric-indent-mode nil)
 '(evil-auto-indent nil)
 '(fill-column 80)
 '(indent-tabs-mode nil)
 '(js-indent-level 2)
 '(lsp-completion-provider :none)
 '(package-selected-packages
   '(vue-mode flymake vterm-toggle tide yasnippet-snippets rainbow-mode autothemer poet-theme flymake-cspell expand-region ef-themes multiple-cursors ibuffer-projectile ensure-packages dashboard gruber-darker-theme which-key evil dirvish vterm beacon projectile yasnippet company vertico consult use-package doom-themes hc-zenburn-theme catppuccin-theme atom-one-dark-theme lsp-mode))
 '(recentf-mode t)
 '(tab-bar-mode nil)
 '(tab-width 2)
 '(treesit-font-lock-level 4)
 '(truncate-lines t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
