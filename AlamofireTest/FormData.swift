//
//  FormData.swift
//  AlamofireTest
//
//  Created by Jim Chuang on 2018/12/4.
//  Copyright © 2018 nhr. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol FormDataDelegate {
    func postMethodIsSuccess(isSucces:Bool,errorStr:String)
    func postMethodResponseJson(json:JSON)
}

class FormData{
    static let share = FormData()
    var delegate:FormDataDelegate?

    func postFormData(urlStr:String,dic:Dictionary<String,Any>){
        if let url = URL(string: urlStr){
            Alamofire.upload(multipartFormData: { (MFD) in
                for (key,value) in dic{
                    MFD.append("\(JSON(value))".data(using: String.Encoding.utf8)!, withName: key)
                }
            }, to: url) { (sessionResult) in
                switch sessionResult{
                case .success(request: let myUpLoad,_,_):
                    myUpLoad.responseJSON(completionHandler: { (responseJson) in
                        if responseJson.result.isSuccess{
                            self.delegate?.postMethodIsSuccess(isSucces: true, errorStr: "")
                            self.delegate?.postMethodResponseJson(json: JSON(responseJson.result.value))
                        }else{
                            self.delegate?.postMethodIsSuccess(isSucces: false, errorStr: "response Json fail")
                        }
                    })
                    break
                case .failure:
                    self.delegate?.postMethodIsSuccess(isSucces: false, errorStr: "session result fail")
                    break
                }
            }
        }else{
            self.delegate?.postMethodIsSuccess(isSucces: false, errorStr: "url fail")
        }
    }

    func getGoogleRoute(completion: @escaping ((Bool) -> Void)){
        let originLat = 25.048292
        let originLng = 121.518788
        let destinationLat = 25.058786
        let destinationLng = 121.562291
        if let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?"
            + "origin=\(originLat),\(originLng)"
            + "&destination=\(destinationLat),\(destinationLng)"
            + "&sensor=false"
            + "&units=metric"
            + "&mode=driving"
            + "&key=AIzaSyAXkbnjM_z-jY48BoOne_Z43jug7uwIVYE"){
            Alamofire.request(url).responseJSON { (dataResponse) in
                if dataResponse.result.isSuccess{
                    completion(true)
                    let myJson = JSON(dataResponse.result.value)
                    print("my Json = ",myJson)
                }else{
                    completion(false)
                }
            }
        }else{
            completion(false)
        }
    }

}
