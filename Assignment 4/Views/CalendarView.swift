import SwiftUI

struct CalendarView: View {
    @State private var moodEntries = PersistenceController.shared.fetchMoodEntries()
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
//            LazyVGrid(columns: Array(repeating: .init(), count: 7)) {
//                ForEach(moodEntries, id: \.date) { entry in
//                    Text(entry.mood ?? "")
//                        .frame(width: 40, height: 40)
//                        .background(Color.gray.opacity(0.2))
//                        .cornerRadius(5)
//                }
//            }
            
            HStack {
                // Month Button
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
                
                // Year Button
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
                        .onChange(of: selectedMonth) {
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
                        
                        // Define background color separately to simplify the expression
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
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Category: \(entry.mood ?? "Unknown")")
                                .font(.headline)
                            
                            if let quoteText = entry.quoteText {
                                Text("\"\(quoteText)\"")
                                    .font(.body)
                                    .foregroundColor(.primary)
                                    .italic()
                            }
                            
                            if let author = entry.quoteAuthor {
                                Text("- \(author)")
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                                    .italic()
                            }
                            
                            if let imageData = entry.photo, let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxHeight: 150)
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                            }
                        }
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(10)
                        .padding(.vertical, 5)
                    }
                }
            }
        }
        .padding()
        .navigationTitle("Mood Calendar")
    }
    
    private func updateEntriesDatesIfNeeded() {
        guard entriesDates.isEmpty else { return }
        entriesDates = getEntriesDate(moodEntries: moodEntries)
    }
}

#Preview {
    CalendarView()
}
