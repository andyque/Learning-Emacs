#!/bin/sh -e
echo "Attempting startup..."
export HOME="/home/runner/work/.emacs.d"; \
emacs -q --batch \
        --eval "(message \"Testing...\")" \
        --eval "(let ((early-init-file (locate-user-emacs-file \"early-init.el\"))
                (user-init-file (locate-user-emacs-file \"init.el\")))
            (and (>= emacs-major-version 27) (load early-init-file))
            (load user-init-file))" \
                --eval "(message \"Testing...done\")"
echo "Startup successful"
