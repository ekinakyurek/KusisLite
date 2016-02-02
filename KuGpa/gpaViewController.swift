//
//  gpaViewController.swift
//  
//
//  Created by Ekin Akyürek and Ali Mert Türker on 1.10.2015.
//
//

import UIKit
import Parse

var spa = [Double]()
var spaholder=0.0
var creditholder=0.0
var creditperterm = [Double]()

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

class gpaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarControllerDelegate{
 
    
    func updateStorage(){
        storage = Reachability.ToJson()
        NSUserDefaults.standardUserDefaults().setObject(storage, forKey: "storage")
        storage = ""
        NSUserDefaults.standardUserDefaults().setObject(name, forKey: "name")
        NSUserDefaults.standardUserDefaults().setObject(pass, forKey: "pass")
        
    }
   
    @IBAction func logout(sender: AnyObject) {
        self.performSegueWithIdentifier("logout", sender: self)
        storage = ""
        terms.removeAll()
        
        updated = false
        PFUser.logOut()
        isUploaded = false
        NSUserDefaults.standardUserDefaults().removeObjectForKey("storage")
        
        
    }

    @IBOutlet weak var tableView: UITableView!
    var refreshControl:UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.delegate = self

        if NSUserDefaults.standardUserDefaults().objectForKey("storage") != nil {
            
            storage = NSUserDefaults.standardUserDefaults().objectForKey("storage") as! String
            Reachability.ReadJson()
            Reachability.CalculateGpaFromSpas()
            name = NSUserDefaults.standardUserDefaults().objectForKey("name") as! NSString
            pass = NSUserDefaults.standardUserDefaults().objectForKey("pass") as! NSString
            
            
        }
        navigationController?.navigationBar.hidden = false
        navigationController!.navigationBar.barTintColor = navigationControllerColor
        let titleLabel : UILabel = UILabel(frame: CGRectMake(0,0,50,32))
        titleLabel.text = name as String
        titleLabel.font =  UIFont(name:"HalveticaNeue-UltraLight", size: 25.0)
        titleLabel.textColor = UIColor.whiteColor()
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
      
        self.navigationItem.titleView = titleLabel
        self.navigationController!.navigationBar.barStyle = UIBarStyle.BlackTranslucent

        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        
        
      //  tableView.backgroundColor = tableColor
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView(frame: CGRect.zero)
       
        if isUploaded == false {
            
            let USER = PFUser()
            USER.username = name as String
            USER.password = "respectforsecurity"
            USER.email = (name as String) + "@ku.edu.tr"
            USER.setObject(gpa, forKey:"gpa")
            USER.setObject(credit, forKey: "credit")
            USER.setObject(Reachability.ToJson(), forKey: "records")
            
            USER.signUpInBackgroundWithBlock({ (succeed, error) -> Void in
                
                if ((error) != nil) {
                   
                    
                }else {
                    
                    isUploaded = true
                        
                    
                }
            })

          
              
            
            
        }
    
        
    
      
        // Do any additional setup after loading the view.
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        
        
        if viewController.title == "enrollments" && !UIDevice.currentDevice().orientation.isLandscape.boolValue  {
        
        let value = UIInterfaceOrientation.LandscapeRight.rawValue
        
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
      
        }
       
    }
    
    func refresh(sender:AnyObject)
        
    {
        if Reachability.isConnectedToNetwork(){
            
            let request = Reachability.PrepareLoginRequest()
        
            let session = NSURLSession.sharedSession()
            
            let task = session.dataTaskWithRequest(request){ (data, response, error) -> Void in
                
                dispatch_async(dispatch_get_main_queue(), {
             
                    let newrequest = Reachability.PrepareCourseHistoryRequest()
                
                    let newtask = session.dataTaskWithRequest(newrequest){ (data, repsonse, error) -> Void in
                    
                        dispatch_async(dispatch_get_main_queue(), {
                  
                    
                            if Reachability.dataCheck(data!){
                        
                                Reachability.dataParsing(data!)
                                
                            } else  {
                        
                                self.AlertConnection()
                            
                            }
                        
                        Reachability.CheckList()
                        Reachability.TermSorter()
                        Reachability.CalculateGpa(Dersler)
                        self.AfterCalculation()
                        
                    
                        })
                    }
                    newtask.resume()
                
                    })
                }
            
                task.resume()
        }else{
                self.AlertConnection()
            }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        Reachability.CalculateGpaFromSpas();
        tableView.reloadData()
        navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.interactivePopGestureRecognizer!.enabled = true;
        Reachability.sortTerms()

        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  
  
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return terms.count+1
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        
        cell=tableView.dequeueReusableCellWithIdentifier("cell",forIndexPath:indexPath) as UITableViewCell

        
        updateStorage()
        
        if indexPath.row==0{
            cell.textLabel?.text = String(format: "GPA: %.2f", gpa)
            cell.backgroundColor = firstCellColor
            cell.tintColor = UIColor.whiteColor()
            cell.textLabel?.font = UIFont(name:"Roboto-Light", size:19.0)
            cell.detailTextLabel?.text = String(format: "Credit: %.0f", credit)
            cell.detailTextLabel?.textColor = detailLabelColor
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.userInteractionEnabled = false
        
            
        }else{
            
            Reachability.CalculateSpa(terms[indexPath.row-1])
            cell.textLabel?.text=terms[indexPath.row-1][0].term
            cell.textLabel?.font = UIFont(name:"Roboto-Light", size:16.0)
            if spaholder >= 0 {
            cell.detailTextLabel?.text = String(format: "%.2f", spaholder)
            }else{
                cell.detailTextLabel?.text = "-"
            }
            
        }

                return cell;
        
    }
    
    func AlertConnection(){
        
        let alertController = UIAlertController(title: "Connection Error", message:
            "Please sign in again!", preferredStyle: UIAlertControllerStyle.Alert)
    
        alertController.addAction(UIAlertAction(title: "Okey", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func AfterCalculation(){
        let USER = PFUser.currentUser()
        
        let currentUser = PFUser.currentUser()?.username
        
        if currentUser != nil {
            USER!.setObject(gpa, forKey:"gpa")
            USER!.setObject(credit, forKey: "credit")
            USER!.setObject(Reachability.ToJson(), forKey: "records")
            USER!.saveInBackground()
        }
  
        
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
   
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row != 0 {
            indexofTerm = indexPath.row-1
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
             

      }
 
}
