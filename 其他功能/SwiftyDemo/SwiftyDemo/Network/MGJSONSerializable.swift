//
//  MGJSONSerializable.swift
//  SwiftyDemo
//
//  Created by newunion on 2019/4/8.
//  Copyright © 2019年 firestonetmt. All rights reserved.
//

import UIKit

protocol MGJSONRepresentable {
    var JSONRepresentation: AnyObject { get }
}

protocol MGJSONSerializable: MGJSONRepresentable {
}

extension MGJSONSerializable {
    var JSONRepresentation: AnyObject {
        var representation = [String: AnyObject]()
        for case let (label?, value) in Mirror(reflecting: self).children {
            switch value {
            case let value as MGJSONRepresentable:
                representation[label] = value.JSONRepresentation

            case let value as NSObject:
                representation[label] = value

            default:
                // Ignore any unserializable properties
                break
            }
        }

        return representation as AnyObject
    }
}

extension MGJSONSerializable {
    func toJSON() -> String? {
        let representation = JSONRepresentation

        guard JSONSerialization.isValidJSONObject(representation) else {
            return nil
        }

        do {
            let data = try JSONSerialization.data(withJSONObject: representation, options: [])
            return String(data: data, encoding: String.Encoding.utf8)
        } catch {
            return nil
        }
    }
}
/// for example
struct DD: MGJSONSerializable,Codable {
    var privacy_deactivation:CC
}

struct CC: MGJSONSerializable,Codable {
    var reason_id: String
    var reason_text: String
}

func ccdd() {
    let cc = CC(reason_id: "6", reason_text: "笨蛋")
    let dd = DD(privacy_deactivation: cc)
    if let json1 = dd.toJSON() {
        print(json1)
    }
}
