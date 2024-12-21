//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 20/12/2024.
//

import Dependencies
import DependenciesMacros
import Foundation
import MemberwiseInit
import Tagged

public enum Lists {}

extension Mailgun.Lists {
    public struct List: Sendable, Codable, Equatable {
        public let address: String
        public let name: String
        public let description: String
        public let accessLevel: AccessLevel
        public let replyPreference: ReplyPreference
        public let createdAt: String
        public let membersCount: Int
        
        public init(
            address: String,
            name: String,
            description: String,
            accessLevel: AccessLevel,
            replyPreference: ReplyPreference,
            createdAt: String,
            membersCount: Int
        ) {
            self.address = address
            self.name = name
            self.description = description
            self.accessLevel = accessLevel
            self.replyPreference = replyPreference
            self.createdAt = createdAt
            self.membersCount = membersCount
        }
    }
    
    public struct Member: Sendable, Codable, Equatable {
        public let address: String
        public let name: String?
        public let vars: [String: String]
        public let subscribed: Bool
        
        public init(
            address: String,
            name: String?,
            vars: [String: String],
            subscribed: Bool
        ) {
            self.address = address
            self.name = name
            self.vars = vars
            self.subscribed = subscribed
        }
    }
    
    public struct Paging: Sendable, Codable, Equatable {
        public let first: URL
        public let last: URL
        public let next: URL?
        public let previous: URL?
        
        public init(first: URL, last: URL, next: URL?, previous: URL?) {
            self.first = first
            self.last = last
            self.next = next
            self.previous = previous
        }
    }
    
    public enum AccessLevel: String, Sendable, Codable, Equatable {
        case readonly
        case members
        case everyone
    }
    
    public enum ReplyPreference: String, Sendable, Codable, Equatable {
        case list
        case sender
    }
    
    public enum PageDirection: String, Sendable, Codable, Equatable, RawRepresentable {
        case first
        case last
        case next
        case prev
    }
}

// List Operations
extension Mailgun.Lists.List {
    public enum Create {
        public struct Request: Sendable, Codable, Equatable {
            public let address: String
            public let name: String?
            public let description: String?
            public let accessLevel: Mailgun.Lists.AccessLevel?
            public let replyPreference: Mailgun.Lists.ReplyPreference?
            
            public init(
                address: String,
                name: String? = nil,
                description: String? = nil,
                accessLevel: Mailgun.Lists.AccessLevel? = nil,
                replyPreference: Mailgun.Lists.ReplyPreference? = nil
            ) {
                self.address = address
                self.name = name
                self.description = description
                self.accessLevel = accessLevel
                self.replyPreference = replyPreference
            }
        }
        
        public struct Response: Sendable, Codable, Equatable {
            public let list: Mailgun.Lists.List
            public let message: String
            
            public init(list: Mailgun.Lists.List, message: String) {
                self.list = list
                self.message = message
            }
        }
    }
    
    public struct Request: Sendable, Codable, Equatable {
        public let limit: Int?
        public let skip: Int?
        public let address: String?
        
        public init(limit: Int? = nil, skip: Int? = nil, address: String? = nil) {
            self.limit = limit
            self.skip = skip
            self.address = address
        }
    }
    
    public struct Response: Sendable, Codable, Equatable {
        public let totalCount: Int
        public let items: [Mailgun.Lists.List]
        
        public init(totalCount: Int, items: [Mailgun.Lists.List]) {
            self.totalCount = totalCount
            self.items = items
        }
    }
    
    public enum Update {
        public struct Request: Sendable, Codable, Equatable {
            public let address: String?
            public let name: String?
            public let description: String?
            public let accessLevel: Mailgun.Lists.AccessLevel?
            public let replyPreference: Mailgun.Lists.ReplyPreference?
            
            public init(
                address: String? = nil,
                name: String? = nil,
                description: String? = nil,
                accessLevel: Mailgun.Lists.AccessLevel? = nil,
                replyPreference: Mailgun.Lists.ReplyPreference? = nil
            ) {
                self.address = address
                self.name = name
                self.description = description
                self.accessLevel = accessLevel
                self.replyPreference = replyPreference
            }
        }
        
        public struct Response: Sendable, Codable, Equatable {
            public let message: String
            public let list: Mailgun.Lists.List
            
            public init(message: String, list: Mailgun.Lists.List) {
                self.message = message
                self.list = list
            }
        }
    }
    
    public enum Delete {
        public struct Response: Sendable, Decodable, Equatable {
            public let address: String
            public let message: String
            
            public init(address: String, message: String) {
                self.address = address
                self.message = message
            }
        }
    }
    
    public enum Get {
        public struct Response: Sendable, Decodable, Equatable {
            public let list: Mailgun.Lists.List
            
