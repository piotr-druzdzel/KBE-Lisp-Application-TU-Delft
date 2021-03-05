(in-package :gdl-user)

(define-object diagram (base-object)
  
  :documentation
  (:author "Hermen de Jong"
   :maintainer "Durk Steenhuizen"
   :description "Plots a diagram which can consist of multiple graphs. Scaling is done according to a keyword input. Furthermore a legend and additional text can be plotted.")
  
  :input-slots
  ("List of lists. Each list within this list represents a graph and has to be of form ((s1 v1) (s2 v2) etc). Maximum of 5 graphs.
:examples
<pre>;; input entry with 2 graphs, with 3 points each
 (((0.0 11.1) (0.1 9.3) (0.2  7.4)) ((0.0  2.9) (0.1 6.2) (0.2 11.6)))</pre>"
    input
   ("List of two numbers. Defines the boundaries of x, irrespective of the input. Defaults to the minimum and maximum value."
    x-domain (if (every #'(lambda (x) x) (mapcar #'null (the input)))
                 (list 0 10)
               (list (apply #'min (mapcar #'(lambda (input-line) (apply #'min (mapcar #'first input-line))) (the input)))
                     (apply #'max (mapcar #'(lambda (input-line) (apply #'max (mapcar #'first input-line))) (the input))))))
   ("String. This label is added to the x-axis. Default is 'x'." 
    x-label "x" :settable)
   ("String. This label is added to the y-axis. Default is 'y'." 
    y-label "y" :settable)
   ("Keyword. Options are :square, :equal, :four-by-one :TA2-fit (default) and :two-by-one." 
    scaling-type :TA2-fit :settable)
   ("List of strings. The elements of the text list are plotted as additional text lines."
    text (list) :settable)
   ("List of keywords. Prefered list of colors to be used for the graphs. Defaults to (:red :blue :green-forest :orange :purple :blue-midnight)"
    color-list (list :red :blue :green-forest :orange :purple :blue-midnight))
   ("List of list. List of preferred dash patterns. Defaults to ((1 0))."
    dash-list (make-list (length (the color-list)) :initial-element (list 1 0)))
   ("Number. The thickness of all lines in the graph. Defaults to 2."
    line-thickness 1 :settable)
   
   ;;legend inputs
   ("Plist. With the indicators :labels and :location, where :labels is followed by a list of strings and :location by a keyword :north-east, :south-east, :north-west (default) or :south-west." 
    legend (list :labels (list) :location :north-east) :settable)
   (legend-line-length 0.05)
   (line-text-spacing 0.02)
   ("3dpoint. Manual placing of the legend where the coordinates have to be TA2/Tasty coordinates. Defaults to the compass quarters of the :location indicator of legend."
    legend-location (translate 
                     (the center)
                     :right (case (getf (the legend) :location) ;x
                              ((:north-east :south-east) (- (the x-axis-max)
                                                            (apply #'max (mapcar #'(lambda (txt) (the-object txt width)) 
                                                                                 (list-elements (the legend-text))))
                                                            (* (the width-x-axis) (+ (the legend-line-length)
                                                                                     (the line-text-spacing)))))
                              ((:north-west :south-west) (+ (the x-axis-min) (* 0.01 (the width-x-axis)))))
                     :rear (case (getf (the legend) :location) ;y
                             ((:north-east :north-west) (- (* (the y-axis-max) (the scaling-y)) 
                                                           (* 0.05 (the width-y-axis) (the scaling-y))))
                             ((:south-east :south-west) (+ (* (the y-axis-min) (the scaling-y))
                                                           (* (length (getf (the legend) :labels))
                                                              (the legend-text character-size))))))))
  
  :computed-slots
  ((start-x (first (the x-domain)))
   (end-x (second (the x-domain)))
   (width-x (- (the end-x) (the start-x)))
   (width-y (- (the y-max) (the y-min)))
   (width-x-axis (- (the x-axis-max) (the x-axis-min)))
   (width-y-axis (- (the y-axis-max) (the y-axis-min)))
   
   (processed-input (mapcar #'(lambda (input-line) 
                                (remove nil 
                                        (reverse (let (result) 
                                                   (dotimes (n (length input-line) result)
                                                     (setq result
                                                       (cons
                                                        (if (> (the start-x) (first (nth n input-line)))
                                                            nil
                                                          (if (< (the end-x) (first (nth n input-line)))
                                                              nil
                                                            (nth n input-line))) result)))))))
                            (the input)))
   
   (y-max (if (every #'(lambda (x) x) (mapcar #'null (the input)))
              10
            (apply #'max (mapcar #'(lambda (input-line) (apply #'max (mapcar #'second input-line))) (append '(((0 0))) (the input))))))
   (y-min (if (every #'(lambda (x) x) (mapcar #'null (the input)))
              0
            (apply #'min (mapcar #'(lambda (input-line) (apply #'min (mapcar #'second input-line))) (append '(((0 0))) (the input))))))

   (rounding-x (the (rounding (the width-x))))
   (rounding-y (the (rounding (the width-y))))

   (x-axis-min (the (axis-boundaries :min (the start-x) (the rounding-x))))
   (x-axis-max (the (axis-boundaries :max (the end-x) (the rounding-x))))
   (y-axis-min (the (axis-boundaries :min (the y-min) (the rounding-y))))
   (y-axis-max (the (axis-boundaries :max (the y-max) (the rounding-y))))
   
   (scaling-y (case (the scaling-type) 
                (:square (/ (the width-x) (the width-y)))
                (:equal 1)
                (:TA2-fit (/ (the width-x) (the width-y) 1.3))
                (:four-by-one (/ (the width-x) (the width-y) 4))
                (:two-by-one (/ (the width-x) (the width-y) 2)))))
  
  :functions
  ((rounding (width) (let ((significance (log width 10))) 
                       (if (< (mod significance 1) (log 2 10)) 
                           (expt 10 (floor (1- significance)))
                         (expt 10 (ceiling (1- significance))))))
    
   (axis-boundaries (min-max value rounding) (case min-max 
                                               (:max (* (ceiling (/ value rounding)) rounding))
                                               (:min (* (floor (/ value rounding)) rounding)))))
                                                            
  :objects
  ((graph :type 'fitted-curve 
          :sequence (:size (length (the input)))
          :degree 1
          :display-controls (list :color (nth (the-child index) (the color-list))
                                  :line-thickness (the line-thickness)
                                  :dash-pattern (nth (the-child index) (the dash-list)))
          :points (let ((result))
                    (dotimes (n (length (nth (the-child index) (the processed-input))) result)
                      (setq result
                        (cons
                         (translate (the center) 
                                    :right (first (nth n (nth (the-child index) (the processed-input)) ))
                                    :rear (* (the scaling-y) (second (nth n (nth (the-child index) (the processed-input))))) 
                                    :top 0)
                         result)))))
   
   (x-axis :type 'line
           :display-controls (list :line-thickness (the line-thickness))
           :start (translate (the center) :right (the x-axis-min))
           :end (translate (the center) :right (the x-axis-max)))
   
   (x-ticks :type 'line
            :sequence (:size (1+ (/ (the width-x-axis) (the rounding-x))))
            :display-controls (list :line-thickness (the line-thickness))
            :start (translate (the center) :right (+ (the x-axis-min) (* (the-child index) (the rounding-x))))
            :end (translate (the center) :right (get-x (the-child start)) :rear (- (/ (the width-x-axis) 100))))
   
   (y-axis :type 'line
           :display-controls (list :line-thickness (the line-thickness))
           :start (translate (the center) :rear (* (the y-axis-min) (the scaling-y)))
           :end (translate (the center) :rear (* (the y-axis-max) (the scaling-y))))
   
   (y-ticks :type 'line
            :sequence (:size (1+ (/ (the width-y-axis) (the rounding-y))))
            :display-controls (list :line-thickness (the line-thickness))
            :start (translate (the center) :rear (* (+ (the y-axis-min) (* (the-child index) (the rounding-y))) (the scaling-y)))
            :end (translate (the-child start) :right (- (/ (the width-x-axis) 100))))
   
   (y-text :type 'text-line
           :center (translate (the center) 
                              :right (- (+ (* 2 (the-child character-size))
                                           (the (y-ticks 0) length)
                                           (the (y-numbers 0) width)))
                              :rear (* (the scaling-y) (+ (half (the width-y-axis)) (the y-axis-min))))
           :orientation (alignment :rear (make-vector -1 0 0))
           :character-size (/ (the width-x-axis) 40)
           :text (the y-label)
           :font "courier")

   (x-text :type 'text-line
           :center (translate (the center) 
                              :right (+ (half (the width-x-axis)) (the x-axis-min)) 
                              :rear (* -1 (the-child character-size)))
           :character-size (the y-text character-size)
           :text (the x-label)
           :font "courier")
   
   (text-block :type 'text-line
               :sequence (:size (length (the text)))
               :start (translate (the center)
                                 :right (* 0.01 (the width-x-axis))
                                 :rear (- (* (the y-axis-max) (the scaling-y)) 
                                          (* (the-child index) (the-child character-size) 1 ) 
                                          (* 0.05 (the width-y-axis) (the scaling-y))))
               :character-size (the y-text character-size)
               :text (nth (the-child index) (the text))
               :font "courier")
   
   (x-numbers :type 'text-line
              :sequence (:size (length (list-elements (the x-ticks))))
              :center (translate (the (x-ticks (the-child index)) center) 
                                 :front (* (the-child character-size) 0.7))
              :character-size (* (the x-text character-size) 0.65)
              :text (format nil "~A" (let ((number (+ (* (the-child index) 
                                                         (the rounding-x)) 
                                                      (the x-axis-min)))
                                           (significance (log (the rounding-x) 10)))
                                       (if (< significance 0)
                                           (froundn number (abs significance))
                                         number)))
              :font "courier")
   
   (y-numbers :type 'text-line
              :sequence (:size (length (list-elements (the y-ticks))))
              :center (translate (the (y-ticks (the-child index)) center) 
                                 :left (* (the-child character-size) (1+ (floor (abs (log (the rounding-y) 10)))) 0.7 ))
              :character-size (* (the x-text character-size) 0.65)
              :text (format nil "~A" (let ((number (+ (* (the-child index) 
                                                         (the rounding-y)) 
                                                      (the y-axis-min)))
                                           (significance (log (the rounding-y) 10)))
                                       (if (< significance 0)
                                           (froundn number (abs significance))
                                         number)))
              :font "courier")
      
   (legend-line :type 'line
                :sequence (:size (length (getf (the legend) :labels)))
                :display-controls (list :line-thickness (the line-thickness))
                :start (translate (the legend-location) :front (+ (* (the legend-text character-size) (the-child index))
                                                                  (half (the legend-text character-size))))
                :end (translate (the-child start) :right (* (the width-x-axis) (the legend-line-length)))
                :display-controls (list :color (nth (the-child index) (list :red :blue :green :orange :purple))))
   
   (legend-text :type 'text-line
                :sequence (:size (length (getf (the legend) :labels)))
                :start (translate (the (legend-line (the-child index)) end) 
                                  :front (* 0.25 (the legend-text character-size))
                                  :right (* (the width-x-axis)(the line-text-spacing)))
                :text (nth (the-child index) (getf (the legend) :labels))
                :character-size (the y-text character-size)
                :font "courier")
   
   )                                    ;matches :objects (
  )                                     ;matches :define-object (
   

(defun froundn (float n)
  (multiple-value-bind (rounded frac)
      (ftruncate (* float (expt 10 n)))
    (/ (+ rounded (if (>= frac 0.5) 1.0 0.0))
       (expt 10 n))))                

   
