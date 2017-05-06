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
  ;; level
  (pict-read-from 7)
  (plot-mode-stamp)
  (plot-quads 8 1)
  ;; timerF
  (pict-read-from 9)
  (plot-mode-stamp)
  (plot-quads 9 1)
  ;; gameover
  (draw-gameover)
  ;; complete
  (draw-complete))

(define (draw-gates)
  (values))

(define (draw-player)
  (values))

(define (draw-photons)
  (values))

(define (draw-gameover)
  (values))

(define (draw-complete)
  (values))

;;; update

(define scene-name 'title)
(define wait 0)
(define gameover? #f)
(define complete? #f)

(define (update-title-scene)
  (receive (btn0 btn1 btn2 btn3 x y) (gpad-joystick-status)
    (when btn0 (set! scene-name 'main))))

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

(define (update-bgm)
  (values))

(define (update-player)
  (values))

(define (update-photons)
  (values))

(define (update-gates)
  (values))

(define (hit-player-and-photon)
  (values))

(define (hit-player-and-gate)
  (values))

(define (limit-score)
  (values))

(define (increase-level)
  (values))

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

