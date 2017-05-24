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
import Kanna
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}


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
struct Lecture{
    var name = ""
    var location = ""
    var lecStart = 0.0
    var lecEnd = 0.0
    var lecDays = ""
    var psDays = ""
    var dsDays = ""
    var labDays = ""
    var psStart = 0.0
    var psEnd =  0.0
    var psLocation = ""
    var dsStart = 0.0
    var dsEnd = 0.0
    var dsLocation = ""
    var labStart = 0.0
    var labEnd = 0.0
    var labLocation = ""
    var indexInLectures = 0
}

var planned = [Lecture]()
var confirmed = [Lecture]()
var todays = [Lecture]()

var Dersler = [Courses]()

var terms = [[Courses]]()

var storage = ""

var indexofTerm=0

var gpa=0.0

var credit = 0.0

var creditholder2 = 0.0

//Colors

let greenButtonColor = UIColor(netHex: 0x4DC4AA)

let mainStoryBoardColo = UIColor(netHex: 0x2B2B2B)

let mainStoryBoardColor = UIColor(netHex: 0x2c3e50)

var navigationControllerColor = mainStoryBoardColor

var firstCellColor = UIColor(netHex: 0xECEFF1);

var detailLabelColor = UIColor(netHex: 0x8E8E93)

open class Reachability {
    
