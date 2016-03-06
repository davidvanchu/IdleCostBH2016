//
//  ViewController.swift
//  IdleCost
//
//  Created by David Chu on 2/19/16.
//  Copyright © 2016 David Chu. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var SpeedLabel: UILabel!
    @IBOutlet weak var IdleTimeLabel: UILabel!
    @IBOutlet weak var FuelUsedLabel: UILabel!
    @IBOutlet weak var SpentLabel: UILabel!
    let iCC = IdleCostCalc()
    @IBOutlet weak var Paws: UIButton!
    var timer = NSTimer()
    var isPaused = false
    var location = CLLocation.init()
    var locationManager = CLLocationManager()
    var timeSinceLast:Double = 0
    var lastUpdate:NSDate = NSDate()
    var idleTimeSeconds:Double = 0
    
    let costData = ItemManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib
        timeSinceLast = 0
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.requestAlwaysAuthorization()
        
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        self.view.backgroundColor = UIColor.magentaColor()
        
        if costData.itemList.count > 0 {
            let restoreData = costData.itemList[0].idleTimeSeconds
            
            iCC.setIdleTime(restoreData)
            print("Restored \(restoreData)")
            idleTimeSeconds = restoreData
            //updateTime()
            setLbls()
        }
        
        let formatter = NSNumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.minimumIntegerDigits = 1
        FuelUsedLabel.text = "Fuel Used: \(formatter.stringFromNumber(iCC.getFuelUsed())!) gallons."
        IdleTimeLabel.text = "Idle Time: \(formatter.stringFromNumber(iCC.getIdleTimeSeconds()/60)!) minutes."
        SpentLabel.text = "You have spent $\(formatter.stringFromNumber(iCC.getSpent())!) while idling."
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("updateTime"), userInfo: nil, repeats: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        /**
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "CostCalc")
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            costData = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        print("Fetched!")
        
        let restoreData = costData[0]
        
        let restoreData2 = restoreData.valueForKey("idleTime")
        print("Restored \(restoreData2)")
        
        iCC.setIdleTime(restoreData2 as! Double)

        //iCC.setIdleTime((costData[0].valueForKey("idleTime") as? Double)!)
        */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func ButtonPressed(sender: AnyObject) {
        iCC.reset()
        setLbls()
        /**
        if (isPaused == false) {
            timer.invalidate()
            isPaused = true
        }
        else {
            timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
            isPaused = false
        }
        */
        
    }
    
  /**  func update() {
        print(CLLocationManager.authorizationStatus().rawValue)
        //if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.AuthorizedAlways) {
        //    return;
        //}
        let speed = locationManager.location!.speed
        //SpeedLabel.text = "Speed: \(speed) mph"
        setSpeedLbl(speed)
        print(speed)
        if (locationManager.location!.speed > 3) {
            return
        }
        iCC.updateCalc()
        let formatter = NSNumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.minimumIntegerDigits = 1
        
        FuelUsedLabel.text = "Fuel Used: \(formatter.stringFromNumber(iCC.getFuelUsed())!) gallons."
        //IdleTimeLabel.text = "Idle Time: \(formatter.stringFromNumber(iCC.getIdleTimeSeconds()/60)!) minutes."
        SpentLabel.text = "You have spent $\(formatter.stringFromNumber(iCC.getSpent())!) while idling."
    }
*/
    
    func updateTime() {
        print(CLLocationManager.authorizationStatus().rawValue)
        locationManager.startUpdatingLocation()
        let speed = locationManager.location!.speed
        setSpeedLbl(speed)
        if (locationManager.location!.speed > 3) {
            return
        }
        iCC.updateTime()
        iCC.updateCalc()
        idleTimeSeconds = iCC.getIdleTimeSeconds()
        setLbls()
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let eventDate = location!.timestamp
        timeSinceLast = eventDate.timeIntervalSinceDate(lastUpdate)
        lastUpdate = eventDate
        //print("lat \(location?.coordinate.latitude) long \(location?.coordinate.longitude)")
        //print ("Speed: \(location?.speed)")
        //print ("timeSinceLast: \(timeSinceLast)")
        //update();
        
        //mapkit??
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        map.showsUserLocation = true
       //map.setUserTrackingMode(MKUserTrackingMode.Follow, animated: true)
        
        self.map.setRegion(region, animated: true)
    }
    
    func setSpeedLbl(var speed: Double) {
        if speed < 0 {
            speed = 0.0
        }
        SpeedLabel.text = "Speed: \(speed) mph"
    }
    
    func setIdleTimeLbl() {
        let formatter = NSNumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.minimumIntegerDigits = 1
        IdleTimeLabel.text = "Idle Time: \(formatter.stringFromNumber(iCC.getIdleTimeSeconds()/60)!) minutes."
    }
    
    func setFuelUsedLbl() {
        let formatter = NSNumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.minimumIntegerDigits = 1
        FuelUsedLabel.text = "Fuel Used: \(formatter.stringFromNumber(iCC.getFuelUsed())!) gallons."
    }
    
    func setSpentLbl() {
        let formatter = NSNumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.minimumIntegerDigits = 1
        SpentLabel.text = "You have spent $\(formatter.stringFromNumber(iCC.getSpent())!) while idling."
    }
    
    func setLbls() {
        setIdleTimeLbl()
        setFuelUsedLbl()
        setSpentLbl()
        
        //costData[0].setValue(iCC.getIdleTimeSeconds(), forKey: "idleTime")
        saveData()
    }
    
    func saveData() {
        print("Help")
        if costData.itemList.count < 1 {
            costData.itemList.append(CostCalcItem(idleTimeSecs: idleTimeSeconds))
        }
        costData.itemList[0] = (CostCalcItem(idleTimeSecs: idleTimeSeconds))
        costData.save()
        print("Saved \(idleTimeSeconds)")
        /**
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity = NSEntityDescription.entityForName("CostCalc", inManagedObjectContext: managedContext)
        
        let cost = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        cost.setValue(iCC.getIdleTimeSeconds(), forKey: "idleTime")
        print("Saving \(iCC.getIdleTimeSeconds())")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print ("Could not save \(error) \(error.userInfo)")
        }
        print("Saved!")
        
        */
    }

}