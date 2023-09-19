//
//  TestingCloudkit.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 9/9/23.
//

import SwiftUI
import CloudKit
import CoreData

// MARK: - TestingCloudkit

struct TestingCloudkit: View {
    @Environment(\.managedObjectContext) var context
    @FetchRequest(sortDescriptors: []) var items: FetchedResults<TestingCloud>
    @State private var isLoading = false
    @State private var showingAlert = false
    
    @State private var fetched: [TestingCloud] = []
    
    @State private var fallbackText = "None so far"
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    
        

    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
            } else {
                List {
                    if fetched.isEmpty {
                        Text(fallbackText)
                    } else {
                        ForEach(fetched) { item in
                            if let name = item.name {
                                Text(name)
                            }
                            Text(item.number.simpleStr())
                        }
                    }
                    Button(action: {
                        addItem()
                    }) {
                        Text("Add Item")
                    }
                    
                    Button("Delete all") {
//                        fetched.forEach { item in
//                            context.delete(item)
//                            
//                        }
                        
                        items.forEach { item in
                            context.delete(item)
                        }
                        
                        try! context.save()
                        Task {
                            await fetchItems()
                        }
                    }
                }
            }
        }
        .onReceive(timer) { _ in
            Task {
                await self.fetchItems()
            }
        }
        .task {
            await self.fetchItems()
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Error"), message: Text("Failed to save item"), dismissButton: .default(Text("OK")))
        }
        .refreshable {
            await self.fetchItems()
        }
    }

    private func fetchItems() async {
        isLoading = true

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TestingCloud")
        fetchRequest.returnsObjectsAsFaults = false

        do {
            let results = try context.fetch(fetchRequest)
            
            fetched = results as! [TestingCloud]
//            for result in results as! [TestingCloud] {
//                fetched.append(result)
//            }
            fallbackText = "Found nothing"
        } catch {
            print("Failed to fetch items from CloudKit")
        }
        isLoading = false
        
        
    }

    private func addItem() {
        let newItem = TestingCloud(context: context)
        newItem.name = "Nana wiwl \(fetched.count + 1)"
        newItem.number = Double.random(in: 0 ... 100)

        do {
            try context.save()
        } catch {
            showingAlert = true
        }
    }
}

// MARK: - TestingCloudkit_Previews

struct TestingCloudkit_Previews: PreviewProvider {
    static var previews: some View {
        TestingCloudkit()
    }
}
