(defvar paket-results-buffer "*paket-package-results*")

(defun paket--start-package-process (text)
  (let ((executable (paket-find-executable paket-executable)))
    (start-file-process "paket" paket-results-buffer executable "find-packages" "searchtext" text "-s" "max" "100000")))

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
