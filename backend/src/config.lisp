(in-package :cl-user)
(defpackage hnopd.config
  (:use :cl)
  (:import-from :envy
                :config-env-var
                :defconfig)
  (:export :config
           :*application-root*
           :*static-directory*
           :*template-directory*
           :appenv
           :developmentp
           :productionp))
(in-package :hnopd.config)

(setf (config-env-var) "APP_ENV")

(defparameter *application-root*   (asdf:system-source-directory :hnopd))
(defparameter *static-directory*   (merge-pathnames #P"../webapp/" *application-root*))
(defparameter *hn-url-root*        "https://news.ycombinator.com")

(defconfig :common
           `(:databases ((:maindb :sqlite3 :database-name ,(write-to-string (merge-pathnames #P"db/hnop.db" *application-root*))))))

(defconfig |development|
  '())

(defconfig |production|
  '())

(defconfig |test|
  '())

(defun config (&optional key)
  (envy:config #.(package-name *package*) key))

(defun appenv ()
  (asdf::getenv (config-env-var #.(package-name *package*))))

(defun developmentp ()
  (string= (appenv) "development"))

(defun productionp ()
  (string= (appenv) "production"))
