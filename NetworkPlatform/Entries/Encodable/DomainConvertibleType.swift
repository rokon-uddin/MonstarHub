//
//  DomainConvertibleType.swift
//  MonstarHub
//
//  Created by Rokon on 5/4/20.
//  Copyright © 2020 Monstarlab. All rights reserved.
//

import Foundation

protocol DomainConvertibleType {
    
    associatedtype DomainType
    var asDomain: DomainType { get }
}

protocol Identifiable {
    var uid: String { get }
}

typealias DomainConvertibleCoding = DomainConvertibleType

protocol Encodable {
    associatedtype Encoder: DomainConvertibleCoding
    var encoder: Encoder { get }
}
