//
//  APRMainViewController.swift
//  flow
//
//  Created by Darvish Kamalia on 4/4/15.
//  Copyright (c) 2015 AprilStudios. All rights reserved.
//

import UIKit
import QuartzCore

struct state {
    
    var name: String
    var circleColor: UIColor
    
    
}

//  Controls the Main View
//  This includes the states selector, and the label from the current state
//

class APRMainViewController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate  {
    
    var states: [state] = []
    let circleLayer: CAShapeLayer! = CAShapeLayer()
    var newView:UIView?
    var startedButtonAnimation = false
    var finishedButtonAnimation = false
    var stateButtons: [UIButton] = []
    var currentPage: Double = 0
    var prevPage: Double = 0
    var lpgc = UILongPressGestureRecognizer()

    @IBAction func addStateButton(sender: AnyObject) {
        
        states.append(state(name: "newState", circleColor: getRandomColor()))
        var newButton = UIButton(frame: CGRect(x: (states.count - 1)*200 + 20, y: 20, width: 180, height: 180))
        //newButton.addTarget(self, action: "changeState:", forControlEvents: UIControlEvents.TouchDown)
        //newButton.addTarget(self, action: "liftUpState:", forControlEvents: UIControlEvents.TouchUpInside)
        newButton.layer.cornerRadius = (newButton.bounds.size.height/2)
        newButton.backgroundColor = states[states.count - 1].circleColor
        stateButtons.append(newButton)
        stateScrollView.contentSize = CGSizeMake(CGFloat(200*states.count), 200)

        stateScrollView.addSubview(newButton)
        
        
        stateScrollView.setContentOffset(CGPoint(x: CGFloat(200*(states.count - 1)), y: 0), animated: true)
        
        currentPage+=1
    }
    @IBOutlet weak var buttonsView: UIView!
    
    @IBOutlet weak var stateScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var lpgc  = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
        lpgc.delegate = self
        view.addGestureRecognizer(lpgc)
        println ("old")
        stateScrollView.showsHorizontalScrollIndicator = false
        stateScrollView.showsVerticalScrollIndicator = false
        
        states.append(state(name: "Working", circleColor: UIColor.lightGrayColor()))
        states.append(state(name: "Eating", circleColor: UIColor.yellowColor()))
        states.append(state(name: "Lifting", circleColor: UIColor.cyanColor()))
        states.append(state(name: "Studying", circleColor: UIColor.magentaColor()))
        states.append(state(name: "Fucking", circleColor: UIColor.greenColor()))
        
        var i = 0

        for state in states {
            
            stateButtons.append(UIButton(frame: CGRect(x: i*200 + 20, y: 20, width: 180, height: 180)))
            stateButtons[i].backgroundColor = states[i].circleColor
            stateButtons[i].layer.cornerRadius = (stateButtons[i].bounds.size.height/2)
            
            //newButton.setTitleColor(getRandomColor(), forState: UIControlState.Normal)
            //newButton.setTitle(states[i].name, forState: UIControlState.Normal)
            
            println("added target")
//            stateButtons[i].addTarget(self, action: "changeState:", forControlEvents: UIControlEvents.TouchDown)
//            stateButtons[i].addTarget(self, action: "liftUpState:", forControlEvents: UIControlEvents.TouchUpInside)
        
           var gs =  UIGestureRecognizer(target: self, action: "longPress")
           stateScrollView.addSubview(stateButtons[i])
            i+=1
            
        }
        
        stateScrollView.contentSize = CGSizeMake(CGFloat(200*states.count), 200)
        println(stateScrollView.contentSize)

        
       
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        
        println("set size")
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: buttonsView.frame.origin.x + 45, y: buttonsView.frame.origin.y + 10),  radius: 100, startAngle: CGFloat(-M_PI/2), endAngle: CGFloat(3*M_PI/2.0), clockwise: true)
        
        // Setup the CAShapeLayer with the path, colors, and line width
        circleLayer.path = circlePath.CGPath
        circleLayer.fillColor = UIColor.clearColor().CGColor
        circleLayer.lineWidth = 5.0
        
        // Don't draw the circle initially
        circleLayer.strokeEnd = 0.0
        
        // Add the circleLayer to the view's layer's sublayers
        buttonsView.layer.addSublayer(circleLayer)
        

    }
    
    
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        finishedButtonAnimation = true
        println("anime")
        
        var pulseAnimation:CABasicAnimation = CABasicAnimation(keyPath: "opacity");
        pulseAnimation.duration = 0.25
        pulseAnimation.toValue = 0.5
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = 2
        circleLayer.addAnimation(pulseAnimation, forKey: "pulse")
    }
    
    
    func animateCircle(duration: NSTimeInterval) {
        println("animating")
        
        circleLayer.strokeColor = states[Int(currentPage)].circleColor.CGColor
        // We want to animate the strokeEnd property of the circleLayer
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        // Set the animation duration appropriately
        animation.duration = duration
        
        // Animate from 0 (no circle) to 1 (full circle)
        animation.fromValue = 0
        animation.toValue = 1
        
        // Do a linear animation (i.e. the speed of the animation stays the same)
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.delegate = self       // Set the circleLayer's strokeEnd property to 1.0 now so that it's the
        // right value when the animation ends.
        circleLayer.strokeEnd = 1.0
        
        // Do the actual animation
        circleLayer.addAnimation(animation, forKey: "animateCircle")
        
        
    }
    
    func handleLongPress (recognizer: UILongPressGestureRecognizer) {
        
        if (recognizer.state == UIGestureRecognizerState.Began){
            
            if (!startedButtonAnimation){
                
                println("starting animation")
                animateCircle(1)
                startedButtonAnimation = true
                finishedButtonAnimation = false
                
            }
        }
            
            else if (recognizer.state == UIGestureRecognizerState.Ended) {
                
                if (finishedButtonAnimation) {
                    
                    println("finished")
                    finishedButtonAnimation = false
                    startedButtonAnimation = false
                    
                }
                    
                else {
                    
                    println("failed")
                    circleLayer.removeAnimationForKey("animateCircle")
                    circleLayer.strokeEnd = 0.0
                    startedButtonAnimation = false
                    
                }

                
            }
    
    }
    
    
//    func changeState (Sender: UIButton!){
//        
//        println("called")
//        if (!startedButtonAnimation){
//        animateCircle(1)
//        }
//        startedButtonAnimation = true
//    }
//    
//    func liftUpState(Sender: UIButton! ){
//        

//   }
    
    func scrollViewDidBeginScroll(scrollView: UIScrollView) {
        var width = Double(scrollView.frame.size.width)
        prevPage = (Double(scrollView.contentOffset.x) + (0.5 * width)) / width - 0.5
        circleLayer.strokeEnd = 0.0

        scrollView.userInteractionEnabled = false
        
    }
    
     func scrollViewDidScroll(scrollView: UIScrollView) {
        var width = Double(scrollView.frame.size.width)
        currentPage = (Double(scrollView.contentOffset.x) + (0.5 * width)) / width - 0.5
        println(currentPage)
        circleLayer.strokeEnd = 0.0

        scrollView.userInteractionEnabled = true
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getRandomColor() -> UIColor{
        
        var randomRed:CGFloat = CGFloat(drand48())
        
        var randomGreen:CGFloat = CGFloat(drand48())
        
        var randomBlue:CGFloat = CGFloat(drand48())
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
