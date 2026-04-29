import SwiftUI

struct GenreMenuView: View {
    @ObservedObject var engine: GameEngine
    @State private var selectedCategory: GenreCategory? = nil
    
    // Links the remote focus to the subcategory buttons
    @FocusState private var focusedSubcategory: UUID?

    let columns = [
        GridItem(.flexible(), spacing: 50),
        GridItem(.flexible(), spacing: 50),
        GridItem(.flexible(), spacing: 50)
    ]

    var body: some View {
        ZStack {
            // MARK: - Background Layer
            Color.clear.ignoresSafeArea() // 👈 We change this to clear

            // MARK: - Main Grid Layer
            VStack(spacing: 0) {
                if let chooser = engine.currentChooser {
                    Text("🎲 \(chooser.name), it's your turn!")
                        .font(.title3)
                        .foregroundColor(.yellow)
                        .padding(.top, 40)
                }
                
                Text("Select a Genre")
                    .font(.system(size: 70, weight: .bold))
                    .padding(.bottom, 20)

                ScrollView {
                    LazyVGrid(columns: columns, spacing: 50) {
                        ForEach(genreCategories) { category in
                            Button {
                                handleCategorySelection(category)
                            } label: {
                                Text(category.name)
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 180)
                            }
                            .buttonStyle(.card)
                        }
                    }
                    .padding(80)
                }
            }
            .padding(.leading, 60)
            .blur(radius: selectedCategory != nil ? 20 : 0)
            .disabled(selectedCategory != nil)

            // MARK: - Subcategory Pop-up (The Modal)
            if let category = selectedCategory, category.subcategories.count > 1 {
                // Dimmed background
                Color.black.opacity(0.4)
                    .ignoresSafeArea()

                VStack(spacing: 40) {
                    Text("Choose Style for \(category.name)")
                        .font(.title2).bold()
                        .foregroundColor(.yellow)

                    HStack(spacing: 40) {
                        ForEach(category.subcategories) { sub in
                            Button {
                                engine.genreChosen(sub.criteria)
                            } label: {
                                Text(sub.name)
                                    .font(.title3)
                                    .padding(.horizontal, 40)
                                    .frame(height: 120)
                            }
                            .buttonStyle(.card)
                            .focused($focusedSubcategory, equals: sub.id)
                        }
                    }
                    
                    Button("Back") {
                        withAnimation {
                            selectedCategory = nil
                        }
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(.white.opacity(0.6))
                    .padding(.top, 20)
                }
                .padding(80)
                .background(RoundedRectangle(cornerRadius: 30).fill(Color.black.opacity(0.9)))
                .shadow(radius: 20)
                .transition(.scale.combined(with: .opacity))
            }
        }
    }

    // Fixed logic to handle the "Skip" if only one subcategory exists
    private func handleCategorySelection(_ category: GenreCategory) {
        // 1. Check if the list of subcategories actually has items
        if let firstSub = category.subcategories.first {
            
            // 2. If there is ONLY one option (like in your 50s category)
            if category.subcategories.count == 1 {
                // We grab the criteria from that 'firstSub' we just found
                engine.genreChosen(firstSub.criteria)
            } else {
                // 3. If there are multiple (like 80s Rock vs 80s Pop)
                withAnimation(.spring()) {
                    selectedCategory = category
                }
                // Snaps the remote focus to the first button in the pop-up
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    focusedSubcategory = firstSub.id
                }
            }
        }
    }
}
