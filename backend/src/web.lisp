(in-package :cl-user)
(defpackage hnopd.web
  (:use :cl
        :caveman2
        :hnopd.config
        :hnopd.view
        :hnopd.db
        :datafly
        :sxql)
  (:export :*web*))
(in-package :hnopd.web)

;;
;; Application

(defclass <web> (<app>) ())
(defvar *web* (make-instance '<web>))
(clear-routing-rules *web*)

;;
;; Routing rules


(defroute "/api/hello.json" ()
            (render-plist-as-json '(:title "Hello people" :body "It is your birthday.")))

(defroute ("/api/news/(?:(top|new|show(?:new)?|ask|jobs)(?:/([1-9][0-9]*))?)$" :regexp t) (&key captures)
          (as-json 
            (let ((chstr (first captures))
                  (pgstr (second captures)))
              (hnopd.view:render-json-newslist (hnopd.hnparser:get-posts :channel
                                                                         (cond ((string= chstr "top")
                                                                                :top)
                                                                               ((string= chstr "new")
                                                                                :new)
                                                                               ((string= chstr "show")
                                                                                :show)
                                                                               ((string= chstr "ask")
                                                                                :ask)
                                                                               ((string= chstr "jobs")
                                                                                :jobs)
                                                                               ((string= chstr "shownew")
                                                                                :shownew)
                                                                               (t :top))
                                                                         :page
                                                                         (if pgstr
                                                                           (parse-integer pgstr)
                                                                           1))))))
;;
;; Error pages

; (defmethod on-exception ((app <web>) (code (eql 404)))
;   (declare (ignore app))
;   (merge-pathnames #P"_errors/404.html"
;                    *template-directory*))
