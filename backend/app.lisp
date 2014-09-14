(ql:quickload :hnopd)

(defpackage hnopd.app
  (:use :cl)
  (:import-from :clack
                :call)
  (:import-from :clack.builder
                :builder)
  (:import-from :clack.middleware.static
                :<clack-middleware-static>)
  (:import-from :clack.middleware.session
                :<clack-middleware-session>)
  (:import-from :clack.middleware.accesslog
                :<clack-middleware-accesslog>)
  (:import-from :clack.middleware.backtrace
                :<clack-middleware-backtrace>)
  (:import-from :ppcre
                :scan
                :regex-replace)
  (:import-from :hnopd.web
                :*web*)
  (:import-from :hnopd.config
                :config
                :productionp
                :*static-directory*))
(in-package :hnopd.app)

(defun build-path (path)
  (let* ((newpath (concatenate 'string
                               (if (productionp)
                                 "/build-release"
                                 "/build-debug") 
                               path)))
    (if (ppcre:scan "^(?:/index\\.html$|/images/|/fonts/|/js/|/css/)" path)
      (if (string= "/" path)
        (concatenate 'string newpath "/index.html")
        newpath)
      nil)))

(builder
  (<clack-middleware-static>
    :path #'build-path
    :root *static-directory*)
  (if (productionp)
    nil
    (make-instance '<clack-middleware-accesslog>))
  (if (getf (config) :error-log)
    (make-instance '<clack-middleware-backtrace>
                   :output (getf (config) :error-log))
    nil)
  <clack-middleware-session>
  (if (productionp)
    nil
    ; (lambda (app)
    ;   (lambda (env)
    ;     (let ((datafly:*trace-sql* t))
    ;       (call app env)))))
    )
  *web*)
