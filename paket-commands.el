(defun paket--find-root ()
  (locate-dominating-file
   (file-name-as-directory
    (file-name-directory buffer-file-name))
   "paket.dependencies"))

(defun paket--prepare-command (command)
  (let ((paket-command (concat paket-program-name " " command)))
    (if paket-hard-by-default
        (concat paket-command " --hard")
      paket-command)))

(defun paket--send-command (command)
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

(defun paket-remove ()
  "Remove package with Paket."
  (interactive)
  (let* ((package (get-package-at-line))
         (confirm (read-string (concat "Remove " package "? (y) "))))
    (if (string-match confirm "y")
        (paket--send-command (concat "remove " package))))
  (paket--revert-buffer))

(provide 'paket-commands)
