//
//  HubProperty.swift
//  BoostBLEKit
//
//  Created by Shinichiro Oba on 30/06/2019.
//  Copyright © 2019 bricklife.com. All rights reserved.
//

import Foundation

public enum HubProperty: UInt8 {
    
    case advertisingName    = 0x01
    case button             = 0x02
    case firmwareVersion    = 0x03
    case batteryVoltage     = 0x06
    
    public enum Value {
        
        case string(String)
        case integer(Int)
        
        public var stringValue: String {
            switch self {
            case .string(let string):
                return string
            case .integer(let integer):
                return integer.description
            }
        }
        
        public var intValue: Int? {
            switch self {
            case .string:
                return nil
            case .integer(let integer):
                return integer
            }
        }
    }
    
    public func value(from data: Data) -> Value? {
        switch self {
        case .advertisingName:
            guard let string = String(data: data, encoding: .utf8) else { return nil }
            return .string(string)
            
        case .firmwareVersion:
            guard data.count == 4 else { return nil }
            let version = data.withUnsafeBytes { $0.load(as: Int32.self).littleEndian }
            let majorVersion = version >> 28 & 0x7
            let minorVersion = version >> 24 & 0xf
            let bugFixingNumber = version >> 16 & 0xff
            let buildNumber = version & 0xffff
            return .string(String(format: "%x.%x.%02x.%04x", majorVersion, minorVersion, bugFixingNumber, buildNumber))
            
        case .button, .batteryVoltage:
            guard data.count > 0 else { return nil }
            return .integer(Int(data[0]))
        }
    }
}

extension HubProperty: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .advertisingName:
            return "Advertising Name"
        case .button:
            return "Button"
        case .firmwareVersion:
            return "Firmware Version"
        case .batteryVoltage:
            return "Battery Voltage [%]"
        }
    }
}

extension HubProperty.Value: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .string(let string):
            return string
        case .integer(let integer):
            return integer.description
        }
    }
}

