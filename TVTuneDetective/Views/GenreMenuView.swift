import SwiftUI

struct GenreMenuView: View {
    @ObservedObject var engine: GameEngine
    @State private var expandedCategory: UUID? = nil

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(genreCategories) { category in
                    VStack(alignment: .leading, spacing: 8) {
                        Button {
                            expandedCategory = (expandedCategory == category.id ? nil : category.id)
                        } label: {
                            HStack {
                                Image(systemName: "music.note.list")
                                Text(category.name)
                                    .font(.title2).bold()
                                Spacer()
                                Image(systemName: expandedCategory == category.id ? "chevron.down" : "chevron.right")
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.purple.opacity(0.7))
                            )
                        }
                        .buttonStyle(.card)

                        if expandedCategory == category.id {
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(category.subcategories) { sub in
                                    Button {
                                        engine.genreChosen(sub.criteria)
                                    } label: {
                                        Text(sub.name)
                                            .font(.title3).bold()
                                            .padding()
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .background(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .fill(Color.green.opacity(0.7))
                                            )
                                    }
                                    .buttonStyle(.card)
                                }
                            }
                            .padding(.leading, 40)
                        }
                    }
                }
            }
            .padding()
        }
    }
}
