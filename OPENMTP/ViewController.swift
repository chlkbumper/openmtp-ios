//
//  ViewController.swift
//  OPENMTP
//
//  Created by Guillaume Cendre on 09/04/2015.
//  Copyright (c) 2015 pierrerougexlabs. All rights reserved.
//

import UIKit
import SceneKit


class ViewController: UIViewController {

    
    var montpellierAggloStamp : UIImageView = UIImageView(image: UIImage(named: "Montpellier.png"))
    
    var screenSize : CGSize = UIScreen.mainScreen().bounds.size
    var gradientView : UIView = UIView()
    
    var splashText : UILabel = UILabel(frame: CGRectMake(0, 0, 0, 0))
    
    var categories : NSDictionary = NSDictionary()

    var actualBubbles : NSMutableArray = NSMutableArray()
    
    var categoriesOffsets : Array<CGPoint> = []

    var path : Array<String> = ["Root"]
    
    var splashBubbleImages = ["Bubble_Green.png", "Bubble_Purple.png", "Bubble_Orange.png"]
    var averageBubbleImage = "Bubble.png"
    
    var backButton = UIButton(type: UIButtonType.Custom)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        categories = NSDictionary(contentsOfFile: NSBundle.mainBundle().pathForResource("Categories", ofType: "plist")!)!
        
        
        
