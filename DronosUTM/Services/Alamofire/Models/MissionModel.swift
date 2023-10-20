import Foundation

struct MissionModel: Codable {
    struct Record: Codable {
        let _id: String?
        let assetIds: [String]?
        let workspaceId: String?
        let missionId: String?
        let applicant: Applicant?
        let name: String?
        let objective: Objective?
        let status: String?
        let permitInfo: PermitInfo?
        let location: String?
        let area: Area?
        let schedules: [Schedule]?
        let attachmentIds: [String]?
        let createdBy: String?
        let updatedBy: String?
        let createdAt: String?
        let updatedAt: String?
        let recordType: String?
        let flightIds: [String]?
        
        // Define coding keys for nested properties
        enum CodingKeys: String, CodingKey {
            case _id
            case assetIds
            case workspaceId
            case missionId
            case applicant
            case name
            case objective
            case status
            case permitInfo
            case location
            case area
            case schedules
            case attachmentIds
            case createdBy
            case updatedBy
            case createdAt
            case updatedAt
            case recordType
            case flightIds
        }
    }
    
    struct Applicant: Codable {
        let _id: String?
        let profilePicture: String?
        let coverPhoto: String?
        let firstName: String?
        let lastName: String?
        let username: String?
        let email: String?
        let socialLinks: [String]?
        let pilotInformation: [String]?
        let website: String?
        let createdAt: String?
        let updatedAt: String?
        let verified: Bool?
        let country: String?
        let city: String?
        let phoneNumber: String?
        let nricAttach: String?
        let userCertificate: [String]?
        let accountLinks: [String]?
        let id: String?
        
        // Define coding keys for nested properties
        enum CodingKeys: String, CodingKey {
            case _id
            case profilePicture
            case coverPhoto
            case firstName
            case lastName
            case username
            case email
            case socialLinks
            case pilotInformation
            case website
            case createdAt
            case updatedAt
            case verified
            case country
            case city
            case phoneNumber
            case nricAttach
            case userCertificate
            case accountLinks
            case id
        }
    }
    
    struct Objective: Codable {
        let _id: String?
        let name: String?
        
        // Define coding keys for nested properties
        enum CodingKeys: String, CodingKey {
            case _id
            case name
        }
    }
    
    struct PermitInfo: Codable {
        struct PermitType: Codable {
            let _id: String?
            let parentId: ParentId?
            let name: String?
            let __v: Int?
            
            struct ParentId: Codable {
                let _id: String?
                let name: String?
                let __v: Int?
                
                // Define coding keys for nested properties
                enum CodingKeys: String, CodingKey {
                    case _id
                    case name
                    case __v
                }
            }
            
            // Define coding keys for nested properties
            enum CodingKeys: String, CodingKey {
                case _id
                case parentId
                case name
                case __v
            }
        }
        
        let permitType: PermitType?
        let permitFees: Int?
        let permit: String?
        
        // Define coding keys for nested properties
        enum CodingKeys: String, CodingKey {
            case permitType
            case permitFees
            case permit
        }
    }
    
    struct Area: Codable {
        let mode: String?
        let coordinate: [Coordinate]?
        let maxAltitude: Int?
        let bufferZone: Bool?
        let geoCoordinate: GeoCoordinate?
        
        // Define coding keys for nested properties
        enum CodingKeys: String, CodingKey {
            case mode
            case coordinate
            case maxAltitude
            case bufferZone
            case geoCoordinate
        }
    }
    
    struct Coordinate: Codable {
        let latitude: String?
        let longitude: String?
        
        // Define coding keys for nested properties
        enum CodingKeys: String, CodingKey {
            case latitude
            case longitude
        }
    }
    
    struct GeoCoordinate: Codable {
        let latitude: String?
        let longitude: String?
        
        // Define coding keys for nested properties
        enum CodingKeys: String, CodingKey {
            case latitude
            case longitude
        }
    }
    
    struct Schedule: Codable {
        let startDate: String?
        let endDate: String?
        let operatorAssign: [String]?
        let drones: [Drone]?
        
        // Define coding keys for nested properties
        enum CodingKeys: String, CodingKey {
            case startDate
            case endDate
            case operatorAssign
            case drones
        }
    }
    
    struct Drone: Codable {
        struct DroneId: Codable {
            let _id: String?
            let organisationId: String?
            let catalogId: CatalogId?
            let serialNumber: String?
            
            struct CatalogId: Codable {
                let _id: String?
                let name: String?
                let maker: String?
                let brand: String?
                let model: String?
                let specs: Specs?
                let type: String?
                
                struct Specs: Codable {
                    let size: String?
                    let maxFlightTime: String?
                    let maxTakeoffWeight: String?
                    let maxSpeed: String?
                    let maxPayload: String?
                    let battery: String?
                    
                    // Define coding keys for nested properties
                    enum CodingKeys: String, CodingKey {
                        case size
                        case maxFlightTime
                        case maxTakeoffWeight
                        case maxSpeed
                        case maxPayload
                        case battery
                    }
                }
                
                // Define coding keys for nested properties
                enum CodingKeys: String, CodingKey {
                    case _id
                    case name
                    case maker
                    case brand
                    case model
                    case specs
                    case type
                }
            }
            
            // Define coding keys for nested properties
            enum CodingKeys: String, CodingKey {
                case _id
                case organisationId
                case catalogId
                case serialNumber
            }
        }
        
        let droneId: DroneId?
        let payloadIds: [PayloadId]?
        
        // Define coding keys for nested properties
        enum CodingKeys: String, CodingKey {
            case droneId
            case payloadIds
        }
    }
    
    struct PayloadId: Codable {
        let _id: String?
        let organisationId: String?
        let catalogId: CatalogId?
        let serialNumber: String?
        
        struct CatalogId: Codable {
            let _id: String?
            let name: String?
            let maker: String?
            let brand: String?
            let model: String?
            let specs: Specs?
            let type: String?
            
            struct Specs: Codable {
                let mainGimbal: String?
                let sensor: String?
                let weight: String?
                let resolution: String?
                let keyFeatures: [String]?
                
                // Define coding keys for nested properties
                enum CodingKeys: String, CodingKey {
                    case mainGimbal
                    case sensor
                    case weight
                    case resolution
                    case keyFeatures
                }
            }
            
            // Define coding keys for nested properties
            enum CodingKeys: String, CodingKey {
                case _id
                case name
                case maker
                case brand
                case model
                case specs
                case type
            }
        }
        
        // Define coding keys for nested properties
        enum CodingKeys: String, CodingKey {
            case _id
            case organisationId
            case catalogId
            case serialNumber
        }
    }
    
    let records: [Record]?
    
    // Add other properties if needed
    
    // Define coding keys for top-level properties
    enum CodingKeys: String, CodingKey {
        case records
        // Add other coding keys as needed
    }
}
