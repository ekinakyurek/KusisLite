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
        UserDefaults.standard.set(storage, forKey: "storage")
        storage = ""
        UserDefaults.standard.set(name, forKey: "name")
        UserDefaults.standard.set(pass, forKey: "pass")
        
    }
   
    @IBAction func logout(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "logout", sender: self)
        storage = ""
        terms.removeAll()
        
        updated = false
        UserDefaults.standard.removeObject(forKey: "storage")
        
        
    }

    @IBOutlet weak var tableView: UITableView!
    var refreshControl:UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.delegate = self

        if UserDefaults.standard.object(forKey: "storage") != nil {
            
            storage = UserDefaults.standard.object(forKey: "storage") as! String
            Reachability.ReadJson()
            Reachability.CalculateGpaFromSpas()
            name = UserDefaults.standard.object(forKey: "name") as! NSString
            pass = UserDefaults.standard.object(forKey: "pass") as! NSString
            
            
        }
        navigationController?.navigationBar.isHidden = false
        navigationController!.navigationBar.barTintColor = navigationControllerColor
        let titleLabel : UILabel = UILabel(frame: CGRect(x: 0,y: 0,width: 50,height: 32))
        titleLabel.text = name as String
        titleLabel.font =  UIFont(name:"HalveticaNeue-UltraLight", size: 25.0)
        titleLabel.textColor = UIColor.white
        self.navigationController!.navigationBar.tintColor = UIColor.white
      
        self.navigationItem.titleView = titleLabel
        self.navigationController!.navigationBar.barStyle = UIBarStyle.blackTranslucent

        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(gpaViewController.refresh(_:)), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(refreshControl)
        
        
      //  tableView.backgroundColor = tableColor
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView(frame: CGRect.zero)
       
      
        // Do any additional setup after loading the view.
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        
        if viewController.title == "enrollments" && !UIDevice.current.orientation.isLandscape  {
        
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        
        UIDevice.current.setValue(value, forKey: "orientation")
      
        }
       
    }
    
    func refresh(_ sender:AnyObject)
        
    {
        if Reachability.isConnectedToNetwork(){
            
            let request = Reachability.PrepareLoginRequest()
        
            let session = URLSession.shared
            
            let task = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
                
                DispatchQueue.main.async(execute: {
             
                    let newrequest = Reachability.PrepareCourseHistoryRequest()
                
                    let newtask = session.dataTask(with: newrequest, completionHandler: { (data, repsonse, error) -> Void in
                    
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
    
    override func viewWillAppear(_ animated: Bool) {
        Reachability.CalculateGpaFromSpas();
        tableView.reloadData()
        navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.interactivePopGestureRecognizer!.isEnabled = true;
        Reachability.sortTerms()

        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return terms.count+1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        
        cell=tableView.dequeueReusableCell(withIdentifier: "cell",for:indexPath) as UITableViewCell

        
        updateStorage()
        
        if indexPath.row==0{
            cell.textLabel?.text = String(format: "GPA: %.2f", gpa)
            cell.backgroundColor = firstCellColor
            cell.tintColor = UIColor.white
            cell.textLabel?.font = UIFont(name:"Roboto-Light", size:19.0)
            cell.detailTextLabel?.text = String(format: "Credit: %.0f", credit)
            cell.detailTextLabel?.textColor = detailLabelColor
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.isUserInteractionEnabled = false
        
            
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
            "Please sign in again!", preferredStyle: UIAlertControllerStyle.alert)
    
        alertController.addAction(UIAlertAction(title: "Okey", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func AfterCalculation(){
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0 {
            indexofTerm = indexPath.row-1
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
             

      }
 
}
