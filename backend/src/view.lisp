(in-package :cl-user)
(defpackage hnopd.view
  (:use :cl 
        :yason)
  (:import-from :hnopd.config
                *hn-url-root*)
  (:import-from :caveman2
                :*response*)
  (:import-from :clack.response
                :headers)
  (:export :as-json
           :render-json-newslist))
(in-package :hnopd.view)

(defmacro as-json (&body body)
  `(progn 
     (setf (headers *response* :content-type) "application/json; charset=utf-8")
     ,@body))

(defun render-json-newslist (newslist)
  (yason:with-output-to-string* (:indent t)
    (yason:with-array ()
      (loop for item across newslist do
            (yason:with-object ()
              (dolist (elem 
                        `(("number" :number)
                          ("title" :title)
                          ("url" :url ,(lambda (url)
                                         (when (ppcre:scan "^https?:\/\/" url)
                                           url)))
                          ("id" :itemid)
                          ("website" :website)
                          ("points" :points)
                          ("comments" :comments)
                          ("username" :username)
                          ("timestamp" :time ,(lambda (timeoff)
                                                (+ (get-universal-time) timeoff)))
                          ("dead" :dead)))
                (yason:encode-object-element (first elem) 
                                             (funcall (or (third elem) 
                                                          #'identity)
                                                      (getf item (second elem))))))))))
 
