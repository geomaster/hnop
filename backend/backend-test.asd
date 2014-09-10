(in-package :cl-user)
(defpackage backend-test-asd
  (:use :cl :asdf))
(in-package :backend-test-asd)

(defsystem backend-test
  :author "geomaster"
  :license ""
  :depends-on (:backend
               :cl-test-more)
  :components ((:module "t"
                :components
                ((:file "backend"))))
  :perform (load-op :after (op c) (asdf:clear-system c)))
