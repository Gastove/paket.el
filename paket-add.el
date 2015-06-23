(defvar paket-results-buffer "*paket-package-results*")

(defun paket--start-package-process (text)
  (let ((executable (paket-find-executable paket-executable)))
    (start-file-process "paket" paket-results-buffer executable "find-packages" "searchtext" text "-s" "max" "100000")))

(defun paket--find-packages-filter (proc)
  (set-process-filter
   proc
   (lambda (proc str)
     (let ((old-result package-cache))
       (setq package-cache (concat str old-result))))))

(defvar package-list (list))
(defvar cache-loaded nil)

(defun paket--fetch-packages (search)
  (setq package-cache "")
  (let ((process (paket--start-package-process search)))
    (paket--find-packages-filter process)
    (set-process-sentinel
     process
     (lambda (p e)
       (if (string-match-p "finished" e)
           (exit-recursive-edit))))
    (recursive-edit))
  (split-string package-cache "\n"))

(defun paket-add-nuget (package)
  "Add a Nuget PACKAGE with Paket."
  (interactive
   (list
    (completing-read "Package name:" (completion-table-dynamic 'paket--fetch-packages))))
  (paket--send-command (concat "add nuget " package)))

(provide 'paket-add)
