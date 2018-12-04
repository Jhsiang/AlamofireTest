//
//  httpViewController.swift
//  AlamofireTest
//
//  Created by Jim Chuang on 2018/12/3.
//  Copyright © 2018 nhr. All rights reserved.
//

import UIKit
import SwiftyJSON

class httpViewController: UIViewController,httpPostFormDataDelegate {
    func httpPostSuccess(isSuccess: Bool) {
        print("post success = ",isSuccess)
    }

    func httpPostResponse(json: JSON) {
        print("post response = ",json)
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        let myDic = postForm(data1: "333", data2: "444", data3: 555)
        let urlStr = "http://httpbin.org/post"
        httpPostFormData.share.delegate = self
        httpPostFormData.share.postData(urlStr: urlStr, dic: myDic)

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


}


