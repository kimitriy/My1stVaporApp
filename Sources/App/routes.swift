import Vapor

func routes(_ app: Application) throws {
    
	app.get { req in
        return "It works!"
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }
	
	app.get("hello", "vapor") { req -> String in
		return "Hello, vapor!"
	}
	
	//":name" - ":" means that "name" is a dynamic parameter and is able to be set with any value
	app.get("hello", ":name") { req -> String in
		
		guard let name = req.parameters.get("name") else {
			throw Abort(.internalServerError)
		}
		
		return ("Hello, \(name)!")
	}
	
	app.get("count", ":word") { req -> String in
		
		guard let word = req.parameters.get("word") else {
			throw Abort(.internalServerError)
		}
		
		return "\(word.count)"
	}
	
	app.post("track") { req -> String in
		let data = try req.content.decode(Track.self)
		return "\(data.artist) - \(data.title) is playing."
	}
	
	app.post("track", "json") { req -> ResponseTrack in
		let data = try req.content.decode(Track.self)
		return ResponseTrack(request: data)
	}
}


//Content - it is a Vapor's protocol that combines Codable, Decodable, Encodable protocols
struct Track: Content {
	let title: String
	let artist: String
}

struct ResponseTrack: Content {
	let request: Track
}
