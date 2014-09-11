(in-package :cl-user)
(defpackage backend.hnparser
  (:use :cl
        :backend.config
        :drakma
        :cxml-stp
        :closure-html)
  (:export :get-posts))
(in-package :backend.web)

(defparameter *hn-root* "https://news.ycombinator.com")

(defun parse-posts-html (html)
  html)

(define-condition http-request-error (error)
  ()
  (:report (lambda (condition stream)
             (declare (ignore condition))
             (format stream "drakma::http-request has returned an error condition."))))

(define-condition http-unexpected-status-error (http-request-error)
  ((status :initarg :status
          :initform (error "You must specify the status code.") 
          :reader status))
  (:report (lambda (condition stream)
             (format stream "A status code of ~A has been received, which was not expected."
                     (status condition)))))

(defun get-posts (&optional (page :top))
  (multiple-value-bind (body status) 
    (handler-case (drakma:http-request 
                    (concatenate 'string *hn-root* (cond ((eq page :top)
                                                          "/news")
                                                         ((eq page :new)
                                                          "/newest")
                                                         ((eq page :show)
                                                          "/show")
                                                         ((eq page :ask)
                                                          "/ask")
                                                         ((eq page :shownew)
                                                          "/shownew")
                                                         (t ""))))
      (error () (error 'http-request-error)))
    (if (eq status 200) 
      (parse-posts-html body)
      (error 'http-unexpected-status-error :status status))))
