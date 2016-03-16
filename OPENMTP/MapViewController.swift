//
//  MapViewController.swift
//  OPENMTP
//
//  Created by Guillaume Cendre on 20/05/2015.
//  Copyright (c) 2015 pierrerougexlabs. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController {

    
    var mapView : MKMapView = MKMapView()
    var statusBarGradient : UIImageView = UIImageView(image: UIImage(named: "MapViewStatusBarGradient.png"))
    var splashText : UILabel = UILabel(frame: CGRectMake(0, 0, 0, 0))
    
    var datasetPath : NSArray!
    
    var screenSize : CGSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height)
    var montpellierCoordinates = CLLocationCoordinate2DMake(43.6125, 3.8785)
    
    
    var closeButton = UIButton(type: UIButtonType.Custom)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 249.0/255.0, green: 245.0/255.0, blue: 237.0/255.0, alpha: 1.0)
        
        
        
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        
        mapView = MKMapView(frame: CGRectMake(0, 0, screenSize.width, screenSize.height))
        
        let region = MKCoordinateRegionMakeWithDistance(montpellierCoordinates, 8500, 8500)
        let adjustedRegion = mapView.regionThatFits(region)
        mapView.setRegion(adjustedRegion, animated: false)
        mapView.showsPointsOfInterest = false
        mapView.showsUserLocation = true
        mapView.showsBuildings = false
        self.view.addSubview(mapView)
        
        
        
        
        statusBarGradient.frame = CGRectMake(0, 0, screenSize.width, 90)
        statusBarGradient.contentMode = UIViewContentMode.ScaleToFill
        
        self.view.addSubview(statusBarGradient)
        
        
        splashText.frame = CGRectMake(0, 0, screenSize.width, 80)
        splashText.textAlignment = NSTextAlignment.Center
        splashText.textColor = UIColor(white:0.15, alpha:1.0)
        splashText.text = "OPENMTP"
        splashText.font = UIFont(name: "AmbroiseStdFrancois-Demi", size: 25.0)
        
        self.view.addSubview(splashText)
        
        
        
        
        closeButton.frame = CGRectMake(10, 25, screenSize.width/9, screenSize.width/9)
        closeButton.setBackgroundImage(UIImage(named: "CloseIcon.png"), forState: .Normal)
        closeButton.addTarget(self, action: "popMap", forControlEvents: .TouchUpInside)
        self.view.addSubview(closeButton)
        
        
        if let datasetP = datasetPath {
            
            print(datasetP)
            
            let datasetPathArray = NSMutableArray(array: datasetP)
            
            //var datas = NSData(contentsOfFile:)
            
            
            let dictionary = NSDictionary(contentsOfFile: NSBundle.mainBundle().pathForResource("Categories", ofType: "plist")!)!
            var nodeElement : AnyObject!

            
            let first : Bool = true
            datasetPathArray.removeObjectAtIndex(0) //Suppression de Root
            
            
            for pathComponent in datasetPathArray {
                if first {
                    nodeElement = dictionary.objectForKey(pathComponent) as! NSDictionary
                } else {
                    nodeElement = nodeElement.objectForKey(pathComponent)
                }
            }
            
            print(nodeElement)
            
            
        }
        
        
        
        
        
        // Do any additional setup after loading the view.
    }

    
    func popMap() {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
