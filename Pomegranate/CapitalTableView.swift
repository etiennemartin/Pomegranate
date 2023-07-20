//
//  CapitalTableView.swift
//  Pomegranate
//
//  Created by Etienne Martin on 2023-07-20.
//

import SwiftUI

struct CapitalTableView: View {
    @State private var capitals = Capital.all.sorted(using: KeyPathComparator(\.name))
    @State private var sortOrder = [KeyPathComparator(\Capital.name)]
    @State private var selection: Capital.ID?
    @State private var path = [Capital]()
    @Environment(\.horizontalSizeClass) var sizeClass
    @State private var ascend = true
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack(alignment: .leading) {
                Text("Top 100 Capitals")
                    .font(.largeTitle)
                    .bold()
                    .padding(.leading)
                if sizeClass == .compact {
                    Button {
                        ascend.toggle()
                        if ascend {
                            capitals.sort {$0.name < $1.name}
                        } else {
                            capitals.sort {$0.name > $1.name}
                        }
                    } label: {
                        Text(ascend ?
                            "Sort \(Image(systemName: "arrowtriangle.down"))" :
                            "Sort \(Image(systemName: "arrowtriangle.up"))")
                    }
                    .buttonStyle(.bordered)
                    .padding(.leading)
                }
                Table(capitals, selection: $selection, sortOrder: $sortOrder) {
                    TableColumn("Capital", value: \.name) { capital in
                        HStack {
                            Text(capital.name)
                            Spacer()
                            if sizeClass == .compact {
                                Text(capital.country)
                                    .font(.caption2)
                                    .textCase(.uppercase)
                            }
                        }
                    }
                    TableColumn("Country", value: \.country)
                    TableColumn("Population", value: \.population) { city in
                        Text("\(city.population)")
                    }
                }
                .navigationDestination(for: Capital.self) { capital in
                    CapitalView(capital: capital)
                }
                .onChange(of: sortOrder) { newOrder in
                    capitals.sort(using: newOrder)
                }
                .onChange(of: selection) { selection in
                    if let selection = selection,
                       let capital = capitals.first(where: { $0.id == selection}) {
                        path.append(capital)
                    }
                }
                .onAppear() {
                    // Ensure you can click on the same element twice in a row
                    selection = nil
                }
                .accessibilityIdentifier("CapitalTableView.Table")
            }
            .accessibilityElement(children: .contain)
            .accessibilityIdentifier("CapitalTableView")
        }
    }
}

struct CapitalTableView_Previews: PreviewProvider {
    static var previews: some View {
        CapitalTableView()
    }
}
