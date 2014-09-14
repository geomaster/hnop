(in-package :cl-user)
(defpackage hnopd.view
  (:use :cl 
        :yason)
  (:import-from :hnopd.config)
  (:import-from :caveman2
                :*response*)
  (:import-from :clack.response
                :headers)
  (:export :as-json))
(in-package :hnopd.view)

(defmacro as-json (&body body)
  `(progn 
     (setf (headers *response* :content-type) "application/json")
     ,@body))

