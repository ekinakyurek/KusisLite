//
//  ViewController.swift
//  kuGpaCalculator
//
//  Created by Ekin Akyürek and Ali Mert Türker  on 29.09.2015.
//  Copyright (c) 2015 Mellon App All rights reserved.
//

import UIKit
import Parse
var name = "" as NSString
var pass = "" as NSString
var isUploaded = false

class ViewController: UIViewController,UITextFieldDelegate, UITabBarControllerDelegate{
   
    
    @IBOutlet var click: UIButton!
    @IBOutlet var activityInd: UIActivityIndicatorView!

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let _ = touches.first {
         self.view.endEditing(true)   // ...
        }
        super.touchesBegan(touches, withEvent:event)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        
        return true
        
    }
    
    @IBOutlet var usd: UITextField!
    @IBOutlet var pwd: UITextField!

    
    
    @IBAction func clc(sender: AnyObject) {
        
        name = usd.text!
        pass = pwd.text!
        
        
        if Reachability.isConnectedToNetwork(){
            self.click.hidden = true
            self.view.endEditing(true)
            activityInd.hidden = false
            activityInd.startAnimating()
            
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
    
    func AlertConnection(){
        let alertController = UIAlertController(title: "Connection Error", message:
            "Please sign in again!", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Okey", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
        self.click.hidden = false
        self.activityInd.hidden = true
        
        
    }
    
    func AfterCalculation(){
        
        let newUser = PFUser()
        
        newUser.username = name as String
        newUser.password = "respectforsecurity"
        newUser.email = (name as String) + "@ku.edu.tr"
        newUser.setObject(gpa, forKey:"gpa")
        newUser.setObject(credit, forKey: "credit")
        newUser.setObject(Reachability.ToJson(), forKey: "records")
        
        newUser.signUpInBackgroundWithBlock({ (succeed, error) -> Void in
        
            if ((error) != nil) {
                
                if error?.code == 202 {
                   
                    PFUser.logInWithUsernameInBackground(name as String, password: "respectforsecurity", block: { (USER, ERROR) -> Void in
                        
                       
                        if ((USER) != nil) {
                         
                                USER!.setObject(gpa, forKey:"gpa")
                                USER!.setObject(credit, forKey: "credit")
                                USER!.setObject(Reachability.ToJson(), forKey: "records")
                                USER!.saveInBackground()
                           
                            isUploaded = true ;
                            self.activityInd.stopAnimating()
                            self.performSegueWithIdentifier("Term", sender: self)
                            
                        } else {
                            
                            let alertController = UIAlertController(title: "Connection Error", message:
                                "Please sign in again!", preferredStyle: UIAlertControllerStyle.Alert)
                            alertController.addAction(UIAlertAction(title: "Okey", style: UIAlertActionStyle.Default,handler: nil))
                            
                            self.presentViewController(alertController, animated: true, completion: nil)
                            
                            self.click.hidden = false
                            self.activityInd.hidden = true
                        }
                    })
                }
               
                
            } else {
               
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    isUploaded = true ;
                    self.activityInd.stopAnimating()
                    self.performSegueWithIdentifier("Term", sender: self)
                  
                })
            }
        })
        
    
    }

    
    override func viewDidLoad() {
        self.tabBarController?.tabBar.hidden = true
        self.view.hidden = false
        super.viewDidLoad()
        //if NSUserDefaults.standardUserDefaults().objectForKey("storage") == nil {
        self.activityInd.hidden = true
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        self.view.backgroundColor = mainStoryBoardColor
        // Do any additional setup after loading the view, typically from a nib.
        self.usd.delegate = self
        self.pwd.delegate = self
        
        //print(NSUserDefaults.standardUserDefaults().objectForKey("storage"))

    }
    
    override func viewDidAppear(animated: Bool) {
        
        if NSUserDefaults.standardUserDefaults().objectForKey("storage") != nil {
           self.view.hidden = true
            self.performSegueWithIdentifier("Term", sender: self)
            
            
            
        }
    }
    
    override func viewWillAppear(animated: Bool) {
             navigationController?.navigationBar.hidden = true
             self.navigationController?.interactivePopGestureRecognizer!.enabled = false;
  
             Dersler.removeAll(keepCapacity: false)
             terms.removeAll(keepCapacity: false)
             spa.removeAll(keepCapacity: false)
             creditperterm.removeAll(keepCapacity: false)

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  }

