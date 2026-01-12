# Changelog

All notable changes to the MT4 Multi-Indicator Telegram Alert System will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2024-01-15

### 🎉 Major Update - Multi-Indicator Support

This is a complete rewrite of the indicator system, transforming it from a simple MA crossover indicator to a powerful multi-indicator confirmation system.

### Added
- **Multi-Indicator Support**: Monitor up to 3 external indicators simultaneously
- **Flexible Confirmation Logic**: 
  - Single mode: Any 1 indicator triggers
  - All mode: All enabled indicators must confirm (AND logic)
  - Majority mode: At least 2 indicators must confirm
  - Any mode: At least 1 indicator confirms (OR logic)
- **Independent Timeframe Selection**: Each indicator can analyze different timeframes (M1, M5, M15, M30, H1, H4, D1, W1, or Current)
- **Entry Timing Control**: Choose between "Same Candle" or "Next Candle" entry for each indicator
- **Custom Buffer Selection**: Configure buy and sell buffer numbers (0-7) for any indicator
- **Custom Indicator Names**: User-defined labels for each indicator slot
- **Enhanced Telegram Alerts**: Messages now show:
  - Which indicators triggered the signal
  - How many indicators confirmed out of total enabled
  - Confirmation mode used
  - All timeframes involved
- **Comprehensive Validation**:
  - Buffer number validation (must be 0-7)
  - Enabled indicator count validation
  - Confirmation mode compatibility checks
  - Telegram configuration validation
- **Advanced Debug Logging**: Detailed information about:
  - Indicator initialization
  - Buffer values being read
  - Signal detection from each indicator
  - Confirmation logic evaluation
- **IndicatorConfig Structure**: Organized configuration management for each indicator
- **Enhanced Duplicate Prevention**: Separate tracking for buy and sell signals

### Changed
- **Complete Code Rewrite**: From MA crossover to external indicator monitoring
- **Alert Message Format**: Now includes multi-indicator confirmation details
- **Parameter Organization**: Grouped into logical sections:
  - Telegram Settings
  - Indicator 1/2/3 Settings
  - Confirmation Settings
  - Alert Settings
  - Advanced Settings
- **Signal Detection Logic**: Now uses iCustom() to read external indicator buffers
- **Indicator Short Name**: Displays confirmation mode and number of active indicators
- **Version Number**: Updated to 2.0.0 to reflect major changes

### Removed
- **Built-in MA Crossover Logic**: Removed hardcoded moving average calculation
- **MA-specific Parameters**: Removed FastMA_Period, SlowMA_Period, MA_Method, MA_Price
- **Simple Signal Detection**: Replaced with flexible buffer-based system

### Fixed
- **Signal Timing**: More precise control over when signals trigger
- **Duplicate Alerts**: Improved prevention with separate buy/sell tracking
- **Timeframe Handling**: Better support for multi-timeframe analysis

### Technical Details
- Added `EntryTiming` enum for same/next candle control
- Added `ConfirmationMode` enum for signal confirmation logic
- Added `CustomTimeframe` enum for timeframe selection
- Added `IndicatorConfig` struct to organize indicator settings
- Implemented `CheckIndicatorSignal()` function to read indicator buffers
- Implemented `EvaluateConfirmation()` function to apply confirmation logic
- Implemented `GetTimeframeValue()` function to convert enum to MT4 timeframe constants
- Implemented `GetConfirmationModeString()` function for user-friendly display
- Enhanced `SendAlert()` to handle multiple indicator names
- Improved `ShouldSendAlert()` with separate buy/sell tracking

### Performance
- Lightweight design maintained despite added functionality
- Only enabled indicators are checked (no wasted computation)
- Efficient buffer reading using iCustom()
- Smart caching prevents redundant calculations

### Documentation
- Completely rewritten README.md with multi-indicator focus
- Added detailed "How to Find Buffer Numbers" section
- Added "Confirmation Logic Explained" section
- Added 4 comprehensive example configurations
- Expanded troubleshooting guide
- Added "Understanding Entry Timing" section
- Added "Best Practices for Multi-Indicator Trading" section
- Updated all screenshots and examples (if applicable)

## [1.0.0] - 2024-01-10

### Added
- Initial release of MT4 Telegram Alert Indicator
- Basic MA crossover signal detection
- Telegram Bot integration with retry logic
- Multiple alert methods (Telegram, popup, email, sound)
- Duplicate prevention system
- Configurable MA periods and methods
- Debug mode for troubleshooting
- Comprehensive README documentation
- Quick start guide
- Troubleshooting section

### Features
- Fast and Slow Moving Average crossover detection
- Buy signal: Fast MA crosses above Slow MA
- Sell signal: Fast MA crosses below Slow MA
- Real-time Telegram notifications
- Visual arrows on chart
- MT4 popup alerts
- Email notifications
- Sound alerts
- Minimum bars between signals filter
- Alert only on new bar option
- HTTP request with retry logic using WinINet
- URL encoding for special characters
- Input parameter validation
- Error handling and logging

