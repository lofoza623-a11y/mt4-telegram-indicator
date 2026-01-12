//+------------------------------------------------------------------+
//|                                        TelegramAlertIndicator.mq4 |
//|                          Multi-Indicator Telegram Alert System   |
//|                                    https://github.com/yourrepo    |
//+------------------------------------------------------------------+
#property copyright "Custom MT4 Multi-Indicator Telegram Alert System"
#property link      "https://github.com/yourrepo"
#property version   "2.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 clrLime
#property indicator_color2 clrRed
#property indicator_width1 2
#property indicator_width2 2

//--- Enums
enum EntryTiming
{
   ENTRY_SAME_CANDLE = 0,    // Signal on current candle close
   ENTRY_NEXT_CANDLE = 1     // Signal on next candle open
};

enum ConfirmationMode
{
   CONFIRM_SINGLE = 0,       // Any single indicator triggers (OR logic)
   CONFIRM_ALL = 1,          // All enabled indicators must confirm (AND logic)
   CONFIRM_MAJORITY = 2,     // At least 2 indicators must confirm
   CONFIRM_ANY = 3           // At least 1 indicator confirms (same as SINGLE)
};

enum CustomTimeframe
{
   TF_CURRENT = 0,           // Use chart timeframe
   TF_M1 = 1,                // 1 Minute
   TF_M5 = 5,                // 5 Minutes
   TF_M15 = 15,              // 15 Minutes
   TF_M30 = 30,              // 30 Minutes
   TF_H1 = 60,               // 1 Hour
   TF_H4 = 240,              // 4 Hours
   TF_D1 = 1440,             // Daily
   TF_W1 = 10080             // Weekly
};

//--- Input Parameters - Telegram Settings
input string    Section1 = "========== Telegram Settings ==========";
input string    TelegramBotToken = "";                    // Telegram Bot Token
input string    TelegramChatID = "";                      // Telegram Chat ID
input bool      EnableTelegramAlerts = true;              // Master Alert Toggle
input int       MaxRetries = 3;                           // API Request Max Retries
input int       RetryDelayMS = 2000;                      // Retry Delay (milliseconds)

//--- Input Parameters - Indicator 1
input string    Section2 = "========== Indicator 1 Settings ==========";
input bool      Indicator1_Enable = true;                 // Enable Indicator 1
input string    Indicator1_Name = "Indicator 1";          // Custom Name
input int       Indicator1_BuyBuffer = 0;                 // Buy Signal Buffer Number
input int       Indicator1_SellBuffer = 1;                // Sell Signal Buffer Number
input EntryTiming Indicator1_Timing = ENTRY_SAME_CANDLE;  // Entry Timing
input CustomTimeframe Indicator1_Timeframe = TF_CURRENT;  // Timeframe

//--- Input Parameters - Indicator 2
input string    Section3 = "========== Indicator 2 Settings ==========";
input bool      Indicator2_Enable = false;                // Enable Indicator 2
input string    Indicator2_Name = "Indicator 2";          // Custom Name
input int       Indicator2_BuyBuffer = 0;                 // Buy Signal Buffer Number
input int       Indicator2_SellBuffer = 1;                // Sell Signal Buffer Number
input EntryTiming Indicator2_Timing = ENTRY_SAME_CANDLE;  // Entry Timing
input CustomTimeframe Indicator2_Timeframe = TF_CURRENT;  // Timeframe

//--- Input Parameters - Indicator 3
input string    Section4 = "========== Indicator 3 Settings ==========";
input bool      Indicator3_Enable = false;                // Enable Indicator 3
input string    Indicator3_Name = "Indicator 3";          // Custom Name
input int       Indicator3_BuyBuffer = 0;                 // Buy Signal Buffer Number
input int       Indicator3_SellBuffer = 1;                // Sell Signal Buffer Number
input EntryTiming Indicator3_Timing = ENTRY_SAME_CANDLE;  // Entry Timing
input CustomTimeframe Indicator3_Timeframe = TF_CURRENT;  // Timeframe

//--- Input Parameters - Confirmation Logic
input string    Section5 = "========== Confirmation Settings ==========";
input ConfirmationMode ConfirmMode = CONFIRM_SINGLE;      // Confirmation Logic Mode

