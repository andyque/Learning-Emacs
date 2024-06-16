(use-package gdscript-mode
  :hook (gdscript-mode . eglot-ensure)
  :init
  (progn
    (setq gdscript-godot-executable "/Applications/Godot.app/Contents/MacOS/Godot")
    (setq gdscript-use-tab-indents t) ;; If true, use tabs for indents. Default: t
    (setq gdscript-indent-offset 4)   ;; Controls the width of tab-based indents
    (setq gdscript-gdformat-save-and-format t) ;; Save all buffers and format them with gdformat anytime Godot executable is run.

    (global-leader
      :major-modes
      '(gdscript-mode t)
      ;;and the keymaps:
      :keymaps
      '(gdscript-mode-map)
      "re" 'gdscript-godot-open-project-in-editor))
  :config
  (add-to-list 'eglot-server-programs '(gdscript-mode "localhost" 6008)))

(provide 'init-game)
