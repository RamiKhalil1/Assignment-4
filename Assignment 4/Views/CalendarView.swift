import SwiftUI

struct CalendarView: View {
    @FetchRequest(
        entity: Mood.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Mood.date, ascending: false)]
    ) var moodEntries: FetchedResults<Mood>
    @State private var selectedMonth = Calendar.current.component(.month, from: Date())
    @State private var selectedYear = Calendar.current.component(.year, from: Date())
    
    @State private var isMonthPickerPresented = false
    @State private var isYearPickerPresented = false
    
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    @State private var days: [Date] = []
    @State private var date: Date = Date.now
    @State private var entriesDates: [Date] = []
    
    @State public var isReload: Bool = false
    @State public var fetchTrigger = UUID()
    
    var body: some View {
        VStack {
            HStack {
                MonthYearPickerView(selectedMonth: $selectedMonth, selectedYear: $selectedYear, date: $date, days: $days)
                            
                Spacer()
                
                
            }
            .padding()
            
            HStack {
                ForEach(daysOfWeek.indices, id: \.self) { index in
                    Text(daysOfWeek[index])
                        .fontWeight(.black)
                        .foregroundStyle(Color.white)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding()
            
            VStack {
                LazyVGrid(columns: columns) {
                    ForEach(days, id: \.self) { day in
                        if day.monthInt != date.monthInt {
                            Text("")
                        } else {
                            let isCurrentDay = date.startOfDay == day.startOfDay
                            let isEntryDate = entriesDates.contains(day)
                            
                            let backgroundColor: Color = isCurrentDay ? Color.red.opacity(0.2) :
                            isEntryDate ? Color.blue.opacity(0.2) :
                            Color.green.opacity(0.2)
                            
                            Text(day.formatted(.dateTime.day()))
                                .fontWeight(.bold)
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity, minHeight: 40)
                                .background(
                                    Circle()
                                        .foregroundColor(backgroundColor)
                                )
                                .onTapGesture {
                                    date = day.startOfDay
                                }
                            
                        }
                    }
                }
                .padding(10)
                .onAppear {
                    days = date.calendarDisplayDays
                    updateEntriesDatesIfNeeded()
                }
            }
            .background(Color.white.opacity(0.7))
            .cornerRadius(20)
            .padding(5)
            
            List {
                ForEach(moodEntries, id: \.self) { entry in
                    if Calendar.current.isDate(entry.date ?? Date(), inSameDayAs: date) {
                        EntryView(entry: entry, isReload: $isReload)
                            .listRowBackground(Color.clear)
                    }
                }.onDelete(perform: deleteEntries)
            }
            .listStyle(PlainListStyle())
            .background(Color.clear)
            .cornerRadius(10)
        }
        .padding()
        .navigationTitle("Mood Calendar")
        .onChange(of: isReload) {
            fetchTrigger = UUID()
            isReload = false
        }
        .id(fetchTrigger)
        .background(
            LinearGradient(gradient: Gradient(colors: [.purple, .blue]), startPoint: .leading, endPoint: .trailing)
        )
    }
    
    private func updateEntriesDatesIfNeeded() {
        guard entriesDates.isEmpty else { return }
        entriesDates = getEntriesDate(moodEntries: moodEntries)
    }
    
    private func deleteEntries(at offsets: IndexSet) {
        for index in offsets {
            let entry = moodEntries[index]
            PersistenceController.shared.deleteMoodEntry(entry)
            entriesDates = getEntriesDate(moodEntries: moodEntries)
        }
    }
}

#Preview {
    CalendarView()
}
