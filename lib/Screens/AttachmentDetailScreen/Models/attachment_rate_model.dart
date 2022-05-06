class AttachmentRateModel {
  late double hourlyRate, dailyRate, monthlyRate;
  late double hourlyWithFuelRate, dailyWithFuelRate, monthlyWithFuelRate;

  calculateOtherRates() {
    dailyRate = hourlyRate * 8;
    monthlyRate = dailyRate * 26;
    dailyWithFuelRate = hourlyWithFuelRate * 8;
    monthlyWithFuelRate = dailyWithFuelRate * 26;
  }

  AttachmentRateModel.fromMap(map) {
    try {
      hourlyRate = map['baseRate'];
    } catch (e) {
      hourlyRate = 0.0;
    }
    try {
      hourlyWithFuelRate = map['withFuelRate'];
    } catch (e) {
      hourlyWithFuelRate = 0.0;
    }
    calculateOtherRates();
  }
  AttachmentRateModel() {
    hourlyRate = 100;
    hourlyWithFuelRate = 100;
    calculateOtherRates();
  }
}
