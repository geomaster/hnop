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

(defun render-json-newslist (newslist)
  (yason:with-output-to-string* (:indent t)
    (yason:with-array ()
      (loop for item across newslist do
            (yason:with-object ()
              (yason:encode-object-element "title" (getf item :title))
              (yason:encode-object-element "url" (getf item :url))
              (yason:encode-object-element "author" (getf item :author))
              (yason:encode-object-element "points" (getf item :points))
              (yason:encode-object-element "comments" (getf item :comments)))))))

(defroute "/api/hello.json" ()
            (render-plist-as-json '(:title "Hello people" :body "It is your birthday.")))

(defroute "/api/news/top" ()
          (setf (headers *response* :content-type) "application/json; charset=utf-8")
          (render-json-newslist (backend.hnparser:get-posts)))

;;
;; Error pages

; (defmethod on-exception ((app <web>) (code (eql 404)))
;   (declare (ignore app))
;   (merge-pathnames #P"_errors/404.html"
;                    *template-directory*))
