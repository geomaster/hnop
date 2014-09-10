(in-package :cl-user)
(defpackage backend.view
  (:use :cl)
  (:import-from :backend.config)
  (:import-from :caveman2
                :*response*)
  (:import-from :clack.response
                :headers)
  (:import-from :datafly
                :encode-json)
  (:export :render-json))
(in-package :backend.view)

(defun render-json (object)
  (setf (headers *response* :content-type) "application/json")
  (encode-json object))

