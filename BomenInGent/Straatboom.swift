class Straatboom {
    
    let Straatnamenlijst: String
    let boomsoorten: String
    
    init(Straatnamenlijst: String, boomsoorten: String) {
        self.Straatnamenlijst = Straatnamenlijst
        self.boomsoorten = boomsoorten
        
    }

    
}

extension Straatboom: CustomStringConvertible {
    
    var description: String {
        return boomsoorten + " in straat " + Straatnamenlijst + "\n"
    }
}



extension Straatboom {
    
    convenience init(json: [String: Any]) throws {
        guard let Straatnamenlijst = json["Straatnamenlijst"] as? String else {
            throw Service.Error.missingJsonProperty(name: "Straatnamenlijst")
        }
        guard let boomsoorten = json["boomsoorten"] as? String else {
            throw Service.Error.missingJsonProperty(name: "boomsoorten")
        }
        
        
        self.init(Straatnamenlijst: Straatnamenlijst,
                      boomsoorten: boomsoorten)
        print("added " + boomsoorten + " in straat " + Straatnamenlijst)
    }
}
