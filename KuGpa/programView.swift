//
//  programView.swift
//
//
//  Created by Ekin Akyürek and Ali Mert Türker on 1.10.2015.
//
//

import UIKit
import Foundation
import Parse

var LectureViews = [[UILabel]]()
var updated = false;
var isPlanned = false;
var becauseRotation = false;
var statusBarHeight = CGFloat ()
var oocolor = mainStoryBoardColo
class programView: UIViewController{
var ActivityIndicator = UIActivityIndicatorView()
  
    
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        
    
        if(LectureViews.capacity == 0){
            for _ in 0...7 {
                LectureViews.append(Array(count:8, repeatedValue:UILabel()))
            }
            
        }
        
        
        if UIDevice.currentDevice().orientation.isLandscape.boolValue {
            createMyTableLandscape()
        }else{
            createMyTablePortrait()
        }
        
        if(!updated && isPlanned){
        getPlannedProgram();
        }else if(!updated && !isPlanned){
        getConfirmedProgram()
        }
        
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        
        if isPlanned && updated {
            becauseRotation = true
            putCoursesToTable(planned)
            LectureViews[0][0].text = "Planned"
            self.ActivityIndicator.stopAnimating()
            LectureViews[0][0].userInteractionEnabled = true
        }else if !isPlanned && updated {
             becauseRotation = true
            putCoursesToTable(confirmed)
            LectureViews[0][0].text = "Confirm."
            self.ActivityIndicator.stopAnimating()
            LectureViews[0][0].userInteractionEnabled = true
   
        }
        

    
    }
    
   
   
    
    func createMyTableLandscape(){
        
        ActivityIndicator.startAnimating()
        self.navigationController?.navigationBarHidden = true
        
        var size = get_visible_size()
        size.height += self.tabBarController!.tabBar.frame.size.height + UIApplication.sharedApplication().statusBarFrame.height
        size.width -=  self.tabBarController!.tabBar.frame.size.height
        
        let firstRow = (size.width / 6.0) * 0.8
        let firstColumn = (size.height / 8.0) * 0.7
        
        let rowStep = (size.width - firstRow) / 5.0
        let columnStep = (size.height - firstColumn) / 7.0
        
        
        var cells = [[ CGRect ]]()
        cells.append(Array(count:8, repeatedValue:CGRect()))
        
        cells[0][0] = CGRectMake(0.0,0.0,firstColumn,firstRow);
       
        
      
        
        let label = UILabel(frame: cells[0][0]);
        
        
        label.textAlignment = NSTextAlignment.Center
        if isPlanned {
            label.backgroundColor = navigationControllerColor
        }else{
            label.backgroundColor = oocolor
            
        }
        label.textColor = UIColor.whiteColor()
        label.numberOfLines = 0
        label.font = UIFont(name: "Roboto-Regular", size: 13)
        let tap = UITapGestureRecognizer(target: self, action: Selector("myMethodToHandleTap:"))
        tap.numberOfTapsRequired = 1
        LectureViews[0][0] = label;
        ActivityIndicator.center = CGPoint(x: firstColumn/2, y: firstRow/2)
        LectureViews[0][0].addSubview(ActivityIndicator)
        LectureViews[0][0].addGestureRecognizer(tap)
  
        
        for time in 1...7 {
            cells[0][time] = CGRectMake(CGFloat(time-1)*columnStep + firstColumn,0.0,columnStep,firstRow);
            let label = UILabel(frame: cells[0][time]);
            label.textAlignment = NSTextAlignment.Center;
            label.backgroundColor = greenButtonColor
            label.numberOfLines = 1
    
            
            var start = 8.50 + 1.50 * Double((time-1))
            let intstart = Double(Int(floor(start)))
            let left = start-intstart
            if left == 0.00 {
                
            }else{
                start = intstart + 0.30
            }
            let finish = start + 1.15
            
            label.text = String(format: "%.2f", start) + " - " + String(format: "%.2f", finish )
            label.textColor = UIColor.whiteColor()
            label.font = UIFont(name: "Roboto-Regular", size: 13)
            label.adjustsFontSizeToFitWidth = true
            LectureViews[0][time] = label
            self.view.addSubview(LectureViews[0][time])
        }
        
        for i in 1...5 {
            cells.append(Array(count:8, repeatedValue:CGRect()))
         
            for j in 1...7{
                cells[i][j] = CGRectMake(CGFloat(j-1)*columnStep + firstColumn,firstRow + CGFloat(i-1)*rowStep,columnStep,rowStep);
                let label = UILabel(frame: cells[i][j]);
                label.textAlignment = NSTextAlignment.Center;
                label.backgroundColor = colorPicker(i, column: j)
                label.attributedText = LectureViews[i][j].attributedText
                label.numberOfLines = 0
                LectureViews[i][j] = label
                
                self.view.addSubview( LectureViews[i][j] )
                
                
                
            }
        }
        for day in 1...5{
            
            cells[day][0] = CGRectMake(0,CGFloat(day-1)*rowStep + firstRow,firstColumn,rowStep);
            let label = UILabel(frame: cells[day][0]);
            label.textAlignment = NSTextAlignment.Center;
            label.backgroundColor = greenButtonColor
            label.numberOfLines = 0
            var Sday = ""
            switch day {
            case 1 : Sday = "Mon"
            case 2 : Sday = "Tue"
            case 3 : Sday = "Wed"
            case 4 : Sday = "Thu"
            case 5: Sday = "Fri"
            default: Sday = ""
                
            }
            label.font = UIFont(name: "Roboto-Regular", size: 14)
            label.text = Sday
            label.textColor = UIColor.whiteColor()
            
            LectureViews[day][0] = label
            self.view.addSubview(LectureViews[day][0])
        }
        
        
        LectureViews[0][0].layer.shadowOffset = CGSize(width: 2, height: 2)
        LectureViews[0][0].layer.shadowOpacity = 0.4
        LectureViews[0][0].layer.shadowRadius = 4
        LectureViews[0][0].layer.shadowColor  = UIColor.whiteColor().CGColor
        self.view.addSubview(LectureViews[0][0])
        
    }

    func createMyTablePortrait(){
        
        ActivityIndicator.startAnimating()
        self.navigationController?.navigationBarHidden = true
        
        var size = get_visible_size()
        
        if(becauseRotation) {
            size.height -=  statusBarHeight
            
        }
        
        becauseRotation = false
        
        let firstRow = (size.height / 8.0) * 0.8
        let firstColumn = (size.width / 6.0) * 0.8
       
        
        let rowStep = (size.height-firstRow)/7.0
        let columnStep = (size.width-firstColumn)/5.0
        
        var cells = [[ CGRect ]]()
        cells.append(Array(count: 6, repeatedValue:CGRect()))
        
        cells[0][0] = CGRectMake(0,statusBarHeight,firstColumn,firstRow);
        let label = UILabel(frame: cells[0][0]);
        label.textAlignment = NSTextAlignment.Center
        if isPlanned {
            label.backgroundColor = navigationControllerColor
        }else{
            label.backgroundColor = oocolor
            
        }
        
        label.textColor = UIColor.whiteColor()
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "Roboto-Regular", size: 13)
        let tap = UITapGestureRecognizer(target: self, action: Selector("myMethodToHandleTap:"))
        tap.numberOfTapsRequired = 1
        LectureViews[0][0] = label;
        ActivityIndicator.center = CGPoint(x: firstColumn/2, y: firstRow/2)
        LectureViews[0][0].addSubview(ActivityIndicator)
        
        LectureViews[0][0].addGestureRecognizer(tap)
        self.view.addSubview(LectureViews[0][0])
  
        
        for time in 1...7 {
            
            cells.append(Array(count: 6, repeatedValue:CGRect()))
            
            cells[time][0] = CGRectMake(0.0,statusBarHeight + CGFloat(time-1) * rowStep + firstRow ,firstColumn,rowStep);
            
            let label = UILabel(frame: cells[time][0]);
            label.textAlignment = NSTextAlignment.Center;
            label.backgroundColor = greenButtonColor
            label.numberOfLines = 0
            var start = 8.50 + 1.50 * Double((time-1))
            let intstart = Double(Int(floor(start)))
            let left = start-intstart
            if left == 0.00 {
                
            }else{
                start = intstart + 0.30
            }
            let finish = start + 1.15
            
            label.text = String(format: "%.2f", start) + "\n" + String(format: "%.2f", finish )
            label.textColor = UIColor.whiteColor()
            label.font = UIFont(name: "Roboto-Regular", size: 12)
            
            
            LectureViews[0][time] = label
            self.view.addSubview(LectureViews[0][time])
        }
        
        for i in 1...7 {
            for j in 1...5{
                cells[i][j] = CGRectMake(CGFloat(j-1)*columnStep + firstColumn,statusBarHeight + CGFloat(i-1)*rowStep + firstRow, columnStep,rowStep);
                let label = UILabel(frame: cells[i][j]);
                label.textAlignment = NSTextAlignment.Center;
                label.backgroundColor = colorPicker(j, column: i)
                label.attributedText = LectureViews[j][i].attributedText
                label.numberOfLines = 0
              

                LectureViews[j][i] = label
               
                self.view.addSubview( LectureViews[j][i] )
               
                
                
            }
        }
        for day in 1...5{
            
            cells[0][day] = CGRectMake(CGFloat(day-1)*columnStep + firstColumn,statusBarHeight,columnStep,firstRow);
            let label = UILabel(frame: cells[0][day]);
            label.textAlignment = NSTextAlignment.Center;
            label.backgroundColor = greenButtonColor
            label.numberOfLines = 0
            var Sday = ""
            
            switch day {
              case 1 : Sday = "Mo"
              case 2 : Sday = "Tue"
              case 3 : Sday = "Wed"
              case 4 : Sday = "Thu"
              case 5: Sday = "Fri"
              default: Sday = ""
            
            }
            label.font = UIFont(name: "Roboto-Regular", size: 14)
            label.text = Sday
            label.textColor = UIColor.whiteColor()
           
        
            LectureViews[day][0] = label
            self.view.addSubview(LectureViews[day][0])
        }
        
        LectureViews[0][0].layer.shadowOffset = CGSize(width: 10, height: 10)
        LectureViews[0][0].layer.shadowOpacity = 0.5
        LectureViews[0][0].layer.shadowRadius = 20
        LectureViews[0][0].layer.shadowColor  = UIColor.whiteColor().CGColor
  
      
      
        
    }
    
    func myMethodToHandleTap(sender: UITapGestureRecognizer) {
        
        ActivityIndicator.startAnimating()
        LectureViews[0][0].userInteractionEnabled = false
        
        LectureViews[0][0].text = ""
        
        
        LectureViews[0][0].layer.shadowOffset = CGSize(width: 2, height: 2)
        LectureViews[0][0].layer.shadowOpacity = 0.4
        LectureViews[0][0].layer.shadowRadius = 7
        LectureViews[0][0].layer.shadowColor  = UIColor.grayColor().CGColor
        
        if sender.view?.backgroundColor == navigationControllerColor {
            getConfirmedProgram()
            sender.view?.backgroundColor = oocolor
            isPlanned = false;
        }else{
            getPlannedProgram()
            sender.view?.backgroundColor = navigationControllerColor
            isPlanned = true;
           
        }
       
       
        
    }
    
    func get_visible_size() -> CGSize {
   
    var result = UIScreen.mainScreen().bounds.size;
    var size = UIScreen.mainScreen().bounds.size;
    
    if size.height < size.width {
            
             result.height = size.width;
             result.width = size.height;
    }
  
    
    size = UIApplication.sharedApplication().statusBarFrame.size;
    result.height -= min(size.width, size.height);
      
    
    if (self.navigationController?.navigationBarHidden != true) {
    size = self.navigationController!.navigationBar.frame.size;
    result.height -= min(size.width, size.height);
    }
    
    if (self.tabBarController != nil) {
    size = self.tabBarController!.tabBar.frame.size;
    result.height -= min(size.width, size.height);
    }
    
    return result;
        
    }
    
    func colorPicker(row: Int, column: Int) -> UIColor {
        if row % 2 == 0 {
            return firstCellColor
        }else{
            return UIColor.whiteColor()
        }
    }
    
  
    
    func getPlannedProgram()
        
    {
        
        planned.removeAll()
        
        if Reachability.isConnectedToNetwork(){
            
            let request = Reachability.PrepareLoginRequest()
            
            let session = NSURLSession.sharedSession()
            
            let task = session.dataTaskWithRequest(request){ (data, response, error) -> Void in
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    let newrequest = Reachability.PreparePlannedProgramRequest()
                    
                    let newtask = session.dataTaskWithRequest(newrequest){ (data, repsonse, error) -> Void in
                        
                        dispatch_async(dispatch_get_main_queue(), {
//                            var mytext = NSData()
//                            var path = NSURL()
//                            
//                            do {
//                                path = NSBundle.mainBundle().bundleURL
//                               
//                                
//                                path = path.URLByAppendingPathComponent("pelin")
//                                
//                                mytext = try NSData(contentsOfURL: path)!
//
//                                
//                            } catch let error as NSError {
//                                print("error loading from url")
//                                print(error.localizedDescription)
//                            }

                            Reachability.dataParsingForProgram( data! )
                            
                            let USER = PFUser.currentUser()
                            
                            USER!.setObject( Reachability.ToJson(planned), forKey: "planned" )
                            USER?.saveInBackground()
                            
                            self.putCoursesToTable(planned)
                            LectureViews[0][0].text = "Planned"
                            self.ActivityIndicator.stopAnimating()
                            LectureViews[0][0].userInteractionEnabled = true
                          
                        })
                    }
                    newtask.resume()
                    
                })
            }
            
            task.resume()
        }else{
            //self.AlertConnection()
        }
        
    }
    func getConfirmedProgram()
        
    {
        
        confirmed.removeAll()
        
        if Reachability.isConnectedToNetwork(){
            
            let request = Reachability.PrepareLoginRequest()
            
            let session = NSURLSession.sharedSession()
            
            let task = session.dataTaskWithRequest(request){ (data, response, error) -> Void in
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    let newrequest = Reachability.PrepareConfirmedProgramRequest()
                    
                    let newtask = session.dataTaskWithRequest(newrequest){ (data, repsonse, error) -> Void in
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            Reachability.dataParsingForConfirmed(data!)
                           
                            let USER = PFUser.currentUser()
                            USER!.setObject( Reachability.ToJson(confirmed) , forKey: "confirmed" )
                            USER!.saveInBackground();
                          
                        
                            self.putCoursesToTable(confirmed)
                            if UIDevice.currentDevice().orientation.isLandscape.boolValue {
                            LectureViews[0][0].text = "Confirm."
                            }else{
                            LectureViews[0][0].text = "Conf."
                            }
                            
                            self.ActivityIndicator.stopAnimating()
                            LectureViews[0][0].userInteractionEnabled = true
                            
                          
                        
                            
                        })
                    }
                    newtask.resume()
                    
                })
            }
            
            task.resume()
        }else{
            //self.AlertConnection()
        }
        
    }
    
    func putCoursesToTable(listOfProgram: [Lecture]){
        
        for lectures in LectureViews{
            for lecture in lectures {
                lecture.text = " "
            }
        }
        
        for lecture in listOfProgram {
            
            var index = [0,0,0,0]
            
            var firstLine = NSMutableAttributedString(string: "")
        
            
            let smallerFontSize = [NSFontAttributeName: UIFont(name: "Roboto-Light", size: 10)!]
       
            let biggerFontSize = [NSFontAttributeName: UIFont(name: "Roboto-Regular", size: 12)!]
            
            var secondLine = NSMutableAttributedString(string: "")
            
            let yildiz =  NSMutableAttributedString(string: "*", attributes: smallerFontSize)
           
            if(lecture.lecStart != 0.0 ){
               
                index = dateToIndex(lecture.lecStart,end: lecture.lecEnd , days: lecture.lecDays)
                
                
                firstLine = NSMutableAttributedString(string: lecture.name, attributes: biggerFontSize)
                
           
                              
                
                secondLine = NSMutableAttributedString(string: "\n" + lecture.location, attributes: smallerFontSize)
                
                if index[4]==1 {
                    secondLine.appendAttributedString(yildiz)
                }
                
                firstLine.appendAttributedString(secondLine)
                
                 LectureViews[index[2]][index[0]].font = nil
                 LectureViews[index[2]][index[0]].textColor = nil
                  LectureViews[index[2]][index[0]].attributedText = firstLine
                
                
                if index[3] != 0 {
                    LectureViews[index[3]][index[0]].attributedText = firstLine
                }
                if index[1] == 1 {
                    LectureViews[index[3]][index[0]+1].attributedText = firstLine
                }
                if index[1] == 2 {
                    LectureViews[index[3]][index[0]+1].attributedText = firstLine
                    LectureViews[index[3]][index[0]+2].attributedText = firstLine
                }
                
            }
            if(lecture.psStart != 0.0 ){
                
                index = dateToIndex(lecture.psStart,end: lecture.psEnd , days: lecture.psDays)
                
                firstLine = NSMutableAttributedString(string: "PS-\(lecture.name)\n", attributes: biggerFontSize)
                
                
              
                secondLine = NSMutableAttributedString(string: "\(lecture.psLocation)", attributes: smallerFontSize)
                
                if index[4]==1 {
                    secondLine.appendAttributedString(yildiz)
                }
                
                
                firstLine.appendAttributedString(secondLine)
                
                
                LectureViews[index[2]][index[0]].attributedText = firstLine
                
                
                if index[3] != 0 {
                    LectureViews[index[3]][index[0]].attributedText = firstLine
                }
                if index[1] == 1 {
                    LectureViews[index[3]][index[0]+1].attributedText = firstLine
                }
                if index[1] == 2 {
                    LectureViews[index[3]][index[0]+1].attributedText = firstLine
                    LectureViews[index[3]][index[0]+2].attributedText = firstLine
                }
                
        
            }
            if(lecture.dsStart != 0.0 ){
                index = dateToIndex(lecture.dsStart,end: lecture.dsEnd , days: lecture.dsDays)
                
                firstLine = NSMutableAttributedString(string: "DS-\(lecture.name)\n", attributes: biggerFontSize)
            
                
                secondLine = NSMutableAttributedString(string: "\(lecture.dsLocation)", attributes: smallerFontSize)
                
                if index[4]==1 {
                    secondLine.appendAttributedString(yildiz)
                }
                
                firstLine.appendAttributedString(secondLine)
                
                
                LectureViews[index[2]][index[0]].attributedText = firstLine
                
                
                if index[3] != 0 {
                    LectureViews[index[3]][index[0]].attributedText = firstLine
                }
                if index[1] == 1 {
                    LectureViews[index[3]][index[0]+1].attributedText = firstLine
                }
                if index[1] == 2 {
                    LectureViews[index[3]][index[0]+1].attributedText = firstLine
                    LectureViews[index[3]][index[0]+2].attributedText = firstLine
                }
           
             
            }
            if(lecture.labStart != 0.0 ){
                
                index = dateToIndex(lecture.labStart,end: lecture.labEnd , days: lecture.labDays)
                
                firstLine = NSMutableAttributedString(string: "LAB-\(lecture.name)\n", attributes: biggerFontSize)
                
            
                
                secondLine = NSMutableAttributedString(string: "\(lecture.labLocation)", attributes: smallerFontSize)
                
                if index[4]==1 {
                    secondLine.appendAttributedString(yildiz)
                }
                
                firstLine.appendAttributedString(secondLine)
                
                
                LectureViews[index[2]][index[0]].attributedText = firstLine
                
             
                
                if index[3] != 0 {
                    
                    
                    LectureViews[index[3]][index[0]].attributedText = firstLine
                }
                if index[1] == 1 {
                    
                    LectureViews[index[2]][1 + index[0]].attributedText = firstLine
                }
                if index[1] == 2 {
                    LectureViews[index[2]][index[0]+1].attributedText = firstLine
                    LectureViews[index[2]][index[0]+2].attributedText = firstLine
                }
              
                
            }
            
        
        }
        updated = true
       
        let parent: UIView = self.view.superview!
        self.view.removeFromSuperview()
        self.view = nil; // unloads the view
        parent.addSubview(self.view)
        
    }
    
    func dateToIndex(start: Double, end: Double, days: String) -> [Int]{
        var i,j : Int
        var t,z: Int
        var yildiz : Int
        
        yildiz = 0
        
        switch start {
        case 8.3  : j = 1
        case 10.0 : j = 2
        case 11.3 : j = 3
        case 13.0 : j = 4
        case 14.3 : j = 5
        case 16.0 : j = 6
        case 17.3 : j = 7
        case 12.3 : j = 4
                    yildiz = 1
        default: j = 0
        }
        switch end {
        case 9.45  : z = 1 - j
        case 11.15 : z = 2 - j
        case 12.45 : z = 3 - j
        case 14.15 : z = 4 - j
        case 15.45 : z = 5 - j
        case 17.15 : z = 6 - j
        case 16.45 : z = 7 - j
        case 12.20 : z = 3 - j
                     yildiz = 1
        default: z = 0
        }
        switch days {
        case "MoWe" :
            i = 1
            t = 3
        case "TuTh" :
            i = 2
            t = 4
        case "Mo" :
            i = 1
            t = 0
        case "Tu" :
            i = 2
            t = 0
        case "We" :
            i = 3
            t = 0
        case "Th" :
            i = 4
            t = 0
        case "Fr" :
            i = 5
            t = 0
        default :
            i=0
            t=0
        }
     return [j,z,i,t,yildiz]
    }
    
    override func viewWillAppear(animated: Bool) {
        
        navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.interactivePopGestureRecognizer!.enabled = true
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

