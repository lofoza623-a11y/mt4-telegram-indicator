# Changelog

All notable changes to the MT4 Telegram Alert Indicator will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-01-15

### Initial Release

#### Added
- ✅ Core indicator functionality with MA crossover signal detection
- ✅ Telegram Bot API integration for real-time alerts
- ✅ Customizable input parameters via MT4 interface
- ✅ Multiple alert methods (Telegram, popup, email, sound)
- ✅ Duplicate signal prevention system
- ✅ HTTP request retry logic with configurable attempts
- ✅ URL encoding for special characters in messages
- ✅ Visual signal arrows on chart (buy/sell indicators)
- ✅ Multi-timeframe support (M1 to MN1)
- ✅ Debug mode for troubleshooting
- ✅ Error handling and logging
- ✅ Alert-only-on-new-bar option to prevent repainting
- ✅ Configurable minimum bars between signals
- ✅ Support for different MA methods (SMA, EMA, SMMA, LWMA)
- ✅ Comprehensive documentation (README, QUICKSTART, EXAMPLES, TROUBLESHOOTING)
- ✅ Example configurations for different trading strategies
- ✅ MIT License

#### Features

**Telegram Integration**
- Real-time message delivery to personal chats or groups
- Formatted alert messages with emoji support
- Bot token and chat ID configuration
- Automatic retry on API failures
- Error response handling

**Signal Detection**
- Moving Average crossover strategy
- Buy signal: Fast MA crosses above Slow MA
- Sell signal: Fast MA crosses below Slow MA
- Configurable MA periods (Fast and Slow)
- Support for SMA, EMA, SMMA, and LWMA
- Applied price selection (Close, Open, High, Low, etc.)

**Alert System**
- Telegram messages with detailed signal information
- MT4 popup alerts
- Email notifications (requires MT4 email setup)
- Sound alerts with custom sound file support
- Visual arrows on chart (green for buy, red for sell)

**Duplicate Prevention**
- Track last signal type and bar index
- Minimum bars between same signal types
- Separate tracking for buy and sell signals
- Alert-only-on-new-bar option

**Error Handling**
- Validation of input parameters
- Internet connection error handling
- API response verification
- Detailed error logging in MT4 terminal
- User-friendly warning messages

**Customization**
- 20+ configurable parameters
- Organized input sections
- Enable/disable individual alert types
- Adjustable signal sensitivity
- Debug mode toggle

#### Documentation
- Comprehensive README with setup guide
- Quick start guide (5-minute setup)
- Example configurations for different strategies
- Detailed troubleshooting guide
- Code comments for non-programmers
- Strategy recommendations by timeframe

#### Known Limitations
- Windows-only (uses WinINet DLL)
- Requires active internet connection
- Telegram API rate limits apply (30 messages/second)
- Signal detection limited to MA crossover in initial release

---

## [Unreleased]

### Planned Features for Future Releases

#### Version 1.1.0 (Planned)
- [ ] Additional indicator support (RSI, MACD, Stochastic)
- [ ] Multiple indicator confirmation
- [ ] Session-based filtering (London, New York, Asian)
- [ ] Custom message templates
- [ ] Stop Loss / Take Profit calculation
- [ ] Risk-to-reward ratio in alerts

#### Version 1.2.0 (Planned)
- [ ] Multi-currency monitoring from single chart
- [ ] Signal strength indicator (weak/medium/strong)
- [ ] Historical signal performance tracking
- [ ] Alert scheduling (only alert during specific hours)
- [ ] Weekend/holiday alert suppression
- [ ] Custom sound files per signal type

#### Version 2.0.0 (Planned)
- [ ] Machine learning signal filtering
- [ ] News event integration
- [ ] Sentiment analysis
- [ ] Trade copier functionality
- [ ] Web dashboard for monitoring
- [ ] Mobile app integration

---

## Version History

| Version | Release Date | Status      | Description                          |
|---------|--------------|-------------|--------------------------------------|
| 1.0.0   | 2024-01-15   | ✅ Released | Initial release with core features   |

---

## Migration Guide

### From Pre-release to 1.0.0

This is the initial release. No migration needed.

---

## Support and Feedback

If you encounter bugs or have feature requests:

1. Check [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for known issues
2. Enable debug mode and review terminal logs
3. Submit detailed bug reports with:
   - MT4 build number
   - Indicator settings used
   - Error messages from terminal
   - Steps to reproduce

---

## Contributing

We welcome contributions! Future changelog entries should follow this format:

```markdown
## [Version] - YYYY-MM-DD

### Added
- New features

### Changed
- Changes to existing features

### Deprecated
- Features marked for removal

### Removed
- Removed features

### Fixed
- Bug fixes

### Security
- Security improvements
```

---

## Development Roadmap

### Q1 2024
- ✅ Initial release (v1.0.0)
- Additional indicator support
- Documentation improvements

### Q2 2024
- Multi-indicator confirmation
- Session filtering
- Performance optimizations

### Q3 2024
- Advanced customization options
- Signal strength analysis
- Historical performance tracking

### Q4 2024
- Web dashboard (preview)
- Enhanced error handling
- Community feature requests

---

**Stay Updated**: Watch the repository for updates and new releases!

**Current Version**: 1.0.0
**Last Updated**: 2024-01-15
