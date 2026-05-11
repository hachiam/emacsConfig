;;; Emacs 30.2 For Windows10 

;; Set the path for the custom file
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
;; Load the custom file if it exists, without throwing an error if it doesn't
(when (file-exists-p custom-file)
  (load custom-file))

(require 'package)
(setq package-archives '(("gnu"    . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
                         ("nongnu" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/nongnu/")
                         ("melpa"  . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;;启动加速 
(setq package-quickstart t
      inhibit-compacting-font-caches t)

;;; ==================== 启动全屏 ====================
(add-hook 'window-setup-hook 'toggle-frame-fullscreen t)

;;; ==================== 基础界面 ====================
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

(setq inhibit-startup-screen t
      inhibit-splash-screen t
      frame-title-format "Emacs 30.2")
(setq ring-bell-function 'ignore)

;; 滚动流畅
(setq scroll-margin 3
      scroll-conservatively 100000
      mouse-wheel-scroll-amount '(1 ((shift) . 3))
      mouse-wheel-progressive-speed nil
      fast-but-imprecise-scrolling t)

;; 关闭备份
(setq make-backup-files nil
      auto-save-default t)
;;; base package
(use-package which-key
	     :ensure t
	     :init (which-key-mode))
(use-package vertico ;; 补全界面优化
	     :ensure t
	     :config
	     (vertico-mode))
(use-package orderless ;;无序搜索
	     :ensure t
	     :custom
	     (completion-styles '(orderless basic))
	     (completion-category-defaults nil)
	     (completion-category-overrides '((file (styles partial-completion)))))
;; 设置主题
(use-package doom-themes
  :ensure t
  :custom
  ;; Global settings (defaults)
  (doom-themes-enable-bold t)   ; if nil, bold is universally disabled
  (doom-themes-enable-italic t) ; if nil, italics is universally disabled
  ;; for treemacs users
  (doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
  :config
  (load-theme 'doom-gruvbox-light t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Enable custom neotree theme (nerd-icons must be installed!)
  (doom-themes-neotree-config)
  ;; or for treemacs users
  (doom-themes-treemacs-config)
  ;; Corrects (and improves) org-mode's native fontification.
	     (doom-themes-org-config))

(use-package nyan-mode
	     :ensure t
	     :config
	     (nyan-mode 1))

(use-package dashboard
	     :ensure t
	     :config
	     (dashboard-setup-startup-hook)

	     (setq dashboard-banner-logo-title "Start for Hacking!!!")
	     (setq dashboard-items '((recents   . 5)
				     (agenda    . 5)
				     ))
	     )


;;; ==================== 行号 + 当前行高亮 ====================
(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)
(global-hl-line-mode 1)
;;(set-face-background 'hl-line "#e8f4ff")

;;; ==================== 窗口管理 ====================
(use-package winner
  :config (winner-mode 1))

(use-package ace-window
  :bind ("M-o" . ace-window)
  :config (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))

;;; ==================== 文件搜索 ====================
(use-package ivy
  :diminish ivy-mode
  :config (ivy-mode 1))

(use-package counsel
  :bind (("C-x f" . counsel-find-file)
         ("C-x b" . counsel-switch-buffer)
         ("M-x" . counsel-M-x)))

(use-package swiper
  :bind ("C-s" . swiper))


;;; ==================== Company 补全 ====================
(use-package company
  :hook (after-init . global-company-mode)
  :config
  (setq company-minimum-prefix-length 1
        company-idle-delay 0.1
        company-selection-wrap-around t
        company-show-numbers t))

;;; ==================== 括号自动补全 + 彩虹括号 ====================
(use-package smartparens
  :config (smartparens-global-mode t))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;;; ==================== Common Lisp ====================
(use-package slime
  :config
  (setq inferior-lisp-program "sbcl")
  (slime-setup '(slime-fancy slime-repl)))

(use-package paren-face
  :config (global-paren-face-mode t))

;;; =================org-mode========================

(use-package org-roam
	     :ensure t
	     :custom
	     (org-roam-directory "c:/workspace/roam-notes/")
	     (org-roam-dailies-directory "daily/")
	     (org-roam-db-gc-threshold most-positive-fixnum)
	     :bind (("C-c n f" . org-roam-node-find)
		    ("C-c n i" . org-roam-node-insert)
		    ("C-c n c" . org-roam-capture)
		    ("C-c n l" . org-roam-buffer-toggle) ;;显示后链窗口
		    ("C-c n u" . org-roam-ui-mode)) ;;浏览器中可视化
	     :bind-keymap
	     ("C-c n d" . org-roam-dailies-map) ;;日记菜单
	     :config
	     (require 'org-roam-dailies) ;;启用日记功能
	     (org-roam-db-autosync-mode)) ;;启动时自动同步数据库

(use-package org-roam-ui
	     :ensure t
	     :after org-roam
	     :custom
	     (org-roam-ui-sync-theme t);;同步emacs主题
	     (org-roam-ui-follow t)
	     (org-roam-ui-update-on-save t)) 
;;; ==================== magit =========================
(use-package magit
	     :ensure t
	     :config

	     ;; 优化magit在windows10上的性能
	     (setq magit-refresh-status-buffer t)
	     (setq magit-auto-revert-mode nil)
	     )
(let ((git-path "c:/personalProgram/Git/bin/git.exe"))
  (when (file-exists-p git-path)
    (setq magit-git-executable git-path)))
;;; ==================== 代码格式化 ====================
(setq default-tab-width 2
      lisp-body-indent 2
      lisp-indent-function 'common-lisp-indent-function
      indent-tabs-mode nil)

(global-set-key (kbd "C-c f")
                (lambda ()
                  (interactive)
                  (mark-whole-buffer)
                  (indent-region (point-min) (point-max))
                  (message "代码格式化完成！")))

(electric-indent-mode 1)

;;; ==================== 快捷键 ====================
(global-set-key (kbd "C-c w") 'ace-window)
(global-set-key (kbd "C-c W") 'winner-undo)
(global-set-key (kbd "C-c C-l") 'slime)
(global-set-key (kbd "C-c C-k") 'slime-compile-and-load-file)
(global-set-key (kbd "C-c e")
                (lambda ()
                  (interactive)
                  (find-file (expand-file-name "init.el" user-emacs-directory))))

(defun open-init-file()
  (interactive)
  (find-file "~/.emacs.d/init.el"))
  
(global-set-key (kbd "<f2>") 'open-init-file)
;;; ==================== 基础优化 不错====================
(setq column-number-mode t)
(show-paren-mode t)
;; 设置默认字体为 Sarasa Mono SC，字号建议 14 或 16 (根据 DPI 调整)
(set-face-attribute 'default nil
                    :font "Sarasa Mono SC-14")

;; 或者使用更稳妥的 alist 设置，确保新建的 frame 也生效
(add-to-list 'default-frame-alist '(font . "Sarasa Mono SC-14"))
(provide 'init)
