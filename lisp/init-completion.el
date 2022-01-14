;;;;  -*- lexical-binding: t; -*-
(require 'init-funcs)

;;
;;; Packages

(use-package vertico
  :hook (after-init . vertico-mode)
  :config
  (setq vertico-resize nil
        vertico-count 17
        vertico-cycle t
        completion-in-region-function
        (lambda (&rest args)
          (apply (if vertico-mode
                     #'consult-completion-in-region
                   #'completion--in-region)
                 args)))
  ;; Cleans up path when moving directories with shadowed paths syntax, e.g.
  ;; cleans ~/foo/bar/// to /, and ~/foo/bar/~/ to ~/.
  (add-hook 'rfn-eshadow-update-overlay-hook #'vertico-directory-tidy)
  (add-hook 'minibuffer-setup-hook #'vertico-repeat-save)
  (define-key vertico-map (kbd "C-j") 'vertico-next)
  (define-key vertico-map (kbd "C-k") 'vertico-previous)
  (define-key vertico-map [backspace] #'vertico-directory-delete-char)
  ;; (map! :map vertico-map [backspace] #'vertico-directory-delete-char)
  )


(use-package orderless
  :config

  (setq completion-styles '(orderless)
        orderless-component-separator "[ &]")
  ;; ...otherwise find-file gets different highlighting than other commands
  (set-face-attribute 'completions-first-difference nil :inherit nil))


(use-package consult
  :defer t
  :init
  (advice-add #'completing-read-multiple :override #'consult-completing-read-multiple)
  (advice-add #'multi-occur :override #'consult-multi-occur)

  :config

  (setq ;; consult-project-root-function #'doom-project-root
        consult-narrow-key "<"
        consult-line-numbers-widen t
        consult-async-min-input 2
        consult-async-refresh-delay  0.15
        consult-async-input-throttle 0.2
        consult-async-input-debounce 0.1)


  (consult-customize
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file
   consult--source-file consult--source-project-file consult--source-bookmark
   :preview-key (kbd "C-SPC"))

  (consult-customize
   consult-theme
   :preview-key (list (kbd "C-SPC") :debounce 0.5 'any))

  ;; (after! org
  ;;         (defvar +vertico--consult-org-source
  ;;           `(:name     "Org"
  ;;                       :narrow   ?o
  ;;                       :hidden t
  ;;                       :category buffer
  ;;                       :state    ,#'consult--buffer-state
  ;;                       :items    ,(lambda () (mapcar #'buffer-name (org-buffer-list)))))
  ;;         (add-to-list 'consult-buffer-sources '+vertico--consult-org-source 'append))
  ;; (map! :map consult-crm-map
  ;;       :desc "Select candidate" "TAB" #'+vertico/crm-select
  ;;       :desc "Enter candidates" "RET" #'+vertico/crm-exit)
  )


(use-package consult-dir
  :bind (([remap list-directory] . consult-dir)
         :map vertico-map
         ("C-x C-d" . consult-dir)
         ("C-x C-j" . consult-dir-jump-file)))

(use-package consult-flycheck
  :after (consult flycheck))


(use-package embark
  :defer t
  :init
  (setq which-key-use-C-h-commands nil
        prefix-help-command #'embark-prefix-help-command)
  ;; (map! [remap describe-bindings] #'embark-bindings
  ;;       "C-;"               #'embark-act  ; to be moved to :config default if accepted
  ;;       (:map minibuffer-local-map
  ;;        "C-;"               #'embark-act
  ;;        "C-c C-;"           #'embark-export
  ;;        :desc "Export to writable buffer" "C-c C-e" #'+vertico/embark-export-write)
  ;;       (:leader
  ;;        :desc "Actions" "a" #'embark-act))
                                        ; to be moved to :config default if accepted
  :config
  ;(set-popup-rule! "^\\*Embark Export Grep" :size 0.35 :ttl 0 :quit nil)

  (define-key minibuffer-local-map (kbd "C-'") #'embark-become)

  ;; add the package! target finder before the file target finder,
  ;; so we don't get a false positive match.



  ;; (map! (:map embark-file-map
  ;;        :desc "Open target with sudo" "s" #'doom/sudo-find-file
  ;;        (:when (featurep! :tools magit)
  ;;         :desc "Open magit-status of target" "g"   #'+vertico/embark-magit-status)
  ;;        (:when (featurep! :ui workspaces)
  ;;         :desc "Open in new workspace" "TAB" #'+vertico/embark-open-in-new-workspace)))
  )


(use-package marginalia
  :hook (after-init . marginalia-mode)
  :init
  :config
  ;; (advice-add #'marginalia--project-root :override #'doom-project-root)
  ;; (pushnew! marginalia-command-categories
  ;;           '(+default/find-file-under-here. file)
  ;;           '(doom/find-file-in-emacsd . project-file)
  ;;           '(doom/find-file-in-other-project . project-file)
  ;;           '(doom/find-file-in-private-config . file)
  ;;           '(doom/describe-active-minor-mode . minor-mode)
  ;;           '(flycheck-error-list-set-filter . builtin)
  ;;           '(persp-switch-to-buffer . buffer)
  ;;           '(projectile-find-file . project-file)
  ;;           '(projectile-recentf . project-file)
  ;;           '(projectile-switch-to-buffer . buffer)
  ;;           '(projectile-switch-project . project-file))
  )


(use-package embark-consult
  :after (embark consult)
  :config
  (add-hook 'embark-collect-mode-hook #'consult-preview-at-point-mode)
  )


(use-package wgrep
  :commands wgrep-change-to-wgrep-mode
  :config (setq wgrep-auto-save-buffer t))



(provide 'init-completion)
