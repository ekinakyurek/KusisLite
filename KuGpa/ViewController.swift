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

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let _ = touches.first {
         self.view.endEditing(true)   // ...
        }
        super.touchesBegan(touches, with:event)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        
        return true
        
    }
    
    @IBOutlet var usd: UITextField!
    @IBOutlet var pwd: UITextField!

    
    
    @IBAction func clc(_ sender: AnyObject) {
        
        name = usd.text! as NSString
        pass = pwd.text! as NSString
        
        
        if Reachability.isConnectedToNetwork(){
          
            self.click.isHidden = true
            self.view.endEditing(true)
            activityInd.isHidden = false
            activityInd.startAnimating()
         
            let request =  Reachability.PrepareLoginRequest()
            
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
                

                
                DispatchQueue.main.async(execute: {
                    
                    let newrequest = Reachability.PrepareCourseHistoryRequest()
                    
                    let newtask = URLSession.shared.dataTask(with: newrequest, completionHandler: { (data, repsonse, error) -> Void in
                        
                        DispatchQueue.main.async(execute: {
                     
                          
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
                    })
                    newtask.resume()
                    
                   
                    
                })
            })
            
            task.resume()
        }else{
            self.AlertConnection()
        }

    }
    
    func AlertConnection(){
        let alertController = UIAlertController(title: "Connection Error", message:
            "Please sign in again!", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Okey", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
        
        self.click.isHidden = false
        self.activityInd.isHidden = true
        
        
    }
    
    func AfterCalculation(){
        
        
        
        isUploaded = true ;
        self.activityInd.stopAnimating()
        self.performSegue(withIdentifier: "Term", sender: self)
  

        
    
    }

    
    override func viewDidLoad() {
        self.tabBarController?.tabBar.isHidden = true
        self.view.isHidden = false
        super.viewDidLoad()
        //if NSUserDefaults.standardUserDefaults().objectForKey("storage") == nil {
        self.activityInd.isHidden = true
        self.navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent
        self.view.backgroundColor = mainStoryBoardColor
        // Do any additional setup after loading the view, typically from a nib.
        self.usd.delegate = self
        self.pwd.delegate = self
        
        //print(NSUserDefaults.standardUserDefaults().objectForKey("storage"))

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if UserDefaults.standard.object(forKey: "storage") != nil {
           self.view.isHidden = true
            self.performSegue(withIdentifier: "Term", sender: self)
            
            
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
             navigationController?.navigationBar.isHidden = true
             self.navigationController?.interactivePopGestureRecognizer!.isEnabled = false;
  
             Dersler.removeAll(keepingCapacity: false)
             terms.removeAll(keepingCapacity: false)
             spa.removeAll(keepingCapacity: false)
             creditperterm.removeAll(keepingCapacity: false)

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  }

