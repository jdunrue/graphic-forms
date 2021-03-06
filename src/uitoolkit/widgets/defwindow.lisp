;;;;
;;;; defwindow.lisp
;;;;
;;;; Copyright (C) 2007, Jack D. Unrue
;;;; All rights reserved.
;;;;
;;;; Redistribution and use in source and binary forms, with or without
;;;; modification, are permitted provided that the following conditions
;;;; are met:
;;;; 
;;;;     1. Redistributions of source code must retain the above copyright
;;;;        notice, this list of conditions and the following disclaimer.
;;;; 
;;;;     2. Redistributions in binary form must reproduce the above copyright
;;;;        notice, this list of conditions and the following disclaimer in the
;;;;        documentation and/or other materials provided with the distribution.
;;;; 
;;;;     3. Neither the names of the authors nor the names of its contributors
;;;;        may be used to endorse or promote products derived from this software
;;;;        without specific prior written permission.
;;;; 
;;;; THIS SOFTWARE IS PROVIDED BY THE AUTHORS AND CONTRIBUTORS "AS IS" AND ANY
;;;; EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
;;;; WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DIS-
;;;; CLAIMED.  IN NO EVENT SHALL THE AUTHORS AND CONTRIBUTORS BE LIABLE FOR ANY
;;;; DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
;;;; (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
;;;; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
;;;; ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
;;;; (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
;;;; SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
;;;;

(in-package :graphic-forms.uitoolkit.widgets)

(defvar *layout-initargs* (make-hash-table))
(progn
  (setf (gethash :border *layout-initargs*)
        '(:bottom-margin :horizontal-margins :left-margin
          :margins :right-margin :top-margin :vertical-margins))
  (setf (gethash :flow *layout-initargs*)
        '(:bottom-margin :horizontal-margins :left-margin
          :margins :right-margin :spacing :style :top-margin
          :vertical-margins))
  (setf (gethash :heap *layout-initargs*)
        '(:bottom-margin :horizontal-margins :left-margin
          :margins :right-margin :top-child :top-margin
          :vertical-margins)))

(defun filter-initargs (arg-plist valid-keywords)
  "This function filters a putative list of initargs against a list of
 allowed keywords. The first return value is the list of valid initargs
 with unrecognized keywords and duplicates removed. The second return value
 is a list of the invalid keywords (and their values) that were removed."
  (let ((clean-args nil)
        (bad-args (copy-seq arg-plist)))
    (loop for keyword in valid-keywords
          do (let ((value (getf arg-plist keyword)))
               (when value
                 (push value clean-args)
                 (push keyword clean-args)
                 (loop for result = (remf bad-args keyword)
                       while result))))
    (values clean-args bad-args)))

(defun filter-style-keywords (input-keywords valid-keywords)
  "This function filters a putative list of style keywords against a list of
 allowed style keywords. The first return value is the list of valid keywords
 with unrecognized keywords and duplicates removed. The second return value
 is a list of the invalid keywords that were removed."
  (let ((ok-keywords nil)
        (bad-keywords nil))
    (loop for input in input-keywords
          do (if (find input valid-keywords)
                 (push input ok-keywords)
                 (push input bad-keywords)))
    (values ok-keywords bad-keywords)))

#|
  (let ((style-form (getf form :style)))
|#

(defun extract-layout-definition (form)
  (let ((layout-form (getf form :layout)))
    (when layout-form
      (let ((valid-keywords (gethash (first form) *layout-initargs*)))
        (if (endp valid-keywords)
            (error 'gfs:toolkit-error
                   :format-control "form ~a is not a layout definition"
                   :format-arguments (list form)))
        (filter-initargs (rest form) valid-keywords)))))

#|
(defun rewrite-panel-form (form)
  (unless (eql (first form) :panel)
    (error 'gfs:toolkit-error
           :format-control "form ~a is not a panel definition"
           :format-arguments (list form)))
  (let ((style (extract-panel-style form))
        (layout (
|#
