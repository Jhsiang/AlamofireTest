//
//  httpViewController.swift
//  AlamofireTest
//
//  Created by Jim Chuang on 2018/12/3.
//  Copyright © 2018 nhr. All rights reserved.
//

import UIKit
import SwiftyJSON

class httpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let myDic = postForm(data1: "333", data2: "444", data3: 555)
        postData(urlStr: "http://httpbin.org/post", dic: myDic)

    }

    func postData(urlStr:String, dic:[String:Any]){
        requestWithFormData(urlString: urlStr, parameters: dic) { (data) in
            let myJson = JSON(data)
            print("my Json = ",myJson)
        }
    }
    

    func postForm(data1:String,data2:String,data3:Int) -> [String:Any]{
        var resultDic = Dictionary<String,Any>()

        resultDic["key"] = "111"
        resultDic["cmd"] = "222" // Device Mode = "new" or "reply" or "query"

        let dataDic = [
            "data1":data1,
            "data2":data2,
            "data3":data3
            ] as [String : Any]

        resultDic["data"] = dataDic

        return resultDic
    }

    //MARK: - Http form-data post method
    //Ref: https://medium.com/@jerrywang0420/urlsession-%E6%95%99%E5%AD%B8-swift-3-ios-part-3-34699564fb12
    private func requestWithFormData(urlString: String, parameters: [String: Any], /*dataPath: [String: Data],*/ completion: @escaping (Data) -> Void){
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = "Boundary+\(arc4random())\(arc4random())"
        var body = Data()

        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        for (key, value) in parameters {
            body.appendString(string: "--\(boundary)\r\n")
            body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString(string: "\(JSON(value))\r\n")
        }
        /*
         for (key, value) in dataPath {
         body.appendString(string: "--\(boundary)\r\n")
         body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(arc4random())\"\r\n") //此處放入file name，以隨機數代替，可自行放入
         body.appendString(string: "Content-Type: image/png\r\n\r\n") //image/png 可改為其他檔案類型 ex:jpeg
         body.append(value)
         body.appendString(string: "\r\n")
         }
         */

        body.appendString(string: "--\(boundary)--\r\n")
        request.httpBody = body
        fetchedDataByDataTask(from: request, completion: completion)
    }

    private func fetchedDataByDataTask(from request: URLRequest, completion: @escaping (Data) -> Void){

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in

            if error != nil{
                print("error here")
                print(error as Any)
            }else{
                guard let data = data else{return}
                completion(data)
            }
        }
        task.resume()
    }

}

extension Data{

    mutating func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
