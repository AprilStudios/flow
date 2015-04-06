
import UIKit
import QuartzCore
import Accelerate
import PNChartSwift

struct state {
    var name: String
    var circleColor: UIColor
}


/**
* APRMainViewController
*
* Controls the Main View
* This includes the states selector, and the label from the current state
*
* :author: Darvish Kamalia
* :version: 0.1
*/
class APRMainViewController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate, PNChartDelegate
    
{
    
    //MARK: Private Instance Vars
    var states: [state] = []
    let circleLayer: CAShapeLayer! = CAShapeLayer()
    var newView:UIView?
    var startedButtonAnimation = false
    var finishedButtonAnimation = false
    var stateButtons: [UIButton] = []
    var currentPage: Double = 0
    var prevPage: Double = 0
    var lpgc = UILongPressGestureRecognizer()
    var chart: PNBarChart?
    var chosenPage = 0
    
    @IBOutlet weak var graphView: UIView!
    @IBOutlet weak var stateScrollView: UIScrollView!
    
    /**
    * addStateButton
    *
    * Called when user presses addStateButton.
    * Scrolls scrollView to the last addState circle.
    *
    * :param: sender - of event
    */
    @IBAction func addStateButton(sender: AnyObject)
    {
        states.append(state(name: "newState", circleColor: getRandomColor()))
        var newButton = UIButton(frame: CGRect(x: stateButtons[stateButtons.count - 1].frame.origin.x + self.view.frame.width, y: 20, width: 180, height: 180))
        newButton.layer.cornerRadius = (newButton.bounds.size.height/2)
        newButton.backgroundColor = states[states.count - 1].circleColor
        stateButtons.append(newButton)
        stateScrollView.contentSize = CGSizeMake(CGFloat(states.count) * (self.view.frame.width), 220)
        stateScrollView.addSubview(newButton)
        
        stateScrollView.setContentOffset(CGPoint(x: (self.view.frame.width)*(CGFloat(states.count - 1)), y: 0), animated: true)
        
        var width = Double(stateScrollView.frame.size.width)
        currentPage = (Double(stateScrollView.contentOffset.x) + (0.5 * width)) / width - 0.5
        
        updateCircleLayer()
        
        if (Int(currentPage) == chosenPage){
            println("chosenPage")
            println(currentPage)
            circleLayer.strokeEnd = 1.0
        }
            
        else {
            
            circleLayer.strokeEnd = 0.0
        }
        
        
        stateScrollView.userInteractionEnabled = true
        updateChartData()
        
    }
    
    
    //MARK: - View LifeCycle Methods
    /**
    * viewDidLoad
    *
    * Called when view is loaded
    */
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //NavBar username setting
        let nickname: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("nickname");
        self.navigationItem.title = nickname as? String;
        
        var lpgc  = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
        lpgc.delegate = self
        view.addGestureRecognizer(lpgc)
        
        stateScrollView.showsHorizontalScrollIndicator = false
        stateScrollView.showsVerticalScrollIndicator = false
        
        states.append(state(name: "Working", circleColor: UIColor.lightGrayColor()))
        states.append(state(name: "Eating", circleColor: UIColor.yellowColor()))
        states.append(state(name: "Lifting", circleColor: UIColor.cyanColor()))
        states.append(state(name: "Studying", circleColor: UIColor.magentaColor()))
        states.append(state(name: "Fucking", circleColor: UIColor.greenColor()))
        
        stateButtons.append(UIButton(frame: CGRect(x:self.view.frame.width/2 - 87, y: 20, width: 180, height: 180)))
        stateButtons[0].backgroundColor = states[0].circleColor
        stateButtons[0].layer.cornerRadius = (stateButtons[0].bounds.size.height/2)
        
        
        var gs =  UIGestureRecognizer(target: self, action: "longPress")
        stateScrollView.addSubview(stateButtons[0])
        
        for i in 1 ... states.count - 1
        {
            stateButtons.append(UIButton(frame: CGRect(x: stateButtons[i-1].frame.origin.x + self.view.frame.width, y: 20, width: 180, height: 180)))
            stateButtons[i].backgroundColor = states[i].circleColor
            stateButtons[i].layer.cornerRadius = (stateButtons[i].bounds.size.height/2)
            
            var gs =  UIGestureRecognizer(target: self, action: "longPress")
            stateScrollView.addSubview(stateButtons[i])
        }
        
        stateScrollView.contentSize = CGSizeMake(CGFloat(states.count) * (self.view.frame.width), 220)
        
        chart = PNBarChart(frame: CGRect(x: graphView.frame.origin.x, y: graphView.frame.origin.y + 30, width: graphView.frame.width, height: graphView.frame.height))
        
        createGraph()
        
