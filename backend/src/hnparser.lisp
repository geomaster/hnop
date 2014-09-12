(in-package :cl-user)
(defpackage backend.hnparser
  (:use :cl
        :backend.config)
  (:export :get-posts
           :http-request-error
           :http-unexpected-status-error
           :html-error))

(in-package :backend.hnparser)

(defparameter *url-root* "https://news.ycombinator.com")

(defparameter *expected-posts* 30)

(defparameter *first-tbody-selector* 
  "center table:first-child tbody tr:nth-child(3) td table tbody")

(defparameter *post-title-selector*
  "td:nth-child(3) a:first-child")

(defparameter *post-website-selector*
  "td:nth-child(3) span.comhead")

(defparameter *get-itemid-regex*
  "vote\\?for=([0-9]+)(&.*)$")

(defparameter *get-auth-regex*
  "&auth=([a-z0-9]+)&|$")

(defparameter *post-upvote-link-selector*
  "td:nth-child(2) a:first-child")

(defparameter *post-pointcount-selector*
  "td:nth-child(2) span:first-child")

(defparameter *post-username-selector*
  "td:nth-child(2) a:nth-child(3)")

(defparameter *post-comments-selector*
  "td:nth-child(2) a:nth-child(5)")

(defparameter *commentcount-regex*
  "([0-9]+) comments?")

(defparameter *pointcount-regex*
  "([0-9]+) points?")

(defparameter *post-time-selector*
  "td:nth-child(2) *")

(defparameter *time-regex*
  "([0-9]+) (hour|day)s? ago")

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
 
(defun build-cookie-header (user-cookie)
  (if user-cookie
    (cons "Cookie" 
          (concatenate 'string "user=" (drakma:url-encode user-cookie :utf-8)))))
 
(defun extract-post-info (upvote-href)
    (ppcre:register-groups-bind (itemid otherstring)
        (*get-itemid-regex* upvote-href :sharedp t)
      (list :itemid
              itemid
              :auth
              (ppcre:register-groups-bind (authcode)
                  (*get-auth-regex* otherstring :sharedp t)
                authcode))))

(defun parse-post-title-link (node)
  (let ((text-node (stp:first-child node))
        (href-attr (stp:find-attribute-named node "href")))
    (list :title 
          (when (typep text-node 'stp:text) (stp:data text-node))
          :url
              (when href-attr (stp:value href-attr)))))

(defun find-and-parse-title-link (node)
  (let ((title-link (css-selectors:query1 *post-title-selector* node)))
    (when title-link
      (parse-post-title-link title-link))))

(defmacro select-and-extract ((node selector var) &body body)
  (let ((element-name (gensym))
        (text-node-name (gensym)))
    `(let ((,element-name (css-selectors:query1 ,selector ,node)))
       (when ,element-name
         (let ((,text-node-name (stp:first-child ,element-name)))
           (when (typep ,text-node-name 'stp:text)
             (let ((,var (stp:data ,text-node-name)))
               ,@body)))))))

(defun find-and-parse-website (node)
  (select-and-extract (node *post-website-selector* text)
    (list :website 
          (remove-if (lambda (chr)
                       (or (eq chr #\()
                           (eq chr #\))
                           (eq chr #\ ))) 
                     text))))

(defun find-and-parse-upvote (node)
  (let ((upvote-link (css-selectors:query1 *post-upvote-link-selector* node)))
    (when upvote-link
      (let ((upvote-href (stp:find-attribute-named upvote-link "href")))
        (if upvote-href 
          (extract-post-info (stp:value upvote-href))
          (error 'html-error))))))

(defun parse-post-first-row (node)
  (append (find-and-parse-title-link node)
          (find-and-parse-website node)
          (find-and-parse-upvote node)))

(defun find-and-parse-points (node)
  (select-and-extract (node *post-pointcount-selector* text) 
    (cl-ppcre:register-groups-bind (pointcount) (*pointcount-regex* text)
      (list :points pointcount))))

(defun find-and-parse-username (node)
  (select-and-extract (node *post-username-selector* text)
    (list :username text)))

(defun find-and-parse-comments (node)
  (select-and-extract (node *post-comments-selector* text)
    (if (eql text "discuss")
      (list :comments 0)
      (cl-ppcre:register-groups-bind (commentcount) (*commentcount-regex* text)
        (list :comments commentcount)))))

(defun timestring->offset (timestring)
  (ppcre:register-groups-bind (integral designator) (*time-regex* timestring)
    (* (parse-integer integral)
       (if (string= designator "hour")
         -3600
         -86400))))

(defun find-and-parse-time (node)
  (let ((child (stp:find-recursively-if 
                 (lambda (candidate)
                   (and (typep candidate 'stp:text)
                        (ppcre:scan *time-regex* (stp:data candidate))))
                 node)))
    (when child
      (list :time (timestring->offset (stp:data child))))))

(defun parse-post-second-row (node)
  (append (find-and-parse-points node)
          (find-and-parse-comments node)
          (find-and-parse-time node)
          (find-and-parse-username node)))

(defun parse-posts (head posts)
  (if head
    (let ((post-entry (append 
                        (parse-post-first-row (first head)) 
                        (parse-post-second-row (second head)))))
      (when post-entry
        (vector-push-extend post-entry posts))
      (parse-posts (cdddr head) posts))))

(defun parse-posts-html (html)
  (let* ((document (chtml:parse html (cxml-stp:make-builder)))
         (posts (make-array 30 :adjustable t :fill-pointer 0)))
    (if document
      (let ((main-table-body (css-selectors:query1 *first-tbody-selector* document)))
        (parse-posts (stp:list-children main-table-body) posts)
        posts)
      (error 'html-error))))

(defun get-posts (&optional user-cookie (page :top))
  (multiple-value-bind (body status) 
    (handler-case (drakma:http-request 
                    (concatenate 'string *url-root* (cond ((eq page :top)
                                                           "/news")
                                                          ((eq page :new)
                                                           "/newest")
                                                          ((eq page :show)
                                                           "/show")
                                                          ((eq page :ask)
                                                           "/ask")
                                                          ((eq page :shownew)
                                                           "/shownew")
                                                          (t "")))
                    :additional-headers
                    (list (build-cookie-header user-cookie)))
      (error () (error 'http-request-error)))
    (if (eq status 200) 
      (parse-posts-html body)
      (error 'http-unexpected-status-error :status status))))

