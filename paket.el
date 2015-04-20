
(require 'compile)

(defgroup paket nil
  "Paket tooling for Emacs"
  :prefix "paket-")

(defconst paket-buffer-name "*paket*"
  "The buffer for Paket results")

(defcustom paket-program-name "paket"
  "The shell command for PAket"
  :type 'string)

(defun paket-find-root ()
  (locate-dominating-file
   (file-name-as-directory
    (file-name-directory buffer-file-name))
   "paket.dependencies"))

(define-compilation-mode paket-buffer-mode "Paket"
  "Paket buffer mode.")

(defun paket-send-command (command)
  (let ((default-directory (paket-find-root)))
    (with-current-buffer
        (compilation-start command
                           nil
                           (lambda (x) paket-buffer-name)))))

(defun paket-install ()
  (interactive)
  (paket-send-command "paket install --hard"))

(defun paket-add-nuget (package)
  (interactive
   (list
    (read-string "Package name:")))
  (paket-send-command (concat "paket add nuget " package)))



(define-minor-mode paket-mode
  "Mode for interacting with Paket."
  :group 'paket
  :lighter " paket")
