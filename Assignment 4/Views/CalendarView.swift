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
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    isMonthPickerPresented.toggle()
                }) {
                    Text("\(DateFormatter().monthSymbols[selectedMonth - 1])")
                        .font(.system(size: 18))
                        .foregroundColor(.blue)
                }
                .sheet(isPresented: $isMonthPickerPresented) {
                    VStack {
                        Picker(selection: $selectedMonth, label: Text("Month")) {
                            ForEach(1..<13) { month in
                                Text("\(DateFormatter().monthSymbols[month - 1])").tag(month)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .onChange(of: selectedMonth) {
                            date = updateDateForNewMonthOrYear(newMonth: selectedMonth, newYear: selectedYear, date: date)
                            days = date.calendarDisplayDays
                        }
                        Button("Done") {
                            isMonthPickerPresented = false
                        }
                    }
                }
                
                Button(action: {
                    isYearPickerPresented.toggle()
                }) {
                    Text(yearFormatter.string(from: NSNumber(value: selectedYear)) ?? "\(selectedYear)")
                        .font(.system(size: 18))
                        .foregroundColor(.blue)
                }
                .sheet(isPresented: $isYearPickerPresented) {
                    VStack {
                        Picker(selection: $selectedYear, label: Text("Year")) {
                            ForEach(years, id: \.self) { year in
                                Text(yearFormatter.string(from: NSNumber(value: year)) ?? "\(year)").tag(year)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .onChange(of: selectedYear) {
                            date = updateDateForNewMonthOrYear(newMonth: selectedMonth, newYear: selectedYear, date				: date)
                            days = date.calendarDisplayDays
                        }
                        Button("Done") {
                            isYearPickerPresented = false
                        }
                    }
                }
                
                Spacer()
                
                Button(){
                    if selectedMonth > 1 {
                        selectedMonth -= 1
                    } else {
                        selectedYear -= 1
                        selectedMonth = 12
                    }
                    date = updateDateForNewMonthOrYear(newMonth: selectedMonth, newYear: selectedYear, date: date)
                    days = date.calendarDisplayDays
                } label: {
                    Image(systemName: "arrowshape.backward.fill")
                }
                Button(){
                    if selectedMonth < 12 {
                        selectedMonth += 1
                    } else {
                        selectedYear += 1
                        selectedMonth = 1
                    }
                    date = updateDateForNewMonthOrYear(newMonth: selectedMonth, newYear: selectedYear, date: date)
                    days = date.calendarDisplayDays
                } label: {
                    Image(systemName: "arrowshape.forward.fill")
                }
            }
            .padding()
            
            HStack {
                ForEach(daysOfWeek.indices, id: \.self) { index in
                    Text(daysOfWeek[index])
                        .fontWeight(.black)
                        .foregroundStyle(Color.green)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding()
            
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
            .padding()
            .onAppear {
                days = date.calendarDisplayDays
                updateEntriesDatesIfNeeded()
            }
            
            List {
                ForEach(moodEntries, id: \.self) { entry in
                    if Calendar.current.isDate(entry.date ?? Date(), inSameDayAs: date) {
                        EntryView(entry: entry)
                    }
                }.onDelete(perform: deleteEntries)
            }
        }
        .padding()
        .navigationTitle("Mood Calendar")
    }
    
    private func updateEntriesDatesIfNeeded() {
        guard entriesDates.isEmpty else { return }
        entriesDates = getEntriesDate(moodEntries: moodEntries)
    }
    
    private func deleteEntries(at offsets: IndexSet) {
        for index in offsets {
            let entry = moodEntries[index]
            PersistenceController.shared.deleteMoodEntry(entry)
        }
    }
}

#Preview {
    CalendarView()
}
