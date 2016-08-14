//
//  ViewController.swift
//  simpleAccelerationApp01
//
//  Created by SoHirai on 2016/08/02.
//  Copyright © 2016年 SoHirai. All rights reserved.
//

//
//  ViewController.swift
//  CoreMotion001
//

import UIKit
import CoreMotion
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var myMotionManager: CMMotionManager!
    
    var myLocationManager:CLLocationManager!
    
    // 緯度表示用のラベル.
    var myLatitudeLabel:UILabel!
    
    // 経度表示用のラベル.
    var myLongitudeLabel:UILabel!
    
    var params_list: [String: AnyObject] = [
        "operation": "create",
        "tableName": "accerelation_sample",
        "data": []
    ]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Labelを作成.
        let myXLabel: UILabel = UILabel(frame: CGRectMake(0,0,200,50))
        myXLabel.backgroundColor = UIColor.blueColor()
        myXLabel.layer.masksToBounds = true
        myXLabel.layer.cornerRadius = 10.0
        myXLabel.textColor = UIColor.whiteColor()
        myXLabel.shadowColor = UIColor.grayColor()
        myXLabel.textAlignment = NSTextAlignment.Center
        myXLabel.layer.position = CGPoint(x: self.view.bounds.width/2,y: 200)
        
        let myYLabel: UILabel = UILabel(frame: CGRectMake(0,0,200,50))
        myYLabel.backgroundColor = UIColor.orangeColor()
        myYLabel.layer.masksToBounds = true
        myYLabel.layer.cornerRadius = 10.0
        myYLabel.textColor = UIColor.whiteColor()
        myYLabel.shadowColor = UIColor.grayColor()
        myYLabel.textAlignment = NSTextAlignment.Center
        myYLabel.layer.position = CGPoint(x: self.view.bounds.width/2,y: 280)
        
        let myZLabel: UILabel = UILabel(frame: CGRectMake(0,0,200,50))
        myZLabel.backgroundColor = UIColor.redColor()
        myZLabel.layer.masksToBounds = true
        myZLabel.layer.cornerRadius = 10.0
        myZLabel.textColor = UIColor.whiteColor()
        myZLabel.shadowColor = UIColor.grayColor()
        myZLabel.textAlignment = NSTextAlignment.Center
        myZLabel.layer.position = CGPoint(x: self.view.bounds.width/2,y: 360)

        // Viewの背景色を青にする.
//        self.view.backgroundColor = UIColor.cyanColor()
        
        // ViewにLabelを追加.
        self.view.addSubview(myXLabel)
        self.view.addSubview(myYLabel)
        self.view.addSubview(myZLabel)
        
        // MotionManagerを生成.
        myMotionManager = CMMotionManager()
        
        // 更新周期を設定.
        myMotionManager.accelerometerUpdateInterval = 2
        
        // 加速度の取得を開始.
        myMotionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: {(accelerometerData:CMAccelerometerData?, error:NSError?) -> Void in
            // 現在時刻の取得
            let now = NSDate()
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let date_string = formatter.stringFromDate(now)
            
            let x_data: Double = accelerometerData!.acceleration.x
            let y_data: Double = accelerometerData!.acceleration.y
            let z_data: Double = accelerometerData!.acceleration.z
            
            self.postPosition(date_string ,x_data: x_data, y_data: y_data, z_data: z_data)
            
            // 表示
            myXLabel.text = "x=\(x_data)"
            myYLabel.text = "y=\(y_data)"
            myZLabel.text = "z=\(z_data)"
            

        })
        
    }
    
    // 引数で加速度情報が渡される
    // 加速度情報とタイムスタンプを渡すと、それをDynamoDBに格納するAPI
    func postPosition(datetime: String, x_data: Double, y_data: Double, z_data: Double) {
        let url = NSURL(string: "https://wv2wzxmz36.execute-api.ap-northeast-1.amazonaws.com/sample/access-accerelation")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        
        // JSON 化したいデータを Dictionary で作成
        let dict: [String: AnyObject] = [
            "operation": "create",
            "tableName": "accerelation_sample",
            "data": [
                [
                    "datetime": "\(datetime)",
                    "x": "\(x_data)",
                    "y": "\(y_data)",
                    "z": "\(z_data)",
                ]
            ]
        ]
        
        var json: String = ""
        do {
            // Dict -> JSON
            let jsonData = try NSJSONSerialization.dataWithJSONObject(dict, options: []) //(*)options??
            
            json = NSString(data: jsonData, encoding: NSUTF8StringEncoding)! as String
        } catch {
            print("Error!: \(error)")
        }
        
        let strData = json.dataUsingEncoding(NSUTF8StringEncoding)
        request.HTTPBody = strData
        
        do {
            // API POST
            let data = try NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
            
            json = NSString(data: data, encoding: NSUTF8StringEncoding)! as String
            
            // JSON -> Dict
            let jsonDict = try NSJSONSerialization.JSONObjectWithData(data, options: []) //(*)options??
            print(jsonDict)
        } catch {
            print("error!: \(error)")
        }
        
    }
    
}