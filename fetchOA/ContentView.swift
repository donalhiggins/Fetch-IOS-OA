//
//  ContentView.swift
//  fetchOA
//
//  Created by Donal Higgins on 2/17/23.
//

import SwiftUI

class ContentViewModel {
    func getItems(completion:@escaping ([Item]) -> ()) {
        // Fetch json from url
        guard let url = URL(string: "https://fetch-hiring.s3.amazonaws.com/hiring.json") else { return }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            var items = try! JSONDecoder().decode([Item].self, from: data!)
            
            // Filter out all names that are nil or blank
            items = items.filter { $0.name != nil && $0.name != "" }
            
            items.sort {
                // Sort by listId if they aren't the same, otherwise sort by name
                if $0.listId != $1.listId {
                    return $0.listId < $1.listId
                }
                // Sort by name
                else {
                    return $0.name! < $1.name!
                }
            }
            
            DispatchQueue.main.async {
                completion(items)
            }
        }
        .resume()
    }
}

struct ContentView: View {
    @State var items: [Item] = []
    
    var body: some View {
        
        NavigationView {
            List(items) { item in
                HStack(alignment: .center, spacing: nil) {
                    Text(item.name!)
                        .frame(maxWidth: 100, alignment: .leading)
                    Divider()
                    Text("\(item.id)")
                        .frame(maxWidth: 100, alignment: .leading)
                    Divider()
                    Text("\(item.listId)")
                        .frame(maxWidth: 100, alignment: .leading)
                }
            }
            .navigationTitle("Items")
        }
        .onAppear {
            // Make items list
            ContentViewModel().getItems { (items) in
                self.items = items
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
