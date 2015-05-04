
(require 'compile)

(defgroup paket nil
  "Paket tooling for Emacs"
  :prefix "paket-")

(defconst paket-buffer-name "*paket*"
  "The buffer for Paket results")

(defcustom paket-program-name "paket"
  "The shell command for Paket"
  :type 'string)

(defcustom paket-hard-by-default t
  "Whether to add the --hard switch to commands"
  :type 'boolean)

(defun paket-find-root ()
  (locate-dominating-file
   (file-name-as-directory
    (file-name-directory buffer-file-name))
   "paket.dependencies"))

(define-compilation-mode paket-buffer-mode "Paket"
  "Paket buffer mode.")

(defun add-switches (command)
  (if paket-hard-by-default
      (concat command " --hard")
    command))

(defun paket-send-command (command)
  (let ((default-directory (paket-find-root)))
    (if default-directory
        (with-current-buffer
            (compilation-start (add-switches command)
                               nil
                               (lambda (x) paket-buffer-name)))
      (message "Unable to find paket.dependencies"))))

(defun paket-install ()
  (interactive)
  (paket-send-command "paket install"))

(defun paket-add-nuget (package)
  (interactive
   (list
    (read-string "Package name:")))
  (paket-send-command (concat "paket add nuget " package)))

(setq dependencies-keywords
      '(("nuget \\|source " . font-lock-type-face)))

(define-derived-mode paket-mode fundamental-mode
  (setq font-lock-defaults '(dependencies-keywords))
  (setq mode-name "Paket"))

(add-to-list 'auto-mode-alist '("paket.dependencies" . paket-mode))
