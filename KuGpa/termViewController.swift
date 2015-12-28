//
//  gpaViewController.swift
//  
//
//  Created by Ekin Akyürek and Ali Mert Türker on 1.10.2015.
//
//
import UIKit

var unit = 0.0

class termViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
@IBOutlet weak var tableView: UITableView!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleLabel : UILabel = UILabel(frame: CGRectMake(0,0,100,32))
        titleLabel.text = terms[indexofTerm][0].term
        titleLabel.font =  UIFont(name:"HalveticaNeue-UltraLight", size: 25.0)
        titleLabel.textColor = UIColor.whiteColor()
       
        self.navigationItem.titleView = titleLabel
        
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.backgroundColor = UIColor.whiteColor()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
       
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return terms[indexofTerm].count+1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        var cell: customCell
        
        cell=tableView.dequeueReusableCellWithIdentifier("cell",forIndexPath:indexPath) as! customCell
     
  
        cell.title.font = UIFont(name: "Robot-Light", size: 11.0)
        cell.detail.font = UIFont(name: "Robot-Light", size: 11.0)
        cell.detail.textColor = UIColor(netHex: 0x8E8E93)
        cell.plus.tag = indexPath.row+100
        cell.minus.tag = 200+indexPath.row
        cell.textField.tag = 300+indexPath.row
        cell.plus.addTarget(self, action: "plus:", forControlEvents: .TouchUpInside)
        cell.minus.addTarget(self, action:"minus:", forControlEvents: .TouchUpInside)
        
        
        
        if indexPath.row==0{
            
            Reachability.CalculateSpa(terms[indexofTerm])
            cell.title.text = String(format: "SPA: %.2f", spaholder)
            cell.title.font = UIFont(name:"Roboto-Light", size:19.0)
            cell.contentView.backgroundColor = firstCellColor
            cell.backgroundColor = firstCellColor
            cell.detail.font = UIFont(name:"Roboto-Light", size:19.0)
            cell.detail.text = String(format: "Credit: %.0f", creditholder)
            cell.textField.removeFromSuperview()
            cell.plus.removeFromSuperview()
            cell.minus.removeFromSuperview()
            
            
        }
        else {
            
            
        cell.title.font = UIFont(name:"Roboto-Light", size:16.0)
        cell.title.text=terms[indexofTerm][indexPath.row-1].name
        cell.detail.text = String(format: "%.0f", terms[indexofTerm][indexPath.row-1].units)
        cell.detail.font = UIFont(name:"Roboto-Light", size:16.0)
        cell.textField.text = terms[indexofTerm][indexPath.row-1].grade
    
            
        }
     
        return cell;
        
    }


    
    func plus(sender: UIButton){
        
    switch terms[indexofTerm][sender.tag-101].grade{
            
        case "A+":
        terms[indexofTerm][sender.tag-101].grade = "W"
        terms[indexofTerm][sender.tag-101].wunit =  terms[indexofTerm][sender.tag-101].units
        terms[indexofTerm][sender.tag-101].units = 0.0
        case "A":
        terms[indexofTerm][sender.tag-101].grade="A+"
        terms[indexofTerm][sender.tag-101].point = 4.3
        case "A-":
        terms[indexofTerm][sender.tag-101].grade = "A"
        terms[indexofTerm][sender.tag-101].point = 4.0
        case "B+":
        terms[indexofTerm][sender.tag-101].grade="A-"
        terms[indexofTerm][sender.tag-101].point = 3.7
        case "B":
        terms[indexofTerm][sender.tag-101].grade = "B+"
        terms[indexofTerm][sender.tag-101].point = 3.3
        case "B-":
        terms[indexofTerm][sender.tag-101].grade = "B"
        terms[indexofTerm][sender.tag-101].point = 3.0
        case "C+":
        terms[indexofTerm][sender.tag-101].grade = "B-"
        terms[indexofTerm][sender.tag-101].point = 2.7
        case "C":
        terms[indexofTerm][sender.tag-101].grade = "C+"
        terms[indexofTerm][sender.tag-101].point = 2.3
        case "C-":
        terms[indexofTerm][sender.tag-101].grade = "C"
        terms[indexofTerm][sender.tag-101].point = 2.0
        case "D+":
        terms[indexofTerm][sender.tag-101].grade = "C-"
        terms[indexofTerm][sender.tag-101].point = 1.7
        case "D":
        terms[indexofTerm][sender.tag-101].grade = "D+"
        terms[indexofTerm][sender.tag-101].point = 1.3
        case "F":
        terms[indexofTerm][sender.tag-101].grade = "D"
        terms[indexofTerm][sender.tag-101].point = 1.0
        case "W":
        terms[indexofTerm][sender.tag-101].grade = "F"
        terms[indexofTerm][sender.tag-101].point = 0.0
        terms[indexofTerm][sender.tag-101].units = terms[indexofTerm][sender.tag-101].wunit
        default:
        terms[indexofTerm][sender.tag-101].grade = "F"
        terms[indexofTerm][sender.tag-101].point = 0.0
        terms[indexofTerm][sender.tag-101].units = terms[indexofTerm][sender.tag-101].wunit
        terms[indexofTerm][sender.tag-101].valid = 1
  }
        Reachability.CalculateSpa(terms[indexofTerm])
        Reachability.CalculateGpaFromSpas()
        self.tableView.reloadData()
        
    }
    
    func minus(sender: UIButton){
    
    switch terms[indexofTerm][sender.tag-201].grade{
        case "A+":
        terms[indexofTerm][sender.tag-201].grade = "A"
        terms[indexofTerm][sender.tag-201].point = 4.0
        case "A":
        terms[indexofTerm][sender.tag-201].grade="A-"
        terms[indexofTerm][sender.tag-201].point = 3.7
        case "A-":
        terms[indexofTerm][sender.tag-201].grade = "B+"
        terms[indexofTerm][sender.tag-201].point = 3.3
        case "B+":
        terms[indexofTerm][sender.tag-201].grade="B"
        terms[indexofTerm][sender.tag-201].point = 3.0
        case "B":
        terms[indexofTerm][sender.tag-201].grade = "B-"
        terms[indexofTerm][sender.tag-201].point = 2.7
        case "B-":
        terms[indexofTerm][sender.tag-201].grade = "C+"
        terms[indexofTerm][sender.tag-201].point = 2.3
        case "C+":
        terms[indexofTerm][sender.tag-201].grade = "C"
        terms[indexofTerm][sender.tag-201].point = 2.0
        case "C":
        terms[indexofTerm][sender.tag-201].grade = "C-"
        terms[indexofTerm][sender.tag-201].point = 1.7
        case "C-":
        terms[indexofTerm][sender.tag-201].grade = "D+"
        terms[indexofTerm][sender.tag-201].point = 1.3
        case "D+":
        terms[indexofTerm][sender.tag-201].grade = "D"
        terms[indexofTerm][sender.tag-201].point = 1.0
        case "D":
        terms[indexofTerm][sender.tag-201].grade = "F"
        terms[indexofTerm][sender.tag-201].point = 0
        case "F":
        terms[indexofTerm][sender.tag-201].grade = "W"
        terms[indexofTerm][sender.tag-201].wunit =  terms[indexofTerm][sender.tag-201].units
        terms[indexofTerm][sender.tag-201].units = 0.0
        case "W":
        terms[indexofTerm][sender.tag-201].grade = "A+"
        terms[indexofTerm][sender.tag-201].point = 4.3
        terms[indexofTerm][sender.tag-201].units = terms[indexofTerm][sender.tag-201].wunit
        default:
        terms[indexofTerm][sender.tag-201].grade = "A+"
        terms[indexofTerm][sender.tag-201].point = 4.3
        terms[indexofTerm][sender.tag-201].units = terms[indexofTerm][sender.tag-201].wunit
        terms[indexofTerm][sender.tag-201].valid = 1
            
        }
     
        Reachability.CalculateSpa(terms[indexofTerm])
        Reachability.CalculateGpaFromSpas()
        self.tableView.reloadData()
        
    }



    
    
}
