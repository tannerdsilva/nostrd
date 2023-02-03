import Foundation

extension Data {
	func hexEncodedString() -> String {
		let hexString = self.map { String(format:"%02x", $0) }.joined()
		return hexString
	}
	
	init(hexEncodedString:String) {
		self = Data(hexEncodedString.split(by:2).map({ UInt8(String($0), readix:16)! }))
	}
}