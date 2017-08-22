;;;; Copyright (c) 2017 bis83. Distributed under the BSD license. 

(use hina)
(screen 640 480 16 16 32)
(game void)
(game void)

(define pi (acos -1))

(png 0   0   0 "data/frame.png")          ; 640x480
(png 0   0 480 "data/field01.png")        ; 400x400
(png 0   0 880 "data/time.png")           ; 400x20
(png 0 650   0 "data/number.png")         ; 240x24
(png 0 650  24 "data/level.png")          ; 120x80
(png 0 650 104 "data/score.png")          ; 120x40
(png 0 650 144 "data/time_f.png")         ; 120x40
(png 0 650 320 "data/gate.png")           ; 64x64
(png 0 650 384 "data/tama.png")           ; 128x64
(png 0 650 448 "data/player_cristal.png") ; 128x128
(png 1   0   0 "data/title_back.png")     ; 640x480
(png 1   0 480 "data/title.png")          ; 640x240
(png 1   0 720 "data/push_start.png")     ; 320x120
(png 2   0   0 "data/gameover.png")       ; 640x480
(png 2   0 480 "data/clear.png")          ; 640x480

(define (plot-p sx sy dx dy)
  (plot sx sy dx dy 0 4 255 255 255 255))
(define (plot-4p sx sy dx dy w h)
  (plot-p (+ sx 0) (+ sy 0) (+ dx 0) (+ dy 0))
  (plot-p (+ sx 0) (+ sy h) (+ dx 0) (+ dy h))
  (plot-p (+ sx w) (+ sy h) (+ dx w) (+ dy h))
  (plot-p (+ sx w) (+ sy 0) (+ dx w) (+ dy 0)))

(define (plot-a sx sy dx dy r g b a)
  (plot sx sy dx dy 0 4 r g b a))
(define (plot-4a sx sy dx dy w h r g b a)
  (plot-a (+ sx 0) (+ sy 0) (+ dx 0) (+ dy 0) r g b a)
  (plot-a (+ sx 0) (+ sy h) (+ dx 0) (+ dy h) r g b a)
  (plot-a (+ sx w) (+ sy h) (+ dx w) (+ dy h) r g b a)
  (plot-a (+ sx w) (+ sy 0) (+ dx w) (+ dy 0) r g b a))

(define (plot-ra sx sy dx dy a)
  (plot sx sy dx dy 0 4 255 255 255 a))
(define (plot-4ra sx sy dx dy w h rot a)
  (define (rx x y) (- (* (cos rot) x) (* (sin rot) y)))
  (define (ry x y) (+ (* (sin rot) x) (* (cos rot) y)))
  (define rx0 (rx (/ w -2) (/ h -2)))
  (define ry0 (ry (/ w -2) (/ h -2)))
  (define rx1 (rx (/ w -2) (/ h +2)))
  (define ry1 (ry (/ w -2) (/ h +2)))
  (define rx2 (rx (/ w +2) (/ h +2)))
  (define ry2 (ry (/ w +2) (/ h +2)))
  (define rx3 (rx (/ w +2) (/ h -2)))
  (define ry3 (ry (/ w +2) (/ h -2)))
  (plot-ra (+ sx 0) (+ sy 0) (+ dx rx0) (+ dy ry0) a)
  (plot-ra (+ sx 0) (+ sy h) (+ dx rx1) (+ dy ry1) a)
  (plot-ra (+ sx w) (+ sy h) (+ dx rx2) (+ dy ry2) a)
  (plot-ra (+ sx w) (+ sy 0) (+ dx rx3) (+ dy ry3) a))

(ploti 0)
(plot-4p   0   0   0   0 640 480) ;  0, title_back
(plot-4p   0 480   0   0 640 240) ;  1, title
(plot-4p   0 720 160 320 320 240) ;  2, push_start
(plot-4p   0 480 120  40 400 400) ;  3, field01
(plot-4p   0   0   0   0 640 480) ;  4, frame
(plot-4p   0 880 120 450 400  20) ;  5, time
(plot-4p 640 104 130   0 120  40) ;  6, score
(plot-4p 640  24   0  40 120  80) ;  7, level
(plot-4p 640 144   0 400 120  40) ;  8, time_f
(plot-4p   0   0   0   0 640 480) ;  9, gameover
(plot-4p   0 480   0 400 640 480) ; 10, clear

;;; draw

(define (draw-title-scene)
  (face -1 1 -1 -1 0 3))

