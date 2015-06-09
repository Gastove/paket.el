(defvar paket-bootstrap-executable "paket.bootstrapper.exe")

(defvar paket-executable "paket.exe")

(defvar paket-bootstrap-complete nil)

(defun paket-find-executable (executable)
  (or (executable-find executable)
      (concat (file-name-directory (or load-file-name buffer-file-name))
              executable)))

(defvar paket-bootstrap-command
  (paket-find-executable paket-bootstrap-executable))

(defun paket-executable-exists ()
  (file-exists-p (paket-find-executable paket-executable)))

(defun paket-bootstrap--start-process ()
  (let ((process (start-file-process "bootstrapper" "paket-bootstrap" paket-bootstrap-command)))
    (set-process-sentinel
     process
     (lambda (p e)
       (if (string-match-p "finished" e)
           (setq paket-bootstrap-complete t))))))

(defun paket-bootstrap--do ()
  "Run Paket bootsrapper process"
  (unless (paket-executable-exists)
    (paket-bootstrap--start-process)))

(defun paket-bootstrap--ensure ()
  "Wait until the Paket executable is present before exiting"
  (paket-bootstrap--do)
  (if (paket-executable-exists)
      t
    (progn
      (sit-for 0.2)
      (paket-bootstrap--ensure))))

(paket-bootstrap--do)

(provide 'paket-bootstrap)
