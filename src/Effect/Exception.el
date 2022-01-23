;; -*- lexical-binding: t; -*-

;; signalの仕組みを利用する。
;; Error型の値としては (cons <error-symbol> <data>) として表現する。
(defvar Effect.Exception.showErrorImpl
  (lambda (err)
    (format "%s" err)))

;; `error' 関数がsignalする形式と合わせる
(defvar Effect.Exception.error
  (lambda (msg)
     (list 'error msg)))

(defvar Effect.Exception.message
  (lambda (e)
    (pcase e
      (`(error ,msg) msg)
      (_ (format "%s" (cdr e))))))

(defvar Effect.Exception.name
  (lambda (e)
    (symbol-name (car e))))

;; Always return nothing since we can't acquire stack.
;; PS側からthrowExceptionで投げられる例外に関してスタックを付けていいかも..
(defvar Effect.Exception.stackImpl
  (lambda (just)
    (lambda (nothing)
      (lambda (e)
        nothing))))

(defvar Effect.Exception.throwException
  (lambda (e)
    (lambda ()
      (signal (car e) (cdr e)))))

(defvar Effect.Exception.catchException
  (lambda (c)
    (lambda (t)
      (lambda ()
        (condition-case e
            (funcall t)
          (t
           (funcall (funcall c e))))))))
