(in-package :cl-user)
(defpackage backend-asd
  (:use :cl :asdf))
(in-package :backend-asd)

(defsystem backend
  :version "0.1"
  :author "geomaster"
  :license ""
  :depends-on (:clack
               :caveman2
               :envy
               :cl-ppcre

               ;; for CL-DBI
               :datafly
               :sxql
               
               :css-selectors-stp
               :css-selectors
               
               :cxml-stp
               :closure-html
               
               :drakma
               :yason)
  :components ((:module "src"
                :components
                ((:file "main" :depends-on ("config" "view" "db"))
                 (:file "web" :depends-on ("view" "hnparser"))
                 (:file "view" :depends-on ("config"))
                 (:file "db" :depends-on ("config"))
                 (:file "hnparser" :depends-on ("config"))
                 (:file "config"))))
  :description ""
  :in-order-to ((test-op (load-op backend-test))))
