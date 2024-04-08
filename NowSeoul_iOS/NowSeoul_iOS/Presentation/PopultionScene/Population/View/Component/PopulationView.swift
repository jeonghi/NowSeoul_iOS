//
//  PopulationView.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/27/24.
//

import UIKit
import DGCharts
import Then
import SnapKit

final class PopulationView: BaseView {
  let pieChartView: PieChartView = .init(frame: .zero)
  
  override func configView() {
    super.configView()
    configPieChartView()
  }
  
  override func configLayout() {
    super.configLayout()
    
    pieChartView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  override func configHierarchy() {
    super.configHierarchy()
    addSubview(pieChartView)
  }
  
  func configure(with model: SeoulPopulationDTO.Data?) {
    guard let data = model else { return }
    var entries: [PieChartDataEntry] = []
    
    if let rate0 = data.rate0 { entries.append(PieChartDataEntry(value: rate0, label: "10대 미만")) }
    if let rate10 = data.rate10 { entries.append(PieChartDataEntry(value: rate10, label: "10대")) }
    if let rate20 = data.rate20 { entries.append(PieChartDataEntry(value: rate20, label: "20대")) }
    if let rate30 = data.rate30 { entries.append(PieChartDataEntry(value: rate30, label: "30대")) }
    if let rate40 = data.rate40 { entries.append(PieChartDataEntry(value: rate40, label: "40대")) }
    if let rate50 = data.rate50 { entries.append(PieChartDataEntry(value: rate50, label: "50대")) }
    if let rate60 = data.rate60 { entries.append(PieChartDataEntry(value: rate60, label: "60대")) }
    if let rate70 = data.rate70 { entries.append(PieChartDataEntry(value: rate70, label: "70대 이상")) }
    
    let dataSet = PieChartDataSet(entries: entries, label: "연령대별 인구 비율")
    // 색상 템플릿을 설정하여 각 세그먼트에 다른 색상을 적용합니다.
    dataSet.colors = ChartColorTemplates.vordiplom() + ChartColorTemplates.joyful() + ChartColorTemplates.colorful()
    // 값의 텍스트 색상과 폰트를 설정합니다.
    dataSet.valueTextColor = UIColor.black
    dataSet.valueFont = .systemFont(ofSize: 12)
    dataSet.sliceSpace = 2 // 각 조각 사이의 공간
    dataSet.selectionShift = 5 // 선택 시 조각의 이동 거리
    
    let chartData = PieChartData(dataSet: dataSet)
    
    pieChartView.data = chartData
    pieChartView.rotationEnabled = false
  }
}

extension PopulationView {
  private func configPieChartView() {
    // 범례 스타일 조정
    pieChartView.legend.enabled = false
    pieChartView.legend.verticalAlignment = .bottom
    pieChartView.legend.horizontalAlignment = .left
    pieChartView.legend.orientation = .horizontal
    pieChartView.legend.drawInside = true
    pieChartView.legend.form = .circle
    pieChartView.legend.formSize = 12
    pieChartView.legend.font = UIFont.systemFont(ofSize: 12)
    pieChartView.legend.textColor = UIColor.darkGray
    
    
    // 중앙 텍스트 스타일링
    pieChartView.holeRadiusPercent = 0.5
    pieChartView.transparentCircleRadiusPercent = 0.55
    pieChartView.centerText = "연령대별"
    pieChartView.centerTextRadiusPercent = 1
  }
  
  //  // 연령대별 인구 비율을 담는 임시 모델 구조체
  //  struct SeoulPopulationDTO {
  //    struct Data {
  //      let rate0: Double?
  //      let rate10: Double?
  //      let rate20: Double?
  //      let rate30: Double?
  //      let rate40: Double?
  //      let rate50: Double?
  //      let rate60: Double?
  //      let rate70: Double?
  //    }
  //  }
}

@available(iOS 17.0, *)
#Preview {
  let view = PopulationView()
  return view
}
