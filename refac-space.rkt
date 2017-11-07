;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname refac-space) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
(require 2htdp/image)
(require 2htdp/universe)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;; DATA DEFINITIONS

;; A Direction  is one of
;; -LEFT
;; -RIGHT
;; -STOP
;; INTERP: represents a direction for the spaceship

;; Deconstructor Template
;; direction-fn: Direction  -> ???
#; (define (direction-fn direction)
     (cond
       [(string=? LEFT "left") ...]
       [(string=? RIGHT "right") ...]
       [(string=? STOP "stop") ...]))

;; A Body is a Posn
;; INTERP: represents the body of spaceship/invader/bullets
;; Deconstructor Template
;; body-fn: Body ->???
#;(define (body-fn body)
    ... (posn-x body)...
    ... (posn-y body)...)

;; A Spaceship is (make-spaceship Body)
;; INTERP: represents a space ship
;; WHERE: Direction can only be "left" "right or "stop"
(define-struct spaceship (body direction))
;; Deconstructor Template
;; spaceship-fn: Shapceship -> ???
#; (define (spacecship-fn spaceship)
     ... (body-fn (spaceship-body spaceship)) ...
     ... (direction -fn (spacecship-direction spacecship)) ...)

;; An Invader is a (make-invader Body Index)
;; INTERP: represents an invader and its state
(define-struct invader (body index))
;; Deconstructor Template
;; invader-fn: Invader -> ???
#; (define (invader-fn invader)
     ... (body-fn (invader-body invader)) ...
     ... (invader-index invader) ...)

;; A Mothership is a  (make-mothership Body Direction)
;; INTERP: represents the mothership of the invaders
(define-struct mothership (body ))
;; Deconstructor Template
;; mothership-fn: mothership -> ???
#; (define (mothership-fn mothership)
     ... (body-fn (mothership-body mothership)) ...)

;; A ListofInvaders (LOI) is one of
;; - empty
;; - (cons Invader LOI)
;; INTERP: represents a list of invaders
;; Deconstructor Template
;; loi-fn: LOI -> ???
#; (define (loi-fn loi)
     (cond
       [(empty? loi) ....]
       [(cons? loi) ... (invader-fn (first loi)) ...
                    ... (loi-fn (rest loi)) ...]))

; A ShipBullet is a Posn

;; A ListofShipBullets LOSB is one of
;; -empty
;; (cons ShipBullet LOSB)
;; INTERP: represents a list of ship bullets
;; Deconstructor Template
;; losb-fn: LOSB -> ???
#; (define (losb-fn losb)
     (cond
       [(empty? losb) ...]
       [(cons? losb) ... (first losb) ...
                     ... (rest losb) ...]))

;;A InvBullet is a Posn 

;; A ListofInvBullets LOIB is one of[
;; -empty
;; (cons InvBullet LOIB)
;; INTERP: represents a list of invader bullets
;; Deconstructor Template
;; loib-fn: LOIB -> ???
#; (define (loib-fn loib)
     (cond
       [(empty? loib) ...]
       [(cons? loib) ... (first loib) ...
                     ... (loib-fn (rest loib)) ...]))

;; A Ticker is a NonNegInt
;; WHERE: NonNegInt < 30
;; INTERP: represents the number of ticks that have passed
;;         since the game has started

;; A Score is a NonNegInt
;; INTERP: represents the number of ticks that have passed
;;         since the game has started

;; A Lives is a NonNegInt
;; INTERP: represents the number of lives that are remaining in the game

;; A World is
;; (make-world Spaceship LLOI ShipBullet InvBullet Lives Score Ticker)
;; INTERP: spaceship represents the spacecship in the game
;;         LOI represents all the invaders in the game
;;         ShipBullet represent the bullets fired by the spaceship
;;         InvBullet represent the bullets fired by the invaders
;;         Lives represent the spaceship lives
;;         Score represents the score in the game
;;         Ticker represents the number of ticks from game start (resets at 30)
(define-struct world (spaceship loi losb loib mothership lives score ticker))

;; Deconstructor Template
;; world-fn : World -> ???
#; (define (world-fn world)
     ... (spaceship-fn (world-spaceship world)) ...
     ... (loi-fn (world-loi world)) ...
     ... (losb-fn (world-losb world)) ...
     ... (loib-fn (world-loib world)) ...
     ... (mothership-fn (world-mothership world)) ...
     ... (world-lives world) ...
     ... (world-score)
     ... (world-ticker world) ...)

;; An Element is one of
;; -Spaceship
;; -Invader
;; -Mothership
;; INTERP: represents the elements of the game

;; A Bullet is one of
;; -ShipBullet
;; -InvBullet
;; INTERP: represents the bullets in the game

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define WIDTH 690)
(define HEIGHT 780)
(define UNIT-LEN 30)
(define BACKGROUND (empty-scene WIDTH HEIGHT))

(define LEFT "left")
(define RIGHT "right")

(define SHIPSPEED 10)
(define MSHIPSPEED 30)
(define BULLETSPEED 10)

(define MAX-INV-BULLETS 10)
(define MAX-SHIP-BULLETS 3)

(define INV-LEN-FACTOR 1)
(define INVADER-IMG (square
                     (* UNIT-LEN INV-LEN-FACTOR) "solid" "red"))
(define SHIP-LEN-FACTOR 2)
(define SHIP-IMG (rectangle
                  (* UNIT-LEN SHIP-LEN-FACTOR) UNIT-LEN "solid" "blue"))



(define MOTHERSHIP-IMG (rectangle
                  (* UNIT-LEN INV-LEN-FACTOR) UNIT-LEN "solid" "pink"))

(define SHIP-BULLET-IMG (circle 5 "solid" "cyan"))
(define INV-BULLET-IMG (circle 3 "solid" "grey"))

(define STOP "stop")
(define SHIP-INIT (make-spaceship (make-posn 345 735) STOP))

(define MOTHERSHIP-INIT (make-mothership (make-posn 15 60) ))

(define LOSB-INIT empty)
(define LOIB-INIT empty)

(define TICKER-INIT 0)
(define LIVES-INIT 3)
(define SCORE-INIT 0)

(define INVADER-COUNT 36)

(define MSHIP-BONUS 20)
(define INV-BONUS 5)


