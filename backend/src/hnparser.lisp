(in-package :cl-user)
(defpackage hnopd.hnparser
  (:use :cl
        :hnopd.config)
  (:import-from :hnopd.config
                :*hn-url-root*)
  (:export :get-posts
           :extract-itemid-from-url
           :http-request-error
           :http-unexpected-status-error
           :html-error))

(in-package :hnopd.hnparser)

;;
;; CSS selectors and regex definitions
;;

(defparameter *url-root* *hn-url-root*)
(defparameter *expected-posts* 30)
(defparameter *first-tbody-selector* "center table:first-child tbody tr:nth-child(3) td table tbody")
(defparameter *post-title-selector* "td:nth-child(3) a")
(defparameter *post-website-selector* "td:nth-child(3) span.comhead")
(defparameter *get-itemid-regex* "item\\?id=([0-9]+)")
(defparameter *post-upvote-link-selector* "td:nth-child(2) a:first-child")
(defparameter *post-number-selector* "td:first-child")
(defparameter *post-pointcount-selector* "td:nth-child(2) span:first-child")
(defparameter *post-username-selector* "td:nth-child(2) a:nth-child(3)")
(defparameter *post-comments-selector* "td:nth-child(2) a:last-child")
(defparameter *commentcount-regex* "([0-9]+) comments?")
(defparameter *pointcount-regex* "([0-9]+) points?")
(defparameter *post-time-selector* "td:nth-child(2) *")
(defparameter *time-regex* "([0-9]+) (minute|hour|day)s? ago")
(defparameter *post-number-regex* "([0-9]+).")

;;
;; Conditions
;;

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
 
(define-condition html-error (error)
  ()
  (:report (lambda (condition stream)
             (declare ( ignore condition))
             (format stream "There was an error in the HTML we received."))))
 
;;
;; Macros for convenience
;;

(defmacro select-and-extract ((node selector var) &body body)
  (let ((element-name (gensym))
        (text-node-name (gensym)))
    `(let ((,element-name (css-selectors:query1 ,selector ,node)))
       (when ,element-name
         (let ((,text-node-name (stp:first-child ,element-name)))
           (when (typep ,text-node-name 'stp:text)
             (let ((,var ,text-node-name))
               ,@body)))))))

;; 
;; HTTP stuff
;;

(defun build-cookie-header (user-cookie)
  (if user-cookie
    (cons "Cookie" 
          (concatenate 'string "user=" (drakma:url-encode user-cookie :utf-8)))))
 
;;
;; HTML parsing
;;

;; First row

(defun extract-itemid-from-url (url)
    (ppcre:register-groups-bind (itemid)
        (*get-itemid-regex* url :sharedp t)
      itemid))

(defun parse-post-title-link (node)
  (let ((text-node (stp:first-child node))
        (href-attr (stp:find-attribute-named node "href")))
    (list :title 
          (when (typep text-node 'stp:text) (stp:data text-node))
          :url
          (when href-attr (stp:value href-attr))
          :dead (not href-attr))))

(defun find-and-parse-number (node)
  (select-and-extract (node *post-number-selector* text-node)
    (ppcre:register-groups-bind (nmb) (*post-number-regex* (stp:data text-node))
      (list :number (parse-integer nmb)))))

(defun find-and-parse-title-link (node)
  (let ((title-link (css-selectors:query1 *post-title-selector* node)))
    (when title-link
      (parse-post-title-link title-link))))

(defun find-and-parse-website (node)
  (select-and-extract (node *post-website-selector* text-node)
    (list :website 
          (remove-if (lambda (chr)
                       (or (eq chr #\()
                           (eq chr #\))
                           (eq chr #\ ))) 
                     (stp:data text-node)))))

;; Second row

(defun find-and-parse-points (node)
  (select-and-extract (node *post-pointcount-selector* text-node) 
    (cl-ppcre:register-groups-bind (pointcount) (*pointcount-regex* 
                                                  (stp:data text-node))
      (list :points (parse-integer pointcount)))))

(defun find-and-parse-username (node)
  (select-and-extract (node *post-username-selector* text-node)
    (list :username (stp:data text-node))))

(defun extract-post-itemid (node)
  (let ((href-attr (stp:find-attribute-named node "href")))
    (when href-attr
      (extract-itemid-from-url (stp:value href-attr)))))

(defun find-and-parse-comments (node)
  (select-and-extract (node *post-comments-selector* text-node)
    (list :comments (if (string= (stp:data text-node) "discuss")
                      0
                      (cl-ppcre:register-groups-bind (commentcount) 
                                                     (*commentcount-regex* (stp:data text-node))
                                                     (parse-integer commentcount)))
          :itemid (or (extract-post-itemid (stp:parent text-node))))))

(defun timestring->offset (timestring)
  (ppcre:register-groups-bind (integral designator) (*time-regex* timestring)
    (* (parse-integer integral)
       (cond ( (string= designator "hour")
               -3600)
             ((string= designator "minute")
              -60)
             ((string= designator "day")
              -86400)
             (t (error 'html-error))))))

(defun find-and-parse-time (node)
  (let ((child (stp:find-recursively-if 
                 (lambda (candidate)
                   (and (typep candidate 'stp:text)
                        (ppcre:scan *time-regex* (stp:data candidate))))
                 node)))
    (when child
      (list :time (timestring->offset (stp:data child))))))

;; Aggregate functions

(defun parse-post-second-row (node)
  (append (find-and-parse-points node)
          (find-and-parse-comments node)
          (find-and-parse-time node)
          (find-and-parse-username node)))

(defun parse-post-first-row (node)
  (append (find-and-parse-number node)
          (find-and-parse-title-link node)
          (find-and-parse-website node)))

(defun parse-post (nodes)
  (let ((result (append
                 (parse-post-first-row (first nodes))
                 (parse-post-second-row (second nodes)))))
    (unless (member :itemid result)
      (let ((itemid (extract-itemid-from-url (getf result :url))))
        (when itemid
          (nconc result (list :itemid itemid)))))
    result))

(defun parse-posts (head posts)
  (if (>= (length head) 3)
    (let ((post-entry (parse-post head)))
      (when post-entry
        (vector-push-extend post-entry posts))
      (parse-posts (cdddr head) posts))))

(defun parse-posts-html (html channel)
  (let* ((document (chtml:parse html (cxml-stp:make-builder)))
         (posts (make-array 30 :adjustable t :fill-pointer 0)))
    (if document
      (let ((main-table-body (css-selectors:query1 *first-tbody-selector* document)))
        (parse-posts (funcall (cond ((eq channel :show)
                                     #'cdddr)
                                    ((eq channel :jobs)
                                     #'cddr)
                                    (t #'identity)) (stp:list-children main-table-body)) posts)
        posts)
      (error 'html-error))))

(defun get-posts (&key user-cookie (channel :top) page)
  (multiple-value-bind (body status) 
    (handler-case (drakma:http-request 
                    (concatenate 'string *url-root* (cond ((eq channel :top)
                                                           "/news")
                                                          ((eq channel :new)
                                                           "/newest")
                                                          ((eq channel :show)
                                                           "/show")
                                                          ((eq channel :ask)
                                                           "/ask")
                                                          ((eq channel :shownew)
                                                           "/shownew")
                                                          ((eq channel :jobs)
                                                           "/jobs")
                                                          (t ""))
                                 (when page
                                   (concatenate 'string "?p=" (write-to-string page))))
                    :additional-headers
                    (list (build-cookie-header user-cookie)))
      (error () (error 'http-request-error)))
    (if (eq status 200) 
      (parse-posts-html body channel)
      (error 'http-unexpected-status-error :status status))))

