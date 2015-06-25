(defvar paket-bootstrap-executable "paket.bootstrapper.exe")

(defvar paket-bootstrap-complete nil)

(defvar paket-bootstrap-command
  (paket-find-executable paket-bootstrap-executable))

(defun paket-executable-exists ()
  (paket-find-executable paket-executable))

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
