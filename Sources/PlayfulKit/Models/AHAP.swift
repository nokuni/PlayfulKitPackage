//
//  AHAP.swift
//  
//
//  Created by Maertens Yann-Christophe on 22/04/23.
//

import Foundation

// MARK: - AHAP
// AHAP is a JSON-like file format that specifies a haptic pattern through key-value pairs, analogous to a dictionary literal, except in a text file. https://developer.apple.com/documentation/corehaptics/representing_haptic_patterns_in_ahap_files

public struct AHAP: Codable {
    let version: Double?
    let metadata: AHAPMetadata?
    let pattern: [AHAPPattern]
    
    enum CodingKeys: String, CodingKey {
        case version = "Version"
        case metadata = "Metadata"
        case pattern = "Pattern"
    }
}

struct AHAPMetadata: Codable {
    let project: String
    let created: String
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case project = "Project"
        case created = "Created"
        case description = "Description"
    }
}

struct AHAPPattern: Codable {
    let event: AHAPEvent
    let parameterCurve: AHAPParameterCurve
    
    enum CodingKeys: String, CodingKey {
        case event = "Event"
        case parameterCurve = "ParameterCurve"
    }
}

struct AHAPEvent: Codable {
    let time: Double
    let eventType: EventType
    let eventDuration: Double?
    let eventParamater: [AHAPEventParameter]
    
    enum EventType: String, Codable {
        case hapticTransient = "HapticTransient"
        case hapticContinuous = "HapticContinuous"
    }
    
    enum CodingKeys: String, CodingKey {
        case time = "Time"
        case eventType = "EventType"
        case eventDuration = "EventDuration"
        case eventParamater = "EventParamater"
    }
}

struct AHAPEventParameter: Codable {
    let parameterID: ParamaterID
    let parameterValue: Double
    
    enum ParamaterID: String, Codable {
        case hapticIntensity = "HapticIntensity"
        case hapticSharpness = "HapticSharpness"
    }
    
    enum CodingKeys: String, CodingKey {
        case parameterID = "ParameterID"
        case parameterValue = "ParameterValue"
    }
}

struct AHAPParameterCurve: Codable {
    let parameterID: ParamaterID
    let time: Double
    let parameterCurveControlPoints: [AHAPParameterCurveControlPoint]
    
    enum ParamaterID: String, Codable {
        case hapticIntensityControl = "HapticIntensityControl"
        case hapticSharpnessControl = "HapticSharpnessControl"
    }
    
    enum CodingKeys: String, CodingKey {
        case parameterID = "ParameterID"
        case time = "Time"
        case parameterCurveControlPoints = "ParameterCurveControlPoints"
    }
}

struct AHAPParameterCurveControlPoint: Codable {
    let time: Double
    let parameterValue: Double
    
    enum CodingKeys: String, CodingKey {
        case time = "Time"
        case parameterValue = "ParameterValue"
    }
}
