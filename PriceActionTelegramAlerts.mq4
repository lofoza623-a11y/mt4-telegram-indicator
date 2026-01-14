//+------------------------------------------------------------------+
//|                                 PriceActionTelegramAlerts.mq4      |
//|                    EA-Based Telegram Alert System for .ex4         |
//|                                    https://github.com/yourrepo    |
//+------------------------------------------------------------------+
#property copyright "EA-Based Telegram Alert System for Compiled Indicators"
#property link      "https://github.com/yourrepo"
#property version   "1.00"
#property strict

//--- Enums
enum EntryTiming
{
   ENTRY_SAME_CANDLE = 0,    // Signal on current candle close
   ENTRY_NEXT_CANDLE = 1     // Signal on next candle open
};

//--- Input Parameters - Telegram Settings
input string    Section1 = "========== Telegram Settings ==========";
input string    TelegramBotToken = "";                    // Telegram Bot Token
input string    TelegramChatID = "";                      // Telegram Chat ID
input bool      EnableTelegramAlerts = true;              // Master Alert Toggle
input int       MaxRetries = 3;                           // API Request Max Retries
input int       RetryDelayMS = 2000;                      // Retry Delay (milliseconds)

//--- Input Parameters - Indicator Settings
input string    Section2 = "========== Indicator Settings ==========";
input string    IndicatorName = "";                       // Exact .ex4 filename (e.g., MyPriceAction.ex4)
input int       BuyBufferNumber = 0;                      // Buy Signal Buffer Number (0-7)
input int       SellBufferNumber = 1;                     // Sell Signal Buffer Number (0-7)
input EntryTiming SignalTiming = ENTRY_SAME_CANDLE;      // Signal Timing
input bool      UseCurrentTimeframe = true;              // Use chart timeframe
input int       CustomTimeframe = PERIOD_H1;             // Custom timeframe if not current

//--- Input Parameters - Alert Settings
input string    Section3 = "========== Alert Settings ==========";
input bool      SendPopupAlert = true;                    // Send MT4 Popup Alert
input bool      SendEmailAlert = false;                   // Send Email Alert
input bool      PlaySoundAlert = true;                    // Play Sound Alert
input string    AlertSoundFile = "alert.wav";             // Alert Sound File

//--- Input Parameters - Advanced Settings
input string    Section4 = "========== Advanced Settings ==========";
input int       DuplicatePreventionBars = 5;              // Bars to prevent duplicate alerts
input bool      EnableDebugMode = false;                  // Enable Debug Logging
input bool      EnablePerformanceTracking = true;         // Track win/loss performance
input int       PerformanceTrackingBars = 20;             // Bars to hold trade for result
input double    TakeProfitPips = 50.0;                    // Take profit level in pips
input double    StopLossPips = 30.0;                      // Stop loss level in pips

//--- Global Variables
int lastBuyAlertBar = -1;
int lastSellAlertBar = -1;
datetime lastBuyAlertTime = 0;
datetime lastSellAlertTime = 0;

//--- Performance Tracking Variables
int totalTrades = 0;
int winningTrades = 0;
int losingTrades = 0;
double totalProfit = 0.0;
double totalLoss = 0.0;

//--- Active Trade Tracking
datetime lastBuySignalTime = 0;
datetime lastSellSignalTime = 0;
double lastBuySignalPrice = 0.0;
double lastSellSignalPrice = 0.0;
bool buyTradeActive = false;
bool sellTradeActive = false;

//--- Import Windows API for HTTP requests
#import "wininet.dll"
   int InternetOpenW(string, int, string, string, int);
   int InternetOpenUrlW(int, string, string, int, int, int);
   int InternetReadFile(int, uchar &buffer[], int, int &OneInt[]);
   int InternetCloseHandle(int);
