(in-package :cl-user)
(defpackage backend.web
  (:use :cl
        :caveman2
        :backend.config
        :backend.view
        :backend.db
        :datafly
        :sxql)
  (:export :*web*))
(in-package :backend.web)

;;
;; Application

(defclass <web> (<app>) ())
(defvar *web* (make-instance '<web>))
(clear-routing-rules *web*)

;;
;; Routing rules

(defroute "/api/hello.json" ()
  (render-plist-as-json '(:title "Hello people" :body "It is your birthday.")))

;;
;; Error pages

; (defmethod on-exception ((app <web>) (code (eql 404)))
;   (declare (ignore app))
;   (merge-pathnames #P"_errors/404.html"
;                    *template-directory*))
