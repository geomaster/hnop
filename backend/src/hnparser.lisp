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
  ())

(define-condition http-unexpected-status-error (http-request-error)
  (status :initarg (error "You must specify the status code.") 
          :reader status))

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
