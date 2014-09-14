(in-package :cl-user)
(defpackage hnopd-test-asd
  (:use :cl :asdf))
(in-package :hnopd-test-asd)

(defsystem hnopd-test
  :author "geomaster"
  :license ""
  :depends-on (:hnopd
               :cl-test-more)
  :components ((:module "t"
                :components
                ((:file "hnopd"))))
  :perform (load-op :after (op c) (asdf:clear-system c)))
