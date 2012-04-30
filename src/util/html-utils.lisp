(in-package :example)

(defmacro html-to-stout (&body body)
  "Outputs HTML to standard out. Thanks Inaimathi for this tip!"
  `(with-html-output (*standard-output* nil :indent t) ,@body))

(defun get-id-from-uri ()
  "Returns the ID from the URI request."
  (car (cl-ppcre:all-matches-as-strings "[0-9]+" (request-uri *request*))))

(defun movies-path (movie)
  "Given a <Movie>, return the RESTful URI -- e.g. 'movies/3'"
  (concatenate 'string "movies/" (write-to-string (movie-id movie))))

(defun all-movie-rows ()
  (dolist (movie (movie-get-all))
    (htm
     (:tr
      (:td (fmt "~a" (movie-title movie)))
      (:td (fmt "~a" (movie-rating movie)))
      (:td (fmt "~a" (print-date (movie-release-date movie))))
      (:td (:a :href (movies-path movie)
	       (fmt "More info about ~A" (movie-title movie))))))))

(defun selector-form (name options)
  (html-to-stout
    (:select :name name
	     (mapcar
	      #'(lambda (x) (htm (:option :value x (fmt "~A" (mkstr x)))))
	      options))))