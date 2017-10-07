//
//  ViewController.swift
//  SampleUrlCallWithCompleatoin
//
//  Created by pothuri raju on 06/10/17.
//  Copyright © 2017 pothuri raju. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var RT:String = ""
    var latitude = [String]()
    var longitude  = [String]()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        getDataFromJson(url: "https://uatapp.orient-bank.com/wb/int/intf.jsp", parameter: "dat={\"SC\":\"ATMBRANCHLocator\",\"VER\":\"20171005\",\"Type\":\"ATM\",\"Keyword\":\"KAM\",\"SRC\":\"Android\",\"IMEI\":\"123123123234\",\"SID\":\"234234234234\"}", completion: { flatlong in
            
            
            print("----------Restult-----------")
            
            print(flatlong)
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func getDataFromJson(url: String, parameter: String, completion: @escaping (_ success: [String : String]) -> Void) {
        
         var latlong = [String: String]()
        //@escaping...If a closure is passed as an argument to a function and it is invoked after the function returns, the closure is @escaping.
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        let postString = parameter
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { Data, response, error in
            
//            guard let data = Data, error == nil else {  // check for fundamental networking error
//                
//                print("error=\(error)")
//                return
//            }
//            
//            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {  // check for http errors
//                
//                print("statusCode should be 200, but is \(httpStatus.statusCode)")
//                print(response!)
//                return
//                
//            }
//            
//            let responseString  = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : AnyObject]
//            completion(responseString)
            
            
            if error != nil
            {
                print("Raghu error=\(error!)")
                
                let alert = UIAlertController(title: "Alert", message: "Oops. Network connection error!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            // You can print out response object
            print("response = \(response!)")
            
            do
            {
                let json = try JSONSerialization.jsonObject(with: Data!, options: .mutableContainers) as? NSDictionary
                if let parseJSON = json {
                    print(parseJSON)
                    
                    self.RT =  (parseJSON["RT"])! as! String
                    
                    if self.RT.contains("S")
                    {
                        
                        if let DAT = parseJSON["Locations"] as? [[String: AnyObject]] {
                            for DAT in DAT {
                                if let Lattitude = DAT["Lattitude"] as? String {
                                    
                                    
                                    self.latitude.append(String(Lattitude.characters.filter { !" \n\t\r".characters.contains($0) }))
                                    
                                }
                                
                                if let Longitude = DAT["Longitude"] as? String {
                                    self.longitude.append(String(Longitude.characters.filter { !" \n\t\r".characters.contains($0) }))
                                    
                                }
                                
                                
                                
                                
                            }
                        }
                        
                        
                        
                        print("------------------Latitude----------------")
                        print(self.latitude)
                        print("------------------Longitude----------------")
                        print(self.longitude)
                        
                        for i in 0..<min(self.latitude.count, self.longitude.count) {
                            latlong[self.latitude[i]] = self.longitude[i]
                        }
                        
                        print("------------------LatLong----------------")
                        
                        print(latlong)
                        
                        
                        
                        
                    }
                    else
                    {
                        print("Unable to Read Lat Long")
                        
                    }
                    
                    
                    completion(latlong)
                    
                }
            } catch {
                print("----raghu-------")
                print(error)
            }
            

            
        }
        task.resume()
    }


}

