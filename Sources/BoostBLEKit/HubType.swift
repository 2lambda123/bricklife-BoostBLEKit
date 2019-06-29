//
//  HubType.swift
//  BoostBLEKit
//
//  Created by Shinichiro Oba on 20/07/2018.
//  Copyright © 2018 bricklife.com. All rights reserved.
//

import Foundation

public enum HubType {
    
    case boost
    case boostV1
    case poweredUp
    case duploTrain
}

public extension HubType {
    
    init?(manufacturerData: Data) {
        guard manufacturerData.count > 3 else { return nil }
        
        switch manufacturerData[3] {
        case 0x40:
            if manufacturerData[6] & 0x02 > 0 {
                self = .boost
            } else {
                self = .boostV1
            }
        case 0x41:
            self = .poweredUp
        case 0x20:
            self = .duploTrain
        default:
            return nil
        }
    }
}

extension HubType: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .boost:
            return "Boost Move Hub"
        case .boostV1:
            return "Boost Move Hub (F/W 1.x)"
        case .poweredUp:
            return "Powered Up Smart Hub"
        case .duploTrain:
            return "Duplo Train Base"
        }
    }
}

