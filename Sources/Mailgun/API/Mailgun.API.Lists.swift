//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 20/12/2024.
//

import Dependencies
import Foundation
import UrlFormCoding
import URLRouting

extension Mailgun.API {
    public enum Lists: Equatable, Sendable {
        case create(request: Mailgun.Lists.List.Create.Request)
        case list(request: Mailgun.Lists.List.Request)
        case members(listAddress: String, request: Mailgun.Lists.List.Members.Request)
        case addMember(listAddress: String, request: Mailgun.Lists.Member.Add.Request)
        case bulkAdd(listAddress: String, members: [Mailgun.Lists.Member.Bulk], upsert: Bool?)
        case bulkAddCSV(listAddress: String, request: Data, subscribed: Bool?, upsert: Bool?)
        case getMember(listAddress: String, memberAddress: String)
        case updateMember(listAddress: String, memberAddress: String, request: Mailgun.Lists.Member.Update.Request)
        case deleteMember(listAddress: String, memberAddress: String)
        case update(listAddress: String, request: Mailgun.Lists.List.Update.Request)
        case delete(listAddress: String)
        case get(listAddress: String)
        case pages(limit: Int?)
        case memberPages(listAddress: String, request: Mailgun.Lists.List.Members.Pages.Request)
    }
}

extension Mailgun.API.Lists {
    public struct Router: ParserPrinter, Sendable {
        public init() {}
        
        public var body: some URLRouting.Router<Mailgun.API.Lists> {
            OneOf {
                // POST /v3/lists
                Route(.case(Mailgun.API.Lists.create)) {
                    Method.post
                    Path { "v3" }
                    Path { "lists" }
                    Body(.form(Mailgun.Lists.List.Create.Request.self, decoder: .default))
                }
                
                // GET /v3/lists
                Route(.case(Mailgun.API.Lists.list)) {
                    Method.get
                    Path { "v3" }
                    Path { "lists" }
                    Parse(.memberwise(Mailgun.Lists.List.Request.init)) {
                        Query {
                            Optionally {
                                Field("limit") { Digits() }
                            }
                            Optionally {
                                Field("skip") { Digits() }
                            }
                            Optionally {
                                Field("address") { Parse(.string) }
                            }
                        }
                    }
                }
                
                // GET /v3/lists/{list_address}/members
                Route(.case(Mailgun.API.Lists.members)) {
                    Method.get
                    Path { "v3" }
                    Path { "lists" }
                    Path { Parse(.string) }
                    Path { "members" }
                    Parse(.memberwise(Mailgun.Lists.List.Members.Request.init)) {
                        Query {
                            Optionally {
                                Field("address") { Parse(.string) }
                            }
                            Optionally {
                                Field("subscribed") { Bool.parser() }
                            }
                            Optionally {
                                Field("limit") { Digits() }
                            }
                            Optionally {
                                Field("skip") { Digits() }
                            }
                        }
                    }
                }
                
                // POST /v3/lists/{list_address}/members
                Route(.case(Mailgun.API.Lists.addMember)) {
                    Method.post
                    Path { "v3" }
                    Path { "lists" }
                    Path { Parse(.string) }
                    Path { "members" }
                    Body(.form(Mailgun.Lists.Member.Add.Request.self, decoder: .default))
                }
                
                // POST /v3/lists/{list_address}/members.json
                Route(.case(Mailgun.API.Lists.bulkAdd)) {
                    Method.post
                    Path { "v3" }
                    Path { "lists" }
                    Path { Parse(.string) }
                    Path { "members.json" }
                    Body(.form([Mailgun.Lists.Member.Bulk].self, decoder: .default))
                    Query {
                        Optionally {
                            Field("upsert") { Bool.parser() }
                        }
                    }
                }
                
                // POST /v3/lists/{list_address}/members.csv
                Route(.case(Mailgun.API.Lists.bulkAddCSV)) {
                    Method.post
                    Path { "v3" }
                    Path { "lists" }
                    Path { Parse(.string) }
                    Path { "members.csv" }
                    Path { Parse(.data) }
                    Query {
                        Optionally {
                            Field("subscribed") { Bool.parser() }
                        }
                    }
                    Query {
                        Optionally {
                            Field("upsert") { Bool.parser() }
                        }
                    }
                }
                
                // GET /v3/lists/{list_address}/members/{member_address}
                Route(.case(Mailgun.API.Lists.getMember)) {
                    Method.get
                    Path { "v3" }
                    Path { "lists" }
                    Path { Parse(.string) }
                    Path { "members" }
                    Path { Parse(.string) }
                }
                
                // PUT /v3/lists/{list_address}/members/{member_address}
                Route(.case(Mailgun.API.Lists.updateMember)) {
                    Method.put
                    Path { "v3" }
                    Path { "lists" }
                    Path { Parse(.string) }
                    Path { "members" }
                    Path { Parse(.string) }
                    Body(.form(Mailgun.Lists.Member.Update.Request.self, decoder: .default))
                }
                
                // DELETE /v3/lists/{list_address}/members/{member_address}
                Route(.case(Mailgun.API.Lists.deleteMember)) {
                    Method.delete
                    Path { "v3" }
                    Path { "lists" }
                    Path { Parse(.string) }
                    Path { "members" }
                    Path { Parse(.string) }
                }
                
                // PUT /v3/lists/{list_address}
                Route(.case(Mailgun.API.Lists.update)) {
                    Method.put
                    Path { "v3" }
                    Path { "lists" }
                    Path { Parse(.string) }
                    Body(.form(Mailgun.Lists.List.Update.Request.self, decoder: .default))
                }
                
                // DELETE /v3/lists/{list_address}
                Route(.case(Mailgun.API.Lists.delete)) {
                    Method.delete
                    Path { "v3" }
                    Path { "lists" }
                    Path { Parse(.string) }
                }
                
                // GET /v3/lists/{list_address}
                Route(.case(Mailgun.API.Lists.get)) {
                    Method.get
                    Path { "v3" }
                    Path { "lists" }
                    Path { Parse(.string) }
                }
                
                // GET /v3/lists/pages
                Route(.case(Mailgun.API.Lists.pages)) {
                    Method.get
                    Path { "v3" }
                    Path { "lists" }
                    Path { "pages" }
                    Query {
                        Optionally {
                            Field("limit") { Digits() }
                        }
                    }
                }
                
                // GET /v3/lists/{list_address}/members/pages
                Route(.case(Mailgun.API.Lists.memberPages)) {
                    Method.get
                    Path { "v3" }
                    Path { "lists" }
                    Path { Parse(.string) }
                    Path { "members" }
                    Path { "pages" }
                    Parse(.memberwise(Mailgun.Lists.List.Members.Pages.Request.init)) {
                        Query {
                            Optionally {
                                Field("subscribed") { Bool.parser() }
                            }
                            Optionally {
                                Field("limit") { Digits() }
                            }
                            Optionally {
                                Field("address") { Parse(.string) }
                            }
                            Optionally {
                                Field("page") { Parse(.string).map(.representing(Mailgun.Lists.PageDirection.self)) }
                            }
                        }
                    }
                }
            }
        }
    }
}

extension UrlFormDecoder {
    fileprivate static var `default`: UrlFormDecoder {
        let decoder = UrlFormDecoder()
        decoder.parsingStrategy = .bracketsWithIndices
        return decoder
    }
}