//--- Input Parameters - Alert Settings
input string    Section6 = "========== Alert Settings ==========";
input bool      ShowArrowsOnChart = true;                 // Show Signal Arrows on Chart
input bool      SendPopupAlert = true;                    // Send MT4 Popup Alert
input bool      SendEmailAlert = false;                   // Send Email Alert
input bool      PlaySoundAlert = true;                    // Play Sound Alert
input string    AlertSoundFile = "alert.wav";             // Alert Sound File

//--- Input Parameters - Advanced Settings
input string    Section7 = "========== Advanced Settings ==========";
input int       DuplicatePreventionBars = 5;              // Bars to prevent duplicate alerts
input bool      EnableDebugMode = false;                  // Enable Debug Logging

//--- Indicator Buffers
double BuySignalBuffer[];
double SellSignalBuffer[];

//--- Global Variables
datetime lastBuyAlertTime = 0;
datetime lastSellAlertTime = 0;
int lastBuyAlertBar = -1;
int lastSellAlertBar = -1;

//--- Import Windows API for HTTP requests
#import "wininet.dll"
   int InternetOpenW(string, int, string, string, int);
   int InternetOpenUrlW(int, string, string, int, int, int);
   int InternetReadFile(int, uchar &buffer[], int, int &OneInt[]);
   int InternetCloseHandle(int);
#import

//+------------------------------------------------------------------+
//| Structure to hold indicator configuration                        |
//+------------------------------------------------------------------+
struct IndicatorConfig
{
   bool enabled;
   string name;
   int buyBuffer;
   int sellBuffer;
   EntryTiming timing;
   int timeframe;
};