        categoriesOffsets = [CGPointMake((screenSize.width/2)-80, (screenSize.height/2)-70), CGPointMake((screenSize.width/2)+80, (screenSize.height/2)-20), CGPointMake((screenSize.width/2), (screenSize.height/2)+80)]

        
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        self.setNeedsStatusBarAppearanceUpdate()
        
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "startApp", userInfo: nil, repeats: false)
        
        self.view.backgroundColor = UIColor.blackColor()
        
        splashText.frame = CGRectMake(0, 0, screenSize.width, 100)
        //splashText.sizeToFit()
        splashText.center = CGPointMake(screenSize.width/2, screenSize.height/2)
        splashText.textAlignment = NSTextAlignment.Center
        splashText.textColor = UIColor(white:0.15, alpha:1.0)
        splashText.text = "OPENMTP"
        splashText.font = UIFont(name: "AmbroiseStdFrancois-Demi", size: 35.0)
        splashText.alpha = 0
        
        
        UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.AllowAnimatedContent, animations: {
            
            self.splashText.layer.transform = CATransform3DConcat(CATransform3DMakeRotation(CGFloat(M_PI/2), 0, 0, 0), CATransform3DMakeTranslation(0, -10, 0))
            
        }, completion: nil)
        
        
        gradientView = UIView(frame: CGRectMake(0, 0, screenSize.height, screenSize.height))
        let gradientLayer : CAGradientLayer = CAGradientLayer()
        gradientLayer.frame = gradientView.bounds
        gradientLayer.colors = [UIColor(white:0.8, alpha: 1.0).CGColor, UIColor(white:0.95, alpha:1.0).CGColor]
        gradientView.layer.insertSublayer(gradientLayer, atIndex: 1)
        
        self.view.addSubview(gradientView)
        gradientView.center = CGPointMake(screenSize.width/2, screenSize.height/2)
        
        
        self.view.addSubview(splashText)
        
        
        
        let stampHeight = (screenSize.width/2)*(406/1115)
        montpellierAggloStamp.frame = CGRectMake(screenSize.width/2, screenSize.height-stampHeight, screenSize.width/2, stampHeight)
        montpellierAggloStamp.alpha = 0
        self.view.addSubview(montpellierAggloStamp)
        
        UIView.animateWithDuration(1.0, delay: 1.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.AllowAnimatedContent, animations: {
            
                self.montpellierAggloStamp.alpha = 1
            
            }, completion: {
                (value : Bool) in
                self.spawnBubbleForPath()
                
        })
        
        
        backButton.frame = CGRectMake(10, 30, screenSize.width/8, screenSize.width/8)
        backButton.setBackgroundImage(UIImage(named: "BackIcon.png"), forState: .Normal)
        backButton.addTarget(self, action: "goBack", forControlEvents: .TouchUpInside)
        backButton.alpha = 0
        self.view.addSubview(backButton)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func goBack() {
     
        
        if (path.count > 1) {
        
            path.removeAtIndex(path.count-1)
            
            for bubble in actualBubbles {
                
                
                let views = bubble as! NSArray
                
                
                UIView.animateWithDuration(1.0, delay:0.0, usingSpringWithDamping:1.0, initialSpringVelocity:1.0, options: UIViewAnimationOptions.AllowAnimatedContent, animations: {
                    
                    for view in views {
                        
                        let viewTyped = view as! UIView
                        
                        
                        if viewTyped.tag != 1000 && viewTyped.tag != 0 {
                            
                            
                            viewTyped.frame = CGRectMake(0, 0, 10, 10)
                            //viewTyped.transform = CGAffineTransformMakeScale(2, 2)
                            
                            
                            viewTyped.alpha = 0
                            
                            viewTyped.transform = CGAffineTransformMakeScale(2, 2)
                            viewTyped.center = CGPointMake(CGFloat(self.screenSize.width)/2.0, CGFloat(self.screenSize.height)/2.0)
                            
                        }
                        
                        
                    }
                    
                    }, completion: {
                        
                        (value : Bool) in
                        
                })
                
            }
         
            spawnBubbleForPath()
            
        }
        
        
        if (path.count == 1) {
            
            UIView.animateWithDuration(0.5, animations: {
                
                self.backButton.alpha = 0
                
            })
            
        }

        
    }
    
    func tapped(sender : AnyObject) {
        
        UIView.animateWithDuration(1.0, animations: {
            self.backButton.alpha = 1
        })
        
        let button = sender as! UIButton
        
        let categoriesTitles : NSMutableArray = NSMutableArray()
        
        let pathLength = path.count
        var iteration : Int = 0
        
        var actualCategories : NSDictionary = NSDictionary()
        
        actualCategories = categories
        
        for (var j = 1; j<pathLength; j++) {
            
            actualCategories = actualCategories.objectForKey(path[j]) as! NSDictionary
            
        }
        
        
        for category in actualCategories {
            
            categoriesTitles.addObject(category.0)
            
        }
        
        path.append("\(categoriesTitles.objectAtIndex(button.tag))")
        

        
        //Bounce animation
        
        for bubble in actualBubbles {
            
            
            let views = bubble as! NSArray
            
            
            UIView.animateWithDuration(1.0, delay:0.0, usingSpringWithDamping:1.0, initialSpringVelocity:1.0, options: UIViewAnimationOptions.AllowAnimatedContent, animations: {
            
                for view in views {
                    
                    let viewTyped = view as! UIView
                    
                    
                    if viewTyped.tag != 1000 && viewTyped.tag != 0 {

                        
                        if viewTyped.tag == button.tag {
                            
                            viewTyped.frame = CGRectMake(0, 0, self.screenSize.height*3, self.screenSize.height*3)
                            //viewTyped.transform = CGAffineTransformMakeScale(2, 2)
                            
                        } else {
                            
                            //viewTyped.transform = CGAffineTransformMakeScale(0, 0)
                            
                        }
                        
                        
                        viewTyped.alpha = 0
                        
                    }
                    
                    if ((viewTyped.tag) - 100 == button.tag) {
                       
                        viewTyped.transform = CGAffineTransformMakeScale(2, 2)
                        viewTyped.center = CGPointMake(CGFloat(self.screenSize.width)/2.0, CGFloat(self.screenSize.height)/2.0)
                        
                    }
                    
                    
                }
            
            }, completion: {
                
                (value : Bool) in
                
            })
            
        }

        
        if (path.count == 4) {
            
            let mapViewController = MapViewController()
            mapViewController.datasetPath = NSArray(array: path)
            self.presentViewController(mapViewController, animated: true, completion: nil)
            
        } else {
            
            self.spawnBubbleForPath()
        
        }

        
    }
    
    
    func spawnBubbleForPath() {
        
        
        let pathLength = path.count
        var iteration : Int = 0
        
        var actualCategories : NSDictionary = NSDictionary()
        
        if (pathLength == 1) {
            
            actualCategories = categories
            
        } else {
            
            actualCategories = categories
            for (var j = 1; j<pathLength; j++) {
                
                actualCategories = actualCategories.objectForKey(path[j]) as! NSDictionary
                
            }
            
        }
        
        print(path)
        
        
        var i : Double = 0.0
        
        for category in actualCategories {
            
            
            let index : Int = Int(i)
            
            ///////CONDITIONNED
            let bubbleSize = ((screenSize.width/12)*7)/(CGFloat(arc4random_uniform(2)+8)/10.0)
            ///////////////////
            
            let bubbleView = UIImageView(frame: CGRectMake(0, 0, bubbleSize, bubbleSize))
            
            if (pathLength == 1) {
                bubbleView.image = UIImage(named:splashBubbleImages[Int(i)])
            } else {
                bubbleView.image = UIImage(named:averageBubbleImage)
            }
            
            bubbleView.backgroundColor = UIColor.clearColor()
            bubbleView.tag = 100 + Int(i)
            bubbleView.alpha = 0
            
            
            ///////CONDITIONED
            bubbleView.center = CGPointMake(categoriesOffsets[index].x, /*40 +*/ categoriesOffsets[index].y)
            //////////////////
            
            
            
            self.view.addSubview(bubbleView)
            
            
            let bubbleTitle = UILabel(frame: CGRectMake(bubbleSize*0.05, bubbleSize*0.05, bubbleSize*0.9, bubbleSize*0.9))
            bubbleTitle.text = category.0.uppercaseString
            bubbleTitle.textAlignment = NSTextAlignment.Center
            bubbleTitle.backgroundColor = UIColor.clearColor()
            bubbleTitle.font = UIFont(name:"Oswald-Light", size:19)
            bubbleTitle.textColor = UIColor.whiteColor()
            bubbleTitle.tag = 1000
            
            bubbleView.addSubview(bubbleTitle)
            
            
            
            let button = UIButton(type: UIButtonType.Custom)
            button.frame = CGRectMake(0,0,bubbleView.frame.size.width, bubbleView.frame.size.height)
            button.center = bubbleView.center
            button.backgroundColor = UIColor(white:0, alpha:0)
            button.addTarget(self, action: "tapped:", forControlEvents: UIControlEvents.TouchDown)
            button.tag = Int(i)
            button.layer.cornerRadius = bubbleView.frame.size.height/2
            button.layer.masksToBounds = true
            
            button.clipsToBounds = true
            
            self.view.addSubview(button)
            
            bubbleView.transform = CGAffineTransformMakeScale(0, 0)
            
            UIView.animateWithDuration(0.6, delay: (i*0.2), usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.AllowAnimatedContent, animations: {
                
                bubbleView.alpha = 1
                bubbleView.transform = CGAffineTransformMakeScale(1, 1)
                //bubbleView.center = CGPointMake(bubbleView.center.x, bubbleView.center.y - 40)
                
                }, completion: nil)
            
            i += 1.0
            
            let components = NSArray(array: [bubbleView, button, bubbleTitle])
            
            actualBubbles.addObject(components)
            
        }

        print(i)
        
        /*if (path[0] == "Root") {
        
        }*/
        
    }

    func startApp() {
        
        UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.5, options: UIViewAnimationOptions.AllowAnimatedContent, animations: {
            
            self.splashText.frame = CGRectMake(0, 0, self.screenSize.width, self.splashText.frame.size.height)
            self.splashText.alpha = 1
            
        }, completion: nil)
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .Default
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

