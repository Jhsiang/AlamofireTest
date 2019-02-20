//
//  ViewController.swift
//  AlamofireTest
//
//  Created by Jim Chuang on 2018/11/28.
//  Copyright © 2018 nhr. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController,FormDataDelegate {
    func postMethodIsSuccess(isSucces: Bool, errorStr: String) {
        if isSucces == false{
            print("error = ",errorStr)
        }
    }

    func postMethodResponseJson(json: JSON) {
        print("response = ",json)
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        FormData.share.delegate = self

    }

    func postDataExam(){
        let urlStr = "http://httpbin.org/post"
        let myDic = postQueryForm(IMEI: "123456789012345")

        FormData.share.postFormData(urlStr: urlStr, dic: myDic)
        print("1")
        postFormData2(urlStr: urlStr, dic: myDic) { (isSuccess) in
            if isSuccess{
                print("yeah success")
            }else{
                print("fail fail fail important so say 3 times")
            }
            print("3")
        }
        print("2")
    }

    func getGoogleRoute(){
        FormData.share.getGoogleRoute { (isSuccess) in
            if isSuccess{
                print("yeah ok")
            }else{
                print("fail la ")
            }
        }
    }

    func postFormData2(urlStr:String,dic:[String:Any], completion: @escaping ((Bool) -> Void)){
        if let myURL = URL(string: urlStr){

            Alamofire.upload(multipartFormData: { (myMFD) in
                for (key,value) in dic{
                    if let myData = "\(JSON(value))".data(using: .utf8){
                        myMFD.append(myData, withName: key)
                    }
                }
            }, to: myURL) { (myResult) in
                switch myResult{
                case .success(request: let myUpload, streamingFromDisk: _, streamFileURL: _):
                    myUpload.responseJSON(completionHandler: { (response2) in
                        if response2.result.isSuccess{
                            completion(true)
                            print("res = \(JSON(response2.result.value))")
                        }else{
                            completion(false)
                            print("oh no")
                        }
                    })
                case .failure:
                    completion(false)
                    break
                }
            }
        }else{
            completion(false)
        }
    }

    func postFormData(urlStr:String,dic:[String:Any]) -> Bool{
        if let myURL = URL(string: urlStr){

            Alamofire.upload(multipartFormData: { (myMFD) in
                for (key,value) in dic{
                    if let myData = "\(JSON(value))".data(using: .utf8){
                        myMFD.append(myData, withName: key)
                    }
                }
            }, to: myURL) { (myResult) in
                switch myResult{
                case .success(request: let myUpload, streamingFromDisk: _, streamFileURL: _):
                    myUpload.responseJSON(completionHandler: { (response2) in
                        if response2.result.isSuccess{
                            print("res = \(JSON(response2.result.value))")
                        }else{
                            print("oh no")
                            print(response2)
                        }
                    })
                case .failure:
                    break
                }
            }

            return true
        }else{
            return false
        }
    }

    func postQueryForm(IMEI:String) -> [String:Any]{
        var resultDic = Dictionary<String,Any>()

        resultDic["c"] = 123
        var dataDic = Dictionary<String,Any>()
        dataDic["num1"] = IMEI
        dataDic["num2"] = 23
        resultDic["data"] = dataDic


        return resultDic
    }

/*
 http://httpbin.org/ip Returns Origin IP.
 http://httpbin.org/user-agent Returns user-agent.
 http://httpbin.org/headers Returns header dict.
 http://httpbin.org/get Returns GET data.
 http://httpbin.org/post Returns POST data.
 http://httpbin.org/put Returns PUT data.
 http://httpbin.org/delete Returns DELETE data
 http://httpbin.org/gzip Returns gzip-encoded data.
 http://httpbin.org/status/:code Returns given HTTP Status code.
 http://httpbin.org/response-headers?key=val Returns given response headers.
 http://httpbin.org/redirect/:n 302 Redirects n times.
 http://httpbin.org/relative-redirect/:n 302 Relative redirects n times.
 http://httpbin.org/cookies Returns cookie data.
 http://httpbin.org/cookies/set/:name/:value Sets a simple cookie.
 http://httpbin.org/basic-auth/:user/:passwd Challenges HTTPBasic Auth.
 http://httpbin.org/hidden-basic-auth/:user/:passwd 404'd BasicAuth.
 http://httpbin.org/digest-auth/:qop/:user/:passwd Challenges HTTP Digest Auth.
 http://httpbin.org/stream/:n Streams n–100 lines.
 http://httpbin.org/delay/:n Delays responding for n–10 seconds.
     */
}


