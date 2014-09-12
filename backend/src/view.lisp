(in-package :cl-user)
(defpackage backend.view
  (:use :cl 
        :yason)
  (:import-from :backend.config)
  (:import-from :caveman2
                :*response*)
  (:import-from :clack.response
                :headers)
  (:export :as-json
           :render-plist-as-json))
(in-package :backend.view)

(defun as-json (object &optional transform-fn)
  (setf (headers *response* :content-type) "application/json")
  (if transform-fn
    (funcall transform-fn object)
    object))


(defun render-plist-as-json (object)
  (setf (headers *response* :content-type) "application/json")
  (let ((s (make-string-output-stream)))
    (yason:encode object s)
    (get-output-stream-string s)))

