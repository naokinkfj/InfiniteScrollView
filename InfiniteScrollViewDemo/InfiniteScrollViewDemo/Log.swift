//
//  Log.swift
//  InfiniteScrollViewDemo
//
//  Created by Naoki Fujii on 12/12/15.
//  Copyright © 2015 nfujii. All rights reserved.
//

import UIKit

public class Log: NSObject {
    enum Level: Int {
        case Debug = 1
        case Error = 10
    }
    
    static var level = Level.Error
    
    public class func d(msg: String, lineNumber: Int = __LINE__, funcName: String = __FUNCTION__) {
        if Level.Debug.rawValue <= level.rawValue {
            Log._print(msg, lineNumber: lineNumber, funcName: funcName)
        }
    }
    
    private class func _print(msg: String, lineNumber: Int, funcName: String) {
        print("[\(funcName)(\(lineNumber))] \(msg)")
    }
}