#import

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   //--- Validate indicator name
   if(IndicatorName == "")
   {
      Alert("ERROR: IndicatorName parameter is empty! Please specify the .ex4 filename.");
      return(INIT_PARAMETERS_INCORRECT);
   }

   //--- Validate buffer numbers
   if(BuyBufferNumber < 0 || BuyBufferNumber > 7)
   {
      Alert("ERROR: BuyBufferNumber must be between 0-7!");
      return(INIT_PARAMETERS_INCORRECT);
   }

   if(SellBufferNumber < 0 || SellBufferNumber > 7)
   {
      Alert("ERROR: SellBufferNumber must be between 0-7!");
      return(INIT_PARAMETERS_INCORRECT);
   }

   //--- Validate Telegram settings
   if(EnableTelegramAlerts && (TelegramBotToken == "" || TelegramChatID == ""))
   {
      Alert("WARNING: Telegram alerts enabled but Bot Token or Chat ID is empty!");
      Print("Please configure TelegramBotToken and TelegramChatID in EA settings.");
   }

   //--- Log initialization
   if(EnableDebugMode)
   {
      Print("========================================");
      Print("EA-Based Telegram Alert System Initialized");
      Print("Indicator: ", IndicatorName);
      Print("Buy Buffer: ", BuyBufferNumber);
      Print("Sell Buffer: ", SellBufferNumber);
      Print("Timing: ", SignalTiming == ENTRY_SAME_CANDLE ? "Same Candle" : "Next Candle");
      Print("Timeframe: ", UseCurrentTimeframe ? "Current" : GetTimeframeString(CustomTimeframe));
      Print("========================================");
   }

   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   if(EnableDebugMode)
      Print("EA-Based Telegram Alert System deinitialized. Reason: ", reason);
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   //--- Check for new bar
   static datetime lastBarTime = 0;
   bool isNewBar = false;
   
   datetime currentTime = iTime(NULL, 0, 0);
   if(currentTime != lastBarTime)
   {
      isNewBar = true;
      lastBarTime = currentTime;
   }

   //--- Determine timeframe to use
   int timeframe = UseCurrentTimeframe ? Period() : CustomTimeframe;

   //--- Check for buy signal
   if(CheckSignal(true, timeframe, isNewBar))
   {
      if(ShouldSendAlert(true, currentTime, Bars))
      {
          SendAlert("BUY", Bid, currentTime);
          lastBuyAlertTime = currentTime;
          lastBuyAlertBar = Bars;
          
          //--- Start performance tracking for buy signal
          if(EnablePerformanceTracking)
          {
             lastBuySignalTime = currentTime;
             lastBuySignalPrice = Bid;
             buyTradeActive = true;
             sellTradeActive = false; // Close any active sell trade
          }
      }
   }

   //--- Check for sell signal
   if(CheckSignal(false, timeframe, isNewBar))
   {
      if(ShouldSendAlert(false, currentTime, Bars))
      {
          SendAlert("SELL", Ask, currentTime);
          lastSellAlertTime = currentTime;
          lastSellAlertBar = Bars;
          
          //--- Start performance tracking for sell signal
          if(EnablePerformanceTracking)
          {
             lastSellSignalTime = currentTime;
             lastSellSignalPrice = Ask;
             sellTradeActive = true;
             buyTradeActive = false; // Close any active buy trade
          }
      }
   }
   
   //--- Check performance of active trades
   if(EnablePerformanceTracking)
   {
      CheckTradePerformance();
      CheckPeriodicPerformanceReport();
   }
}

