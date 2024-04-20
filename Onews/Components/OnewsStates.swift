//
//  OnewsStates.swift
//  Onews
//
//  Created by Sizwe Khathi on 2024/04/02.
//

import Foundation

public class OnewsState {
    
    var currentState: OnewsStates = .signedOut
    
    public static let sharedInstance = OnewsState()
    
    public init() {}
}

enum OnewsStates {
    case signedInWithFaceId
    case verifyFaceIdFailed
    case signingInWithFaceId
    case signedInNoFaceId
    case faceIDRequired
    case signedOut
}