//--- Indicator configurations array
IndicatorConfig indicators[3];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
   //--- Indicator buffers mapping
   SetIndexBuffer(0, BuySignalBuffer);
   SetIndexBuffer(1, SellSignalBuffer);
   
   //--- Set indicator styles
   SetIndexStyle(0, DRAW_ARROW);
   SetIndexArrow(0, 233);  // Up arrow
   SetIndexStyle(1, DRAW_ARROW);
   SetIndexArrow(1, 234);  // Down arrow
   
   //--- Set indicator labels
   SetIndexLabel(0, "Buy Signal");
   SetIndexLabel(1, "Sell Signal");
   
   //--- Initialize buffers as series
   ArraySetAsSeries(BuySignalBuffer, true);
   ArraySetAsSeries(SellSignalBuffer, true);
   
   //--- Initialize indicator configurations
   indicators[0].enabled = Indicator1_Enable;
   indicators[0].name = Indicator1_Name;
   indicators[0].buyBuffer = Indicator1_BuyBuffer;
   indicators[0].sellBuffer = Indicator1_SellBuffer;
   indicators[0].timing = Indicator1_Timing;
   indicators[0].timeframe = GetTimeframeValue(Indicator1_Timeframe);
   
   indicators[1].enabled = Indicator2_Enable;
   indicators[1].name = Indicator2_Name;
   indicators[1].buyBuffer = Indicator2_BuyBuffer;
   indicators[1].sellBuffer = Indicator2_SellBuffer;
   indicators[1].timing = Indicator2_Timing;
   indicators[1].timeframe = GetTimeframeValue(Indicator2_Timeframe);
   
   indicators[2].enabled = Indicator3_Enable;
   indicators[2].name = Indicator3_Name;
   indicators[2].buyBuffer = Indicator3_BuyBuffer;
   indicators[2].sellBuffer = Indicator3_SellBuffer;
   indicators[2].timing = Indicator3_Timing;
   indicators[2].timeframe = GetTimeframeValue(Indicator3_Timeframe);
   
   //--- Validation
   int enabledCount = 0;
   for(int i = 0; i < 3; i++)
   {
      if(indicators[i].enabled)
      {
         enabledCount++;
         
         //--- Validate buffer numbers
         if(indicators[i].buyBuffer < 0 || indicators[i].buyBuffer > 7)
         {
            Alert(StringFormat("ERROR: %s Buy Buffer must be between 0-7!", indicators[i].name));
            return(INIT_PARAMETERS_INCORRECT);
         }
         
         if(indicators[i].sellBuffer < 0 || indicators[i].sellBuffer > 7)
         {
            Alert(StringFormat("ERROR: %s Sell Buffer must be between 0-7!", indicators[i].name));
            return(INIT_PARAMETERS_INCORRECT);
         }
      }
   }
   
   if(enabledCount == 0)
   {
      Alert("WARNING: No indicators are enabled! Please enable at least one indicator.");
   }
   
   //--- Validate confirmation mode
   if(ConfirmMode == CONFIRM_MAJORITY && enabledCount < 2)
   {
      Alert("WARNING: Majority confirmation requires at least 2 enabled indicators!");
   }
   
   if(ConfirmMode == CONFIRM_ALL && enabledCount < 2)
   {
      Print("INFO: ALL confirmation mode with only one indicator enabled.");
   }
   
   //--- Telegram validation
   if(EnableTelegramAlerts && (TelegramBotToken == "" || TelegramChatID == ""))
   {
      Alert("WARNING: Telegram alerts enabled but Bot Token or Chat ID is empty!");
      Print("Please configure TelegramBotToken and TelegramChatID in indicator settings.");
   }
   
   //--- Set indicator short name
   string confirmModeStr = GetConfirmationModeString(ConfirmMode);
   string shortName = StringFormat("Multi-Indicator Alert [%s] - %d Active", confirmModeStr, enabledCount);
   IndicatorShortName(shortName);
   
   //--- Log initialization
   if(EnableDebugMode)
   {
      Print("========================================");
      Print("Multi-Indicator Telegram Alert System Initialized");
      Print("Enabled Indicators: ", enabledCount);
      Print("Confirmation Mode: ", confirmModeStr);
      for(int i = 0; i < 3; i++)
      {
         if(indicators[i].enabled)
         {
            Print(StringFormat("  - %s [TF:%s, Buy:%d, Sell:%d, Timing:%s]", 
                  indicators[i].name,
                  GetTimeframeString(indicators[i].timeframe),
                  indicators[i].buyBuffer,
                  indicators[i].sellBuffer,
                  indicators[i].timing == ENTRY_SAME_CANDLE ? "Same Candle" : "Next Candle"));
         }
      }
      Print("========================================");
   }
   
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   if(EnableDebugMode)
      Print("Multi-Indicator Alert System deinitialized. Reason: ", reason);
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
   //--- Set arrays as series
   ArraySetAsSeries(time, true);
   ArraySetAsSeries(close, true);
   ArraySetAsSeries(high, true);
   ArraySetAsSeries(low, true);
   
   //--- Check for new bar
   static datetime lastBarTime = 0;
   bool isNewBar = false;
   
   if(time[0] != lastBarTime)
   {
      isNewBar = true;
      lastBarTime = time[0];
   }
   
   //--- Initialize current bar signals
   BuySignalBuffer[0] = EMPTY_VALUE;
   SellSignalBuffer[0] = EMPTY_VALUE;
   
   //--- Check each enabled indicator for signals
   string buyIndicators[];
   string sellIndicators[];
   int buyCount = 0;
   int sellCount = 0;
   
   for(int i = 0; i < 3; i++)
   {
      if(!indicators[i].enabled)
         continue;
      
      //--- Check buy signal
      if(CheckIndicatorSignal(i, true, isNewBar))
      {
         ArrayResize(buyIndicators, buyCount + 1);
         buyIndicators[buyCount] = indicators[i].name;
         buyCount++;
         
         if(EnableDebugMode)
            Print("Buy signal detected from: ", indicators[i].name);
      }
      
      //--- Check sell signal
      if(CheckIndicatorSignal(i, false, isNewBar))
      {
         ArrayResize(sellIndicators, sellCount + 1);
         sellIndicators[sellCount] = indicators[i].name;
         sellCount++;
         
         if(EnableDebugMode)
            Print("Sell signal detected from: ", indicators[i].name);
      }
   }
   
   //--- Evaluate confirmation logic
   bool buyConfirmed = EvaluateConfirmation(buyCount);
   bool sellConfirmed = EvaluateConfirmation(sellCount);
   
   //--- Process buy signal
   if(buyConfirmed)
   {
      if(ShowArrowsOnChart)
         BuySignalBuffer[0] = low[0] - (10 * Point);
      
      //--- Send alert (check for duplicates)
      if(ShouldSendAlert(true, time[0], Bars))
      {
         SendAlert("BUY", close[0], time[0], buyIndicators, buyCount);
         lastBuyAlertTime = time[0];
         lastBuyAlertBar = Bars;
      }
   }
   
   //--- Process sell signal
   if(sellConfirmed)
   {
      if(ShowArrowsOnChart)
         SellSignalBuffer[0] = high[0] + (10 * Point);
      
      //--- Send alert (check for duplicates)
      if(ShouldSendAlert(false, time[0], Bars))
      {
         SendAlert("SELL", close[0], time[0], sellIndicators, sellCount);
         lastSellAlertTime = time[0];
         lastSellAlertBar = Bars;
      }
   }
   
   return(rates_total);
}