(define LOI
  (list
   (make-invader (make-posn (* UNIT-LEN 3) (* UNIT-LEN 4)) 1)
   (make-invader (make-posn (* UNIT-LEN 5) (* UNIT-LEN 4)) 2)
   (make-invader (make-posn (* UNIT-LEN 7) (* UNIT-LEN 4)) 3)
   (make-invader (make-posn (* UNIT-LEN 9) (* UNIT-LEN 4)) 4)
   (make-invader (make-posn (* UNIT-LEN 11) (* UNIT-LEN 4)) 5)
   (make-invader (make-posn (* UNIT-LEN 13) (* UNIT-LEN 4)) 6)
   (make-invader (make-posn (* UNIT-LEN 15) (* UNIT-LEN 4)) 7)
   (make-invader (make-posn (* UNIT-LEN 17) (* UNIT-LEN 4)) 8)
   (make-invader (make-posn (* UNIT-LEN 19) (* UNIT-LEN 4)) 9)
   (make-invader (make-posn (* UNIT-LEN 3) (* UNIT-LEN 6)) 10)
   (make-invader (make-posn (* UNIT-LEN 5) (* UNIT-LEN 6)) 11)
   (make-invader (make-posn (* UNIT-LEN 7) (* UNIT-LEN 6)) 12)
   (make-invader (make-posn (* UNIT-LEN 9) (* UNIT-LEN 6)) 13)
   (make-invader (make-posn (* UNIT-LEN 11) (* UNIT-LEN 6)) 14)
   (make-invader (make-posn (* UNIT-LEN 13) (* UNIT-LEN 6)) 15)
   (make-invader (make-posn (* UNIT-LEN 15) (* UNIT-LEN 6)) 16)
   (make-invader (make-posn (* UNIT-LEN 17) (* UNIT-LEN 6)) 17)
   (make-invader (make-posn (* UNIT-LEN 19) (* UNIT-LEN 6)) 18)
   (make-invader (make-posn (* UNIT-LEN 3) (* UNIT-LEN 8)) 19)
   (make-invader (make-posn (* UNIT-LEN 5) (* UNIT-LEN 8)) 20)
   (make-invader (make-posn (* UNIT-LEN 7) (* UNIT-LEN 8)) 21)
   (make-invader (make-posn (* UNIT-LEN 9) (* UNIT-LEN 8)) 22)
   (make-invader (make-posn (* UNIT-LEN 11) (* UNIT-LEN 8)) 23)
   (make-invader (make-posn (* UNIT-LEN 13) (* UNIT-LEN 8)) 24)
   (make-invader (make-posn (* UNIT-LEN 15) (* UNIT-LEN 8)) 25)
   (make-invader (make-posn (* UNIT-LEN 17) (* UNIT-LEN 8)) 26)
   (make-invader (make-posn (* UNIT-LEN 19) (* UNIT-LEN 8)) 27)
   (make-invader (make-posn (* UNIT-LEN 3) (* UNIT-LEN 10)) 28)
   (make-invader (make-posn (* UNIT-LEN 5) (* UNIT-LEN 10)) 29)
   (make-invader (make-posn (* UNIT-LEN 7) (* UNIT-LEN 10)) 30)
   (make-invader (make-posn (* UNIT-LEN 9) (* UNIT-LEN 10)) 31)
   (make-invader (make-posn (* UNIT-LEN 11) (* UNIT-LEN 10)) 32)
   (make-invader (make-posn (* UNIT-LEN 13) (* UNIT-LEN 10)) 33)
   (make-invader (make-posn (* UNIT-LEN 15) (* UNIT-LEN 10)) 34)
   (make-invader (make-posn (* UNIT-LEN 17) (* UNIT-LEN 10)) 35)
   (make-invader (make-posn (* UNIT-LEN 19) (* UNIT-LEN 10)) 36)))


(define INIT-WORLD
  (make-world
   SHIP-INIT LOI LOSB-INIT LOIB-INIT MOTHERSHIP-INIT
   LIVES-INIT SCORE-INIT TICKER-INIT))

(define SAMPLE-WORLD
  (make-world
 (make-spaceship (make-posn 455 735) "left")
 LOI
 (list (make-posn 605 285) (make-posn 30 75) (make-posn 625 225))
 (list
  (make-posn 90 240)
  (make-posn 510 370)
  (make-posn 510 390)
  (make-posn 90 350)
  (make-posn 510 380)
  (make-posn 210 420)
  (make-posn 150 430)
  (make-posn 150 500)
  (make-posn 210 450)
  (make-posn 210 690))
 (make-mothership (make-posn 15 60))
 3
 25
 26))

(define SAMPLE-WORLD2
  (make-world
 (make-spaceship (make-posn 455 735) "right")
 (list
   (make-invader (make-posn (* UNIT-LEN 3) (* UNIT-LEN 4)) 1)
   (make-invader (make-posn (* UNIT-LEN 5) (* UNIT-LEN 4)) 2)
   (make-invader (make-posn (* UNIT-LEN 7) (* UNIT-LEN 4)) 3)
   (make-invader (make-posn (* UNIT-LEN 9) (* UNIT-LEN 4)) 4))
 (list (make-posn 585 345) (make-posn 605 285) (make-posn 625 225))
 (list
  (make-posn 90 240)
  (make-posn 510 370)
  (make-posn 210 450)
  (make-posn 210 690))
 (make-mothership (make-posn 765 60))
 3
 25
 0))

(define SAMPLE-WORLD3
  (make-world
 (make-spaceship (make-posn 415 680) "left")
 LOI
 (list (make-posn 405 290) (make-posn 605 285) (make-posn 625 225))
 (list
  (make-posn 426 665)
  (make-posn 90 240)
  (make-posn 510 370)
  (make-posn 210 450)
  (make-posn 210 690))
 (make-mothership (make-posn 765 60))
 1
 25
 26))

(define DEAD-WORLD
  (make-world
   SHIP-INIT
   LOI
   LOSB-INIT
   LOIB-INIT
   MOTHERSHIP-INIT
   0
   SCORE-INIT
   TICKER-INIT))

(define WIN-WORLD
  (make-world
   SHIP-INIT
   empty
   LOSB-INIT
   LOIB-INIT
   MOTHERSHIP-INIT
   2
   SCORE-INIT
   TICKER-INIT))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;; FUNCTION DEFINITIONS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; get-body: Element -> Posn
    ;; GIVEN: an Element
    ;; RETURNS: its position
    (define (get-body element)
       (cond
         [(invader? element) (invader-body element)]
         [(spaceship? element) (spaceship-body element)]
         [(mothership? element) (mothership-body element)]))


;; Draw Functions
     
;; SIgnature
;; draw<Element>: Element Image -> Image
;; GIVEN: an element of the game and a background
;; RETURNS: a new image with the element drawn on the image

(define (draw-element element img)
     (local
        ;; get-img: Element -> Image
        ;; GIVEN: an Element
        ;; RETURNS: corresponding image for the element
        ((define (get-img element)
          (cond
            [(spaceship? element) SHIP-IMG]
            [(invader? element) INVADER-IMG]
            [(mothership? element) MOTHERSHIP-IMG])))
  
       (place-image (get-img element)
               (posn-x (get-body element))
               (posn-y (get-body element))
               img)))

