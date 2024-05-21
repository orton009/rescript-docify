module Styles = CF_Styles

type trend = Increasing | Decreasing
type chartType = Half | Full

let halfChartIncreasing =
  <svg width="132" height="52" viewBox="0 0 132 52" fill="none" xmlns="http://www.w3.org/2000/svg">
    <g clipPath="url(#clip0_1202_23411)">
      <path
        d="M6.18608 31.3759L-1.01562 36.858V53.0156H133.047V4.83114L109.503 12.0444L93.7145 2.23438L82.081 14.0641L74.8793 12.0444L62.6918 23.0085L56.875 19.5462L48.2884 31.3759L35.2699 4.54261L24.1903 31.3759H6.18608Z"
        fill="url(#paint0_linear_1202_23411)"
        stroke="#0E9255"
        strokeWidth="1.5"
      />
    </g>
    <defs>
      <linearGradient
        id="paint0_linear_1202_23411"
        x1="66.0156"
        y1="-6.39844"
        x2="66.0156"
        y2="53.0156"
        gradientUnits="userSpaceOnUse">
        <stop stopColor="#12B76A" stopOpacity="0.5" />
        <stop offset="0.551288" stopColor="#76C8A2" stopOpacity="0.12" />
        <stop offset="1" stopColor="#D9D9D9" stopOpacity="0" />
        <stop offset="1" stopColor="#12B76A" stopOpacity="0" />
      </linearGradient>
      <clipPath id="clip0_1202_23411">
        <rect width="132" height="52" fill="white" />
      </clipPath>
    </defs>
  </svg>

let halfChartDecreasing: React.element =
  <svg width="132" height="52" viewBox="0 0 132 52" fill="none" xmlns="http://www.w3.org/2000/svg">
    <g clipPath="url(#clip0_1202_23424)">
      <path
        d="M6.18608 31.3759L-1.01562 36.858V53.0156H133.047V4.83114L109.503 12.0444L93.7145 2.23438L82.081 14.0641L74.8793 12.0444L62.6918 23.0085L56.875 19.5462L48.2884 31.3759L35.2699 4.54261L24.1903 31.3759H6.18608Z"
        fill="url(#paint0_linear_1202_23424)"
        stroke="#F04438"
        strokeWidth="1.5"
      />
    </g>
    <defs>
      <linearGradient
        id="paint0_linear_1202_23424"
        x1="66.0156"
        y1="-6.39844"
        x2="66.0156"
        y2="53.0156"
        gradientUnits="userSpaceOnUse">
        <stop stopColor="#F04438" stopOpacity="0.5" />
        <stop offset="0.551288" stopColor="#F04438" stopOpacity="0.12" />
        <stop offset="1" stopColor="#D9D9D9" stopOpacity="0" />
        <stop offset="1" stopColor="#F04438" stopOpacity="0" />
      </linearGradient>
      <clipPath id="clip0_1202_23424">
        <rect width="132" height="52" fill="white" />
      </clipPath>
    </defs>
  </svg>

let fullChartIncreasing =
  <svg width="216" height="49" viewBox="0 0 216 49" fill="none" xmlns="http://www.w3.org/2000/svg">
    <path
      d="M18.2719 12.8793C9.55176 11.9688 0 1.03129 0 1.03129V49H216V2.50002C214.402 -0.462741 206.08 30.4697 190.55 20.5805C184.035 16.4317 185.118 8.49493 177.499 6.36289C169.257 4.05702 165.209 13.5639 156.616 12.8793C147.028 12.1154 145.343 0.53223 135.734 1.03129C122.511 1.71806 129.993 27.6612 116.81 26.5045C107.993 25.7308 108.7 12.7568 99.8429 12.8793C93.3263 12.9694 91.9877 20.1669 85.4864 20.5805C78.0921 21.0509 75.9016 12.2709 68.5196 12.8793C62.2461 13.3963 61.1103 20.3564 54.8157 20.5805C45.7928 20.9017 46.7551 7.71116 37.8489 6.36289C29.8146 5.1466 26.3642 13.7242 18.2719 12.8793Z"
      fill="url(#paint0_linear_1202_23436)"
    />
    <path
      d="M0 1.01567C0 1.01567 9.55176 11.9532 18.2719 12.8637C26.3642 13.7086 29.8146 5.13097 37.8489 6.34727C46.7551 7.69554 45.7928 20.8861 54.8157 20.5649C61.1103 20.3408 62.2461 13.3807 68.5196 12.8637C75.9016 12.2553 78.0921 21.0353 85.4864 20.5649C91.9877 20.1513 93.3263 12.9538 99.8429 12.8637C108.7 12.7411 107.993 25.7152 116.81 26.4889C129.993 27.6456 122.511 1.70244 135.734 1.01567C145.343 0.516605 147.028 12.0998 156.616 12.8637C165.209 13.5483 169.257 4.0414 177.498 6.34727C185.118 8.4793 184.503 15.8574 190.55 20.5649C199.023 27.1615 212.589 12.1137 215.432 2.875"
      stroke="#0E9255"
      strokeWidth="2"
      strokeLinecap="round"
    />
    <defs>
      <linearGradient
        id="paint0_linear_1202_23436"
        x1="108"
        y1="1.01562"
        x2="108"
        y2="49"
        gradientUnits="userSpaceOnUse">
        <stop stopColor="#C6F6D5" stopOpacity="0.8" />
        <stop offset="1" stopColor="#C6F6D5" stopOpacity="0" />
      </linearGradient>
    </defs>
  </svg>

