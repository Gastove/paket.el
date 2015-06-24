(defun paket--search-packages (search)
  (let ((executable (paket-find-executable paket-executable)))
    (process-lines executable "find-packages" "searchtext" search "-s")))

(defun paket-add-nuget (package)
  "Add a Nuget PACKAGE with Paket."
  (interactive
   (list
    (completing-read "Package name: " (completion-table-with-cache 'paket--search-packages))))
  (paket--send-command (concat "add nuget " package)))

(provide 'paket-add)
