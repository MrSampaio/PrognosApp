# 📈 Prognos: Investment Simulator and Comparison Tool
Prognos is a smart investment simulator and comparison tool that aims to help users make better investment choices. The program has an easy to use interface for selecting investment categories, entering investment information, and modeling investment results. Prognos allows consumers to see full results, test different investment scenarios and make investment decisions based on data.

## 🚀 Features
- **Investment Selection**: Users are able to compare up to two types of investments.
- **Investment Details**: The user is able to enter details of the investment they choose, such as the amount and the duration.
- **Simulation Results**: The application simulates the results of investment and presents the results in a clear and easy to understand format.
- **Comparison**: Users can compare results of different investment scenarios.
- **Responsive Design**: The application is responsive, so it works well on different devices and screen sizes.

## 🛠️ Tech Stack
- **Frontend**: SwiftUI
- **Backend**: Not applicable (client-side application)
- **Database**: Not applicable (client-side application)
- **AI Tools**: Not applicable
- **Build Tools**: Xcode
- **Frameworks**: Combine, UIKit (for UIPageControl customization)
- **Libraries**: Charts (for creating charts in the results view)

## 📱 System Showcase

<div align="center">
  <img src="./assets/mockup.png" alt="PrognosApp Cross-Platform" width="1000"/>
</div>

<br>

## 📱 System in Action: Core Flow

Experience the seamless journey from asset selection to the final reactive dashboard, engineered and tailored natively for both platforms.

| 📱 iOS Experience | 💻 macOS Experience |
| :---: | :---: |
| <img src="./assets/full_ios.gif" width="260" alt="iOS Core Flow"/> | <img src="./assets/full_mac.gif" width="500" alt="macOS Core Flow"/> |
| *Mobile-first flow: intuitive asset selection, dynamic state validations, and touch-optimized results.* | *Desktop-first flow: split-screen dashboard, expansive charts, and comprehensive data visualization.* |

### 💻 macOS: Dashboard & Reactive Charts
The macOS interface leverages wider screens to display parameters and results simultaneously. 

<div align="center">
  <img src="./assets/mac_simulation.gif" alt="macOS Charts Animation" width="700"/>
  <p><i>The Charts framework reacting smoothly to inflation scenarios and data state changes.</i></p>
</div>

<br>

| Asset Selection & UI States | Search & Accordion Components |
| :---: | :---: |
| <img src="./assets/selecao_ios.gif" width="260"/> | <img src="./assets/search_ios.gif" width="260"/> |
| *State-driven limits restrict selection to 2 assets, dynamically enabling the Call-to-Action.* | *Real-time search filtering and custom accordion views for educational content.* |
---

## 📦 Installation & Build

PrognosApp is a native Apple ecosystem project. To run it locally, follow these steps:

**1. Clone the repository**

Open your Terminal and run:

```bash
git clone https://github.com/MrSampaio/PrognosApp.git
```

**2. Open the project in Xcode**

Navigate to the cloned folder and double-click the `.xcodeproj` file to open it in Xcode.

**3. Select the Build Target**

Because PrognosApp is cross-platform, you must select the appropriate scheme before building. In the Xcode top toolbar, click on the active scheme name (next to the Stop button) and choose:

- **For Mobile**: Select the `PrognosApp` scheme → Choose an iPhone Simulator (e.g., iPhone 15 Pro) or your connected physical device.
- **For Desktop**: Select the `Prognos Mac` (or `PrognosMacApp`) scheme → Choose `My Mac`.

**4. Compile and Run**

Press `Cmd + R` or click the Play (▶) button. Xcode will resolve any internal dependencies, compile the Swift code, and launch the application.

---

## 💻 Usage Guide

Once the application is compiled and running, explore the simulation engine by following the core flow:

1. **Asset Selection**: From the Home screen, click "Consultar". Browse the catalog and select the fixed-income assets you want to compare. The system enforces a strict selection limit to ensure UI consistency (up to 2 assets on iOS and 4 assets on macOS).

2. **Define Parameters**: After confirming your selection, enter the global variables: Investment Amount (*Valor*) and Time Horizon in years (*Tempo*). The app will dynamically display specific input fields (e.g., *Taxa Prefixada*, *Percentual do CDI*) tailored to the exact asset types you chose.

3. **Simulate & Analyze**: Click "Simular" to calculate the projections and render the dashboard.
   - **Interactive Charts**: The line chart displays the projected growth over time.
   - **Real vs. Nominal**: Toggle the "Considerar inflação" switch to instantly convert nominal values into real purchasing power (discounting inflation).
   - **Stress Testing**: Use the directional arrows (`<` | `>`) to cycle through different macroeconomic scenarios (Controlled, High, or Historical Inflation) and watch the chart react in real-time.
   - **The Verdict**: Scroll to the bottom to see the final net profit calculations, where the most profitable asset is automatically highlighted in green.

---
## 📂 Project Structure
```
Prognos
├── Prognos
│   ├── PrognosApp.swift
│   ├── ContentView.swift
│   ├── ViewModel
│   │   ├── InformacaoInvestimentoViewModel.swift
│   │   ├── TelaInvestimentosViewModel.swift
│   │   ├── TelaResultadosViewModel.swift
│   ├── Model
│   │   ├── CardModel.swift
│   │   ├── CenarioInvestimentoModel.swift
│   │   ├── SimulacaoModel.swift
│   ├── View
│   │   ├── TelaSelecaoView.swift
│   │   ├── TelaInformacoesView.swift
│   │   ├── TelaInvestimentosView.swift
│   │   ├── HomeView.swift
│   │   ├── TelaSimuladorView.swift
│   │   ├── TelaResultadosView.swift
```

## 🍎 Thank you, Apple Developer Academy teammates!

This project was developed in collaboration with [@Leo-gsilva](https://github.com/Leo-gsilva), [@marifracarolis2-arch](https://github.com/marifracarolis2-arch), and [@naaclaraa](https://github.com/naaclaraa). Without you, guys, this wouldn't have been possible! ❤️