            public init(list: Mailgun.Lists.List) {
                self.list = list
            }
        }
    }
    
    public enum Pages {
        public struct Response: Sendable, Decodable, Equatable {
            public let paging: Mailgun.Lists.Paging
            public let items: [Mailgun.Lists.List]
            
            public init(paging: Mailgun.Lists.Paging, items: [Mailgun.Lists.List]) {
                self.paging = paging
                self.items = items
            }
        }
    }
}

extension Mailgun.Lists.List {
    public enum Members {
        public struct Request: Sendable, Codable, Equatable {
            public let address: String?
            public let subscribed: Bool?
            public let limit: Int?
            public let skip: Int?
            
            public init(
                address: String? = nil,
                subscribed: Bool? = nil,
                limit: Int? = nil,
                skip: Int? = nil
            ) {
                self.address = address
                self.subscribed = subscribed
                self.limit = limit
                self.skip = skip
            }
        }
        
        public struct Response: Sendable, Decodable, Equatable {
            public let totalCount: Int
            public let items: [Mailgun.Lists.Member]
            
            public init(totalCount: Int, items: [Mailgun.Lists.Member]) {
                self.totalCount = totalCount
                self.items = items
            }
        }
        
        public enum Pages {
            public struct Request: Sendable, Decodable, Equatable {
                public let subscribed: Bool?
                public let limit: Int?
                public let address: String?
                public let page: Mailgun.Lists.PageDirection?
                
                public init(
                    subscribed: Bool? = nil,
                    limit: Int? = nil,
                    address: String? = nil,
                    page: Mailgun.Lists.PageDirection? = nil
                ) {
                    self.subscribed = subscribed
                    self.limit = limit
                    self.address = address
                    self.page = page
                }
            }
            
            public struct Response: Sendable, Codable, Equatable {
                public let paging: Mailgun.Lists.Paging
                public let items: [Mailgun.Lists.Member]
                
                public init(paging: Mailgun.Lists.Paging, items: [Mailgun.Lists.Member]) {
                    self.paging = paging
                    self.items = items
                }
            }
        }
    }
}

extension Mailgun.Lists.Member {
    public enum Add {
        public struct Request: Sendable, Codable, Equatable {
            public let address: String
            public let name: String?
            public let vars: [String: String]?
            public let subscribed: Bool?
            public let upsert: Bool?
            
            public init(
                address: String,
                name: String? = nil,
                vars: [String: String]? = nil,
                subscribed: Bool? = nil,
                upsert: Bool? = nil
            ) {
                self.address = address
                self.name = name
                self.vars = vars
                self.subscribed = subscribed
                self.upsert = upsert
            }
        }
        
        public struct Response: Sendable, Codable, Equatable {
            public let member: Mailgun.Lists.Member
            public let message: String
            
            public init(member: Mailgun.Lists.Member, message: String) {
                self.member = member
                self.message = message
            }
        }
    }
    
    public enum Update {
        public struct Request: Sendable, Codable, Equatable {
            public let address: String?
            public let name: String?
            public let vars: [String: String]?
            public let subscribed: Bool?
            
            public init(
                address: String? = nil,
                name: String? = nil,
                vars: [String: String]? = nil,
                subscribed: Bool? = nil
            ) {
                self.address = address
                self.name = name
                self.vars = vars
                self.subscribed = subscribed
            }
        }
        
        public struct Response: Sendable, Codable, Equatable {
            public let member: Mailgun.Lists.Member
            public let message: String
            
            public init(member: Mailgun.Lists.Member, message: String) {
                self.member = member
                self.message = message
            }
        }
    }
    
    public enum Delete {
        public struct Response: Sendable, Codable, Equatable {
            public let member: DeletedInfo
            public let message: String
            
            public init(member: DeletedInfo, message: String) {
                self.member = member
                self.message = message
            }
        }
        
        public struct DeletedInfo: Sendable, Codable, Equatable {
            public let address: String
            
            public init(address: String) {
                self.address = address
            }
        }
    }
    
    public struct Bulk: Sendable, Codable, Equatable {
        public let address: String
        public let name: String?
        public let vars: [String: String]?
        public let subscribed: Bool?
        
        public init(
            address: String,
            name: String? = nil,
            vars: [String: String]? = nil,
            subscribed: Bool? = nil
        ) {
            self.address = address
            self.name = name
            self.vars = vars
            self.subscribed = subscribed
        }
    }
}

extension Mailgun.Lists.Member.Bulk {
    public struct Response: Sendable, Codable, Equatable {
        public let list: Mailgun.Lists.List
        public let taskId: String
        public let message: String
        
        public init(list: Mailgun.Lists.List, taskId: String, message: String) {
            self.list = list
            self.taskId = taskId
            self.message = message
        }
    }
}

