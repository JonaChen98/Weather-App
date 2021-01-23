import Foundation

class PersistencyHelper {
  
  static func saveFavCities(_ items: [FavoriteCitiesItem]) {
    let encoder = PropertyListEncoder()
    do {
      let data = try encoder.encode(items)
      try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
    } catch {
      print("Error encoding item array: \(error.localizedDescription)")
    }
  }
  
  static func loadFavCities() -> [FavoriteCitiesItem] {
    var items = [FavoriteCitiesItem]()
    let path = dataFilePath()
    if let data = try? Data(contentsOf: path) {
      let decoder = PropertyListDecoder()
      do {
        items = try decoder.decode([FavoriteCitiesItem].self, from: data)
      } catch {
        print("Error decoding item array: \(error.localizedDescription)")
      }
    }
    return items
  }
  
  static func dataFilePath() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory,
                                          in: .userDomainMask)
    return paths[0].appendingPathComponent("favoriteCityItem.plist")
  }
}
