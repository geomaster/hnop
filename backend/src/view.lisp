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
  (if (transform-fn)
    (transform-fn object)
    object))

(defmacro render-plist-as-json (plist)
  `(as-json plist yason:encode-plist))

(defun render-plist-as-json (object)
  (setf (headers *response* :content-type) "application/json")
  (yason:encode object))

