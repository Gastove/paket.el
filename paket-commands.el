(defun paket--find-root ()
  (locate-dominating-file
   (file-name-as-directory
    (file-name-directory buffer-file-name))
   "paket.dependencies"))

(defun paket--prepare-command (command)
  (let ((paket-command (concat (paket-find-executable paket-executable) " " command)))
    (if paket-hard-by-default
        (concat paket-command " --hard")
      paket-command)))

(defun paket--send-command (command)
  (paket-bootstrap--ensure)
  (let ((default-directory (paket--find-root)))
    (if default-directory
        (with-current-buffer
            (compilation-start (paket--prepare-command command)
                               nil
                               (lambda (x) paket-buffer-name)))
      (message "Unable to find paket.dependencies"))))

(defun paket--revert-buffer ()
  (with-current-buffer
      (revert-buffer t t)))

(defun paket-install ()
  "Install packages with Paket."
  (interactive)
  (paket--send-command "install"))

(defun paket-restore ()
  "Restore packages with Paket."
  (interactive)
  (paket--send-command "restore"))

(defun paket-outdated ()
  "Check for outdated packages with Paket."
  (interactive)
  (paket--send-command "outdated"))

(defun paket-update ()
  "Update packages with Paket."
  (interactive)
  (paket--send-command "update"))

(provide 'paket-commands)
