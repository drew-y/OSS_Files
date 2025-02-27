;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname FP) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
(require 2htdp/image)
(require 2htdp/universe)

;; A simple one line text editor

;; ===========
;; Constants

(define FONT-SIZE 24)
(define FONT-COLOR "black")

(define WIDTH 600)
(define HEIGHT (+ FONT-SIZE 2))

(define CURSOR (rectangle 1 HEIGHT "solid" "red"))

(define MTS (empty-scene WIDTH HEIGHT))

;; ============
;; Data Definitions

(define-struct ls (str cursor-pos))
;; Line is (make-line String Natural[0, (string-length str)])
;; interp. The state of the line.
;;         str is the current string
;;         cursor-pos is the x-coordinate from zero to the length of the string
(define LS1 (make-ls "This is a line" 0))    ;Cursor at start of the line
(define LS2 (make-ls "This is a line" 6))    ;Cursor between "i" and "s"
(define LS3 (make-ls "This is a line" 14))   ;Cursor at the end of the line
#;
(define (fn-for-line-state ls)
  (... (ls-str ls)
       (ls-cursor-pos ls)))


;; ===========
;; Functions

;; Template rules used:
;; - compound: 2 fields

;;LineState -> LineState
;;Change str to reflect keypress
;;Start with (main (make-ls "" 0))
;; <no tests for main functions>

(define (main ls)
  (big-bang ls
            (on-key key-handler)
            (to-draw render-line)))

;; LineState KeyEvent -> LineState
;; Move the cursor and remove a character, or append a character
(check-expect (key-handler LS3 "s") (make-ls "This is a lines" 15))    ;add "s" and move cursor over 1
(check-expect (key-handler LS3 "\b") (make-ls "This is a lin" 13))     ;remove "e" and move cursor back 1
(check-expect (key-handler LS3 "left") (make-ls "This is a line" 13))  ;Move the cursor back one
(check-expect (key-handler LS3 "right") (make-ls "This is a line" 14)) ;The cursor can't go beyond the end of the string

(check-expect (key-handler LS2 "left") (make-ls "This is a line" 5))   ;The cursor cannot move before the start
(check-expect (key-handler LS2 "right") (make-ls "This is a line" 7))  ;Move the cursor forward one
(check-expect (key-handler LS2 "\b") (make-ls "This s a line" 5))      ;Delete "i" move the cursor back one
(check-expect (key-handler LS2 "q") (make-ls "This iqs a line" 7))     ;Insert "q" move the cursor forward one

(check-expect (key-handler LS1 "left") (make-ls "This is a line" 0))   ;Move the cursor back one
(check-expect (key-handler LS1 "right") (make-ls "This is a line" 1))  ;Move the cursor forward one
(check-expect (key-handler LS1 "\b") (make-ls "This is a line" 0))     ;Cannot remove when cursor is at start
(check-expect (key-handler LS1 "q") (make-ls "qThis is a line" 1))    ;Insert "q" move the cursor forward one

;(define (key-handler ls key) LS1)   ;stub

;<template from LineState>
(define (key-handler ls key)
  (cond [(key=? key "right") (move-cursor ls 1)]
        [(key=? key "left") (move-cursor ls -1)]
        [(key=? key "\b") (backspace ls)]
        [(key=? key "shift") ls]
        [else (add-to-line ls key)]))

;; LineState Integer -> LineState
;; Move the cursor if it does not exceed the string distance
(check-expect (move-cursor LS1 1) (make-ls "This is a line" 1))
(check-expect (move-cursor LS1 -1) (make-ls "This is a line" 0))
(check-expect (move-cursor LS2 1) (make-ls "This is a line" 7))
(check-expect (move-cursor LS2 -1) (make-ls "This is a line" 5))
(check-expect (move-cursor LS3 1) (make-ls "This is a line" 14))
(check-expect (move-cursor LS3 -1) (make-ls "This is a line" 13))

;(define (move-cursor ls dist) ls)    ;stub

;<template from LineState>
(define (move-cursor ls dist)
  (if (and (> (+ (ls-cursor-pos ls) dist) 0)
           (<= (+ (ls-cursor-pos ls) dist) (string-length (ls-str ls))))
      (make-ls (ls-str ls) (+ (ls-cursor-pos ls) dist))
      ls))
;; LineState -> LineState
;; Remove any characters behind the cursor (if there are any
(check-expect (backspace LS1) (make-ls "This is a line" 0))
(check-expect (backspace LS2) (make-ls "This s a line" 5))

;(define (backspace ls) ls)    ;stub
;<template from LineState>
(define (backspace ls)
  (if (> (ls-cursor-pos ls) 0)
      (make-ls (string-append 
                (substring (ls-str ls) 0 (- (ls-cursor-pos ls) 1))
                (substring (ls-str ls) (ls-cursor-pos ls)))
               (- (ls-cursor-pos ls) 1))
      ls))
;; LineState String -> LineState
(check-expect (add-to-line LS1 "q") (make-ls "qThis is a line" 1))
(check-expect (add-to-line LS2 "q") (make-ls "This iqs a line" 7))

;(define (add-to-line ls key) ls)    ;stub
;<template from LineState>
(define (add-to-line ls char)
  (make-ls (string-append 
            (substring (ls-str ls) 0 (ls-cursor-pos ls))
            char
            (substring (ls-str ls) (ls-cursor-pos ls)))
           (+ (ls-cursor-pos ls) 1)))

;; LineString -> Image
;; Overlay string and cursor (in the correct position) on the MTS
(check-expect (render-line (make-ls "" 0)) (overlay/align "left" "middle"
                                             (beside (text "" FONT-SIZE FONT-COLOR)
                                                     CURSOR)
                              MTS))
(check-expect (render-line (make-ls "hello" 0)) (overlay/align "left" "middle"
                                                 (beside CURSOR
                                                         (text "hello" FONT-SIZE FONT-COLOR))
                                                         MTS))

;(define (render-line ls) 0)   ;stub

(define (render-line ls)
  (overlay/align "left" "middle"
                 (beside (text
                          (substring (ls-str ls) 0 (ls-cursor-pos ls))
                          FONT-SIZE FONT-COLOR)
                         CURSOR
                         (text
                          (substring (ls-str ls) (ls-cursor-pos ls))
                          FONT-SIZE FONT-COLOR))
                 MTS))

;(place-image/align 
                              ;(beside (text
                              ;        (substring (ls-str ls) 0 (ls-cursor-pos ls))
                              ;       FONT-SIZE FONT-COLOR)
