(defun paket--list-installed-packages ()
  (let ((executable (paket-find-executable paket-executable)))
    (process-lines executable "show-installed-packages" "-s")))

(defvar package-name-regex "\\(.*\\) -")

(defun paket-remove-nuget (package)
  (interactive
   (list
    (ido-completing-read "Package: " (paket--list-installed-packages))))
  (string-match package-name-regex package)
  (paket--send-command
   (concat "remove nuget "
           (match-string 1 package))))

(provide 'paket-remove)