;; Tests
(check-expect 
 (draw-element (make-invader (make-posn (* UNIT-LEN 3) (* UNIT-LEN 3)) 1) 
               BACKGROUND)
 (place-image INVADER-IMG 90 90 BACKGROUND))
(check-expect (draw-element SHIP-INIT BACKGROUND)
              (place-image SHIP-IMG 345 735 BACKGROUND))
(check-expect (draw-element MOTHERSHIP-INIT BACKGROUND)
              (place-image MOTHERSHIP-IMG 15 60 BACKGROUND))

;; Signature
;; draw-loe: Lof<Element> Image -> Image
;; GIVEN: a list of elements and background image
;; RETURNS: a new image with list of elements drawn on background
(define (draw-loe loe img)
  (foldr draw-element img loe))

;; Test
(check-expect (draw-loe empty BACKGROUND) BACKGROUND)
(check-expect (draw-loe (list (make-invader
                               (make-posn (* UNIT-LEN 3) (* UNIT-LEN 3)) 1))
                        BACKGROUND)
              (place-image INVADER-IMG 90 90 BACKGROUND))

;; Signature
;; draw-bullet: Bullet Image Image -> Image
;; GIVEN: a Bullet , its image and a background
;; RETURNS: the image of bullet on the background
(define (draw-bullet bullet bullet-img img)
  (place-image bullet-img
               (posn-x bullet)
               (posn-y bullet)
               img))

;; Tests
(check-expect (draw-bullet (make-posn 300 300) SHIP-BULLET-IMG BACKGROUND) 
              (place-image SHIP-BULLET-IMG 300 300 BACKGROUND))
(check-expect (draw-bullet (make-posn 200 200) INV-BULLET-IMG BACKGROUND) 
              (place-image INV-BULLET-IMG 200 200 BACKGROUND))

;; Signature
;; draw-lofb: Lof<Bullet> Image Image -> Image
;; GIVEN: a list of bullets, imgae of the bullet and a background
;; RETURNS: a new image with the list of bullets drawn on the image
(define (draw-lofb lofb bullet-img img)
  (cond
    [(empty? lofb) img]
    [(cons? lofb) (draw-bullet (first lofb)
                               bullet-img
                               (draw-lofb (rest lofb) bullet-img img))]))

;; Tests
(check-expect
 (draw-lofb (list (make-posn 100 100) (make-posn 200 100))
            SHIP-BULLET-IMG BACKGROUND)
 (place-image SHIP-BULLET-IMG 100 100 (place-image SHIP-BULLET-IMG 200 100
                                                   BACKGROUND)))