### Technical Implementation
- Used WinINet Windows API for HTTP requests
- Implemented indicator buffers for buy/sell signals
- Arrow indicators (233 for up, 234 for down)
- Series array handling for proper MT4 compatibility
- Signal tracking to prevent duplicates
- Timeframe string conversion
- Comprehensive input parameters organization

---

## Migration Guide: v1.0 to v2.0

If you're upgrading from version 1.0, here's what you need to know:

### Breaking Changes
1. **MA Parameters Removed**: The indicator no longer has built-in MA calculation
   - Old parameters like `FastMA_Period` and `SlowMA_Period` are gone
   - You now need to add MA indicators to your chart separately

2. **Configuration Structure**: Complete redesign of input parameters
   - Old settings won't transfer automatically
   - You'll need to reconfigure the indicator

### How to Migrate

#### Option 1: Use Built-in MT4 Indicators
1. Add MA or other indicators to your chart
2. Configure the Multi-Indicator system to read from them
3. Set appropriate buffer numbers

#### Option 2: Use Custom Indicators
1. Install your preferred custom indicators
2. Configure buffer numbers for buy/sell signals
3. Set confirmation logic based on your strategy

#### Option 3: Recreate MA Crossover Strategy
To replicate the old v1.0 MA crossover behavior:

1. Add two Moving Average indicators to your chart (Fast and Slow)
2. Add a custom MA crossover indicator that generates signals
3. Configure Indicator 1 to read from the MA crossover indicator:
   ```
   Indicator1_Enable = true
   Indicator1_Name = "MA Crossover"
   Indicator1_BuyBuffer = 0
   Indicator1_SellBuffer = 1
   Indicator1_Timing = Same Candle
   Indicator1_Timeframe = Current
   ```
4. Set Confirmation Mode to "Single"
5. Keep Indicator 2 and 3 disabled

### New Capabilities You Should Explore
- **Multi-timeframe analysis**: Run same indicator on H1, H4, and D1 simultaneously
- **Multiple indicator confirmation**: Combine RSI + MACD + MA for stronger signals
- **Flexible timing**: Choose same or next candle entry per indicator
- **Advanced filtering**: Use majority or all confirmation modes to reduce false signals

### Support
If you encounter issues during migration:
1. Enable debug mode to see what's happening
2. Test with one indicator first before adding more
3. Check the troubleshooting guide in README.md
4. Verify buffer numbers using Data Window

---

## Future Roadmap

### Planned Features (v2.1+)
- [ ] Support for up to 5 indicators (increased from 3)
- [ ] Visual indicator status panel on chart
- [ ] Signal history log file
- [ ] Configurable alert templates
- [ ] Multi-symbol monitoring from single chart
- [ ] Web dashboard for alert history
- [ ] SMS alerts integration
- [ ] Discord/Slack integration
- [ ] Advanced filter: Time-of-day trading windows
- [ ] Advanced filter: News event avoidance
- [ ] Backtesting mode for strategy validation
- [ ] Performance statistics tracking
- [ ] Alert priority levels (high/medium/low)
- [ ] Customizable alert cooldown periods per indicator

### Under Consideration
- Machine learning signal scoring
- Cloud-based signal aggregation
- Mobile app integration
- Social trading features
- Automated trade execution (EA mode)

### Community Requests
Have a feature request? Open an issue on GitHub or contribute to the project!

---

## Known Issues

### Version 2.0.0
- None reported yet

### Version 1.0.0
- ✅ **Fixed in v2.0**: Limited to single indicator type (MA only)
- ✅ **Fixed in v2.0**: No multi-timeframe support
- ✅ **Fixed in v2.0**: No confirmation logic options

---

## Upgrade Instructions

### From v1.0 to v2.0

1. **Backup your current settings**
   - Take a screenshot of your v1.0 indicator settings
   - Note your Telegram Bot Token and Chat ID

2. **Remove old indicator**
   - Right-click chart → Indicators List
   - Select old indicator → Delete

3. **Install v2.0**
   - Copy new `TelegramAlertIndicator.mq4` to `MQL4/Indicators` folder
   - Restart MT4 or refresh Navigator

4. **Compile new version**
   - Open MetaEditor (F4)
   - Open `TelegramAlertIndicator.mq4`
   - Compile (F7)

5. **Add indicators to chart**
   - If replicating MA strategy: Add MA crossover indicator
   - If using new features: Add your preferred indicators

6. **Configure v2.0**
   - Drag new indicator to chart
   - Enter Telegram Bot Token and Chat ID
   - Configure indicator slots
   - Set confirmation mode
   - Test with debug mode enabled

7. **Verify functionality**
   - Check MT4 Terminal for initialization messages
   - Wait for a signal or trigger manually
   - Verify Telegram alert received

---

## Contributing

We welcome contributions! See [CONTRIBUTING.md] for guidelines.

### Recent Contributors
- Initial development team
- Community testers
- Documentation contributors

---

## License

This project is licensed under the MIT License - see [LICENSE](LICENSE) file for details.

---

**Note**: This changelog is maintained manually. For detailed commit history, see the git log.
