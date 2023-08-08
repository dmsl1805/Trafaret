import Foundation

public enum Device: String {
    case iPhoneX
    case iPhoneXS
    case iPhoneXSMax
    case iPhoneXR
    case iPhone11
    case iPhone11Pro
    case iPhone11ProMax
    case iPhone12Mini
    case iPhone12
    case iPhone12Pro
    case iPhone12ProMax
    case iPhone13Mini
    case iPhone13
    case iPhone13Pro
    case iPhone13ProMax
    case iPhone14
    case iPhone14Pro
    case iPhone14ProMax
    case iPhoneSE3rdGen
    case iPadPro4thGen
    case iPadPro2ndGenMini

    public var name: String {
        switch self {
        case .iPhoneX: return "iPhone X"
        case .iPhoneXS: return "iPhone XS"
        case .iPhoneXSMax: return "iPhone XS Max"
        case .iPhoneXR: return "iPhone XR"
        case .iPhone11: return "iPhone 11"
        case .iPhone11Pro: return "iPhone 11 Pro"
        case .iPhone11ProMax: return "iPhone 11 Pro Max"
        case .iPhone12Mini: return "iPhone 12 Mini"
        case .iPhone12: return "iPhone 12"
        case .iPhone12Pro: return "iPhone 12 Pro"
        case .iPhone12ProMax: return "iPhone 12 Pro Max"
        case .iPhone13Mini: return "iPhone 13 Mini"
        case .iPhone13: return "iPhone 13"
        case .iPhone13Pro: return "iPhone 13 Pro"
        case .iPhone13ProMax: return "iPhone 13 Pro Max"
        case .iPhone14: return "iPhone 14"
        case .iPhone14Pro: return "iPhone 14 Pro"
        case .iPhone14ProMax: return "iPhone 14 Pro Max"
        case .iPhoneSE3rdGen: return "iPhone SE (3rd Generation)"
        case .iPadPro4thGen: return "iPad Pro (4th Generation)"
        case .iPadPro2ndGenMini: return "iPad Pro (2nd Generation Mini)"
        }
    }

    public var size: CGSize {
        switch self {
        case .iPhoneX, .iPhone11Pro, .iPhoneXS, .iPhone12Mini, .iPhone13Mini:
            return CGSize(width: 375, height: 812)
            
        case .iPhoneXSMax, .iPhoneXR, .iPhone11, .iPhone11ProMax:
            return CGSize(width: 414, height: 896)
            
        case .iPhoneSE3rdGen:
            return CGSize(width: 375, height: 667)
            
        case .iPhone12, .iPhone12Pro, .iPhone13, .iPhone13Pro, .iPhone14:
            return CGSize(width: 390, height: 844)

        case .iPhone12ProMax, .iPhone13ProMax:
            return CGSize(width: 428, height: 926)
            
        case .iPadPro4thGen:
            return CGSize(width: 1024, height: 1366)
            
        case .iPadPro2ndGenMini:
            return CGSize(width: 834, height: 1112)
            
        case .iPhone14Pro:
            return CGSize(width: 393, height: 852)
            
        case .iPhone14ProMax:
            return CGSize(width: 430, height: 932)
        }
    }
}
