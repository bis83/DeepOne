;;;; Copyright (c) 2017 bis83. Distributed under the BSD license. 

(use hina)

;;; pictures

(pict-file 0 "data/title_back.png")
(pict-file 1 "data/title.png")
(pict-file 2 "data/push_start.png")
(pict-file 3 "data/field01.png")
(pict-file 4 "data/frame.png")
(pict-file 5 "data/time.png")
(pict-file 6 "data/number.png")
(pict-file 7 "data/level.png")
(pict-file 8 "data/score.png")
(pict-file 9 "data/time_f.png")
(pict-file 10 "data/gameover.png")
(pict-file 11 "data/clear.png")
(pict-file 12 "data/gate.png")
(pict-file 13 "data/tama.png")
(pict-file 14 "data/player_cristal.png")

;;; plots

(plot-data 0
  (f32vector   0   0   0   0
               0 480   0 480
             640 480 640 480
             640   0 640   0))
(plot-data 1
  (f32vector   0   0   0   0
               0 240   0 240
             640 240 640 240
             640   0 640   0))
(plot-data 2
  (f32vector   0   0 160 320
               0 120 160 440
             320 120 480 440
             320   0 480 320))
(plot-data 3
  (f32vector   0   0 120  40
               0 400 120 440
             400 400 520 440
             400   0 520  40))
(plot-data 4
  (f32vector   0   0   0   0
               0 480   0 480
             640 480 640 480
             640   0 640   0))
(plot-data 5
  (f32vector   0   0 120 450
               0  20 120 470
             400  20 520 470
             400   0 520 450))
(plot-data 7
  (f32vector   0   0 130   0
               0  40 130  40
             120  40 250  40
             120   0 250   0))
(plot-data 8
  (f32vector   0   0   0  40
               0  80   0 120
             120  80 120 120
             120   0 120  40))
(plot-data 9
  (f32vector   0   0   0 400
               0  40   0 440
             120  40 120 440
             120   0 120 400))

;;; draw

(define (draw-title-scene)
  (pict-write-to-screen)
  (pict-clear 0 0 0 0)
  ;; title-back
  (pict-read-from 0)
  (plot-mode-stamp)
  (plot-quads 0 1)
  ;; titile
  (pict-read-from 1)
  (plot-mode-stamp)
  (plot-quads 1 1)
  ;; push-start
  (pict-read-from 2)
  (plot-mode-stamp)
  (plot-quads 2 1))

(define (draw-main)
  (pict-write-to-screen)
  (pict-clear 0 0 0 0)
  ;; background
  (pict-read-from 3)
  (plot-mode-stamp)
  (plot-quads 3 1)
  ;; gates
  (draw-gates)
  ;; player
  (draw-player)
  ;; photons
  (draw-photons)
  ;; frame
  (pict-read-from 4)
  (plot-mode-stamp)
  (plot-quads 4 1)
  ;; timer
  (pict-read-from 5)
  (plot-mode-stamp)
  (plot-quads 5 1)
  ;; score
  (pict-read-from 8)
  (plot-mode-stamp)
  (plot-quads 7 1)
  (draw-number 10 8 260 8 1 score)
  ;; level
  (pict-read-from 7)
  (plot-mode-stamp)
  (plot-quads 8 1)
  (draw-number 18 2 20 120 1.5 level)
  ;; timerF
  (pict-read-from 9)
  (plot-mode-stamp)
  (plot-quads 9 1)
  (draw-number 20 3 80 440 1 (inexact->exact (floor (/ timer 60))))
  ;; gameover
  (draw-gameover)
  ;; complete
  (draw-complete))

(define (draw-number start digits x y s num)
  (let loop ((i 0)
             (n num))
    (when (< i digits)
      (define u (expt 10 (- digits i 1)))
      (define k (inexact->exact (floor (/ n u))))
      (plot-data (+ start i)
        (f32vector  (* k 24)        0 (+ x (* s i 24))       y
                    (* k 24)       24 (+ x (* s i 24))       (+ y (* s 24))
                    (* (+ k 1) 24) 24 (+ x (* s (+ i 1) 24)) (+ y (* s 24))
                    (* (+ k 1) 24)  0 (+ x (* s (+ i 1) 24)) y))
      (loop (+ i 1) (modulo n u))))
  (pict-read-from 6)
  (plot-mode-stamp)
  (plot-quads start digits))

(define (draw-gates)
  (values))

(define (draw-player)
  (plot-data 32
    (f32vector (* player-color 64)          0 player-pos-x         player-pos-y
               (* player-color 64)         64 player-pos-x         (+ player-pos-y 64)
               (* (+ player-color 1) 64)   64 (+ player-pos-x 64)  (+ player-pos-y 64)
               (* (+ player-color 1) 64)    0 (+ player-pos-x 64)  player-pos-y
               (* cristal-color 64)        64 cristal-pos-x        cristal-pos-y
               (* cristal-color 64)       128 cristal-pos-x        (+ cristal-pos-y 64)
               (* (+ cristal-color 1) 64) 128 (+ cristal-pos-x 64) (+ cristal-pos-y 64)
               (* (+ cristal-color 1) 64)  64 (+ cristal-pos-x 64) cristal-pos-y))
  (pict-read-from 14)
  (plot-mode-stamp)
  (plot-quads 32 2))

(define (draw-photons)
  (values))

