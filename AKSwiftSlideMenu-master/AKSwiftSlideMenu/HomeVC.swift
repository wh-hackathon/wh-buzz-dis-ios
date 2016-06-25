//
//  HomeVC.swift
//  AKSwiftSlideMenu
//
//  Created by MAC-186 on 4/8/16.
//  Copyright © 2016 Kode. All rights reserved.
//


/*
 New API
 POST: https://buzz-dis.herokuapp.com/tags/get-all-by-location-open
 Content-Type: application/json
 
 {
 "latitude": 18.523331,
 "longitude": 73.7775214,
 "distance": 2
 }

 */

import UIKit
import GoogleMaps
import MapKit
import CoreLocation
let kSavedItemsKey = "savedItems"
class HomeVC: BaseViewController, UITableViewDataSource, UITableViewDelegate,CLLocationManagerDelegate {

     @IBOutlet var tblDiscount : UITableView!
    //var discountArray: NSMutableArray = []
    var arrDiscount = [Discount]();
     let locationManager = CLLocationManager()
    var lat :Double = 0.0
    var long :Double = 0.0
    
    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        getDiscountWebserviceCall();
        self.title="Discount list"
        addSlideMenuButton()
        self.tblDiscount.dataSource = self;
        self.tblDiscount.delegate = self ;
        self.tblDiscount.backgroundColor = UIColor.lightGrayColor()
        //self.tblDiscount.reloadData()
        
        // Do any additional setup after loading the view.
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var locValue:CLLocationCoordinate2D = manager.location!.coordinate
        lat=locValue.latitude
        long=locValue.longitude
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "DiscountCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! HomeCell
        
        // Fetches the appropriate meal for the data source layout.
       tableView.separatorStyle = .None
        
        
        var disctObj = Discount()
        disctObj = arrDiscount[indexPath.row]
        print(disctObj.shopName)
        cell.nameLabel.text = disctObj.shopName
        cell.discountLabel.text=disctObj.discount
        cell.shopAddress.text=disctObj.shopAddress
        cell.discountBanner.text=disctObj.discountBanner
        // cell.photoImageView.image = meal.photo
       print("XXXXXX: \(disctObj.shopName)")

        let separatorView: UIView = UIView(frame: CGRectMake(0, 0, 1024, 1))
        separatorView.layer.borderColor = UIColor.lightGrayColor().CGColor
        separatorView.layer.borderWidth = 2.0
        cell.contentView.addSubview(separatorView)
        
        cell.callBtn.tag = indexPath.row
        cell.callBtn.addTarget(self, action: Selector("callBtnAction:"), forControlEvents: .TouchUpInside)
        //cell.callBtn.addTarget(self, action: Selector("callBtnAction"),forControlEvents: .TouchUpInside)
        
        
        cell.likeBtn.tag = indexPath.row
        cell.likeBtn.addTarget(self, action: Selector("likeBtnAction:"), forControlEvents: .TouchUpInside)
        //cell.backgroundColor.c
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        /*
         ["latitude": 18.523331,
         "longitude": 73.7775214,
         "distance": 3

         */
        var disctObj = Discount()
        disctObj = arrDiscount[indexPath.row]
        
        
        
        let urlstr = String(format: "comgooglemapsurl://maps.google.com/maps?f=d&daddr=%.2f,%.2f&sll=%.2f,%.2f&sspn=0.2,0.1&nav=1", disctObj.lat, disctObj.long,lat,long)
        
        
        if (UIApplication.sharedApplication().canOpenURL(NSURL(string:"comgooglemaps://")!)) {
            UIApplication.sharedApplication().openURL(NSURL(string:
                urlstr)!)
        } else {
            print("Can't use comgooglemaps://");
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        print(arrDiscount.count)
        return arrDiscount.count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func callBtnAction(sender: UIButton)
    {
        print("likeBtnAction");
        
    }
    func likeBtnAction(sender: UIButton)
    {
        
        print("likeBtnAction");
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
     func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        //cell.backgroundColor = UIColor.clearColor()
         cell.separatorInset = UIEdgeInsetsZero
        //cell.backgroundColor = UIColor.redColor()
    }
    
    func getDiscountWebserviceCall()
    {
        
        
            do
            {
                let bodyInfo: [String: AnyObject] =
                    ["latitude": 18.523331,
                     "longitude": 73.7775214,
                     "distance": 3
                ]
                
                let url = NSURL(string: "https://buzz-dis.herokuapp.com/tags/get-all-by-location-open")
                let request = NSMutableURLRequest(URL: url!)
                
                let session = NSURLSession.sharedSession()
                request.HTTPMethod = "POST"
                
                
                
                let jsonData = try NSJSONSerialization.dataWithJSONObject(bodyInfo, options: NSJSONWritingOptions())
                request.HTTPBody = jsonData
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
               // request.addValue("application/json", forHTTPHeaderField: "Accept")
                
                
                let dataString = NSString(data: jsonData, encoding: NSUTF8StringEncoding)
                print("dataString : \(dataString)")
                
                
                let task = session.dataTaskWithRequest(request, completionHandler:
                    {data, response, error -> Void in
                        print("Response: \(response)")
                        let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                        print("Body: \(strData)")
                        
                        
                        
                        do {
                            if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .
                                MutableLeaves) as? NSArray
                              {
                                print("ASynchronous\(jsonResult)")
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.setData(jsonResult)
                                })
                                
                            }
                        } catch let error as NSError {
                            print(error.localizedDescription)
                        }
                        
                      
                        
                })
                
                task.resume()
            }catch
            {
                print ("nothin")
            }
 
        
        
        
            }
    
    
    
    
    func parseResonponse(data :NSData)->Void
    {
        do {
            let result = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String:AnyObject]
            
            print("Result -> \(result)")
            
        } catch {
            print("Error -> \(error)")
        }
    }
    
    
    func setData(data : NSArray) -> Void
    {
      
        for (index, element) in data.enumerate()
        {
            let discountEle = Discount()
            
            print("Item \(index): \(element)")
            let info = element.objectForKey("info")
            let location = element.objectForKey("location")
            let arrCords = location!.objectForKey("coordinates")
            discountEle.shopName = (info?.objectForKey("shopName"))! as! String
            discountEle.shopAddress = (info?.objectForKey("shopAddress"))! as! String
            discountEle.discount = (info?.objectForKey("discount"))! as! String
            discountEle.discountBanner = (info?.objectForKey("discountBanner"))! as! String
            //discountEle.likes = (info?.objectForKey("likes"))! as! Int16
            discountEle.likes = 7
            //print("ARRTAY COARDS: \(arrCords)")
            discountEle.lat = (arrCords?.objectAtIndex(1))! as! Double
            discountEle.long = (arrCords?.objectAtIndex(0))! as! Double
            arrDiscount.append(discountEle)
            tblDiscount .reloadData()
        
            
         
        }
     }
    @IBAction func zoomToCurrentLocation(sender: AnyObject) {
       // zoomToUserLocationInMapView(mapView)
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        //mapView.showsUserLocation = (status == .AuthorizedAlways)
    }
    func locationManager(manager: CLLocationManager, monitoringDidFailForRegion region: CLRegion?, withError error: NSError) {
        print("Monitoring failed for region with identifier: \(region!.identifier)")
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Location Manager failed with the following error: \(error)")
    }

    }
