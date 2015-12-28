//
//  reachability.swift
//  kuGpaCalculator
//
//  Created by Ekin Akyürek and Ali Mert Türker on 5.10.2015.
//  Copyright (c) 2015 MellonApp. All rights reserved.
//
import UIKit
//import Foundation
import SystemConfiguration

// Global Variables
struct Courses{
    var name = ""
    var term = ""
    var units = 0.0
    var wunit=0.0
    var grade = ""
    var point=0.0
    var valid=1
    var indexInDersler=0
}
var Dersler = [Courses]()

var terms = [[Courses]]()

var storage = ""

var indexofTerm=0

var gpa=0.0

var credit = 0.0

var creditholder2 = 0.0

//Colors



let greenButtonColor = UIColor(netHex: 0x4DC4AA)

let mainStoryBoardColor = UIColor(netHex: 0x2B2B2B)

var navigationControllerColor = greenButtonColor

var firstCellColor = UIColor(netHex: 0xECEFF1);

var detailLabelColor = UIColor(netHex: 0x8E8E93)

public class Reachability {
    
   var doc = ""
    
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags.ConnectionAutomatic
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }

    
    class func PrepareLoginRequest() -> NSMutableURLRequest{
        let request = NSMutableURLRequest(URL: NSURL(string: "https://kusis.ku.edu.tr/psp/ps/?cmd=login")!)
        request.HTTPMethod = "POST"
        let postString = "userid=\(name)&pwd=\(pass)"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-type")
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        return request
    }
    func descending (value1: Int, value2: Int) -> Bool {
        return value1 > value2;
    }
    class func sortTerms(){


        for(var i=0; i < terms.count-1; i++){
            
            for(var j=1; j < terms.count-i; j++){
                
                let namej = terms[j][0].term as NSString
                let yearj = Double(namej.substringFromIndex(namej.length-4))! + self.TermNameToDouble(namej.substringToIndex(namej.length-5))
                
                let namej1 = terms[j-1][0].term as NSString
                let yearj1 = Double(namej1.substringFromIndex(namej1.length-4))! + self.TermNameToDouble(namej1.substringToIndex(namej1.length-5))
                
              //  print(namej1.substringFromIndex(namej1.length-4))
                if(yearj1 < yearj){
                    
                    let temp = terms[j-1]
                    terms[j-1] = terms[j]
                    terms[j] = temp;
                }
            }
        }
        for thing in terms{
            print(thing[0].term)
        }

        
    }
    class func TermNameToDouble(name: String) -> Double{
        var toDouble = 0.0
        if name == "Spring" {
            toDouble = 0.1;
        }else if name == "Summer" {
            toDouble = 0.2
        }else if name == "Fall" {
            toDouble = 0.3
        }
        return toDouble;
    }
    
    class func PrepareCourseHistoryRequest()  -> NSMutableURLRequest {
        
        let coursehistory="https://kusis.ku.edu.tr/psc/ps/EMPLOYEE/HRMS/c/SA_LEARNER_SERVICES.SSS_MY_CRSEHIST.GBL?PORTALPARAM_PTCNAV=HC_SSS_MY_CRSEHIST_GBL&EOPP.SCNode=HRMS&EOPP.SCPortal=EMPLOYEE&EOPP.SCName=CO_EMPLOYEE_SELF_SERVICE&EOPP.SCLabel=Self%20Service&EOPP.SCPTfname=CO_EMPLOYEE_SELF_SERVICE&FolderPath=PORTAL_ROOT_OBJECT.CO_EMPLOYEE_SELF_SERVICE.HCCC_ACADEMIC_RECORDS.HC_SSS_MY_CRSEHIST_GBL&IsFolder=false&PortalActualURL=https%3a%2f%2fkusis.ku.edu.tr%2fpsc%2fps%2fEMPLOYEE%2fHRMS%2fc%2fSA_LEARNER_SERVICES.SSS_MY_CRSEHIST.GBL&PortalContentURL=https%3a%2f%2fkusis.ku.edu.tr%2fpsc%2fps%2fEMPLOYEE%2fHRMS%2fc%2fSA_LEARNER_SERVICES.SSS_MY_CRSEHIST.GBL&PortalContentProvider=HRMS&PortalCRefLabel=My%20Course%20History&PortalRegistryName=EMPLOYEE&PortalServletURI=https%3a%2f%2fkusis.ku.edu.tr%2fpsp%2fps%2f&PortalURI=https%3a%2f%2fkusis.ku.edu.tr%2fpsc%2fps%2f&PortalHostNode=HRMS&NoCrumbs=yes&PortalKeyStruct=yes"
        
        
        let newrequest = NSMutableURLRequest(URL: NSURL(string:coursehistory)!)
        newrequest.HTTPMethod = "GET"
        return newrequest
        
    }
    
    class func ReadHtmlData(data : NSData){
        
               
}

    class func TermSorter(){
        var newterm = [Courses]()
        var tempdersler = Dersler
        
        for thing in Dersler{
            
            for var i=0; i<tempdersler.count; i++ {
                
                let something = tempdersler[i]
                let term1 = thing.term
                let term2 = something.term
               
                if (term1==term2){
                    var newcourse = Courses()
                    newcourse=something
                    tempdersler[i].term = ""
                    newterm.append(newcourse)
                    
                }
                
                
            }
            if newterm.count>=1{
                terms.append(newterm)
                newterm.removeAll(keepCapacity: false)
                
            }
            
            
        }
        
    }
    
    class func dataCheck(data : NSData)-> Bool {
        
         let html = NSString(data: data, encoding: NSUTF8StringEncoding)
         let doc = NDHpple(HTMLData: html! as String)
           
            if doc.searchWithXPathQuery("/html/head/title")![0].text == "My Course History"{
            return true
            }else{
            return false
            }
       
        
    }
    
    class func dataParsing(data : NSData){
        
        let html = NSString(data: data, encoding: NSUTF8StringEncoding)
        
        let doc = NDHpple(HTMLData: html! as String)
        
        var i:Bool = true
        var s:Int = 0
        var derss=Courses()
        Dersler.removeAll(keepCapacity: false)
        terms.removeAll(keepCapacity: false)
        
        while(i) {
            
            
            for node in doc.searchWithXPathQuery("//span[@id='CRSE_NAME$\(s)']")! {
                if node.text != "" {
                    
                    derss.name=node.text!
                    
                    
                    
                }
                
            }
            
            for node in doc.searchWithXPathQuery("//span[@id='CRSE_TERM$\(s)']")! {
                if node.text != "" {
                    derss.term=node.text!
                    
                }
                
            }
            
            for node in doc.searchWithXPathQuery("//span[@id='CRSE_UNITS$\(s)']")! {
                if node.text != "" {
                    derss.units = (node.text! as NSString).doubleValue
                    
                    
                }
                
                
            }
            
            for node in doc.searchWithXPathQuery("//span[@id='CRSE_GRADE$\(s)']")! {
                if node.text !=  "" {
                    derss.grade=node.text!
                    derss.indexInDersler = s
                    Dersler.append(derss)
                    self.AssignPoint(s, grade: Dersler[s].grade)
                    
                }
                
            }
            
            if(Dersler.endIndex != s+1){
                
                i = false
            }
            
            s++
    }
    }
    
    class func AssignPoint(index: Int , grade : String ){
        
        switch  grade {
            
        case "A+": Dersler[index].point = 4.3
        Dersler[index].wunit=Dersler[index].units
        case "A": Dersler[index].point = 4.0
        Dersler[index].wunit=Dersler[index].units
        case "A-": Dersler[index].point = 3.7
        Dersler[index].wunit=Dersler[index].units
        case "B+": Dersler[index].point = 3.3
        Dersler[index].wunit=Dersler[index].units
        case "B": Dersler[index].point = 3.0
        Dersler[index].wunit=Dersler[index].units
        case "B-": Dersler[index].point = 2.7
        Dersler[index].wunit=Dersler[index].units
        case "C+": Dersler[index].point = 2.3
        Dersler[index].wunit=Dersler[index].units
        case "C": Dersler[index].point = 2.0
        Dersler[index].wunit=Dersler[index].units
        case "C-": Dersler[index].point = 1.7
        Dersler[index].wunit=Dersler[index].units
        case "D+": Dersler[index].point = 1.3
        Dersler[index].wunit=Dersler[index].units
        case "D": Dersler[index].point = 1.0
        Dersler[index].wunit=Dersler[index].units
        case "F": Dersler[index].point = 0.0
        Dersler[index].wunit=Dersler[index].units
        case "AU": Dersler[index].units = 0.0
        case "W": Dersler[index].wunit=Dersler[index].units
        Dersler[index].units = 0.0
            
            
        default : Dersler[index].valid = 0
        Dersler[index].wunit=Dersler[index].units
            
            
            
        }
        
        
    }
    
    
    class func CalculateGpa(courses: [Courses]){
        var totalUnits = 0.0
        var unitbypoint = 0.0
        
        for thing in courses {
            if (thing.valid == 1){
                totalUnits = totalUnits+thing.units
                unitbypoint = unitbypoint+(thing.units*thing.point)
            }
        }
        gpa = unitbypoint/totalUnits
        credit = totalUnits
        
    }

    
    class func ReadJson(){
        
        _ = storage as NSString
        
        
        do {
            
            let dict: NSDictionary = try NSJSONSerialization.JSONObjectWithData(storage.dataUsingEncoding(NSUTF8StringEncoding)!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
            
            
            for var a = 0; a<dict.count; a++ {
                var tempterm = [Courses]()
                
                for var b = 0; b<dict.valueForKey("\(a)")!.count; b++ {
                    
                    var newcourse = Courses()
                    newcourse.name = (dict.valueForKey("\(a)")!.valueForKey("\(b+10)")?.valueForKey("name"))! as! String
                    print(newcourse.name)
                    newcourse.grade = (dict.valueForKey("\(a)")!.valueForKey("\(b+10)")?.valueForKey("grade"))! as! String
                    newcourse.term = (dict.valueForKey("\(a)")!.valueForKey("\(b+10)")?.valueForKey("term"))! as! String
                    newcourse.point = Double((dict.valueForKey("\(a)")!.valueForKey("\(b+10)")?.valueForKey("point"))! as! String)!
                    newcourse.units = Double((dict.valueForKey("\(a)")!.valueForKey("\(b+10)")?.valueForKey("units"))! as! String)!
                    newcourse.valid = Int((dict.valueForKey("\(a)")!.valueForKey("\(b+10)")?.valueForKey("valid"))! as! String)!
                    newcourse.wunit = Double((dict.valueForKey("\(a)")!.valueForKey("\(b+10)")?.valueForKey("wunit"))! as! String)!
                    newcourse.indexInDersler = Int((dict.valueForKey("\(a)")!.valueForKey("\(b+10)")?.valueForKey("indexInDersler"))! as! String)!
                    tempterm.append(newcourse)
                    
                    
                    
                }
                terms.append(tempterm)
                
            }
            
            
            
        }catch{
            
        }
        
        
    }
    

    class func CalculateGpaFromSpas (){
        var gpaholder=0.0
        var count = 0
         credit = 0.0;
        for thing in terms{
            CalculateSpa(thing)
            credit = credit + creditholder2;
            gpaholder = spaholder*creditholder2 + gpaholder
            if spaholder != 0.0 {
                count = count + Int(creditholder2)
            }
        }
      
        gpa = gpaholder/Double(count)
        
    }
    
    class func CalculateSpa(courses: [Courses]){
        var totalUnits = 0.0
        var unitbypoint = 0.0
        creditholder = 0.0
        creditholder2=0.0
        for thing in courses {
            creditholder = creditholder + thing.units
            
            if (thing.valid == 1){
                totalUnits = totalUnits+thing.units
                unitbypoint = unitbypoint+(thing.units*thing.point)
            }
            
        }
        creditholder2=totalUnits
        
        if totalUnits == 0 {
            spaholder = 0.0
        }else{
            spaholder = unitbypoint/totalUnits
        }
        
    }
    
    class func CheckList(){
        
        for var i=0;i<Dersler.count; i++ {
            
            for var j=0;j<Dersler.count; j++ {
                
                let namecl = Dersler[i].name as NSString
                let namel = Dersler[j].name as NSString
                
                
                if namecl.substringToIndex(4) == namel.substringToIndex(4){
                    switch namecl.substringToIndex(4) {
                    case "ASIU","SOSC","ETHR","HUMS":
                        if Dersler[i].point > Dersler[j].point{
                            Dersler[j].units = 0.0
                            print("burda")
                            print(Dersler[j].units)
                        }
                        
                        if Dersler[i].point < Dersler[j].point{
                            Dersler[i].units = 0.0
                        }
                    default:
                        
                        if Dersler[i].name == Dersler[j].name{
                            
                            if Dersler[i].point > Dersler[j].point{
                                Dersler[j].units = 0.0
                                
                            }
                            
                            if Dersler[i].point < Dersler[j].point{
                                Dersler[i].units = 0.0
                            }
                            
                        }
                        
                        
                        
                    }
                    
                    
                }
                let elc = Dersler[j].name as NSString
                if elc.substringToIndex(3) == "ELC" {
                    Dersler[j].units=0.0
                    
                }
                
                
                
            }
            
            
        }
    }
    
   class func ToJson() -> String{
        
        var Json = "{"
        
        for var i=0; i < terms.count ; i++ {
            
            Json = Json + "\"" + String(i) + "\":" + "{"
            
            
            for  var j=0; j<terms[i].count; j++ {
                
                Json = Json + "\"" + String(j+10) + "\": {"
                
                Json = Json + "\"name\":\"" + terms[i][j].name + "\","
                
                Json = Json + "\"term\":\"" + terms[i][j].term + "\","
                
                Json = Json + "\"units\":\"" + String(terms[i][j].units) + "\","
                
                Json = Json + "\"grade\":\"" + terms[i][j].grade + "\","
                
                Json = Json + "\"point\":\"" + String(terms[i][j].point) + "\","
                
                Json = Json + "\"wunit\":\"" + String(terms[i][j].wunit) + "\","
                
                Json = Json + "\"valid\":\"" + String(terms[i][j].valid) + "\","
                
                Json = Json + "\"indexInDersler\":\"" + String(terms[i][j].indexInDersler) + "\"},"
                
            }
            
            Json.removeAtIndex(Json.endIndex.predecessor())
            
            Json = Json + "},"
            
        }
        
        Json.removeAtIndex(Json.endIndex.predecessor())
        
        Json = Json + "}"
        print(Json)
        return Json
        
    }
    
    
    
    
}