(define (draw-gameover)
  (when gameover?
    (pict-read-from 10)
    (plot-mode-stamp)
    (plot-quads 0 1)
    (draw-number 23 8 120 360 2 score)))

(define (draw-complete)
  (when complete?
    (pict-read-from 11)
    (plot-mode-stamp)
    (plot-quads 0 1)
    (draw-number 23 8 120 360 2 score)))

;;; update

(define scene-name 'title)
(define wait 0)
(define gameover? #f)
(define complete? #f)

(define score 0)
(define level 1)
(define timer (* 60 20))
(define level-timer 0)

(define player-pos-x (- 320 32))
(define player-pos-y (- 360 32))
(define player-color 0)
(define cristal-pos-x (- 320 32))
(define cristal-pos-y (- 360 96))
(define cristal-vel-x 0)
(define cristal-vel-y 0)
(define cristal-color 1)

(define (update-title-scene)
  (receive (btn0 btn1 btn2 btn3 x y) (gpad-joystick-status)
    (when btn0
      (start-main)
      (set! scene-name 'main))))

(define (start-main)
  (set! gameover? #f)
  (set! complete? #f)
  (set! score 0)
  (set! level 1)
  (set! timer (* 60 20))
  (set! level-timer 0)
  (set! player-pos-x (- 320 32))
  (set! player-pos-y (- 360 32))
  (set! player-color 0)
  (set! cristal-pos-x (- 320 32))
  (set! cristal-pos-y (- 360 96))
  (set! cristal-vel-x 0)
  (set! cristal-vel-y 0)
  (set! cristal-color 1))

(define (update-main)
  (cond
    ((< 0 wait)
      (set! wait (- wait 1)))
    ((or gameover? complete?)
      (receive (btn0 btn1 btn2 btn3 x y) (gpad-joystick-status)
        (when btn0 (set! scene-name 'title))))
    (else
      (update-bgm)
      (update-player)
      (update-photons)
      (update-gates)
      (hit-player-and-photon)
      (hit-player-and-gate)
      (limit-score)
      (increase-timer)
      (increase-level))))

(define (update-bgm)
  (values))

(define (update-player)
  (receive (btn0 btn1 btn2 btn3 x y) (gpad-joystick-status)
    ;; btn0: change player color
    (when btn0
      (cond
        ((= player-color 0)
          (set! player-color 1)
          (set! cristal-color 0))
        (else
          (set! player-color 0)
          (set! cristal-color 1))))
    ;; x,y: move player
    (when (< 0.5 (abs x))
      (set! player-pos-x
        (+ player-pos-x
          (/ 5 (if (positive? x) 1 -1)
               (if (< 0.5 (abs y)) (sqrt 2) 1)))))
    (when (< 0.5 (abs y))
      (set! player-pos-y
        (+ player-pos-y
          (/ 5 (if (positive? y) 1 -1)
               (if (< 0.5 (abs x)) (sqrt 2) 1)))))
    ;; limit player movement
    (set! player-pos-x (min (max player-pos-x 110) (- 530 64)))
    (set! player-pos-y (min (max player-pos-y 30) (- 450 64)))
    ;; move cristal
    (set! cristal-pos-x (+ cristal-pos-x cristal-vel-x))
    (set! cristal-pos-y (+ cristal-pos-y cristal-vel-y))
    ;; reflect cristal from player
    (when (< (+ (expt (- player-pos-x cristal-pos-x) 2)
                (expt (- player-pos-y cristal-pos-y) 2))
             (expt 64 2))
      (set! cristal-vel-x (- cristal-pos-x player-pos-x))
      (set! cristal-vel-y (- cristal-pos-y player-pos-y))
      (define nom (sqrt (+ (expt cristal-vel-x 2) (expt cristal-vel-y 2))))
      (set! cristal-vel-x (* cristal-vel-x (/ nom) 6))
      (set! cristal-vel-y (* cristal-vel-y (/ nom) 6)))
    ;; reflect cristal from border
    (when (or (< cristal-pos-x 110) (> cristal-pos-x (- 520 64)))
      (set! cristal-vel-x (- cristal-vel-x)))
    (when (or (< cristal-pos-y 30) (> cristal-pos-y (- 440 64)))
      (set! cristal-vel-y (- cristal-vel-y)))
    ;; limit cristal movement
    (set! cristal-pos-x (min (max cristal-pos-x 110) (- 520 64)))
    (set! cristal-pos-y (min (max cristal-pos-y 30) (- 440 64)))))

(define (update-photons)
  (values))

(define (update-gates)
  (values))

(define (hit-player-and-photon)
  (values))

(define (hit-player-and-gate)
  (values))

(define (limit-score)
  (when (<= 99999999 score)
    (set! score 99999999)))

(define (increase-timer)
  (when (< 0 timer)
    (set! timer (- timer 1)))
  (when (<= timer 0)
    ;; gameover...
    (set! wait 180)
    (set! gameover? #t)))

(define (increase-level)
  (set! level-timer (+ 1 level-timer))
  (when (<= (* 10 60) level-timer)
    (set! level-timer 0)
    (set! level (+ 1 level))
    (when (<= 100 level)
      ;; complete!
      (set! level 99)
      (set! wait 180)
      (set! complete? #t))))

;;; entrypoint

(define (deep-one)
  (case scene-name
    ((title)
      (update-title-scene)
      (draw-title-scene))
    ((main)
      (update-main)
      (draw-main))))
(awake deep-one)