//+------------------------------------------------------------------+
//| Check if indicator signal is present                             |
//+------------------------------------------------------------------+
bool CheckIndicatorSignal(int indicatorIndex, bool isBuy, bool isNewBar)
{
   IndicatorConfig config = indicators[indicatorIndex];
   
   //--- Determine which buffer to check
   int bufferIndex = isBuy ? config.buyBuffer : config.sellBuffer;
   
   //--- Determine the bar to check based on timing
   int barToCheck = 0;
   if(config.timing == ENTRY_NEXT_CANDLE && isNewBar)
      barToCheck = 0;  // Check current bar if it's a new bar
   else if(config.timing == ENTRY_SAME_CANDLE)
      barToCheck = 0;  // Always check current bar
   else
      return false;  // No signal if conditions not met
   
   //--- Read indicator buffer value
   double bufferValue = iCustom(NULL, config.timeframe, "", bufferIndex, barToCheck);
   
   //--- Check if buffer has a valid signal (not EMPTY_VALUE and not 0)
   if(bufferValue != EMPTY_VALUE && bufferValue != 0.0)
   {
      if(EnableDebugMode)
      {
         Print(StringFormat("Signal from %s: Buffer=%d, Value=%.5f, Bar=%d, TF=%s",
               config.name, bufferIndex, bufferValue, barToCheck, 
               GetTimeframeString(config.timeframe)));
      }
      return true;
   }
   
   return false;
}

//+------------------------------------------------------------------+
//| Evaluate if confirmation logic is satisfied                      |
//+------------------------------------------------------------------+
bool EvaluateConfirmation(int signalCount)
{
   //--- Count enabled indicators
   int enabledCount = 0;
   for(int i = 0; i < 3; i++)
   {
      if(indicators[i].enabled)
         enabledCount++;
   }
   
   if(enabledCount == 0 || signalCount == 0)
      return false;
   
   //--- Apply confirmation logic
   switch(ConfirmMode)
   {
      case CONFIRM_SINGLE:
      case CONFIRM_ANY:
         return signalCount >= 1;  // At least one signal
      
      case CONFIRM_ALL:
         return signalCount >= enabledCount;  // All enabled indicators
      
      case CONFIRM_MAJORITY:
         if(enabledCount >= 2)
            return signalCount >= 2;  // At least 2 indicators
         else
            return signalCount >= 1;  // Fall back to single if only 1 enabled
      
      default:
         return false;
   }
}

//+------------------------------------------------------------------+
//| Check if alert should be sent (duplicate prevention)             |
//+------------------------------------------------------------------+
bool ShouldSendAlert(bool isBuy, datetime currentTime, int currentBars)
{
   if(isBuy)
   {
      //--- Check time-based prevention
      if(lastBuyAlertTime > 0 && currentTime == lastBuyAlertTime)
         return false;
      
      //--- Check bar-based prevention
      if(lastBuyAlertBar > 0 && (currentBars - lastBuyAlertBar) < DuplicatePreventionBars)
         return false;
   }
   else
   {
      //--- Check time-based prevention
      if(lastSellAlertTime > 0 && currentTime == lastSellAlertTime)
         return false;
      
      //--- Check bar-based prevention
      if(lastSellAlertBar > 0 && (currentBars - lastSellAlertBar) < DuplicatePreventionBars)
         return false;
   }
   
   return true;
}