        updateCircleLayer()
        
    }
    
    /**
    * viewDidLayoutSubview
    *
    *
    */
    override func viewDidLayoutSubviews()
    {
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
    * updateCircleLayer
    *
    *
    *
    */
    func updateCircleLayer()
    {
        
        if (Int(currentPage) < stateButtons.count)
        {
            var xpos = stateButtons[Int(currentPage)].center.x
            var ypos = stateButtons[Int(currentPage)].center.y
            
            let circlePath = UIBezierPath(arcCenter: CGPoint(x: xpos  , y: ypos ),  radius: 100, startAngle: CGFloat(-M_PI/2), endAngle: CGFloat(3*M_PI/2.0), clockwise: true)
            
            // Setup the CAShapeLayer with the path, colors, and line width
            circleLayer.path = circlePath.CGPath
            circleLayer.fillColor = UIColor.clearColor().CGColor
            circleLayer.lineWidth = 5.0
            
            // Don't draw the circle initially
            circleLayer.strokeEnd = 0.0
            println("because update")
            
            // Add the circleLayer to the view's layer's sublayers
            stateScrollView.layer.addSublayer(circleLayer)
        }
    }
    
    
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool)
    {
        finishedButtonAnimation = true
        
        var pulseAnimation:CABasicAnimation = CABasicAnimation(keyPath: "opacity");
        pulseAnimation.duration = 0.25
        pulseAnimation.toValue = 0.5
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = 2
        circleLayer.addAnimation(pulseAnimation, forKey: "pulse")
    }
    
    
    func animateCircle(duration: NSTimeInterval)
    {
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
    
    func handleLongPress(recognizer: UILongPressGestureRecognizer)
    {
        if (recognizer.state == UIGestureRecognizerState.Began)
        {
            if (!startedButtonAnimation)
            {
                animateCircle(1)
                startedButtonAnimation = true
                finishedButtonAnimation = false
                
            }
        }
        else if (recognizer.state == UIGestureRecognizerState.Ended)
        {
            if (finishedButtonAnimation)
            {
                chosenPage = Int(currentPage)
                finishedButtonAnimation = false
                startedButtonAnimation = false
            }
            else
            {
                circleLayer.removeAnimationForKey("animateCircle")
                circleLayer.strokeEnd = 0.0
                println ("because recognizer")
                startedButtonAnimation = false
            }
        }
        
    }
    
    func scrollViewDidBeginScroll(scrollView: UIScrollView)
    {
        var width = Double(scrollView.frame.size.width)
        prevPage = (Double(scrollView.contentOffset.x) + (0.5 * width)) / width - 0.5
        circleLayer.strokeEnd = 0.0
        println("lol nope")
        
        scrollView.userInteractionEnabled = false
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        var width = Double(scrollView.frame.size.width)
        currentPage = (Double(scrollView.contentOffset.x) + (0.5 * width)) / width - 0.5
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        updateCircleLayer()
        
        if (Int(currentPage) == chosenPage){
            println("chosenPage")
            println(currentPage)
            circleLayer.strokeEnd = 1.0
        }
            
        else {
            
            circleLayer.strokeEnd = 0.0
        }
        
        
        scrollView.userInteractionEnabled = true
        updateChartData()
    }
    
    func getRandomColor() -> UIColor
    {
        var randomRed:CGFloat = CGFloat(drand48())
        var randomGreen:CGFloat = CGFloat(drand48())
        var randomBlue:CGFloat = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
    
    /// Graph view functions
    
    func createGraph(){
        
        PNBarChart(frame: CGRect(x: graphView.frame.origin.x, y: graphView.frame.origin.y + 50, width: graphView.frame.width, height: graphView.frame.height))
        
        
        println(chart!.frame.width)
        chart!.backgroundColor = UIColor.clearColor()
        chart!.animationType  = .Waterfall
        chart!.barBackgroundColor = UIColor.clearColor()
        chart!.barRadius = 0.2
        
        chart!.delegate = self
        
        updateChartData()
        
        self.view.addSubview(chart!)
        
    }
    
    ///Graph data methods
    
    func userClickedOnBarCharIndex(barIndex: Int)
    {
        println("Click  on bar \(barIndex)")
    }
    
    func userClickedOnLineKeyPoint(point: CGPoint, lineIndex: Int, keyPointIndex: Int)
    {
        println("Click Key on line \(point.x), \(point.y) line index is \(lineIndex) and point index is \(keyPointIndex)")
    }
    
    func userClickedOnLinePoint(point: CGPoint, lineIndex: Int)
    {
        println("Click Key on line \(point.x), \(point.y) line index is \(lineIndex)")
    }
    
    func updateChartData(){
        
        chart!.xLabels = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        var values: [Double] = []
        
        for i in 0 ... 6 {
            
            values.append(Double(arc4random_uniform(30) + 1))
            
        }
        
        chart!.yValues = values
        chart!.strokeColor = states[Int(currentPage)].circleColor
        chart!.labelTextColor = states[Int(currentPage)].circleColor
        chart!.strokeChart()
        
    }
    
}
