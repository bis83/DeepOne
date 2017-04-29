;;;; Copyright (c) 2017 bis83. Distributed under the BSD license. 

(use hina)

(pict-file 0 "data/title.png")

(plot-data 0
  (f32vector   0   0   0   0
               0 240   0 240
             640 240 640 240
             640   0 640   0))

(define (deep-one)
  (pict-write-to-screen)
  (pict-clear 0 0 0 0)
  (pict-read-from 0)
  (plot-mode-stamp)
  (plot-quads 0 1))
(awake deep-one)