//+------------------------------------------------------------------+
//| Check if signal is present                                       |
//+------------------------------------------------------------------+
bool CheckSignal(bool isBuy, int timeframe, bool isNewBar)
{
   //--- Determine which buffer to check
   int bufferIndex = isBuy ? BuyBufferNumber : SellBufferNumber;

   //--- Determine the bar to check based on timing
   int barToCheck = 0;
   if(SignalTiming == ENTRY_NEXT_CANDLE && isNewBar)
   {
      barToCheck = 0;  // Check current bar if it's a new bar
   }
   else if(SignalTiming == ENTRY_SAME_CANDLE)
   {
      barToCheck = 0;  // Always check current bar
   }
   else
   {
      return false;  // No signal if conditions not met
   }

   //--- Read indicator buffer value
   double bufferValue = iCustom(NULL, timeframe, IndicatorName, bufferIndex, barToCheck);

   //--- Check if buffer has a valid signal (not EMPTY_VALUE and not 0)
   if(bufferValue != EMPTY_VALUE && bufferValue != 0.0)
   {
      if(EnableDebugMode)
      {
         Print(StringFormat("Signal detected: %s | Buffer=%d, Value=%.5f, Bar=%d, TF=%s",
               isBuy ? "BUY" : "SELL", bufferIndex, bufferValue, barToCheck,
               GetTimeframeString(timeframe)));
      }
      return true;
   }

   return false;
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
void SendAlert(string signalType, double price, datetime signalTime)
{
   //--- Format alert message
   string symbol = Symbol();
   string timeframe = GetTimeframeString(Period());
   string priceStr = DoubleToString(price, Digits);
   string timeStr = TimeToString(signalTime, TIME_DATE | TIME_MINUTES);

   string alertMessage = StringFormat(
      "🔔 TRADING SIGNAL\n\n" +
      "📊 Asset: %s\n" +
      "⏱️ Timeframe: %s\n" +
      "🎯 Signal: %s\n" +
      "💰 Price: %s\n" +
      "⌚ Time: %s\n\n" +
      "From: %s",
      symbol, timeframe, signalType, priceStr, timeStr, IndicatorName
   );

   if(EnableDebugMode)
      Print("Alert triggered: ", signalType, " | Price: ", price);

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
      Alert(StringFormat("%s Signal on %s %s | Price: %s", 
            signalType, symbol, timeframe, priceStr));
   }

   //--- Play Sound Alert
   if(PlaySoundAlert)
   {
      PlaySound(AlertSoundFile);
   }

   //--- Send Email Alert
   if(SendEmailAlert)
   {
      string emailSubject = StringFormat("%s Signal - %s %s", 
                                         signalType, symbol, timeframe);
      SendMail(emailSubject, alertMessage);
   }
   }

   //+------------------------------------------------------------------+
   //| Check Trade Performance Function                                 |
   //+------------------------------------------------------------------+
   void CheckTradePerformance()
   {
   //--- Calculate pips to points conversion
   double pipValue = Point;
   if(Digits == 3 || Digits == 5) // JPY pairs and some others
     pipValue = Point * 10;

   //--- Check buy trade performance
   if(buyTradeActive && lastBuySignalTime > 0)
   {
     //--- Calculate bars since signal
     int barsSinceSignal = Bars - iBarShift(NULL, 0, lastBuySignalTime);

     //--- Check if trade should be closed (after PerformanceTrackingBars)
     if(barsSinceSignal >= PerformanceTrackingBars)
     {
        double currentPrice = Bid;
        double entryPrice = lastBuySignalPrice;
        double resultPips = (currentPrice - entryPrice) / pipValue;

        //--- Determine win/loss based on take profit and stop loss
        bool isWinner = false;
        double tradeResult = 0.0;

        //--- Check if hit take profit
        if(resultPips >= TakeProfitPips)
        {
           isWinner = true;
           tradeResult = TakeProfitPips;
        }
        //--- Check if hit stop loss
        else if(resultPips <= -StopLossPips)
        {
           isWinner = false;
           tradeResult = -StopLossPips;
        }
        //--- If neither, use actual result
        else
        {
           isWinner = resultPips > 0;
           tradeResult = resultPips;
        }

        //--- Update statistics
        totalTrades++;
        if(isWinner)
        {
           winningTrades++;
           totalProfit += tradeResult;
        }
        else
        {
           losingTrades++;
           totalLoss += MathAbs(tradeResult);
        }

        //--- Send performance summary
        SendPerformanceSummary("BUY", entryPrice, currentPrice, resultPips, isWinner, tradeResult);

        //--- Reset trade tracking
        buyTradeActive = false;
        lastBuySignalTime = 0;
        lastBuySignalPrice = 0.0;
     }
   }

   //--- Check sell trade performance
   if(sellTradeActive && lastSellSignalTime > 0)
   {
     //--- Calculate bars since signal
     int barsSinceSignal = Bars - iBarShift(NULL, 0, lastSellSignalTime);

     //--- Check if trade should be closed (after PerformanceTrackingBars)
     if(barsSinceSignal >= PerformanceTrackingBars)
     {
        double currentPrice = Ask;
        double entryPrice = lastSellSignalPrice;
        double resultPips = (entryPrice - currentPrice) / pipValue;

        //--- Determine win/loss based on take profit and stop loss
        bool isWinner = false;
        double tradeResult = 0.0;

        //--- Check if hit take profit
        if(resultPips >= TakeProfitPips)
        {
           isWinner = true;
           tradeResult = TakeProfitPips;
        }
        //--- Check if hit stop loss
        else if(resultPips <= -StopLossPips)
        {
           isWinner = false;
           tradeResult = -StopLossPips;
        }
        //--- If neither, use actual result
        else
        {
           isWinner = resultPips > 0;
           tradeResult = resultPips;
        }

        //--- Update statistics
        totalTrades++;
        if(isWinner)
        {
           winningTrades++;
           totalProfit += tradeResult;
        }
        else
        {
           losingTrades++;
           totalLoss += MathAbs(tradeResult);
        }

        //--- Send performance summary
        SendPerformanceSummary("SELL", entryPrice, currentPrice, resultPips, isWinner, tradeResult);

        //--- Reset trade tracking
        sellTradeActive = false;
        lastSellSignalTime = 0;
        lastSellSignalPrice = 0.0;
     }
   }
   }

   //+------------------------------------------------------------------+
   //| Send Performance Summary Function                                |
   //+------------------------------------------------------------------+
   void SendPerformanceSummary(string signalType, double entryPrice, double exitPrice,
                          double resultPips, bool isWinner, double tradeResult)
   {
   //--- Calculate performance statistics
   double winRate = 0.0;
   double profitFactor = 0.0;
   if(totalTrades > 0)
   {
     winRate = (winningTrades * 100.0) / totalTrades;
     if(totalLoss > 0)
        profitFactor = totalProfit / totalLoss;
     else
        profitFactor = totalProfit;
   }

   //--- Format performance message
   string symbol = Symbol();
   string timeframe = GetTimeframeString(Period());
   string entryPriceStr = DoubleToString(entryPrice, Digits);
   string exitPriceStr = DoubleToString(exitPrice, Digits);
   string resultStr = DoubleToString(resultPips, 1);
   string tradeResultStr = DoubleToString(tradeResult, 1);

   string performanceMessage = StringFormat(
     "📊 TRADE PERFORMANCE SUMMARY 📊\n\n" +
     "🎯 Signal: %s\n" +
     "💱 Pair: %s\n" +
     "⏱️ Timeframe: %s\n" +
     "💰 Entry: %s\n" +
     "💰 Exit: %s\n" +
     "📈 Result: %s pips\n" +
     "🏆 Status: %s\n\n" +
     "📊 OVERALL STATISTICS:\n" +
     "🔢 Total Trades: %d\n" +
     "🟢 Winning Trades: %d (%.1f%%)\n" +
     "🔴 Losing Trades: %d (%.1f%%)\n" +
     "💰 Total Profit: %.1f pips\n" +
     "💰 Total Loss: %.1f pips\n" +
     "📈 Profit Factor: %.2f\n" +
     "🎯 Win Rate: %.1f%%",
     signalType, symbol, timeframe, entryPriceStr, exitPriceStr, resultStr,
     isWinner ? "🟢 WINNER" : "🔴 LOSER",
     totalTrades, winningTrades, winRate, losingTrades, (100.0 - winRate),
     totalProfit, totalLoss, profitFactor, winRate
   );

   //--- Send performance alert
   if(EnableTelegramAlerts && TelegramBotToken != "" && TelegramChatID != "")
   {
     bool telegramSent = SendTelegramMessage(performanceMessage);
     if(EnableDebugMode)
        Print("Performance summary sent: ", telegramSent);
   }

   //--- Send MT4 Popup Alert
   if(SendPopupAlert)
   {
     Alert(StringFormat("Performance: %s | Result: %s pips | Win: %d | Loss: %d",
           signalType, resultStr, winningTrades, losingTrades));
   }

   if(EnableDebugMode)
   {
     Print("Performance Summary:");
     Print(StringFormat("  Signal: %s, Result: %.1f pips, Status: %s",
           signalType, resultPips, isWinner ? "WINNER" : "LOSER"));
     Print(StringFormat("  Total: %d trades, %d wins (%.1f%%), PF: %.2f",
           totalTrades, winningTrades, winRate, profitFactor));
   }
   }

   //+------------------------------------------------------------------+
   //| Check Periodic Performance Report Function                       |
   //+------------------------------------------------------------------+
   void CheckPeriodicPerformanceReport()
   {
   //--- Send periodic report every 24 hours or when we have significant data
   static datetime lastReportTime = 0;

   if(lastReportTime == 0)
   {
      lastReportTime = TimeCurrent();
      return; // Skip first call
   }

   //--- Check if 24 hours have passed or we have at least 5 trades
   bool sendReport = false;
   if((TimeCurrent() - lastReportTime) >= 86400) // 24 hours in seconds
   {
      sendReport = true;
   }
   else if(totalTrades >= 5 && (totalTrades % 5 == 0))
   {
      sendReport = true; // Send report every 5 trades
   }

   if(sendReport && totalTrades > 0)
   {
      //--- Calculate statistics
      double winRate = 0.0;
      double profitFactor = 0.0;
      double avgWin = 0.0;
      double avgLoss = 0.0;

      if(totalTrades > 0)
      {
         winRate = (winningTrades * 100.0) / totalTrades;
         if(losingTrades > 0)
            avgLoss = totalLoss / losingTrades;
         if(winningTrades > 0)
            avgWin = totalProfit / winningTrades;
         if(totalLoss > 0)
            profitFactor = totalProfit / totalLoss;
         else
            profitFactor = totalProfit;
      }

      //--- Format periodic report
      string symbol = Symbol();
      string timeframe = GetTimeframeString(Period());
      string reportMessage = StringFormat(
         "📈 PERIODIC PERFORMANCE REPORT 📈\n\n" +
         "📊 Indicator: %s\n" +
         "💱 Pair: %s\n" +
         "⏱️ Timeframe: %s\n\n" +
         "📊 TRADE STATISTICS:\n" +
         "🔢 Total Trades: %d\n" +
         "🟢 Winning Trades: %d (%.1f%%)\n" +
         "🔴 Losing Trades: %d (%.1f%%)\n" +
         "📊 Win Rate: %.1f%%\n" +
         "💰 Total Profit: %.1f pips\n" +
         "💰 Total Loss: %.1f pips\n" +
         "📈 Net Result: %.1f pips\n" +
         "📊 Profit Factor: %.2f\n" +
         "💰 Avg Win: %.1f pips\n" +
         "💰 Avg Loss: %.1f pips\n" +
         "📊 Expectancy: %.2f pips/trade\n\n" +
         "🎯 PERFORMANCE METRICS:\n" +
         "📈 Risk/Reward Ratio: %.2f\n" +
         "🎯 Success Rate: %.1f%%\n" +
         "📊 Consistency Score: %.1f%%",
         IndicatorName, symbol, timeframe,
         totalTrades, winningTrades, winRate, losingTrades, (100.0 - winRate),
         winRate, totalProfit, totalLoss, (totalProfit - totalLoss),
         profitFactor, avgWin, avgLoss, ((totalProfit - totalLoss) / totalTrades),
         (TakeProfitPips / StopLossPips), winRate,
         (winningTrades > 0 ? (winningTrades * 100.0) / totalTrades : 0.0)
      );

      //--- Send the report
      if(EnableTelegramAlerts && TelegramBotToken != "" && TelegramChatID != "")
      {
         bool telegramSent = SendTelegramMessage(reportMessage);
         if(EnableDebugMode)
            Print("Periodic performance report sent: ", telegramSent);
      }

      //--- Update last report time
      lastReportTime = TimeCurrent();

      if(EnableDebugMode)
      {
         Print("Periodic Performance Report Sent:");
         Print(StringFormat("  Total Trades: %d, Wins: %d, Losses: %d, Win Rate: %.1f%%",
               totalTrades, winningTrades, losingTrades, winRate));
         Print(StringFormat("  Net Result: %.1f pips, Profit Factor: %.2f",
               (totalProfit - totalLoss), profitFactor));
      }
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
//| Char Array to String Function                                    |
//+------------------------------------------------------------------+
string CharArrayToString(uchar &array[], int start, int length, int codePage)
{
   string result = "";
   for(int i = start; i < start + length; i++)
   {
      result += CharToString(array[i]);
   }
   return result;
}