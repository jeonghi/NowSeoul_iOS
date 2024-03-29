//
//  CongestionChartView.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/24/24.
//

import UIKit
import SnapKit
import DGCharts
import Then

final class CongestionChartView: BaseView {
  private var congestionLevelLabel = UILabel()
  private var barChartView: BarChartView = BarChartView()
  
  
  override func configView() {
    super.configView()
    configureLabel(with: nil)
    configureBarChartView()
  }
  
  override func configHierarchy() {
    super.configHierarchy()
    
    addSubview(congestionLevelLabel)
    addSubview(barChartView)
  }
  
  override func configLayout() {
    super.configLayout()
    
    congestionLevelLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalToSuperview().offset(40)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    barChartView.snp.makeConstraints {
      $0.top.equalTo(congestionLevelLabel.snp.bottom).offset(20)
      $0.horizontalEdges.equalTo(self).inset(20)
      $0.height.equalTo(300)
    }
  }
  
  
  // MARK: Iternal
  func configureChartData(with populationData: SeoulPopulationDTO.Data?) {
    guard let data = populationData else {
      print("No population data available")
      return
    }
    
    configureLabel(with: data.congestionLevel)
    
    guard let forecastData = data.forecastPopulation else {
      print("No population forecast data available")
      return
    }
    
    updateChartData(with: forecastData)
  }
}

// MARK: Private
extension CongestionChartView {
  private func updateChartData(with forecastData: [SeoulPopulationDTO.Forecast]) {
    var dataSets: [BarChartDataSet] = []
    let congestionLevels: [CongestionLevel] = CongestionLevel.allCases
    
    // 각 밀집도 레벨별로 데이터 세트 생성
    for level in congestionLevels {
      let entries = forecastData.enumerated().compactMap { index, forecast -> BarChartDataEntry? in
        guard forecast.congestionLevel == level else { return nil }
        let value = Double(forecast.populationMin ?? 0)
        return BarChartDataEntry(x: Double(index), y: value)
      }
      
      if !entries.isEmpty {
        let dataSet = BarChartDataSet(entries: entries, label: level.description)
        dataSet.setColor(level.color)
        dataSets.append(dataSet)
      }
    }
    
    let chartData = BarChartData(dataSets: dataSets)
    barChartView.data = chartData
    barChartView.notifyDataSetChanged()
    barChartView.animate(yAxisDuration: 2.0, easingOption: .easeInOutQuart)
  }
  