//+------------------------------------------------------------------+
//| Send Alert Function                                              |
//+------------------------------------------------------------------+
void SendAlert(string signalType, double price, datetime signalTime, string &triggeringIndicators[], int indicatorCount)
{
   //--- Format indicator list
   string indicatorList = "";
   for(int i = 0; i < indicatorCount; i++)
   {
      if(i > 0)
         indicatorList += ", ";
      indicatorList += triggeringIndicators[i];
   }
   
   //--- Get confirmation mode string
   string confirmModeStr = GetConfirmationModeString(ConfirmMode);
   
   //--- Count enabled indicators
   int enabledCount = 0;
   for(int i = 0; i < 3; i++)
   {
      if(indicators[i].enabled)
         enabledCount++;
   }
   
   //--- Format alert message
   string symbol = Symbol();
   string timeframe = GetTimeframeString(Period());
   string priceStr = DoubleToString(price, Digits);
   string timeStr = TimeToString(signalTime, TIME_DATE | TIME_MINUTES);
   
   string alertMessage = StringFormat(
      "🚨 MULTI-INDICATOR TRADING SIGNAL 🚨\n\n" +
      "📊 Signal: %s\n" +
      "💱 Pair: %s\n" +
      "⏰ Timeframe: %s\n" +
      "💰 Price: %s\n" +
      "📅 Time: %s\n\n" +
      "✅ Confirmation: %s\n" +
      "🎯 Indicators Triggered (%d of %d):\n" +
      "   %s\n\n" +
      "⚠️ Always verify signals before trading!",
      signalType, symbol, timeframe, priceStr, timeStr,
      confirmModeStr, indicatorCount, enabledCount, indicatorList
   );
   
   if(EnableDebugMode)
      Print("Alert triggered: ", signalType, " | Indicators: ", indicatorList);
   
   //--- Send Telegram Alert
   if(EnableTelegramAlerts && TelegramBotToken != "" && TelegramChatID != "")
   {
      bool telegramSent = SendTelegramMessage(alertMessage);
      if(EnableDebugMode)
         Print("Telegram alert sent: ", telegramSent);
   }
   
   //--- Send MT4 Popup Alert
   if(SendPopupAlert)
   {
      Alert(StringFormat("%s Signal on %s %s | %d indicators confirmed", 
            signalType, symbol, timeframe, indicatorCount));
   }
   
   //--- Play Sound Alert
   if(PlaySoundAlert)
   {
      PlaySound(AlertSoundFile);
   }
   
   //--- Send Email Alert
   if(SendEmailAlert)
   {
      string emailSubject = StringFormat("%s Signal - %s %s [%d indicators]", 
                                         signalType, symbol, timeframe, indicatorCount);
      SendMail(emailSubject, alertMessage);
   }
}

//+------------------------------------------------------------------+
//| Send Telegram Message Function                                   |
//+------------------------------------------------------------------+
bool SendTelegramMessage(string message)
{
   //--- URL encode the message
   string encodedMessage = UrlEncode(message);
   
   //--- Construct Telegram API URL
   string url = StringFormat(
      "https://api.telegram.org/bot%s/sendMessage?chat_id=%s&text=%s",
      TelegramBotToken, TelegramChatID, encodedMessage
   );
   
   //--- Send request with retry logic
   for(int attempt = 1; attempt <= MaxRetries; attempt++)
   {
      if(EnableDebugMode)
         Print("Sending Telegram message, attempt ", attempt, " of ", MaxRetries);
      
      string response = "";
      bool success = HttpRequest(url, response);
      
      if(success)
      {
         if(EnableDebugMode)
            Print("Telegram message sent successfully");
         return true;
      }
      else
      {
         Print("Failed to send Telegram message, attempt ", attempt);
         
         if(attempt < MaxRetries)
         {
            if(EnableDebugMode)
               Print("Retrying in ", RetryDelayMS, " ms...");
            Sleep(RetryDelayMS);
         }
      }
   }
   
   Print("ERROR: Failed to send Telegram message after ", MaxRetries, " attempts");
   return false;
}

