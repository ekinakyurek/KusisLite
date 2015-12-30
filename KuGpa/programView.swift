//
//  programView.swift
//
//
//  Created by Ekin Akyürek and Ali Mert Türker on 1.10.2015.
//
//

import UIKit
import Foundation

var program = [[String]]()
var LectureViews = [[UILabel]]()
var updated = false;
class programView: UIViewController{
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.LandscapeLeft.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
       
        createMyTable();
        
        if(!updated){
        getPlannedProgram();
        }
        
        // Do any additional setup after loading the view.
    }
    
    
    func createMyTable(){
        var cells = [[ CGRect ]]()
        let size = get_visible_size()
        
        let rowStep = size.height / 6.0
        let columnStep = size.width / 8.0
        
        let statusBar = self.navigationController!.navigationBar.frame.size;
        let statusHeight = min(statusBar.width, statusBar.height)
        
        cells.append(Array(count:8, repeatedValue:CGRect()))
        LectureViews.append(Array(count:8, repeatedValue:UILabel()))
        
        for time in 1...7 {
            cells[0][time] = CGRectMake(CGFloat(time)*columnStep,statusHeight,columnStep,rowStep);
            let label = UILabel(frame: cells[0][time]);
            label.textAlignment = NSTextAlignment.Center;
            label.backgroundColor = navigationControllerColor
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
            label.font = UIFont(name: "Roboto-Regular", size: 12)
            LectureViews[0][time] = label
            self.view.addSubview(LectureViews[0][time])
        }
        
        for i in 1...5 {
            cells.append(Array(count:8, repeatedValue:CGRect()))
            LectureViews.append(Array(count:8, repeatedValue:UILabel()))
            for j in 1...7{
                cells[i][j] = CGRectMake(CGFloat(j)*columnStep,statusHeight + CGFloat(i)*rowStep,columnStep,rowStep);
                let label = UILabel(frame: cells[i][j]);
                label.textAlignment = NSTextAlignment.Center;
                label.backgroundColor = colorPicker(i, column: j)
                label.text = LectureViews[i][j].text
                label.textColor = UIColor.blackColor()
                label.font = UIFont(name: "Roboto-Light", size: 12)
                LectureViews[i][j] = label
                self.view.addSubview( LectureViews[i][j] )
                
            }
        }
        for day in 1...5{
            
            cells[day][0] = CGRectMake(0,statusHeight + CGFloat(day)*rowStep,columnStep,rowStep);
            let label = UILabel(frame: cells[day][0]);
            label.textAlignment = NSTextAlignment.Center;
            label.backgroundColor = navigationControllerColor
            var Sday = ""
            switch day {
              case 1 : Sday = "Monday"
              case 2 : Sday = "Tuesday"
              case 3 : Sday = "Wednesday"
              case 4 : Sday = "Thursday"
              case 5: Sday = "Friday"
              default: Sday = ""
            
            }
            label.font = UIFont(name: "Roboto-Regular", size: 15)
            label.text = Sday
            label.textColor = UIColor.whiteColor()
        
            LectureViews[day][0] = label
            self.view.addSubview(LectureViews[day][0])
        }
        
        cells[0][0] = CGRectMake(0,statusHeight,columnStep,rowStep);
      
        let label = UILabel(frame: cells[0][0]);
        label.textAlignment = NSTextAlignment.Center;
        label.backgroundColor = navigationControllerColor
        label.text = "Enrollments"
        label.textColor = UIColor.whiteColor()
        label.font = UIFont(name: "Roboto-Regular", size: 15)
        LectureViews[0][0] = label;
        self.view.addSubview(LectureViews[0][0] )
        
    }
    
    func get_visible_size() -> CGSize{
   
    var result = UIScreen.mainScreen().bounds.size;
    var size = UIScreen.mainScreen().bounds.size;
 
    
    result.width = size.width;
    result.height = size.height;
    
    
    size = UIApplication.sharedApplication().statusBarFrame.size;
    result.height -= min(size.width, size.height);
    
    if (self.navigationController != nil) {
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
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    func getPlannedProgram()
        
    {
        if Reachability.isConnectedToNetwork(){
            
            let request = Reachability.PrepareLoginRequest()
            
            let session = NSURLSession.sharedSession()
            
            let task = session.dataTaskWithRequest(request){ (data, response, error) -> Void in
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    let newrequest = Reachability.PreparePlannedProgramRequest()
                    
                    let newtask = session.dataTaskWithRequest(newrequest){ (data, repsonse, error) -> Void in
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            Reachability.dataParsingForProgram(data!,plannedOrconfirmed: true)
                            
                            self.putCoursesToTable(planned)
                            
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
        if Reachability.isConnectedToNetwork(){
            
            let request = Reachability.PrepareLoginRequest()
            
            let session = NSURLSession.sharedSession()
            
            let task = session.dataTaskWithRequest(request){ (data, response, error) -> Void in
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    let newrequest = Reachability.PrepareConfirmedProgramRequest()
                    
                    let newtask = session.dataTaskWithRequest(newrequest){ (data, repsonse, error) -> Void in
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            Reachability.dataParsingForProgram(data!,plannedOrconfirmed: false)
                            
                            self.putCoursesToTable(confirmed)
                            
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
        
        for lecture in planned{
            var index = [0,0,0,0]
            
            if(lecture.lecStart != 0.0 ){
               
                index = dateToIndex(lecture.lecStart,end: lecture.lecEnd , days: lecture.lecDays)
                LectureViews[index[2]][index[0]].text = lecture.name;
                print(lecture.lecDays)
                
                if index[3] != 0 {
                LectureViews[index[3]][index[0]].text = lecture.name;
                            print(lecture.name)
                }
                if index[1] == 1 {
                LectureViews[index[3]][index[0]+1].text = lecture.name;
                            print(lecture.name)
                }
                if index[1] == 2 {
                LectureViews[index[3]][index[0]+1].text = lecture.name;
                LectureViews[index[3]][index[0]+2].text = lecture.name;
                            print(lecture.name)
                }
                
            }
            if(lecture.psStart != 0.0 ){
                index = dateToIndex(lecture.lecStart,end: lecture.lecEnd , days: lecture.psDays)
                LectureViews[index[2]][index[0]].text = "PS-"+lecture.name;
                if index[3] != 0 {
                    LectureViews[index[3]][index[0]].text = "PS-"+lecture.name;
                }
                if index[1] == 1 {
                    LectureViews[index[3]][index[0]+1].text = "PS-"+lecture.name;
                }
                if index[1] == 2 {
                    LectureViews[index[3]][index[0]+1].text = "PS-"+lecture.name;
                    LectureViews[index[3]][index[0]+2].text = "PS-"+lecture.name;
                }
            }
            if(lecture.dsStart != 0.0 ){
                index = dateToIndex(lecture.lecStart,end: lecture.lecEnd , days: lecture.dsDays)
                LectureViews[index[2]][index[0]].text = "DS-"+lecture.name;
                if index[3] != 0 {
                    LectureViews[index[3]][index[0]].text = "DS-"+lecture.name;
                }
                if index[1] == 1 {
                    LectureViews[index[3]][index[0]+1].text = "DS-"+lecture.name;
                }
                if index[1] == 2 {
                    LectureViews[index[3]][index[0]+1].text = "DS-"+lecture.name;
                    LectureViews[index[3]][index[0]+2].text = "DS-"+lecture.name;
                }
            }
            if(lecture.labStart != 0.0 ){
                index = dateToIndex(lecture.lecStart,end: lecture.lecEnd , days: lecture.labDays)
                LectureViews[index[2]][index[0]].text = "Lab-"+lecture.name;
                if index[3] != 0 {
                    LectureViews[index[3]][index[0]].text = "Lab-"+lecture.name;
                }
                if index[1] == 1 {
                    LectureViews[index[3]][index[0]+1].text = "Lab-"+lecture.name;
                }
                if index[1] == 2 {
                    LectureViews[index[3]][index[0]+1].text = "Lab-"+lecture.name;
                    LectureViews[index[3]][index[0]+2].text = "Lab-"+lecture.name;
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
        
        switch start {
        case 8.3  : j = 1
        case 10.0 : j = 2
        case 11.3 : j = 3
        case 13.0 : j = 4
        case 14.3 : j = 5
        case 16.0 : j = 6
        case 17.3 : j = 7
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
     return [j,z,i,t]
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
