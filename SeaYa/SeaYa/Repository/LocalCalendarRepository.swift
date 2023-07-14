import Foundation

class LocalCalendarRepository {
    
    static let shared = LocalCalendarRepository()
    private let userDefaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    // MARK: - Lifecycle
   private init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    //이벤트가 월,화,수,목,금,토,일,중에 어떤 요일에 있는지
    public func createEvent(event: LocalEvent){
        if let encoded = try? encoder.encode(event) {
            userDefaults.set(encoded, forKey: event.id.uuidString)
        }
    }
    public func removeEvent(event: LocalEvent){
        userDefaults.removeObject(forKey: event.id.uuidString)
        
    }
    public func updateEvent(event: LocalEvent){
        userDefaults.set(event, forKey: event.id.uuidString)
        
    }
    public func getEvent(id: String)->LocalEvent?{
        if let savedData = UserDefaults.standard.object(forKey: id) as? Data {
            if let savedObject = try? decoder.decode(LocalEvent.self, from: savedData) {
                return savedObject
            }
        }
        return nil
    }
    public func getEvents()->[LocalEvent]{
        var result:[LocalEvent] = []
        userDefaults.dictionaryRepresentation().forEach { (key: String, value: Any) in
            if let data = value as? Data{
                if let object = try? decoder.decode(LocalEvent.self, from: data){
                    result.append(object)
                }
            }
        }
        return result
    }
}