(check-expect
 (draw-lofb (list (make-posn 100 100) (make-posn 200 100))
            INV-BULLET-IMG BACKGROUND)
 (place-image INV-BULLET-IMG 100 100 (place-image INV-BULLET-IMG 200 100
                                                  BACKGROUND)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;; MOVE FUNCTIONS

;; Signature
;; move-invader: Invader -> Invader
;; GIVEN: an invader
;; RETURNS: the invader in a new position
(define (move-invader invader)
  (make-invader (make-posn(posn-x (invader-body invader))
                          (+ UNIT-LEN (posn-y (invader-body invader))))
                (invader-index invader)))

;; SIgnature
;; move-loi: World LOI-> LOI
;; GIVEN: a World
;; RETRNS: the LOI from world with updated positions after 10 ticks
(define (move-loi loi world)
  (local
    ;; mod10?: -> Boolean
    ;; RETURNS: true if the ticker is a multiple of 10, else flase
    ((define mod10?
       (= 0 (modulo (world-ticker world) 10))))
    (cond
      [mod10?  (map move-invader loi)]
      [else loi])))

;; Tests
(check-expect (move-loi LOI SAMPLE-WORLD) LOI)
(check-expect
 (move-loi (list
   (make-invader (make-posn (* UNIT-LEN 3) (* UNIT-LEN 4)) 1)
   (make-invader (make-posn (* UNIT-LEN 5) (* UNIT-LEN 4)) 2)
   (make-invader (make-posn (* UNIT-LEN 7) (* UNIT-LEN 4)) 3)
   (make-invader (make-posn (* UNIT-LEN 9) (* UNIT-LEN 4)) 4)) SAMPLE-WORLD2)
 (list
 (make-invader (make-posn 90 150) 1)
 (make-invader (make-posn 150 150) 2)
 (make-invader (make-posn 210 150) 3)
 (make-invader (make-posn 270 150) 4)))


;; Signature
;; move-spaceship: Spaceship -> Spaceship
;; Purpose
;; GIVEN: a spaceship 
;; RETURNS: the spaceship after it moves by SHIPSPEED in the correct direction
;;          within the canvas

(define (move-spaceship world)
  (local ((define spaceship (world-spaceship world))
          ;; INTERP: represents the spaceship from the world
          (define ship-body (spaceship-body spaceship))
          ;; INTERP: represnets the position of the spaceship
          (define direction (spaceship-direction spaceship))
          ;; INTERP: reprenests the body of the spaceship           
          
          ;; move-ship: [Number Number -> Number] -> Posn
          ;; GIVEN: a function (+ or -)
          ;; RETURNS: represnets the new position of ship after moving
          ;;         SHIPSPEED units in the correct direction  
          (define (move-ship f)
            (make-posn (f (posn-x ship-body) SHIPSPEED) (posn-y ship-body)))
          
          ;; in-limits?: Direction -> Boolean
          ;; GIVEN: a direction
          ;; RETURNS: true if the ship is in canvas in that direction, else #f
          (define (in-limits? direction)
            (not (ship-out-of-bounds? spaceship direction))))
       
     (cond
       [ (ship-hit? world) (make-spaceship (make-posn 345 735) LEFT)]
       [(and (string=? direction LEFT)
             (in-limits? direction))
        (make-spaceship (move-ship -) LEFT)]
       [(and (string=? direction RIGHT)
             (in-limits? direction))
        (make-spaceship (move-ship +) RIGHT)]
       [else spaceship])))

;; Tests
(check-expect (move-spaceship SAMPLE-WORLD)
              (make-spaceship (make-posn 445 735) LEFT))
(check-expect (move-spaceship SAMPLE-WORLD2)
              (make-spaceship (make-posn 465 735) RIGHT))
(check-expect (move-spaceship SAMPLE-WORLD3)
              (make-spaceship (make-posn 345 735) "left"))


;; Signature
;; change-dir: World Key -> Spaceship
;; WHERE: Key can be "left" or "right" only
;; GIVEN: a World and a Key
;; RETURNS: a new spaceship with updated direction
(define (change-dir world key)
  (make-spaceship (spaceship-body (world-spaceship world)) key))

;; Tests
(check-expect (change-dir INIT-WORLD "left")
              (make-spaceship (make-posn 345 735) LEFT))
(check-expect (change-dir INIT-WORLD "right")
              (make-spaceship (make-posn 345 735) RIGHT))



;; Signature
;; move-mothership: Mothership -> Mothership
;; GIVEN: a Mothership
;; RETURNS: a mothership in the new position
(define (move-mothership world)  
   (local ((define mothership (world-mothership world))
           ;; INTERP: represents the mothership of world
           (define ship-body (mothership-body mothership))
           ;; INTERP: reprenests the body of the spaceship           

            ;; move-ship: [Number Number -> Number] -> Posn
           ;; GIVEN: a function (+ or -)
           ;; RETURNS: represnets the new position of ship after moving
           ;;         SHIPSPEED units in the correct direction 
           (define (move-ship f)
              (make-posn (f (posn-x ship-body) MSHIPSPEED) (posn-y ship-body))))
     
             (cond
               [(= (modulo (world-ticker world) 30) 0) MOTHERSHIP-INIT]
               [else (make-mothership (move-ship +))])))

;; Tests
(check-expect (move-mothership INIT-WORLD)
              (make-mothership (make-posn 15 60)))
(check-expect (move-mothership 
               (make-world
                SHIP-INIT LOI LOSB-INIT LOIB-INIT
                MOTHERSHIP-INIT LIVES-INIT SCORE-INIT 10))
              (make-mothership (make-posn 45 60)))



;; Signature
;; ship-out-of-bounds?: Element Direction -> Boolean
;; WHERE Direction can ony be LEFT or RIGHT
;;       Element cannot be an Invader
;; GIVEN: a spaceship or mothership and a direction
;; RETURNS: true if it is out of the canvas boundaries, else false

(define (ship-out-of-bounds? element direction)
  
    (cond
    [(string=? direction LEFT)
     (posn-out-of-bounds (ship-edges element -))]
    [(string=? direction RIGHT)
     (posn-out-of-bounds (ship-edges element +))]))

(check-expect (ship-out-of-bounds? SHIP-INIT LEFT) #false)


;; SIgnature
;; ship-edges: Element [X X -> X] ->Posn
;; WHERE: Element cannot be Invader
;; GIVEN: am Element and a function
;; RETURN: A Posn defining the x edges of the Element based on function
(define (ship-edges element f)
  (local
    ;; get-f: Element -> Number
    ;; GIVEN: an Element
    ;; RETURNS: the appropriate length constant for the element
    ((define get-fac
       (cond
         [(mothership? element) SHIP-LEN-FACTOR]
         [(spaceship? element) INV-LEN-FACTOR])))
    
    (make-posn (f (posn-x (get-body element)) (/ UNIT-LEN get-fac)) 
                 (posn-y (get-body element)))))

;; Tests
(check-expect (ship-edges MOTHERSHIP-INIT +)
              (make-posn 30 60))

;; Signature 
;; posn-out-of-bounds : Posn -> Boolean
;; GIVEN: a posn
;; RETURNS: true if the posn is out of bounds, false otherwise
(define (posn-out-of-bounds p)
  (or (<=  (posn-x p) 0)
      (>= (posn-x p) WIDTH)
      (<=  (posn-y p) 0)
      (>= (posn-y p) HEIGHT)))



;; Signature
;; move-bullet: Bullet Direction [Number Number -> Number]-> Bullet
;; GIVEN: a bullet and function (+ or -)
;; RETURNS: a new ullet with its position updated
;;          by BULLETSPEED in correct direction
(define (move-bullet bullet f)
  (local
    ((define factor
       (cond
         [(equal? f +) 2]
         [(equal? f -) 6])))
    ;; INTERP: represents the factor of bullet speed based on its direction
    
   (make-posn (posn-x bullet)
             (f (posn-y bullet) (* factor BULLETSPEED)))))

;; Tests

(check-expect (move-bullet (make-posn 100 200) +)
              (make-posn 100 220))

;; Signature 
;; move-lofb: Lof<Bullet> [Number Number -> Number -> Lof<Bullet>
;; GIVEN: a bullet and a function (+ or -)
;; RETURNS: a Lof<Bullet> with their positions updated
(define (move-lofb lofb f)
  (cond
    [(empty? lofb) empty]
    [(cons? lofb) (cons (move-bullet (first lofb) f)
                        (move-lofb (rest lofb) f))]))

;; Tests
(check-expect (move-lofb (list (make-posn 100 200)
                               (make-posn 0 10)
                               (make-posn 10 20)) -)
              (list
 (make-posn 100 140)
 (make-posn 0 -50)
 (make-posn 10 -40)))
(check-expect (move-lofb (list (make-posn 100 200)
                               (make-posn 0 10)
                               (make-posn 10 20)) +)
              (list
 (make-posn 100 220)
 (make-posn 0 30)
 (make-posn 10 40)))

;;;;; UPDATING FUNCTIONS

;; Signature
;; fill-losb: ShipBullet World -> Lof<ShipBullet>
;; GIVEN: a ShipBullet  and a World
;; RETURNS: a Lof<ShipBullet> with the ShipBullet appended in it

(define (fill-losb world )
  (local
    ((define losb (world-losb world))
      ;; INTERP: represents the LOSB from the world
     (define ship-bullet (spaceship-body (world-spaceship world)))
     ;; INTERP: represent the position of the spaceship as a bullet position
     )
    (cond    
    [(< (count-list losb) MAX-SHIP-BULLETS)
     (cons ship-bullet losb)]
    [else losb])))

;; Tests
(check-expect (fill-losb 
                         (make-world
                          (make-spaceship (make-posn 385 680) LEFT)
                          (list
                           (make-invader (make-posn 90 90) 1)
                           (make-invader (make-posn 150 90) 2)
                           (make-invader (make-posn 210 90) 3))
                          (list
                           (make-posn 520 465)
                           (make-posn 485 350))
                          (list
                           (make-posn 90 595)
                           (make-posn 210 605)
                           (make-posn 150 450)
                           (make-posn 90 610))
                          MOTHERSHIP-INIT
                          LIVES-INIT
                          SCORE-INIT
                          TICKER-INIT))
              
              (list
               (make-posn 385 680)
               (make-posn 520 465)
               (make-posn 485 350)))

;; Signature
;; fill-loib: World -> loib
;; GIVEN: a World
;; RETURNS: a LOIB with the posn of the invader appended in it
(define (fill-loib world )  
  (local
    ((define loib (world-loib world))
    ;; INTERP: represents a LOIB from the world
    (define invader (random-invader (world-loi world))))
    ;; INTERP: represents a random invader from the world LOI

    (cond
    [(and (< (count-list loib) (on-screen-bullets world))
          (< (invader-index invader) INVADER-COUNT))
     (cons (invader-body invader) loib)] 
    [else loib])))


;; RANDOM FUNCTION NO TEST
;; Tests
#;(check-random (fill-loib 
                         (make-world
                          (make-spaceship (make-posn 385 680) LEFT)
                          (list
                           (make-invader (make-posn 90 90) 1)
                           (make-invader (make-posn 150 90) 2)
                           (make-invader (make-posn 210 90) 3))
                          (list
                           (make-posn 520 465)
                           (make-posn 485 350))
                          (list
                           (make-posn 90 610))
                          MOTHERSHIP-INIT
                          LIVES-INIT
                          SCORE-INIT
                          TICKER-INIT))
              
              (list               
               (make-posn 90 610)))

;; on-screen-bullets: World -> NonNegInt
;; GIVEN: a World
;; RETURNS: The max number of invader bullets
;;          to be present on the screen at a given time
(define (on-screen-bullets world)
   (cond
    [(< (count-list (world-loi world))
        (* INVADER-COUNT  0.8))
     (floor (/ MAX-INV-BULLETS 2))]
    [else MAX-INV-BULLETS]))

;; Tests
(check-expect (on-screen-bullets (make-world
                          (make-spaceship (make-posn 385 680) LEFT)
                          empty
                          (list
                           (make-posn 520 465)
                           (make-posn 485 350))
                          (list
                           (make-posn 90 595)
                           (make-posn 210 605)
                           (make-posn 150 450)
                           (make-posn 90 610))
                          MOTHERSHIP-INIT
                          LIVES-INIT
                          SCORE-INIT
                          TICKER-INIT)
                                 ) 5)

(check-expect (on-screen-bullets (make-world
                          (make-spaceship (make-posn 385 680) LEFT)
                          LOI
                          (list
                           (make-posn 520 465)
                           (make-posn 485 350))
                          (list
                           (make-posn 90 595)
                           (make-posn 210 605)
                           (make-posn 150 450)
                           (make-posn 90 610))
                          MOTHERSHIP-INIT
                          LIVES-INIT
                          SCORE-INIT
                          TICKER-INIT)
                                 ) 10)

;; Signature
;; count-lofb: Lof<X> -> NonNegNumber
;; GIVEN: a Lof<X>
;; RETURNS: the number of elements in list
(define (count-list list)
  (foldr + 0
         (map (lambda (x) 1) ;; [Any -> Number]
              list)))

;; Tests
(check-expect (count-list empty) 0)
(check-expect (count-list
               (list
                (make-posn 345 500)
                (make-posn 345 480))) 2)

;; SIgnature
;; lofb-remove: Lof<Bullet> -> Lof<Bullet>
;; Purpose
;; GIVEN: a Lof<Bullet>
;; RETURNS: a new Lof<Bullet> with bullets out of bounds removed from it
(define (lofb-remove lofb)
  (cond
    [(empty? lofb) empty]
    [(cons? lofb) (cond
                    [(posn-out-of-bounds (first lofb)) (rest lofb)]
                    [else (cons (first lofb) (lofb-remove (rest lofb)))])]))
;; Tests
(check-expect (lofb-remove empty) empty)
(check-expect (lofb-remove (list
                            (make-posn 90 595)
                            (make-posn 210 605)
                            (make-posn 1000 -1)
                            (make-posn 90 610)))
              (list
               (make-posn 90 595)
               (make-posn 210 605)
               (make-posn 90 610)))


;; Signature
;; random-invader: LOI -> Invader
;; Purpose
;; GIVEN: LOI
;; RETURNS: a ramdom invader from the list

(define (random-invader loi)
  (local
    ((define NULL-INVADER (make-invader (make-posn 90 90) (+ 1 INVADER-COUNT)))
    ;; INTERP: represents an invader with out-of-bounds index
     (define random-index (random  INVADER-COUNT))
    ;; INTERP: Generates a random number less than INVADER-COUNT      
    )
    (cond
    [(empty? loi) NULL-INVADER]
    [(cons? loi) (cond
                   [(= random-index (invader-index (first loi)))
                    (first loi)] 
                   [else (random-invader (rest loi))])])))

;; RANDOM FUNCTION NO TEST

;; Signature
;; invader-hit?: Invader ShipBullet -> Boolean
;; Purpose
;; GIVEN: an invader and a ShipBulet
;; RETURNS: true if the bullet hits the invader, else false
(define (invader-hit? invader ship-bullet)
  (local
    ;; posn-y=? : Posn Posn -> Boolean
    ;; Purpose
    ;; GIVEN: two posns
    ;; RETURNS: true if the two posns have the same y coordinates or p1-y<p2-y,
    ;;          else false
    ((define (posn-y=? p1 p2)
       (<= (posn-y p1) (posn-y p2))))
    
    (and (posn-y=? ship-bullet (element-hit-bounds-y invader))
         (posn-x-in-element-range? invader ship-bullet ))))

;; Tests
(check-expect
 (invader-hit? (make-invader (make-posn 270 90) 4) (make-posn 270 105)) #true)
(check-expect
 (invader-hit? (make-invader (make-posn 270 90) 4) (make-posn 285 105)) #true)
(check-expect
 (invader-hit? (make-invader (make-posn 270 90) 4) (make-posn 255 105)) #true)
(check-expect
 (invader-hit? (make-invader (make-posn 270 90) 4) (make-posn 255 104)) #true)
(check-expect
 (invader-hit? (make-invader (make-posn 270 90) 4) (make-posn 255 106)) #false)
(check-expect
 (invader-hit? (make-invader (make-posn 270 90) 4) (make-posn 300 105)) #false)

;; Signature
;; mothership-hit?: Mothership ShipBullet -> Boolean
;; GIVEN: a mothership and a ship bullet
;; RETURNS true if the ship bullet hits the mothership, else false
(define (mothership-hit? mothership ship-bullet)
  (local
    ;; posn-y=? : Posn Posn -> Boolean
    ;; Purpose
    ;; GIVEN: two posns
     ;; RETURNS: true if the two posns have the same y coordinates or p1-y<p2-y
    ;;          else false
    ((define (posn-y=? p1 p2)
       (<= (posn-y p1) (posn-y p2))))
    
    (and (posn-y=? ship-bullet (element-hit-bounds-y mothership))
         (posn-x-in-element-range? mothership ship-bullet ))))

;; Signature
;; elemnts-hit-bounds-y: Element -> Posn
;; GIVEN: an Element 
;; RETURNS: the y boundary condition for hitting of the element
(define (element-hit-bounds-y element)
  (local
     ;; get-f: Element -> [Number Number -> Number]
     ;; GIVEN: an Element
     ;; RETURNS: the appropriate function( + or - )
     ((define (get-f element)
       (cond
         [(invader? element) +]
         [(spaceship? element) -]
         [(mothership? element) +])))
    
    (make-posn (posn-x (get-body element))
              ((get-f element) (posn-y (get-body element)) (/ UNIT-LEN 2)))))

;; Tests
(check-expect (element-hit-bounds-y (make-spaceship (make-posn  300 300) LEFT))
              (make-posn 300 285))
(check-expect (element-hit-bounds-y (make-invader (make-posn 270 90) 4) )
              (make-posn 270 105))

;; SIgnature
;; GIVEN: an Element and a Bullet
;; RETURNS: True if the bullet is within the x-offests of the element
;;          else false
(define (posn-x-in-element-range? element bullet)
  (local
    ;; get-f: Element -> Number
    ;; GIVEN: an Element
    ;; RETURNS: the appropriate length constant for the element
    ((define (get-f element)
       (cond
         [(invader? element) INV-LEN-FACTOR]
         [(spaceship? element) SHIP-LEN-FACTOR]
         [(mothership? element) INV-LEN-FACTOR]))

    (define get-half (/ (*(get-f element) UNIT-LEN) 2)))
    ;; INTERP: represents half of the elements length
    
    (and ( >= (+ (posn-x (get-body element)) get-half)
            (posn-x bullet))
       ( <= (- (posn-x (get-body element)) get-half)
            (posn-x bullet)))))


;; Tests
(check-expect
 (posn-x-in-element-range? (make-spaceship (make-posn 300 300) LEFT)
                                    (make-posn 330 300) ) #true )
(check-expect
 (posn-x-in-element-range? (make-spaceship (make-posn 300 300) LEFT)
                                    (make-posn 400 300) ) #false )
(check-expect
 (posn-x-in-element-range? (make-invader (make-posn 300 300) 1)
                                    (make-posn 300 300) ) #true )
(check-expect
 (posn-x-in-element-range? (make-invader (make-posn 300 300) 1)
                                    (make-posn 400 300) ) #false )

;; SIgnature
;; no-invaders?: World -> Boolean
;; GIVEN: a World
;; RETURNS: true if all invaders are dead, else false
(define (no-invader? world)
  (cond
    [(= 0 (count-list (world-loi world))) #true]
    [else #false]))

;; Tests
(check-expect (no-invader? INIT-WORLD) #false)
(check-expect (no-invader? (make-world
                          (make-spaceship (make-posn 385 680) LEFT)
                          (list
                           (make-invader (make-posn 90 90) 1)
                           (make-invader (make-posn 150 90) 2)
                           (make-invader (make-posn 210 90) 3))
                          (list
                           (make-posn 520 465)
                           (make-posn 485 350))
                          (list
                           (make-posn 90 595)
                           (make-posn 210 605)
                           (make-posn 150 450)
                           (make-posn 90 610))
                          MOTHERSHIP-INIT
                          LIVES-INIT
                          SCORE-INIT
                          TICKER-INIT)
                           ) #false)
(check-expect (no-invader? (make-world
                          (make-spaceship (make-posn 385 680) LEFT)
                          empty
                          (list
                           (make-posn 520 465)
                           (make-posn 485 350))
                          (list
                           (make-posn 90 595)
                           (make-posn 210 605)
                           (make-posn 150 450)
                           (make-posn 90 610))
                          MOTHERSHIP-INIT
                          LIVES-INIT
                          SCORE-INIT
                          TICKER-INIT)
                           ) #true)

;; Signature
;; lives-count: World -> NonNegInt
;; GIVEN: a World
;; RETURNS: true, if spaceship is out of lives, else false
(define (lives-count world)
  (local(
         (define mothership (world-mothership world))
         (define losb (world-losb world)))
    
    (cond
    [(mship-hit? mothership losb) (+ (world-lives world) 1)]
    [(ship-hit? world) (- (world-lives world) 1)]
    [else (world-lives world)])))


;; Tests
(check-expect (lives-count SAMPLE-WORLD3) 0)
(check-expect (lives-count SAMPLE-WORLD) 4)


;; Signature
;; lives-over?: World -> Boolean
;; GIVEN: a world
;; RETURNS: true if the spaceship is out of lives, else false
(define (lives-over? world)
  (cond
    [(= 0 (world-lives world)) #true]
    [else false]))

;; Tests
(check-expect (lives-over? SAMPLE-WORLD) #false)
(check-expect (lives-over? DEAD-WORLD) #true)

;; SIgnature
;; 


;; Signature
;; ship-hit: World -> Boolean
;; GIVEN: a world
;; RETURNS: true if the ship is hit else false
(define (ship-hit? world)
  (cond
    [(empty? (world-loib world)) #false]
    [(cons? (world-loib world))
     (ship-hit-loib (world-spaceship world) (world-loib world))]))

;; Tests
(check-expect (ship-hit? DEAD-WORLD) #false)

;; Signature
;; ship-hit-loib: Spaceship LOIB -> Boolean
;; GIVEN: a spaceship and a list of bullets
;; RETURNS: true if an invader bullet hits the spaceship, else false
(define (ship-hit-loib spaceship loib)
  (cond
    [(empty? loib) #false]
    [(cons? loib) (cond
                    [(ship-hit-ib spaceship (first loib)) #true]
                    [else (ship-hit-loib spaceship (rest loib))])]))

;; Tests
(check-expect
 (ship-hit-loib
  (make-spaceship (make-posn 455 680) LEFT) (list
                                             (make-posn 270 150)
                                             (make-posn 510 285)
                                             (make-posn 270 180)
                                             (make-posn 90 195)))
 #false)
(check-expect
 (ship-hit-loib (make-spaceship (make-posn 455 680) LEFT) (list
                                                           (make-posn 270 150)
                                                           (make-posn 510 285)
                                                           (make-posn 445 665)
                                                           (make-posn 90 195)))
 #true)

;; Signature
;; ship-hit-ib: Spaceship InvBullet -> Boolean
;; GIVEN: a space ship and an invader-bullet
;; RETURNS: true if the bullet hits the spaceship, else false
(define (ship-hit-ib spaceship inv-bullet)
  (local
    ;; posn-y=? : Posn Posn -> Boolean
    ;; GIVEN: two posns
    ;; RETURNS: true if the two posns have the same y coordinates, else false
    ((define (posn-y=? p1 p2)
       (= (posn-y p1) (posn-y p2))))

    
  (and (posn-y=? (element-hit-bounds-y spaceship ) inv-bullet)
       (posn-x-in-element-range? spaceship inv-bullet ))))


;; Tests
(check-expect
 (ship-hit-ib (make-spaceship (make-posn 415 680) LEFT) (make-posn 426 665) )
 #true)
(check-expect
 (ship-hit-ib (make-spaceship (make-posn 415 680) LEFT) (make-posn 426 664) )
 #false)

;; SIgnature
;; remove-hit-invader: LOI ShipBullet -> LOI
;; GIVEN: a LOI and a ShipBullet
;; RETURNS: a LOI with the invader hit by the given bullet removed from the LOI

(define (remove-hit-invader loi ship-bullet)
  (cond
    [(empty? loi) empty]
    [(cons? loi) (cond
                   [(invader-hit? (first loi) ship-bullet) (rest loi)]
                   [else (cons (first loi)
                               (remove-hit-invader (rest loi) ship-bullet))])]))






;;Tests
(check-expect (remove-hit-invader empty (make-posn 0 0)) empty)
(check-expect (remove-hit-invader
               (list
                (make-invader (make-posn 90 90) 1)
                (make-invader (make-posn 150 90) 2)
                (make-invader (make-posn 210 90) 3) 
                (make-invader (make-posn 270 90) 4)
                (make-invader (make-posn 330 90) 5)) (make-posn 210 105))
              (list
                (make-invader (make-posn 90 90) 1)
                (make-invader (make-posn 150 90) 2)
                (make-invader (make-posn 270 90) 4)
                (make-invader (make-posn 330 90) 5)))

;; Signautre
;; update-invaders: LOI LOSB -> LOI
;; GIVEN: a LOI and a LOSB
;; RETURS: a LOI with all invaders which are hit by bullets removed from LOI

(define (update-invaders loi losb)
   (cond
    [(empty? losb) loi]
    [(cons? losb)
     (update-invaders (remove-hit-invader loi (first losb))
                      (rest losb))]))


;;;;;;;;;;;;;;;TRY MAP HERE

;; Tests
(check-expect (update-invaders (list
                                (make-invader (make-posn 90 90) 1)
                                (make-invader (make-posn 150 90) 2)
                                (make-invader (make-posn 210 90) 3)
                                (make-invader (make-posn 270 90) 4)
                                (make-invader (make-posn 330 90) 5))
                               (list
                                (make-posn 210 135)
                                (make-posn 150 105)
                                (make-posn 150 310)
                                (make-posn 270 105)
                                (make-posn 90 595)
                                (make-posn 150 495)))
              (list              (make-invader (make-posn 90 90) 1)
                                 (make-invader (make-posn 210 90) 3)
                                 (make-invader (make-posn 330 90) 5)))


;; Signature
;; remove-hit-ship-bullet: Element LOSB -> LOSB
;; WHERE: Element is not a Spaceship
;; GIVEN: an Element and a LOSB
;; RETUNRS: a LOSB with bullets that hit the given invader removed from LOSB

(define (remove-hit-ship-bullet element losb)
  (local
    ;; f: -> [Element ShipBullet -> Boolean]
    ;; wHERE: Element cannot be Spaceship
    ;; RETURNS: the hit function corresponding to the element
    ((define f
       (cond
         [(mothership? element) mothership-hit?]
         [(invader? element) invader-hit?])))
    
    (cond
      [(empty? losb) empty]
      [(cons? losb) (cond
                      [(f element (first losb)) (rest losb)]
                      [else (cons (first losb)
                            (remove-hit-ship-bullet element (rest losb)))])])))

;; Tests
(check-expect (remove-hit-ship-bullet
               (make-invader (make-posn 330 90) 5) empty) empty)
(check-expect (remove-hit-ship-bullet
               (make-invader (make-posn 330 90) 5)
               (list
                 (make-posn 90 90) 
                 (make-posn 150 90) 
                 (make-posn 270 90) 
                 (make-posn 330 105)))
              (list
                 (make-posn 90 90) 
                 (make-posn 150 90) 
                 (make-posn 270 90)))


;; Signature
;; update-losb: Enemy LOSB -> LOSB
;; WHERE: Enemy can be a MOTHERSHIP or LOI
;; GIVEN: an Enemy and a LOSB
;; RETURNS: a LOSB with all bullets that hit any enemy removed from the LOSB


(define (update-losb enemy losb)
    (cond
    [(mothership? enemy) (remove-hit-ship-bullet enemy losb)]  
    [(empty? enemy) losb]
    [(cons? enemy) (update-losb
                  (rest enemy)
                  (remove-hit-ship-bullet (first enemy) losb))]))

;; Tests
(check-expect (update-losb (list
                            (make-invader (make-posn 90 90) 1)
                            (make-invader (make-posn 150 90) 2)
                            (make-invader (make-posn 210 90) 3)
                            (make-invader (make-posn 270 90) 4)
                            (make-invader (make-posn 330 90) 5))
                           (list
                            (make-posn 210 135)
                            (make-posn 150 105)
                            (make-posn 150 310)
                            (make-posn 270 105)
                            (make-posn 90 595)
                            (make-posn 150 495)))
              (list
 (make-posn 210 135)
 (make-posn 150 310)
 (make-posn 90 595)
 (make-posn 150 495)))

(check-expect (update-losb (make-mothership (make-posn 150 90))
                           (list
                            (make-posn 210 135)
                            (make-posn 150 105)
                            (make-posn 150 310)
                            (make-posn 270 105)
                            (make-posn 90 595)
                            (make-posn 150 495)))
              (list
                            (make-posn 210 135)
                            
                            (make-posn 150 310)
                            (make-posn 270 105)
                            (make-posn 90 595)
                            (make-posn 150 495)))


;; SIgnature
;; update-ticker: World -> Ticker
;; GIVEN: a Ticker
;; RETURNS: the value of ticker after 1 tick,
;;          0 after verey 30 ticks
(define (update-ticker world)
  ;;(cond
    ;; if mothereship hit then 0
    ;;[(not (= (world-ticker world) 30)) (+ 1 (world-ticker world))]
    ;;[else 0])
  (+ (world-ticker world) 1))

;; Tests
(check-expect (update-ticker DEAD-WORLD)
              1)

;; mship-hit?: MOthership LOSb -> Boolena
;; GIVEN:  a MOthership and alOSB
;; RETURSN: true of any bullet hits the mothership, else false
(define (mship-hit? mothership losb)
  (cond
    [(empty? losb) #false]
    [(cons? losb) (or (mothership-hit? mothership (first losb))
                      (mship-hit? mothership (rest losb)))]))

;; SIgnature
;; update-score: World -> Score
;; GIVEN: a World
;; RETURNS: the total value of score 
(define (update-score-inv world)
  (local
    ((define mothership (world-mothership world))
     ;; INTERP ;represents the mothership from the world
     (define losb (world-losb world))
     ;; INTERP: represents the losb from teh world
     
         
     (define m-hit (mship-hit? mothership losb))
     ;; INTERP: represents the hit condition of the mothership
     
     (define inv-bonus
       (* INV-BONUS (- INVADER-COUNT (count-list (world-loi world)))))
     ;; INTERP: represents the score due to hit invaders
     )
    
    (cond
      [m-hit (+ MSHIP-BONUS inv-bonus)] 
      [else inv-bonus])))

;; Tests
(check-expect (update-score-inv WIN-WORLD) 180)
(check-expect (update-score-inv SAMPLE-WORLD) 20)


;; Signature
;; show-lives: World Img -> Image
;; GIVEN: a world and a background
;; RETURNS:  a new image with the score displayed on
;;           background at specific position
(define (show-lives world img)
  (place-image
   (text (number->string (world-lives world)) 20 "black")
   (- WIDTH 20)
   (- HEIGHT 20)
   (place-image
    (text "LIVES: " 20 "black")
    (- WIDTH 60)
    (- HEIGHT 20)
    img)))

;; Tests
(check-expect (show-lives DEAD-WORLD BACKGROUND)
              (place-image
               (text "0" 20 "black")
               (- WIDTH 20)
               (- HEIGHT 20)
               (place-image
                (text "LIVES: " 20 "black")
                (- WIDTH 60)
                (- HEIGHT 20)
                BACKGROUND)))


;; Signature
;; show-score: World Img -> Image
;; GIVEN: a world and a background
;; RETURNS:  a new image with the score displayed on
;;           background at specific position
(define (show-score world img)
  (place-image
   (text (number->string (world-score world)) 20 "black")
   (- WIDTH 20)
   20
   (place-image
    (text "SCORE: " 20 "black")
    (- WIDTH 70)
    20
    img)))

;; Tests
(check-expect (show-score DEAD-WORLD BACKGROUND)
              (place-image
               (text "0" 20 "black")
               (- WIDTH 20)
               20
               (place-image
                (text "SCORE: " 20 "black")
                (- WIDTH 70)
                20
                BACKGROUND)))


;; Signature
;; show-ticker: World Img -> Image
;; GIVEN: a world and a background
;; RETURNS:  a new image with the ticks displayed on the
;;           background at specific position
(define (show-ticker world img)
  (place-image
   (text (number->string (world-ticker world)) 20 "black")
   20
   20
   img))

;; Tests
(check-expect (show-ticker DEAD-WORLD BACKGROUND)
              (place-image
               (text "0" 20 "black")
               20
               20
               BACKGROUND))

;; Signature
;; ship-hit-invader?: Spaceship Invader
;; GIVEN: a spacecship and an invader
;; RETURNS: true of the invader crosses the top edge of the spaceship
;;          else false
(define (ship-hit-invader? spaceship invader)
  (<= (posn-y (element-hit-bounds-y spaceship ))
      (+ (/ UNIT-LEN 2)
         (posn-y (invader-body invader)))))

;; Signature
;; invader-down?: World -> Booelan
;; GIVEN: A World
;; RETURNS: True if the invaders cross the spaceship, else false
(define (invader-down? world)
  (local
    ((define (f invader)
       (ship-hit-invader? (world-spaceship world) invader)))
    (ormap f (world-loi world))))

;; Tests
(check-expect (invader-down? INIT-WORLD) #false)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;; BIGBANG AND HELPERS

;;;; Signature 
;; key-handler : World Key-Event -> World
;;;; Purpose
;; GIVEN: the current world and a key event
;; RETURNS: a new world with direction updated according to the key event.


(define (key-handler world ke)
  (local
    ((define movement? (or (key=? ke "left")
                           (key=? ke "right")) ))
    ;; INTERP: checks if the key pressed is a movement key
    (cond 
      [ movement? (make-world (change-dir world ke)
                              (world-loi world)
                              (world-losb world)
                              (world-loib world)
                              (world-mothership world)
                              (world-lives world)
                              (world-score world)
                              (world-ticker world))]
      [(key=? ke " ") (make-world (world-spaceship world)
                                  (world-loi world)
                                  (fill-losb world)
                                  (world-loib world)
                                  (world-mothership world)
                                  (world-lives world)
                                  (world-score world)
                                  (world-ticker world))]    
      [else world])))

;; Tests
(check-expect (key-handler DEAD-WORLD "right")
              (make-world
               (make-spaceship (make-posn 345 735) "right")
               LOI LOSB-INIT LOIB-INIT MOTHERSHIP-INIT 0 SCORE-INIT
               TICKER-INIT))
(check-expect (key-handler DEAD-WORLD " ")
              (make-world
               SHIP-INIT
               LOI (list (make-posn 345 735))
               LOIB-INIT MOTHERSHIP-INIT 0 SCORE-INIT
               TICKER-INIT))
(check-expect (key-handler DEAD-WORLD "up")
              DEAD-WORLD)

  


;;;; Signature
;; draw-world : World -> Image
;;;; Purpose
;; GIVEN: a world 
;; RETURNS: an image representation of the given world


(define (draw-world world)
  (show-ticker world
     (show-lives world
         (show-score world
              (draw-element (world-mothership world)
                   (draw-element (world-spaceship world) 
                        (draw-lofb (world-losb world) SHIP-BULLET-IMG
                               (draw-lofb (world-loib world) INV-BULLET-IMG
                                     (draw-loe (world-loi world) 
                                                         BACKGROUND)))))))))

;; Tests
(check-expect (draw-world INIT-WORLD) (draw-world INIT-WORLD))


;;;; Signature 
;; world-step: World -> World
;;;; Purpose
;; GIVEN: the current world
;; RETURNS: the next world after one clock tick


(define (world-step world)
  (make-world (move-spaceship world)
              (move-loi (update-invaders (world-loi world)
                               (world-losb world))
                        world)
              (lofb-remove (move-lofb (update-losb
                                       (world-mothership world)
                                       (update-losb (world-loi world)
                                                    (world-losb world))) -))
              (lofb-remove (move-lofb (fill-loib world) +))
              (move-mothership world)
              (lives-count world)
              (update-score-inv world)
              (update-ticker world)))

;; Signature
;; end-game: World -> Boolean
;; Purpose
;; GIVEN: a world
;; RETURNS: true if the all invaders are dead or ship is hit, else false
(define (end-game world)
  (or (invader-down? world)
      (no-invader? world)
      (lives-over? world)))

;; Tests
(check-expect (end-game INIT-WORLD) #false)
(check-expect (end-game DEAD-WORLD) #true)

(big-bang INIT-WORLD
          (on-tick world-step 0.1)
          (on-key key-handler)
          (to-draw draw-world)
          (stop-when end-game))
