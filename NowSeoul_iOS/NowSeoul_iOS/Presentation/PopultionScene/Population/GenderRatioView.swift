//
//  AgeDistributionView.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/24/24.
//

import UIKit
import DGCharts
import SnapKit
import Then


final class GenderRatioView: BaseView {
  private let pieChartView: PieChartView = .init(frame: .zero)
  
  override func configView() {
    super.configView()
    configurePieChart()
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
  
  func configureRatio(maleRatio: Double, femaleRatio: Double) {
    // 남성과 여성 비율을 기반으로 ChartDataEntry 배열 생성
    let dataEntries = [
      PieChartDataEntry(value: maleRatio, label: "남성"),
      PieChartDataEntry(value: femaleRatio, label: "여성")
    ]
    // 파이 차트 데이터 설정
    setPieData(with: dataEntries)
  }
}

extension GenderRatioView {
  private func configurePieChart() {
    pieChartView.do {
      $0.noDataText = "데이터를 불러올 수 없습니다."
      $0.noDataFont = .systemFont(ofSize: 16)
      $0.noDataTextColor = .gray
      $0.backgroundColor = .white
      $0.holeColor = UIColor.clear // 중앙의 구멍 색상을 투명하게 설정
      $0.transparentCircleColor = UIColor.clear // 중앙의 투명한 원 색상 설정
      
      // 레전드 스타일 설정
        $0.legend.enabled = false
        $0.legend.form = .circle // 레전드 마커 형태를 원으로 설정
        $0.legend.formSize = 12.0 // 레전드 마커의 크기를 늘림
        $0.legend.verticalAlignment = .bottom
        $0.legend.horizontalAlignment = .center
        $0.legend.orientation = .horizontal
        $0.legend.textColor = .darkGray
        $0.legend.font = .systemFont(ofSize: 16) // 레전드 라벨의 폰트 크기를 늘림
      
      
      // 항목 선택 시 애니메이션 효과
      $0.animate(xAxisDuration: 0.5, yAxisDuration: 0.5, easingOption: .easeOutSine)
    }
  }
  
  private func setPieData(with dataEntries: [ChartDataEntry]) {
    let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: "")
    
    // 색상 및 스타일 설정
    pieChartDataSet.colors = [UIColor.blue.withAlphaComponent(0.8), UIColor.systemPink.withAlphaComponent(0.9)]
    pieChartDataSet.sliceSpace = 2 // 각 조각 사이의 공간
    pieChartDataSet.selectionShift = 5 // 선택 시 조각의 이동 거리

    // 값의 텍스트 스타일 설정: 폰트 크기와 두께 조정
    pieChartDataSet.valueTextColor = UIColor.white
    pieChartDataSet.valueFont = .systemFont(ofSize: 16, weight: .bold) // 더 크고 두꺼운 폰트로 설정

    let pieChartData = PieChartData(dataSet: pieChartDataSet)
    pieChartView.data = pieChartData
    
    // 각 조각의 값 표시 형식을 백분율로 설정
    let formatter = NumberFormatter()
    formatter.numberStyle = .percent
    formatter.maximumFractionDigits = 1
    formatter.multiplier = 1.0
    pieChartData.setValueFormatter(DefaultValueFormatter(formatter: formatter))
    pieChartView.usePercentValuesEnabled = true
  }
}

@available(iOS 17.0, *)
#Preview {
  let view = GenderRatioView()
  view.configureRatio(maleRatio: 64.0, femaleRatio: 36.0)
  
  let stackView = UIStackView(
    arrangedSubviews: [
      view,
      PopulationView()
    ]
  ).then {
    $0.axis = .vertical
    $0.distribution = .fillEqually
  }
  
  return stackView
}