let fullChartDecreasing =
  <svg width="216" height="48" viewBox="0 0 216 48" fill="none" xmlns="http://www.w3.org/2000/svg">
    <path
      d="M18.2719 11.8793C9.55176 10.9688 0 0.0312935 0 0.0312935V48H216V31.4285C205.143 29.0263 199.023 26.1771 190.55 19.5805C184.503 14.873 185.118 7.49493 177.498 5.36289C169.257 3.05702 165.209 12.5639 156.616 11.8793C147.028 11.1154 145.343 -0.467769 135.734 0.0312935C122.511 0.718063 129.993 26.6612 116.81 25.5045C107.993 24.7308 108.7 11.7568 99.8429 11.8793C93.3263 11.9694 91.9877 19.1669 85.4864 19.5805C78.0921 20.0509 75.9016 11.2709 68.5196 11.8793C62.2461 12.3963 61.1103 19.3564 54.8157 19.5805C45.7928 19.9017 46.7551 6.71116 37.8489 5.36289C29.8146 4.1466 26.3642 12.7242 18.2719 11.8793Z"
      fill="url(#paint0_linear_1202_23450)"
    />
    <defs>
      <linearGradient
        id="paint0_linear_1202_23450"
        x1="108"
        y1="0.015625"
        x2="108"
        y2="48"
        gradientUnits="userSpaceOnUse">
        <stop stopColor="#F9B2AD" stopOpacity="0.55" />
        <stop offset="1" stopColor="#F9B2AD" stopOpacity="0" />
      </linearGradient>
    </defs>
  </svg>

let increasingTrend =
  <svg width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
    <path
      d="M10.3333 4L11.86 5.52667L8.60667 8.78L5.94 6.11333L1 11.06L1.94 12L5.94 8L8.60667 10.6667L12.8067 6.47333L14.3333 8V4H10.3333Z"
      fill="#12B76A"
    />
  </svg>
let decreasingTrend =
  <svg width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
    <path
      d="M10.3333 12L11.86 10.4733L8.60667 7.22L5.94 9.88667L1 4.94L1.94 4L5.94 8L8.60667 5.33333L12.8067 9.52667L14.3333 8V12H10.3333Z"
      fill="#F04438"
    />
  </svg>

type input = {
  header: string,
  trend: trend,
  totalVolume: string,
  changeInVolume: string,
}

@react.component
let make = (~input: input, ~chartType=Half) => {
  let trendColor = input.trend == Decreasing ? CF_Color.Red(#600) : CF_Color.Green(#600)
  let trendDom =
    <CF_Row>
      {input.trend == Increasing ? increasingTrend : decreasingTrend}
      <CF_Typography.TextMedium
        textSize={#"text-xs"} textColor=trendColor text=input.changeInVolume
      />
    </CF_Row>
  let innerDom = if chartType == Half {
    <CF_Row gap=0>
      <CF_Col gap=4>
        <CF_Typography.TextMedium text=input.header textColor=CF_Color.Gray(#1000) />
        <CF_Col gap=0>
          <CF_Typography.TextSemiBold
            textSize={#"text-3xl"} textColor=CF_Color.Gray(#2000) text=input.totalVolume
          />
          {trendDom}
        </CF_Col>
      </CF_Col>
      {input.trend == Increasing ? halfChartIncreasing : halfChartDecreasing}
    </CF_Row>
  } else {
    <CF_Col gap=4>
      <CF_Typography.TextMedium text=input.header textColor=CF_Color.Gray(#1000) />
      <CF_Col gap=0>
        <CF_Row gap=5>
          <CF_Typography.TextSemiBold
            textSize={#"text-3xl"} textColor=CF_Color.Gray(#2000) text=input.totalVolume
          />
          {trendDom}
        </CF_Row>
        {input.trend == Increasing ? fullChartIncreasing : fullChartDecreasing}
      </CF_Col>
    </CF_Col>
  }
  <CF_Box paddingStyle="px-4 py-3" className="w-fit"> {innerDom} </CF_Box>
}