  private func configureLabel(with level: CongestionLevel?) {
    print(level)
    
    let replaceString = "-"
    let text = "지금은 인구혼잡도가 \(level?.title ?? replaceString) 상태예요"
    let attributedString = NSMutableAttributedString(string: text)
    let range = (text as NSString).range(of: level?.title ?? replaceString)
    
    // UILabel에 NSAttributedString 할당
    congestionLevelLabel.do {
      $0.attributedText = attributedString
      $0.textAlignment = .center
      $0.layer.cornerRadius = 10
      $0.clipsToBounds = true
    }
    
    // 'level' 부분에 대한 스타일 설정
    attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 24, weight: .bold), range: range)
    
    let levelColor: UIColor
    
    if let level {
      switch level {
      case .relaxed:
        levelColor = .systemGreen
      case .moderate:
        levelColor = .systemYellow
      case .slightlyCrowded:
        levelColor = .systemOrange
      case .crowded:
        levelColor = .systemRed
      }
    } else {
      levelColor = .systemGray
    }
    
    attributedString.addAttribute(.foregroundColor, value: levelColor, range: range)
    
    // 전체 텍스트 스타일 설정
    attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 22, weight: .black), range: range)
    
    congestionLevelLabel.attributedText = attributedString
  }
  
  private func configureBarChartView() {
    // 차트 기본 설정
    barChartView.backgroundColor = UIColor(named: "chartBackgroundColor") ?? .white
    barChartView.noDataText = "데이터가 없습니다."
    barChartView.noDataFont = .systemFont(ofSize: 16, weight: .medium)
    barChartView.noDataTextColor = .lightGray
    barChartView.drawValueAboveBarEnabled = false
    barChartView.drawMarkers = true
    
    
    // X축 스타일링
    barChartView.xAxis.do {
      $0.labelPosition = .bottom
      $0.valueFormatter = DateValueFormatter()
      $0.setLabelCount(4, force: false)
      $0.granularity = 2 // X축 라벨 간격
      $0.drawGridLinesEnabled = false
      $0.labelRotationAngle = 0 // X축 라벨 회전 각도 설정
      $0.labelTextColor = .gray
    }
    
    // Y축 스타일링
    barChartView.leftAxis.do {
      $0.labelTextColor = UIColor(named: "axisLabelColor") ?? .darkGray
      $0.gridColor = UIColor(named: "gridLineColor") ?? .lightGray
      $0.axisLineColor = UIColor(named: "axisLineColor") ?? .lightGray
      $0.labelFont = .systemFont(ofSize: 9)
      $0.enabled = true // Y축 활성화
      $0.setLabelCount(6, force: false)
      $0.granularity = 2000
      $0.drawGridLinesEnabled = true // Y축 그리드 라인 표시
      $0.valueFormatter = LargeValueFormatter() // 2천명 단위 포맷
      $0.gridLineDashLengths = [5, 5]
    }
    
    // RightAxis 비활성화
    barChartView.rightAxis.do {
      $0.enabled = false
    }
    
    // 마커 설정
    let marker = BalloonMarker()
    marker.color = .lightGray
    marker.textColor = .white
    marker.font = .systemFont(ofSize: 14, weight: .bold)
    barChartView.marker = marker
    
    // 차트 기타 스타일링
    barChartView.do {
      $0.legend.form = .line
      $0.doubleTapToZoomEnabled = false // 더블 탭으로 줌 인/아웃 비활성화
      $0.pinchZoomEnabled = false // 핀치 줌 인/아웃 비활성화
      $0.scaleXEnabled = false // 스케일 X 확대/축소 비활성화
      $0.scaleYEnabled = false // 스케일 Y 확대/축소 비활성화
      $0.animate(yAxisDuration: 2.0, easingOption: .easeInOutQuart) // 애니메이션 추가
    }
    
    // 레전드 스타일링
    barChartView.legend.font = .systemFont(ofSize: 14)
    barChartView.legend.textColor = UIColor(named: "legendTextColor") ?? .black
//    barChartView.legend.form = .square
    barChartView.legend.formSize = 12
    
    // 애니메이션 추가
    barChartView.animate(yAxisDuration: 1.5, easingOption: .easeInOutQuart)
  }
  
  // X축을 날짜 형식으로 포맷팅하는 클래스
  private final class DateValueFormatter: AxisValueFormatter {
    private let dateFormatter = DateFormatter()
    
    init() {
      dateFormatter.dateFormat = "a HH:mm" // 시간:분 형식
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
      let date = Date(timeIntervalSinceReferenceDate: value)
      return dateFormatter.string(from: date)
    }
  }
  
  private final class LargeValueFormatter: AxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
      let thousand = value / 1000
      return "\(Int(thousand))천명"
    }
  }
  
  
  private final class BalloonMarker: MarkerImage {
    var text = ""
    var color: UIColor = .white
    var textColor: UIColor = .black
    var font: UIFont = .systemFont(ofSize: 12)
    
    override func draw(context: CGContext, point: CGPoint) {
      let sizeForText = text.size(withAttributes: [.font: font])
      let rect = CGRect(origin: point, size: CGSize(width: sizeForText.width + 8, height: sizeForText.height + 8))
        .offsetBy(dx: -sizeForText.width / 2 - 4, dy: -sizeForText.height - 10)
      
      let clipPath = UIBezierPath(roundedRect: rect, cornerRadius: 4).cgPath
      context.addPath(clipPath)
      context.setFillColor(color.cgColor)
      context.closePath()
      context.fillPath()
      
      let attributes: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: textColor]
      
      let centeredStringRect = CGRect(x: rect.origin.x, y: rect.origin.y + (rect.height - sizeForText.height) / 2, width: rect.width, height: sizeForText.height)
      
      text.draw(in: centeredStringRect, withAttributes: attributes)
    }
    
    override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
      text = " \(Int(entry.y))명"
    }
  }
}

extension CongestionLevel {
  var color: UIColor {
    switch self {
    case .relaxed: return .systemGreen
    case .moderate: return .systemYellow
    case .slightlyCrowded: return .systemOrange
    case .crowded: return .systemRed
    }
  }
  
  var description: String {
    switch self {
    case .relaxed: return "여유"
    case .moderate: return "보통"
    case .slightlyCrowded: return "약간 혼잡"
    case .crowded: return "혼잡"
    }
  }
}
