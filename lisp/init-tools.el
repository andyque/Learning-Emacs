;;; init-tools.el -*- lexical-binding: t no-byte-compile: t -*-

;; Copyright (C) 2021-2022 zilongshanren

;; Author: zilongshanren <guanghui8827@gmail.com>
;; URL: https://github.com/zilongshanren/emacs.d


;; This file is not part of GNU Emacs.
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 3, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth
;; Floor, Boston, MA 02110-1301, USA.
;;


(use-package highlight-global
  :ensure nil
  :commands (highlight-frame-toggle)
  :quelpa (highlight-global :fetcher github :repo "glen-dai/highlight-global")
  :config
  (progn
    (setq-default highlight-faces
                  '(('hi-red-b . 0)
                    ('hi-aquamarine . 0)
                    ('hi-pink . 0)
                    ('hi-blue-b . 0)))))


(use-package symbol-overlay)

(use-package markdown-mode)


(use-package visual-regexp
  :defer
  :commands (vr/replace vr/query-replace))

(use-package visual-regexp-steroids
  :defer
  :commands (vr/select-replace vr/select-query-replace)
  :init
  (progn
    (define-key global-map (kbd "C-c C-r") 'vr/replace)
    (define-key global-map (kbd "C-c C-q") 'vr/query-replace)))

(use-package discover-my-major
  :defer t
    :init
    )


(use-package youdao-dictionary
  :commands (youdao-dictionary-search-at-point+)
  :init
  (global-set-key (kbd "C-c y") 'youdao-dictionary-search-at-point+))


(use-package iedit
  :ensure t
  :config
  (define-key iedit-mode-keymap (kbd "M-h") 'iedit-restrict-function)
  (define-key iedit-mode-keymap (kbd "M-i") 'iedit-restrict-current-line))

(use-package expand-region
  :config
  (defadvice er/prepare-for-more-expansions-internal
      (around helm-ag/prepare-for-more-expansions-internal activate)
    ad-do-it
    (let ((new-msg (concat (car ad-return-value)
                           ", H to highlight in buffers"
                           ", / to search in project, "
                           "e iedit mode in functions"
                           "f to search in files, "
                           "b to search in opened buffers"))
          (new-bindings (cdr ad-return-value)))
      (cl-pushnew
       '("H" (lambda ()
               (interactive)
               (call-interactively
                'zilongshanren/highlight-dwim)))
       new-bindings)
      (cl-pushnew
       '("/" (lambda ()
               (interactive)
               (call-interactively
                'my/search-project-for-symbol-at-point)))
       new-bindings)
      (cl-pushnew
       '("e" (lambda ()
               (interactive)
               (call-interactively
                'iedit-mode)))
       new-bindings)
      (cl-pushnew
       '("f" (lambda ()
               (interactive)
               (call-interactively
                'find-file)))
       new-bindings)
      (cl-pushnew
       '("b" (lambda ()
               (interactive)
               (call-interactively
                'consult-line)))
       new-bindings)
      (setq ad-return-value (cons new-msg new-bindings))))

  )

(use-package prodigy
  :commands (prodigy)
  :defer 1
  :config
  (progn

    ;; define service
    (prodigy-define-service
      :name "Hugo Server"
      :command "hugo"
      :args '("server" "-D" "--navigateToChanged" "-t" "even")
      :cwd blog-admin-dir
      :tags '(hugo server)
      :kill-signal 'sigkill
      :kill-process-buffer-on-stop t)

    (prodigy-define-service
      :name "hugo Deploy"
      :command "bash"
      :args '("./deploy.sh")
      :cwd blog-admin-dir
      :tags '(hugo deploy)
      :kill-signal 'sigkill
      :kill-process-buffer-on-stop t)))





;;
(use-package separedit
  :ensure t
  :init
  (define-key prog-mode-map (kbd "C-c '") #'separedit)
  (define-key minibuffer-local-map (kbd "C-c '") #'separedit)
  (define-key help-mode-map (kbd "C-c '") #'separedit)


  ;; Default major-mode for edit buffer
  ;; can also be other mode e.g. ‘org-mode’.
  (setq separedit-default-mode 'markdown-mode))


(use-package protobuf-mode
  :ensure t
  :config
  (define-key protobuf-mode-map (kbd "RET") 'av/auto-indent-method-maybe))



;; https://github.com/emacsorphanage/quickrun
(use-package quickrun
  :ensure t
  :commands (quickrun)
  :init
  (setq quickrun-option-cmd-alist '((:command . "g++")
                                   (:exec    . ("%c -std=c++0x -o %n %s"
                                                "%n apple orange melon"))
                                   (:remove  . ("%n")))))

(use-package uuidgen
  :ensure t
  :commands (uuidgen))

(use-package link-hint
  :ensure t
  :defer t)

(use-package keycast
  :ensure t
  :commands (+toggle-keycast)
  :config
  (defun +toggle-keycast()
    (interactive)
    (if (member '("" keycast-mode-line " ") global-mode-string)
        (progn (setq global-mode-string (delete '("" keycast-mode-line " ") global-mode-string))
               (remove-hook 'pre-command-hook 'keycast--update)
               (message "Keycast OFF"))
      (add-to-list 'global-mode-string '("" keycast-mode-line " "))
      (add-hook 'pre-command-hook 'keycast--update t)
      (message "Keycast ON"))))

(use-package sudo-edit
  :ensure t)

(when (or sys/mac-x-p sys/linux-x-p (daemonp))
  (use-package  vterm
    :ensure t
    ))

(setq tramp-adb-program "/Applications/Unity/Hub/Editor/2021.3.4f1c1/PlaybackEngines/AndroidPlayer/SDK/platform-tools/adb")
(provide 'init-tools)
