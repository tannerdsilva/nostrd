import Crypto
import Foundation

struct NIP_01 {
	struct Event:Codable {
	
		/// Event Tags help reference other identities or events
		struct Tag:Codable {
			
			/// The types of tags that are supported with events
			enum `Type`:String, Codable {
				case publicKey = "p"
				case event = "e"
			}
			
			let type:Type
			let reference:String
			let recommendedRelay:String?
			
			init(from decoder:Decoder) throws {
				var container = try decoder.unkeyedContainer()
				self.type = try container.decode(Type.self)
				self.reference = try container.decode(String.self)
				if (container.isAtEnd == true) {
					self.recommendedRelay = nil
				} else {
					self.recommendedRelay = try container.decode(String.self)
				}
			}
			
			func encode(to encoder:Encoder) throws {
				var container = try encoder.unkeyedContainer()
				try container.encode(type)
				try container.encode(reference)
				if (recommendedRelay != nil) {
					try container.encode(recommendedRelay!)
				}
			}
		}
	
		enum Kind:Int64, Codable {
			case set_metadata = 0
			case text_note = 1
			case recommended_server = 2
		}
		
		enum CodingKeys:String, CodingKey {
			case id = "id"
			case publicKey = "pubkey"
			case createDate = "created_at"
			case kind = "kind"
			case tags = "tags"
			case content = "content"
			case signature = "sig"
		}
		
		/// 32-bytes lowercase hex-encoded sha256 of the the serialized event data
		let id:String
		/// 32-bytes lowercase hex-encoded public key of the event creator
		let publicKey:String
		/// unix timestamp in seconds
		let unixCreate:Double
		/// integer of the kind of event
		let kind:Kind
		/// Associated tags for this event
		let tags:[Tag]
		/// The primary content of this event
		let content:String
		/// The signature of this event
		let signature:String
		
		init(from decoder:Decoder) throws {
			let container = try decoder.container(keyedBy:CodingKeys.self)
			self.id = try container.decode(String.self, forKey:CodingKeys.id)
			self.publicKey = try container.decode(String.self, forKey:CodingKeys.publicKey)
			self.unixCreate = try container.decode(Double.self, forKey:CodingKeys.createDate)
			self.kind = try container.decode(Kind.self, forKey:CodingKeys.kind)
			self.tags = try container.decode([Tag].self, forKey:CodingKeys.tags)
			self.content = try container.decode(String.self, forKey:CodingKeys.content)
			self.signature = try container.decode(String.self, forKey:CodingKeys.signature)
		}
		
		func encode(to encoder:Encoder) throws {
			var container = try encoder.container(keyedBy:CodingKeys.self)
			try container.encode(self.id, forKey:CodingKeys.id)
			try container.encode(self.publicKey, forKey:CodingKeys.publicKey)
			try container.encode(self.unixCreate, forKey:CodingKeys.createDate)
			try container.encode(self.kind, forKey:CodingKeys.kind)
			try container.encode(self.tags, forKey:CodingKeys.tags)
			try container.encode(self.content, forKey:CodingKeys.content)
			try container.encode(self.signature, forKey:CodingKeys.signature)
		}
		
		struct Serialized:Codable {
			/// 32-bytes lowercase hex-encoded public key of the event creator
			let publicKey:String
			/// unix timestamp in seconds
			let unixCreate:Double
			/// integer of the kind of event
			let kind:Kind
			/// Associated tags for this event
			let tags:[Tag]
			/// The primary content of this event
			let content:String
			
			init(from decoder:Decoder) throws {
				var container = try decoder.unkeyedContainer()
				_ = try container.decode(UInt.self)
				self.publicKey = try container.decode(String.self)
				self.unixCreate = try container.decode(Double.self)
				self.kind = try container.decode(Kind.self)
				self.tags = try container.decode([Tag].self)
				self.content = try container.decode(String.self)
			}
			
			func encode(to encoder:Encoder) throws {
				var container = try encoder.unkeyedContainer()
				try container.encode(0 as UInt)
				try container.encode(self.publicKey)
				try container.encode(self.unixCreate)
				try container.encode(self.kind)
				try container.encode(self.tags)
				try container.encode(self.content)
			}
			
			func computeEventID() throws -> String {
				let encodedData = try JSONEncoder().encode(self)
				var newSHA = SHA256()
				newSHA.update(data:encodedData)
				return Data(newSHA.finalize()).hexEncodedString()
			}
		}
		
		struct Filter {
			enum CodingKeys:String, CodingKey {
				case ids = "ids"
				case authors = "authors"
				case kinds = "kinds"
				case eventIDs = "#e"
				case pubIDs = "#p"
				case since = "since"
				case until = "until"
				case limit = "limit"
			}
			/// a list of event ids for prefixes
			var ids:[String]?
			/// a list of pubkeys or prefixes, the pubkey of an event must be one of these
			var authors:[String]?
			/// a list of a kind numbers
			var kinds:[Kind]?
			/// a list of event ids that are referenced in an "e" tag
			var events:[String]?
			/// a list of pubkeys that are referenced in a "p" tag
			var pubs:[String]?
			/// an integer unix timestamp, events must be newer than this to pass
			var since:Double?
			/// an integer unix timestamp, events must be older than this to pass
			var until:Double?
			/// maximum number of events to be returned in the initial query
			var limit:Double?
			
			func isValidFilter() -> Bool {
				if (ids || authors || kinds || events || pubs || since || until || limit) {
					return true
				} else {
					return false
				}
			}
		}
	}
	
	struct Serialized {
		struct Client {
			struct EventPublication {
				
			}
			struct Request {
			
			}
			
			struct Close {
			
			}
		}
		
		struct Relay {
			struct Event {
			
			}
			
			struct Notice {
			
			}
		}
	}
}