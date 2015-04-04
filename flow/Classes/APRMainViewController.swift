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

class APRMainViewController: UIViewController  {
    
    var states: [state] = []
    let circleLayer: CAShapeLayer! = CAShapeLayer()
    var newView:UIView?
    var finishedButtonAnimation = false

    @IBOutlet weak var buttonsView: UIView!
    
    @IBOutlet weak var stateScrollView: UIScrollView!
    
    @IBOutlet weak var currentStateLabel: UILabel!
    @IBOutlet weak var scrollContentView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stateScrollView.contentSize = CGSizeMake(200, 200)
        stateScrollView.showsHorizontalScrollIndicator = false
        stateScrollView.showsVerticalScrollIndicator = false
        states.append(state(name: "Working", circleColor: UIColor.blueColor()))
        states.append(state(name: "Eating", circleColor: UIColor.yellowColor()))
        states.append(state(name: "Lifting", circleColor: UIColor.cyanColor()))
        
       
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        
        var i = 0
        
        
        for state in states {
        var newButton = UIButton(frame: CGRect(x: i*200, y: 0, width: 180, height: 180))
        newButton.backgroundColor = states[i].circleColor
            
        newButton.layer.cornerRadius = (newButton.bounds.size.height/2);
        scrollContentView.addSubview(newButton)
            
        //newButton.setTitleColor(getRandomColor(), forState: UIControlState.Normal)
        //newButton.setTitle(states[i].name, forState: UIControlState.Normal)
        newButton.addTarget(self, action: "changeState:", forControlEvents: UIControlEvents.TouchDown)
        newButton.addTarget(self, action: "liftUpState:", forControlEvents: UIControlEvents.TouchUpInside)
        i+=1
            
        }

        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: 87, y: 138), radius: 90, startAngle: 0.0, endAngle: CGFloat(M_PI * 2.0), clockwise: true)
        
        // Setup the CAShapeLayer with the path, colors, and line width
        circleLayer.path = circlePath.CGPath
        circleLayer.fillColor = UIColor.clearColor().CGColor
        circleLayer.strokeColor = UIColor.redColor().CGColor
        circleLayer.lineWidth = 5.0
        
        // Don't draw the circle initially
        circleLayer.strokeEnd = 0.0
        
        // Add the circleLayer to the view's layer's sublayers
        buttonsView.layer.addSublayer(circleLayer)
        

    }
    

    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        finishedButtonAnimation = true
    }
    
    func animateCircle(duration: NSTimeInterval) {
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
    
    func changeState (Sender: UIButton!){
        
        currentStateLabel.text = Sender.titleColorForState(UIControlState.Normal)?.description
        animateCircle(1.0)
        
    }
    
    func liftUpState(Sender: UIButton! ){
        
        if (finishedButtonAnimation) {
            
            println("finished")
            
        }
        
        else {
            
            circleLayer.removeAnimationForKey("animateCircle")
            
        }
        
        finishedButtonAnimation = false
        
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