(define (draw-main)
  (face -1 0 -1 -1 3 1)
  (draw-gates)
  (draw-player)
  (draw-photons)
  (face -1 0 -1 -1 4 1)
  (draw-timebar)
  (face -1 0 -1 -1 6 1)
  (draw-number 100 8 260 8 1 score)
  (face -1 0 -1 -1 7 1)
  (draw-number 200 2 20 120 1.5 level)
  (face -1 0 -1 -1 8 1)
  (draw-number 300 3 80 440 1 (inexact->exact (floor (/ timer 60))))
  (draw-gameover)
  (draw-complete))

(define (draw-number start digits x y s num)
  (ploti start)
  (let loop ((i 0) (n num))
    (when (< i digits)
      (define u (expt 10 (- digits i 1)))
      (define k (inexact->exact (floor (/ n u))))
      (plot-4p (+ 650 (* k 24)) 0 (+ x (* s i 24)) y 24 24)
      (loop (+ i 1) (modulo n u))))
  (face -1 0 -1 -1 start digits))

(define (draw-player)
  (ploti 50)
  (plot-4p (+ 650 (* player-color 64))  (+ 448  0) player-pos-x  player-pos-y  64 64)
  (plot-4p (+ 650 (* cristal-color 64)) (+ 448 64) cristal-pos-x cristal-pos-y 64 64)
  (face -1 0 -1 -1 50 2))

(define (draw-gates)
  (define start 400)
  (define count 0)
  (ploti start)
  (let loop ((i 0))
    (when (< i gate-max)
      (when (vector-ref gate-active? i)
        (define x (vector-ref gate-pos-x i))
        (define y (vector-ref gate-pos-y i))
        (define r (* 2 pi (/ (vector-ref gate-time i) 120)))
        (define a (if (<= (vector-ref gate-time i) 0) 128 255))
        (plot-4ra 650 320 x y 64 64 r a)
        (set! count (+ 1 count)))
      (loop (+ i 1))))
  (face -1 0 -1 -1 start count))

(define (draw-photons)
  (define start 500)
  (define count 0)
  (ploti start)
  (let loop ((i 0))
    (when (< i photon-max)
      (when (vector-ref photon-active? i)
        ;; Rotation
        (define x (vector-ref photon-pos-x i))
        (define y (vector-ref photon-pos-y i))
        (define u (* (remainder (vector-ref photon-type i) 4) 32))
        (define v (* (quotient (vector-ref photon-type i) 4) 32))
        (define r (atan (vector-ref photon-vel-y i) (vector-ref photon-vel-x i)))
        (plot-4ra (+ 650 u) (+ 384 v) x y 32 32 r 255)
        (set! count (+ 1 count)))
      (loop (+ i 1))))
  (face -1 0 -1 -1 start count))

(define (draw-timebar)
  (define w (* 400 (/ timer (* 60 30))))
  (ploti 20)
  (plot-4a   0 880 120 450 400  20  36  36  36 196)
  (plot-4a   0 880 120 450   w  20 255 255 255 196)
  (face -1 0 -1 -1 20 2))

(define (draw-gameover)
  (when gameover?
    (ploti 9)
    (plot-4a   0   0   0   0 640 480 255 255 255 (- 255 wait))
    (face -1 2 -1 -1 9 1)
    (draw-number 1000 8 120 360 2 score)))

(define (draw-complete)
  (when complete?
    (ploti 10)
    (plot-4a   0 480   0   0 640 480 255 255 255 (- 255 wait))
    (face -1 2 -1 -1 10 1)
    (draw-number 1000 8 120 360 2 score)))

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

