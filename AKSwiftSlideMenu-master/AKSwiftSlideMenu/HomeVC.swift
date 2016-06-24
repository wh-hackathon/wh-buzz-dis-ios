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
class HomeVC: BaseViewController, UITableViewDataSource, UITableViewDelegate {

     @IBOutlet var tblDiscount : UITableView!
    //var discountArray: NSMutableArray = []
    var arrDiscount = [Discount]();
    override func viewDidLoad()
    {
        super.viewDidLoad()
        getDiscountWebserviceCall();
        self.title="Discount list"
        addSlideMenuButton()
        self.tblDiscount.dataSource = self;
        self.tblDiscount.delegate = self ;
        self.tblDiscount.backgroundColor = UIColor.lightGrayColor()
        //self.tblDiscount.reloadData()
        
        // Do any additional setup after loading the view.
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
        // cell.photoImageView.image = meal.photo
       print("XXXXXX: \(disctObj.shopName)")

        let separatorView: UIView = UIView(frame: CGRectMake(0, 0, 1024, 1))
        separatorView.layer.borderColor = UIColor.lightGrayColor().CGColor
        separatorView.layer.borderWidth = 2.0
        cell.contentView.addSubview(separatorView)
        
        //cell.backgroundColor.c
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if (UIApplication.sharedApplication().canOpenURL(NSURL(string:"comgooglemaps://")!)) {
            UIApplication.sharedApplication().openURL(NSURL(string:
                "comgooglemapsurl://maps.google.com/maps?f=d&daddr=Deccan+Deccan,+Pune,+Maharashtra&sll=18.5176,73.8417&sspn=0.2,0.1&nav=1")!)
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
                     "distance": 2
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
            
            let location1 = location!.objectForKey("coordinates")
            
            
            discountEle.shopName = (info?.objectForKey("shopName"))! as! String
            
            discountEle.shopAddress = (info?.objectForKey("shopAddress"))! as! String
            
             discountEle.discount = (info?.objectForKey("discount"))! as! String
            
            discountEle.discountBanner = (info?.objectForKey("discountBanner"))! as! String
            
           //discountEle.likes = (info?.objectForKey("likes"))! as! Int
            
            
            
            arrDiscount.append(discountEle)
            
            
        
            
         
        }
     }
    
    }
