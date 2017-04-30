;;;; Copyright (c) 2017 bis83. Distributed under the BSD license. 

(use hina)

(pict-file 0 "data/title_back.png")
(pict-file 1 "data/title.png")
(pict-file 2 "data/push_start.png")

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

(define (title-scene-draw)
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
  (plot-quads 2 1)
  )

(define (deep-one)
  (title-scene-draw))
(awake deep-one)