(define gate-max 10)
(define gate-pos-x (make-vector gate-max 0))
(define gate-pos-y (make-vector gate-max 0))
(define gate-vel-x (make-vector gate-max 0))
(define gate-vel-y (make-vector gate-max 0))
(define gate-type (make-vector gate-max 0))
(define gate-level (make-vector gate-max 0))
(define gate-time (make-vector gate-max 0))
(define gate-active? (make-vector gate-max #f))
(define active-gate-count 0)

(define photon-max 512)
(define photon-pos-x (make-vector photon-max 0))
(define photon-pos-y (make-vector photon-max 0))
(define photon-vel-x (make-vector photon-max 0))
(define photon-vel-y (make-vector photon-max 0))
(define photon-type (make-vector photon-max 0))
(define photon-active? (make-vector photon-max #f))

(define (reset-status)
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
  (set! cristal-color 1)
  (vector-fill! gate-active? #f)
  (set! active-gate-count 0)
  (vector-fill! photon-active? #f))

(define (update-title-scene b0)
  (when (= b0 1)
    (reset-status)
    (set! scene-name 'main)))

(define (update-main b0 l r u d)
  (cond
    ((< 0 wait)
      (set! wait (- wait 1)))
    ((or gameover? complete?)
      (when (= b0 1)
        (set! scene-name 'title)))
    (else
      (update-player b0 l r u d)
      (update-photons)
      (update-gates)
      (generate-new-gate)
      (hit-player-and-photon)
      (hit-player-and-gate)
      (limit-score)
      (increase-timer)
      (increase-level))))

(define (reflect-cristal x y)
  (set! cristal-vel-x (- cristal-pos-x x))
  (set! cristal-vel-y (- cristal-pos-y y))
  (define nom (sqrt (+ (expt cristal-vel-x 2) (expt cristal-vel-y 2))))
  (set! cristal-vel-x (* cristal-vel-x (/ nom) 6))
  (set! cristal-vel-y (* cristal-vel-y (/ nom) 6)))

(define (update-player b0 l r u d)
  ;; b0: change player color
  (when (= b0 1)
    (cond
      ((= player-color 0)
        (set! player-color 1)
        (set! cristal-color 0))
      (else
        (set! player-color 0)
        (set! cristal-color 1))))
  ;; x,y: move player
  (define x (+ (if (< 0 l) -1 0) (if (< 0 r) +1 0)))
  (define y (+ (if (< 0 u) -1 0) (if (< 0 d) +1 0)))
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
    (reflect-cristal player-pos-x player-pos-y))
  ;; reflect cristal from border
  (when (or (< cristal-pos-x 110) (> cristal-pos-x (- 520 64)))
    (set! cristal-vel-x (- cristal-vel-x)))
  (when (or (< cristal-pos-y 30) (> cristal-pos-y (- 440 64)))
    (set! cristal-vel-y (- cristal-vel-y)))
  ;; limit cristal movement
  (set! cristal-pos-x (min (max cristal-pos-x 110) (- 520 64)))
  (set! cristal-pos-y (min (max cristal-pos-y 30) (- 440 64))))

(define (update-photons)
  (let loop ((i 0))
    (when (< i photon-max)
      (when (vector-ref photon-active? i)
        (vector-set! photon-pos-x i (+ (vector-ref photon-pos-x i) (vector-ref photon-vel-x i)))
        (vector-set! photon-pos-y i (+ (vector-ref photon-pos-y i) (vector-ref photon-vel-y i)))
        (when (or (< (vector-ref photon-pos-x i) (- 120 16))
                  (> (vector-ref photon-pos-x i) (+ 520 16))
                  (< (vector-ref photon-pos-y i) (- 40 16))
                  (> (vector-ref photon-pos-y i) (+ 440 16)))
          (vector-set! photon-active? i #f)))
      (loop (+ i 1)))))

(define (create-photon type x y vx vy)
  (let loop ((i 0))
    (when (< i photon-max)
      (cond
        ((vector-ref photon-active? i)
          (loop (+ i 1)))
        (else
          (vector-set! photon-active? i #t)
          (vector-set! photon-type i type)
          (vector-set! photon-pos-x i x)
          (vector-set! photon-pos-y i y)
          (vector-set! photon-vel-x i vx)
          (vector-set! photon-vel-y i vy))))))

(define (gate-shoot-0 t l x y)
  (when (= 0 (modulo t (- 60 (* (modulo l 8) 3))))
    (define l/10 (quotient l 10))
    (let loop ((j 0))
      (when (< j (+ 8 l/10))
        (create-photon 0 x y
          (* 2 (cos (/ (* 2 pi j) (+ 8 l/10))))
          (* 2 (sin (/ (* 2 pi j) (+ 8 l/10)))))
        (loop (+ j 1))))))

(define (gate-shoot-1 t l x y)
  (when (= 0 (modulo t (- 60 (* (modulo l 10) 3))))
    (define l/10 (quotient l 10))
    (define rnd (random 360))
    (let loop ((j 0))
      (when (< j (+ 8 l/10))
        (create-photon 1 x y
          (* 2 (cos (+ (/ (* pi j) (+ 8 l/10)) (* 2 pi rnd (/ 360)))))
          (* 2 (sin (+ (/ (* pi j) (+ 8 l/10)) (* 2 pi rnd (/ 360))))))
        (loop (+ j 1))))))

(define (gate-shoot-2 t l x y)
  (when (= 0 (modulo t (- 12 (quotient (modulo l 10) 3))))
    (define l2 (* (quotient l 10) 10))
    (create-photon 2 x y
      (* 2 (cos (/ (* 2 pi (modulo t (+ 60 l2))) (+ 60 l2))))
      (* 2 (sin (/ (* 2 pi (modulo t (+ 60 l2))) (+ 60 l2)))))))

(define (gate-shoot-3 t l x y)
  (when (= 0 (modulo t (- 30 (* 2 (modulo l 10)))))
    (define l/10 (quotient l 10))
    (define rnd (random 360))
    (let loop ((j 0))
      (when (< j (+ 4 l/10))
        (create-photon 3 x y
          (* 2 (cos (/ (* 2 pi rnd) 360)))
          (* 2 (sin (/ (* 2 pi rnd) 360))))
        (loop (+ j 1))))))

(define (gate-shoot-4 t l x y)
  (when (= 0 (modulo t (- 60 (* 3 (modulo l 8)))))
    (define l/10 (quotient l 10))
    (let loop ((j 0))
      (when (< j (+ 4 l/10))
        (create-photon 4 x y
          (* 2 (cos (/ (* 2 pi j) (+ 4 l/10))))
          (* 2 (sin (/ (* 2 pi j) (+ 4 l/10)))))
        (loop (+ j 1)))))
  (when (= 0 (modulo (+ t 30) (- 60 (* 3 (modulo l 8)))))
    (define l/10 (quotient l 10))
    (let loop ((j 0))
      (when (< j (+ 4 l/10))
        (create-photon 4 x y
          (* 2 (cos (/ (* 2 pi (+ (* 2 j) 1)) (* 2 (+ 4 l/10)))))
          (* 2 (sin (/ (* 2 pi (+ (* 2 j) 1)) (* 2 (+ 4 l/10))))))
        (loop (+ j 1))))))

(define (gate-shoot-5 t l x y)
  (when (= 0 (modulo t (- 60 (* 3 (modulo l 10)))))
    (define l/10 (quotient l 10))
    (define rnd (random 360))
    (let loop ((j 0))
      (when (< j (+ 4 l/10))
        (create-photon 5 x y
          (* 2 (cos (+ (* (/ pi 2) (/ j (+ 4 l/10))) (/ (* 2 pi rnd) 360))))
          (* 2 (sin (+ (* (/ pi 2) (/ j (+ 4 l/10))) (/ (* 2 pi rnd) 360)))))
        (create-photon 5 x y
          (* 4 (cos (+ (* (/ pi 2) (/ j (+ 4 l/10))) (/ (* 2 pi rnd) 360))))
          (* 4 (sin (+ (* (/ pi 2) (/ j (+ 4 l/10))) (/ (* 2 pi rnd) 360)))))
        (loop (+ j 1))))))

(define (gate-shoot-6 t l x y)
  (when (= 0 (modulo t (- 24 (quotient (modulo l 10) 3))))
    (define l2 (* (quotient l 10) 10))
    (create-photon 6 x y
      (* 2 (cos (/ (* 2 pi (modulo t (+ 60 l2))) (+ 60 l2))))
      (* 2 (sin (/ (* 2 pi (modulo t (+ 60 l2))) (+ 60 l2)))))
    (create-photon 6 x y
      (* -2 (cos (/ (* 2 pi (modulo t (+ 60 l2))) (+ 60 l2))))
      (* -2 (sin (/ (* 2 pi (modulo t (+ 60 l2))) (+ 60 l2)))))))

(define (gate-shoot-7 t l x y)
  (when (= 0 (modulo t (- 16 (quotient (modulo l 10) 3))))
    (define l2 (* (quotient l 10) 10))
    (create-photon 7 x y
      (* 0.5 (+ (random 5) 2) (cos (/ (* 2 pi (modulo t (+ 60 l2))) (+ 60 l2))))
      (* 0.5 (+ (random 5) 2) (sin (/ (* 2 pi (modulo t (+ 60 l2))) (+ 60 l2)))))))

(define gate-shoot-table
  (vector gate-shoot-0
          gate-shoot-1
          gate-shoot-2
          gate-shoot-3
          gate-shoot-4
          gate-shoot-5
          gate-shoot-6
          gate-shoot-7))

(define (update-gates)
  (let loop ((i 0))
    (when (< i gate-max)
      (when (vector-ref gate-active? i)
        (vector-set! gate-time i (+ 1 (vector-ref gate-time i)))
        (cond
          ((negative? (vector-ref gate-time i))
            (values))
          (else
            (vector-set! gate-pos-x i (+ (vector-ref gate-pos-x i) (vector-ref gate-vel-x i)))
            (vector-set! gate-pos-y i (+ (vector-ref gate-pos-y i) (vector-ref gate-vel-y i)))
            ;; reflect from border
            (when (or (< (vector-ref gate-pos-x i) 110) (> (vector-ref gate-pos-x i) (- 520 64)))
              (vector-set! gate-vel-x i (- (vector-ref gate-vel-x i))))
            (when (or (< (vector-ref gate-pos-y i) 30) (> (vector-ref gate-pos-y i) (- 440 64)))
              (vector-set! gate-vel-y i (- (vector-ref gate-vel-y i))))
            ;; limit gate movement
            (vector-set! gate-pos-x i (min (max (vector-ref gate-pos-x i) 110) (- 520 64)))
            (vector-set! gate-pos-y i (min (max (vector-ref gate-pos-y i) 30) (- 440 64)))
            ;; generate photons
            ((vector-ref gate-shoot-table (vector-ref gate-type i))
              (vector-ref gate-time i)
              (vector-ref gate-level i)
              (vector-ref gate-pos-x i)
              (vector-ref gate-pos-y i)))))
      (loop (+ i 1)))))

(define (create-gate type x y level)
  (cond
    ((>= active-gate-count (+ (/ level 10) 1)) #f)
    (else
      (let loop ((i 0))
        (when (< i gate-max)
          (cond
            ((vector-ref gate-active? i)
              (loop (+ i 1)))
            (else
              (vector-set! gate-active? i #t)
              (vector-set! gate-level i level)
              (vector-set! gate-pos-x i x)
              (vector-set! gate-pos-y i y)
              (vector-set! gate-type i type)
              (vector-set! gate-time i -60)
              (define rnd (/ (random 360) 360))
              (vector-set! gate-vel-x i (cos (* 2 pi rnd)))
              (vector-set! gate-vel-y i (sin (* 2 pi rnd)))
              (set! active-gate-count (+ 1 active-gate-count)))))))))

(define (generate-new-gate)
  (when (= 0 (modulo timer 60))
    (create-gate (random 8) (+ (random 300) 160) (+ (random 300) 80) level)))

(define (hit-player? x y r color)
  (and (= player-color color)
       (< (+ (expt (- (+ player-pos-x 32) x) 2)
             (expt (- (+ player-pos-y 32) y) 2))
          (expt (+ r 24) 2))))

(define (hit-cristal? x y r color)
  (and (= cristal-color color)
       (< (+ (expt (- (+ cristal-pos-x 32) x) 2)
             (expt (- (+ cristal-pos-y 32) y) 2))
          (expt (+ r 24) 2))
       (begin (reflect-cristal x y) #t)))

(define (hit-player-and-photon)
  (define count 0)
  (let loop ((i 0))
    (when (< i photon-max)
      (when (vector-ref photon-active? i)
        (define x (vector-ref photon-pos-x i))
        (define y (vector-ref photon-pos-y i))
        (define c (modulo (vector-ref photon-type i) 2))
        (when (or (hit-player? x y 10 c) (hit-cristal? x y 10 c))
          (vector-set! photon-active? i #f)
          (set! count (+ 1 count))))
      (loop (+ i 1))))
  (set! score (+ score (* 10 count))))

(define (hit-player-and-gate)
  (define count 0)
  (let loop ((i 0))
    (when (< i gate-max)
      (when (and (vector-ref gate-active? i)
                 (<= 0 (vector-ref gate-time i))
                 (or (hit-cristal? (vector-ref gate-pos-x i) (vector-ref gate-pos-y i) 32 0)
                     (hit-cristal? (vector-ref gate-pos-x i) (vector-ref gate-pos-y i) 32 1)))
        (vector-set! gate-active? i #f)
        (set! active-gate-count (- active-gate-count 1))
        (set! count (+ 1 count)))
      (loop (+ i 1))))
  (set! score (+ score (* 200 count)))
  (set! timer (+ timer (* (- 5 (floor (/ level 20))) 60 count)))
  (when (and (< 0 count) (= 0 active-gate-count))
    (set! timer (+ timer (* 60 (floor (/ level 20)))))
    (set! score (+ score (* 1000 (floor (/ level 20))))))
  (when (> timer (* 30 60))
    (set! timer (* 30 60))))

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

(define (deep-one t b0 b1 b2 b3 l r u d)
  (case scene-name
    ((title)
      (update-title-scene b0)
      (draw-title-scene))
    ((main)
      (update-main b0 l r u d)
      (draw-main)))
  (game deep-one))
(game deep-one)