//+------------------------------------------------------------------+
//| HTTP Request Function using WinINet                              |
//+------------------------------------------------------------------+
bool HttpRequest(string url, string &response)
{
   int hInternet = InternetOpenW("MT4 Telegram Bot", 0, "", "", 0);
   if(hInternet == 0)
   {
      Print("ERROR: InternetOpenW failed");
      return false;
   }
   
   int hUrl = InternetOpenUrlW(hInternet, url, "", 0, 0, 0);
   if(hUrl == 0)
   {
      Print("ERROR: InternetOpenUrlW failed");
      InternetCloseHandle(hInternet);
      return false;
   }
   
   uchar buffer[];
   ArrayResize(buffer, 4096);
   int bytesRead[1];
   string result = "";
   
   while(InternetReadFile(hUrl, buffer, ArraySize(buffer), bytesRead))
   {
      if(bytesRead[0] <= 0)
         break;
      result += CharArrayToString(buffer, 0, bytesRead[0], CP_UTF8);
   }
   
   InternetCloseHandle(hUrl);
   InternetCloseHandle(hInternet);
   
   response = result;
   
   //--- Check if response contains "ok":true
   if(StringFind(response, "\"ok\":true") >= 0)
      return true;
   
   return false;
}

//+------------------------------------------------------------------+
//| URL Encode Function                                              |
//+------------------------------------------------------------------+
string UrlEncode(string str)
{
   string result = "";
   uchar ch[];
   int len = StringToCharArray(str, ch, 0, WHOLE_ARRAY, CP_UTF8) - 1;
   
   for(int i = 0; i < len; i++)
   {
      uchar c = ch[i];
      
      //--- Keep alphanumeric and safe characters
      if((c >= 48 && c <= 57) ||   // 0-9
         (c >= 65 && c <= 90) ||   // A-Z
         (c >= 97 && c <= 122) ||  // a-z
         c == 45 || c == 46 || c == 95 || c == 126) // - . _ ~
      {
         result += CharToString(c);
      }
      //--- Encode space as +
      else if(c == 32)
      {
         result += "+";
      }
      //--- Percent-encode everything else
      else
      {
         result += StringFormat("%%%02X", c);
      }
   }
   
   return result;
}

//+------------------------------------------------------------------+
//| Get Timeframe String Function                                    |
//+------------------------------------------------------------------+
string GetTimeframeString(int period)
{
   switch(period)
   {
      case PERIOD_M1:  return "M1";
      case PERIOD_M5:  return "M5";
      case PERIOD_M15: return "M15";
      case PERIOD_M30: return "M30";
      case PERIOD_H1:  return "H1";
      case PERIOD_H4:  return "H4";
      case PERIOD_D1:  return "D1";
      case PERIOD_W1:  return "W1";
      case PERIOD_MN1: return "MN1";
      default:         return "Current";
   }
}

//+------------------------------------------------------------------+
//| Get Timeframe Value from Custom Enum                             |
//+------------------------------------------------------------------+
int GetTimeframeValue(CustomTimeframe tf)
{
   switch(tf)
   {
      case TF_CURRENT: return Period();
      case TF_M1:      return PERIOD_M1;
      case TF_M5:      return PERIOD_M5;
      case TF_M15:     return PERIOD_M15;
      case TF_M30:     return PERIOD_M30;
      case TF_H1:      return PERIOD_H1;
      case TF_H4:      return PERIOD_H4;
      case TF_D1:      return PERIOD_D1;
      case TF_W1:      return PERIOD_W1;
      default:         return Period();
   }
}

//+------------------------------------------------------------------+
//| Get Confirmation Mode String                                     |
//+------------------------------------------------------------------+
string GetConfirmationModeString(ConfirmationMode mode)
{
   switch(mode)
   {
      case CONFIRM_SINGLE:   return "Single (Any 1 indicator)";
      case CONFIRM_ALL:      return "All indicators required";
      case CONFIRM_MAJORITY: return "Majority (At least 2)";
      case CONFIRM_ANY:      return "Any (At least 1)";
      default:               return "Unknown";
   }
}
