(defvar paket-results-buffer "*paket-package-results*")

(defun paket--start-package-process (text)
  (start-process "paket" paket-results-buffer "paket" "find-packages" "searchtext" text "-s" "max" "100000"))

(defun paket--find-packages-filter (proc)
  (set-process-filter
   proc
   (lambda (proc str)
     (let ((old-result package-cache))
       (setq package-cache (concat str old-result))))))

(defvar package-list (list))
(defvar cache-loaded nil)

(defun paket--fetch-packages (search)
  (message "Loading packages...")
  (setq package-cache "")
  (let ((process (paket--start-package-process search)))
    (paket--find-packages-filter process)
    (set-process-sentinel
     process
     (lambda (p e)
       (if (string-match-p "finished" e)
           (exit-recursive-edit))))
    (recursive-edit))
  (message "Packages loaded")
  (split-string package-cache "\n"))

(defun get-list ()
  (if cache-loaded
      package-list
    (progn
      (sit-for 0.5)
      (get-list))))

(defun paket-add-nuget (package)
  "Add a Nuget PACKAGE with Paket."
  (interactive
   (list
    (ido-completing-read "Package name:" (get-list))))
  (paket--send-command (concat "add nuget " package)))

(provide 'paket-add)