   var doc = ""
    
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }

    
    class func PrepareLoginRequest() -> URLRequest{
        var request = URLRequest(url: URL(string: "https://kusis.ku.edu.tr/psp/ps/?cmd=login&languageCd=ENG")!)

        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded;charset=utf-8", forHTTPHeaderField: "Content-Type")
        var postData = "userid=\(name)".data(using: String.Encoding.utf8)!
        postData.append("&pwd=\(pass)".data(using: String.Encoding.utf8)!)
       //request.httpBody = postString.data(using: String.Encoding.utf8)
        request.httpBody = postData;
        return request
    }
    func descending (_ value1: Int, value2: Int) -> Bool {
        return value1 > value2;
    }
    class func sortTerms(){


   
        for i  in 0..<terms.count-1 {
            
            for j in 1..<terms.count-i{
                
                let namej = terms[j][0].term as NSString
                let yearj = Double(namej.substring(from: namej.length-4))! + self.TermNameToDouble(namej.substring(to: namej.length-5))
                
                let namej1 = terms[j-1][0].term as NSString
                let yearj1 = Double(namej1.substring(from: namej1.length-4))! + self.TermNameToDouble(namej1.substring(to: namej1.length-5))
                
              //  print(namej1.substringFromIndex(namej1.length-4))
                if(yearj1 < yearj){
                    
                    let temp = terms[j-1]
                    terms[j-1] = terms[j]
                    terms[j] = temp;
                }
            }
        }
        

        
    }
    class func TermNameToDouble(_ name: String) -> Double{
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
    
    class func PrepareCourseHistoryRequest()  -> URLRequest {
        
        let coursehistory="https://kusis.ku.edu.tr/psc/ps/EMPLOYEE/HRMS/c/SA_LEARNER_SERVICES.SSS_MY_CRSEHIST.GBL?PORTALPARAM_PTCNAV=HC_SSS_MY_CRSEHIST_GBL&EOPP.SCNode=HRMS&EOPP.SCPortal=EMPLOYEE&EOPP.SCName=CO_EMPLOYEE_SELF_SERVICE&EOPP.SCLabel=Self%20Service&EOPP.SCPTfname=CO_EMPLOYEE_SELF_SERVICE&FolderPath=PORTAL_ROOT_OBJECT.CO_EMPLOYEE_SELF_SERVICE.HCCC_ACADEMIC_RECORDS.HC_SSS_MY_CRSEHIST_GBL&IsFolder=false&PortalActualURL=https%3a%2f%2fkusis.ku.edu.tr%2fpsc%2fps%2fEMPLOYEE%2fHRMS%2fc%2fSA_LEARNER_SERVICES.SSS_MY_CRSEHIST.GBL&PortalContentURL=https%3a%2f%2fkusis.ku.edu.tr%2fpsc%2fps%2fEMPLOYEE%2fHRMS%2fc%2fSA_LEARNER_SERVICES.SSS_MY_CRSEHIST.GBL&PortalContentProvider=HRMS&PortalCRefLabel=My%20Course%20History&PortalRegistryName=EMPLOYEE&PortalServletURI=https%3a%2f%2fkusis.ku.edu.tr%2fpsp%2fps%2f&PortalURI=https%3a%2f%2fkusis.ku.edu.tr%2fpsc%2fps%2f&PortalHostNode=HRMS&NoCrumbs=yes&PortalKeyStruct=yes"
        
        
        var newrequest = URLRequest(url: URL(string:coursehistory)!)
        newrequest.httpMethod = "GET"
        return newrequest
        
    }
    
    class func PreparePlannedProgramRequest()  -> URLRequest {
        let program = "https://kusis.ku.edu.tr/psc/ps/EMPLOYEE/HRMS/c/SSR_PROG_ENRL_SS.SSR_APT_SCHD_BLDR.GBL?Page=SSR_APT_SCHD_BLDR&Action=A&EMPLID=0031459&INSTITUTION=KOCUN&SSR_APT_INSTANCE=1&SSR_ITEM_ID=00000004524"
        var newrequest = URLRequest(url: URL(string:program)!)
        newrequest.httpMethod = "GET"
        return newrequest
        
    }

    class func PrepareConfirmedProgramRequest()  -> URLRequest {
        let program = "https://kusis.ku.edu.tr/psc/ps/EMPLOYEE/HRMS/c/SSR_PROG_ENRL_SS.SSR_SS_MY_CLASSES.GBL?Page=SSR_SS_MY_CLASSES&Action=U&ExactKeys=Y&EMPLID=0031459&INSTITUTION=KOCUN&SSR_APT_INSTANCE=1&SSR_ITEM_ID=00000004524&TargetFrameName="
        var newrequest = URLRequest(url: URL(string:program)!)
        newrequest.httpMethod = "GET"
        return newrequest
        
    }
    
    
    class func ReadHtmlData(_ data : Data){
        
               
    }

    class func TermSorter(){
        var newterm = [Courses]()
        var tempdersler = Dersler
        
        for thing in Dersler{
            
            for i in 0 ..< tempdersler.count {
                
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
                newterm.removeAll(keepingCapacity: false)
                
            }
            
            
        }
        
    }
    
    class func dataCheck(_ data : Data)-> Bool {
        
         let html = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
         let doc = HTML(html: html! as String, encoding: .utf8)
           
            if doc?.xpath("/html/head/title")[0].text == "My Course History"{
            return true
            }else{
            return false
            }
       
        
    }
    
    class func dataParsingForProgram(_ data : Data ){
        
        var listOfProgram = [Lecture]()
        
        let html = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        
        let doc = HTML(html: html! as String, encoding: .utf8)
        
        var i: Bool = true
        var s: Int = 0
        var lec: Int = 0
        var classType = ""
        
        while(i) {
            
            i=false;
            
            for node in (doc?.xpath("//a[@id='SSR_APT_CARTWK3_SSR_CLASSNAME_LONG$\(s)']"))! {
                
                if node.text != "" {
                    
                    i=true;
                    classType = node.text!
                    let firstChar = classType.substring(to: classType.characters.index(classType.startIndex, offsetBy: 1))
                  
                    if firstChar.characters.first >= "0" && firstChar.characters.first  <= "9" {
                       classType =  "Lec"
                        for node in (doc?.xpath("//a[@id='SSR_APT_CARTWK2_DESCR50$\(lec)']"))! {
                         
                          if node.text != "" {
                            let name = node.text!
                          
                            var lecture = Lecture()
                            lecture.name = name.substring(to: name.characters.index(name.startIndex, offsetBy: 8))
                            listOfProgram.append(lecture)
                      
                            }
                        }
                        lec+=1;
                        
                    }else if firstChar ==  "P"  {
                       classType =  "PS"
                    }else if firstChar ==  "D" {
                        classType =  "DS"
                    }else if firstChar ==  "L" {
                        classType =  "LAB"
                    }else{
                        
                    }
                }
            }
        
        
            for node in (doc?.xpath("//span[@id='SSR_APT_CARTWK3_SSR_MTG_SCHED_LONG$\(s)']"))! {
               
                if node.text != "" {
                    i=true;
           
                    var classname = node.xpath("/*")[2].content
                   
                    let dateInfo = node.text!
                    var start = 0.0
                    var end = 0.0
                    let doubleDot : Character = ":"
                    let bosluk : Character = " "
                    var days = ""
                    classname = classname?.substring(from: classname!.characters.index(classname!.startIndex, offsetBy: 1))
                    days = dateInfo.substring(to: (dateInfo.characters.index(of: bosluk))!)
                    let index1 = dateInfo.characters.index(of: doubleDot)!
                    
                    let index2 = dateInfo.substring(from: dateInfo.index(after:index1)).characters.index(of: doubleDot)!
                  
                    start = Double( dateInfo.substring(with: dateInfo.index(index1, offsetBy: -2)..<index1) + "." +
                                        dateInfo.substring(with: dateInfo.index(index1,offsetBy: 1)..<dateInfo.index(index1, offsetBy:3)))!
                    
                    let secondPart = dateInfo.substring(from: dateInfo.index(index1,  offsetBy: 1))
                    
                    
                    end = Double( secondPart.substring(with: secondPart.index(index2, offsetBy: -2)..<index2) + "." +
                        secondPart.substring(with: secondPart.index(index2,offsetBy: 1)..<secondPart.index(index1, offsetBy:3)))!
                   
                    
                    
                    if classname!.characters.index(  of: "-" ) != nil
                    {
                    classname = classname?.substring(to: classname!.characters.index(  of: "-" )!)
                    }
                  
                    if classType ==  "Lec"{
                        
                        listOfProgram[lec-1].lecStart = start
                        listOfProgram[lec-1].lecEnd = end
                        listOfProgram[lec-1].location = classname!
                        listOfProgram[lec-1].lecDays = days
                        
                    }else if classType ==  "PS"  {
                        listOfProgram[lec-1].psStart = start
                        listOfProgram[lec-1].psEnd = end
                        listOfProgram[lec-1].psLocation = classname!
                        listOfProgram[lec-1].psDays = days
                        
                    }else if classType ==  "DS" {
                        listOfProgram[lec-1].dsStart = start
                        listOfProgram[lec-1].dsEnd = end
                        listOfProgram[lec-1].dsLocation = classname!
                         listOfProgram[lec-1].dsDays = days
                    
                    }else if classType ==  "LAB" {
                        listOfProgram[lec-1].labStart = start
                        listOfProgram[lec-1].labEnd = end
                        listOfProgram[lec-1].labLocation = classname!
                         listOfProgram[lec-1].labDays = days
                    }else {
                        
                    }
                }
               
            }
                
            s += 1
        }
        
       
            planned = listOfProgram
      
    }
    
    class func dataParsingForConfirmed(_ data : Data ){
        
        var listOfProgram = [Lecture]()
        
        let html = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        let doc = HTML(html: html! as String, encoding: .utf8)
        
        var i: Bool = true
        var s: Int = 0
        var lec: Int = 0
        var classType = ""
      
        
        while(i) {
            
            i=false;
            
            for node in (doc?.xpath("//span[@id='MTG_COMP$\(s)']"))! {
               
                if node.text != "" {
                    
                   
                    i=true;
                    classType = node.text!
                    let firstChar = classType.substring(to: classType.characters.index(classType.startIndex, offsetBy: 1))
                    
                   
                    if classType == "Lecture" {
                        
                        classType =  "Lec"
                        
                   
                        for node in (doc?.xpath("//div[@id='win0divDERIVED_REGFRM1_DESCR20$\(lec)']"))! {
                        
                            
                            if node.text != "" {
                                
                                let name = node.xpath(".//*")[0].xpath(".//*")[1].content!
                            
                                var lecture = Lecture()
                                
                                lecture.name = name.substring(to: name.characters.index(name.startIndex, offsetBy: 8))
                                
                                listOfProgram.append(lecture)
                            }
                            
                        }
                        lec+=1;
                        
                    }else if firstChar ==  "P"  {
                        classType =  "PS"
                    }else if firstChar ==  "D" {
                        classType =  "DS"
                    }else if firstChar ==  "L" {
                        classType =  "LAB"
                    }else{
                        
                    }
                }
            }
            
            
            for node in (doc?.xpath("//span[@id='MTG_SCHED$\(s)']"))! {
   

                if node.text != "" {
                    
                    i=true;
                    
                    let dateInfo = node.text!
              
                    var start = 0.0
                    var end = 0.0
                    let doubleDot : Character = ":"
                    let bosluk : Character = " "
                    var days = ""
                    
                    if dateInfo.characters.count > 4 {
                   
                    days = dateInfo.substring(to: (dateInfo.characters.index(of: bosluk))!)
                    let index1 = dateInfo.characters.index(of: doubleDot)!
                        
                    let index2 = dateInfo.substring(from: dateInfo.index(after:index1)).characters.index(of: doubleDot)!
                    
                    start = Double( dateInfo.substring(with: dateInfo.index(index1, offsetBy: -2)..<index1) + "." +
                        dateInfo.substring(with: dateInfo.index(index1,offsetBy: 1)..<dateInfo.index(index1, offsetBy:3)))!
                    
                    let secondPart = dateInfo.substring(from: dateInfo.index(index1,  offsetBy: 1))
                    
                    
                    end = Double( secondPart.substring(with: secondPart.index(index2, offsetBy: -2)..<index2) + "." +
                        secondPart.substring(with: secondPart.index(index2,offsetBy: 1)..<secondPart.index(index1, offsetBy:3)))!
                    
                    }else {
                    days =  "Fr"
                    start = 18.30
                    end = 18.30
                    }
                    
                        if classType ==  "Lec"{
                            
                            listOfProgram[lec-1].lecStart = start
                            listOfProgram[lec-1].lecEnd = end
                            listOfProgram[lec-1].lecDays = days
                            
                        }else if classType ==  "PS"  {
                            listOfProgram[lec-1].psStart = start
                            listOfProgram[lec-1].psEnd = end
                            listOfProgram[lec-1].psDays = days
                            
                        }else if classType ==  "DS" {
                            listOfProgram[lec-1].dsStart = start
                            listOfProgram[lec-1].dsEnd = end
                            listOfProgram[lec-1].dsDays = days
                            
                        }else if classType ==  "LAB" {
                            listOfProgram[lec-1].labStart = start
                            listOfProgram[lec-1].labEnd = end
                            listOfProgram[lec-1].labDays = days
                        }else {
                            
                        }
                    
                   
                    
                   
                }
                
                
            }
            
            for node in (doc?.xpath("//span[@id='MTG_LOC$\(s)']"))! {
                
                 if node.text != "" {
                    
                    let classname = node.text!
                    
                    if classType ==  "Lec"{
                        
                        listOfProgram[lec-1].location = classname
                      
                        
                    }else if classType ==  "PS"  {
                        
                        listOfProgram[lec-1].psLocation = classname
                        
                    }else if classType ==  "DS" {
                        listOfProgram[lec-1].dsLocation = classname
                        
                        
                    }else if classType ==  "LAB" {
                        listOfProgram[lec-1].labLocation = classname
                        
                    }else {
                        
                    }
                
                    
                 }
                
                
            }

            
            s += 1
        }
        
            confirmed = listOfProgram
        
    }
    

    class func printPlanned(){
        
        for thing in planned {
            print(thing.name)
        }
    }
    
    class func dataParsing(_ data : Data){
        
        let html = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        
        let doc = HTML(html: html! as String, encoding: .utf8)
        
        var i:Bool = true
        var s:Int = 0
        var derss=Courses()
        Dersler.removeAll(keepingCapacity: false)
        terms.removeAll(keepingCapacity: false)
        
        while(i) {
            
            
            for node in (doc?.xpath("//span[@id='CRSE_NAME$\(s)']"))! {
                if node.text != "" {
                    
                    derss.name=node.text!
                    
                    
                    
                }
                
            }
            
            for node in (doc?.xpath("//span[@id='CRSE_TERM$\(s)']"))! {
                if node.text != "" {
                    derss.term=node.text!
                    
                }
                
            }
            
            for node in (doc?.xpath("//span[@id='CRSE_UNITS$\(s)']"))! {
                if node.text != "" {
                    derss.units = (node.text! as NSString).doubleValue
                    
                    
                }
                
                
            }
            
            for node in (doc?.xpath("//span[@id='CRSE_GRADE$\(s)']"))! {
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
            
            s += 1
    }
    }
    
    class func AssignPoint(_ index: Int , grade : String ){
        
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
    
    
    class func CalculateGpa(_ courses: [Courses]){
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
            

            let dict:[String:Any] = try JSONSerialization.jsonObject(with: storage.data(using: String.Encoding.utf8)!, options: []) as! [String:Any]

            
            for coursedict in  dict.values {
                
                var tempterm = [Courses]()
    
                for case let course as [String:Any] in (coursedict as! [String:Any]).values {
                    var newcourse = Courses()
                    newcourse.name = course["name"] as! String
                    newcourse.grade = course["grade"] as! String
                    newcourse.term =  course["term"] as! String
                    newcourse.point =  Double(course["point"] as! String)!
                    newcourse.units = Double(course["units"] as! String)!
                    newcourse.valid = Int( course["valid"] as! String)!
                    newcourse.wunit = Double(course["wunit"] as! String)!
                    newcourse.indexInDersler = Int( course["indexInDersler"] as! String)!
                    tempterm.append(newcourse);
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
    
    class func CalculateSpa(_ courses: [Courses]){
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
        
        for i in 0 ..< Dersler.count {
            
            for j in 0 ..< Dersler.count {
                
                let namecl = Dersler[i].name as NSString
                let namel = Dersler[j].name as NSString
                
                
                if namecl.substring(to: 4) == namel.substring(to: 4){
                    switch namecl.substring(to: 4) {
                    case "ASIU","SOSC","ETHR","HUMS":
                        if Dersler[i].point > Dersler[j].point{
                            Dersler[j].units = 0.0
                            
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
                if elc.substring(to: 3) == "ELC" {
                    Dersler[j].units=0.0
                    
                }
                
                
                
            }
            
            
        }
    }
    
   class func ToJson() -> String{
        
        var Json = "{"
        
        for i in 0 ..< terms.count {
            
            Json = Json + "\"" + String(i) + "\":" + "{"
            
            
            for  j in 0 ..< terms[i].count {
                
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
            
            Json.remove(at: Json.characters.index(before: Json.endIndex))
            
            Json = Json + "},"
            
        }
        
        Json.remove(at: Json.characters.index(before: Json.endIndex))
        
        Json = Json + "}"
    
        return Json
        
    }
    
    class func ToJson(_ Program: [Lecture]) -> String {
        
        var Json = "{"
            
            for  i in 0 ..< Program.count {
                
                Json = Json + "\"" + String(i) + "\": {"
                
                Json = Json + "\"name\":\"" + Program[i].name + "\","
                
                Json = Json + "\"location\":\"" + Program[i].location + "\","
                
                Json = Json + "\"lecStart\":\"" + String(Program[i].lecStart) + "\","
                
                Json = Json + "\"lecEnd\":\"" + String(Program[i].lecEnd) + "\","
                
                Json = Json + "\"lecDays\":\"" + Program[i].lecDays + "\","
                
                Json = Json + "\"psDays\":\"" + Program[i].psDays + "\","
                
                Json = Json + "\"dsDays\":\"" + Program[i].dsDays + "\","
                
                Json = Json + "\"psStart\":\"" + String(Program[i].psStart) + "\","
                
                Json = Json + "\"psEnd\":\"" + String(Program[i].psEnd) + "\","
                
                Json = Json + "\"psLocation\":\"" + Program[i].psLocation + "\","
                
                Json = Json + "\"dsStart\":\"" + String(Program[i].dsStart) + "\","
                
                Json = Json + "\"dsEnd\":\"" + String(Program[i].dsEnd) + "\","
                
                Json = Json + "\"dsLocation\":\"" + Program[i].dsLocation + "\","
               
                Json = Json + "\"labStart\":\"" + String(Program[i].labStart) + "\","
                
                Json = Json + "\"labEnd\":\"" + String(Program[i].labEnd) + "\","
                
                Json = Json + "\"labLocation\":\"" + Program[i].labLocation + "\","
                
                Json = Json + "\"indexInLectures\":\"" + String(Program[i].indexInLectures) + "\"},"
                
            }
    
        
        Json.remove(at: Json.characters.index(before: Json.endIndex))
        
        Json = Json + "}"
        
        return Json
        
    }
    
    
    
}
