//+------------------------------------------------------------------+
//|                                      LongShortExpertModified.mqh |
//|                                        Copyright 2013, jlwarrior |
//|                        https://login.mql5.com/en/users/jlwarrior |
//+------------------------------------------------------------------+

#include <Expert\Expert.mqh>
//+------------------------------------------------------------------+
//| enumeration to control whether long / short or both positions are|
//| allowed to be opened                                             |
//+------------------------------------------------------------------+
//--- 
enum ENUM_AVAILABLE_POSITIONS
  {
   LONG_POSITION,
   SHORT_POSITION,
   BOTH_POSITION
  };
//+------------------------------------------------------------------+
//| Class ExpertModKRV.                                  |
//| Purpose: Allows only long / short / both positions to be opened  |
//| Derives from class CExpert (modifies only Open / Reverse methods)|
//+------------------------------------------------------------------+
 
  class CExpert : public CExpertBase
  {
protected:
   int               m_period_flags;             // timeframe flags (as visible flags)
   int               m_max_orders;               // max number of orders (include position)
   MqlDateTime       m_last_tick_time;           // time of last tick
   datetime          m_expiration;               // time expiration order
   ENUM_AVAILABLE_POSITIONS m_positions;
   //--- history info
   int               m_pos_tot;                  // number of open positions
   int               m_deal_tot;                 // number of deals in history
   int               m_ord_tot;                  // number of pending orders
   int               m_hist_ord_tot;             // number of orders in history
   datetime          m_beg_date;                 // start date of history
   //---
   int               m_waiting_event;            // flags of expected trade events
   //--- trading objects
   CExpertTrade     *m_trade;                    // trading object
   CExpertSignal    *m_signal;                   // trading signals object
   CExpertMoney     *m_money;                    // money manager object
   CExpertTrailing  *m_trailing;                 // trailing stops object
   bool              m_check_volume;             // check and decrease trading volume before OrderSend
   //--- indicators
   CIndicators       m_indicators;               // indicator collection to fast recalculations
   //--- market objects
   CPositionInfo     m_position;                 // position info object
   COrderInfo        m_order;                    // order info object
   //--- flags of handlers
   bool              m_on_tick_process;          // OnTick will be processed       (default true)
   bool              m_on_trade_process;         // OnTrade will be processed      (default false)
   bool              m_on_timer_process;         // OnTimer will be processed      (default false)
   bool              m_on_chart_event_process;   // OnChartEvent will be processed (default false)
   bool              m_on_book_event_process;    // OnBookEvent will be processed  (default false)

public:
                    ExpertModKRV(void);//CExpert(void);
                    ~ExpertModKRV(void);//~CExpert(void);
					
                    
   //--- initialization
   bool              Init(string symbol,ENUM_TIMEFRAMES period,bool every_tick,ulong magic=0);
   void              Magic(ulong value);
   void              CheckVolumeBeforeTrade(const bool flag) { m_check_volume=flag; }
   
   //--- initialization trading objects
   virtual bool      InitSignal(CExpertSignal *signal=NULL);
   virtual bool      InitTrailing(CExpertTrailing *trailing=NULL);
   virtual bool      InitMoney(CExpertMoney *money=NULL);
   virtual bool      InitTrade(ulong magic,CExpertTrade *trade=NULL);
   //--- deinitialization
   virtual void      Deinit(void);
   //--- methods of setting adjustable parameters
   void              OnTickProcess(bool value)              { m_on_tick_process=value;        }
   void              OnTradeProcess(bool value)             { m_on_trade_process=value;       }
   void              OnTimerProcess(bool value)             { m_on_timer_process=value;       }
   void              OnChartEventProcess(bool value)        { m_on_chart_event_process=value; }
   void              OnBookEventProcess(bool value)         { m_on_book_event_process=value;  }
   int               MaxOrders(void)                  const { return(m_max_orders);           }
   void              MaxOrders(int value)                   { m_max_orders=value;             }
   //--- methods of access to protected data
   CExpertSignal    *Signal(void)                     const { return(m_signal);               }
   //--- method of verification of settings
   virtual bool      ValidationSettings();
   //--- method of creating the indicator and timeseries
   virtual bool      InitIndicators(CIndicators *indicators=NULL);
   //--- event handlers
   virtual void      OnTick(void);
   virtual void      OnTrade(void);
   virtual void      OnTimer(void);
   virtual void      OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   virtual void      OnBookEvent(const string &symbol);
   void SetAvailablePositions(ENUM_AVAILABLE_POSITIONS newValue){m_positions=newValue;};

protected:
   //--- initialization
   virtual bool      InitParameters(void) { return(true); }
   //--- deinitialization
   virtual void      DeinitTrade(void);
   virtual void      DeinitSignal(void);
   virtual void      DeinitTrailing(void);
   virtual void      DeinitMoney(void);
   virtual void      DeinitIndicators(void);
   //--- refreshing 
   virtual bool      Refresh(void);
   //--- position select depending on netting or hedging
   virtual bool      SelectPosition(void);
   //--- processing (main method)
   virtual bool      Processing(void);
   //--- trade open positions check
   virtual bool      CheckOpen(void);
   virtual bool      CheckOpenLong(void);
   virtual bool      CheckOpenShort(void);
   //--- trade open positions processing
   virtual bool      OpenLong(double price,double sl,double tp);
   virtual bool      OpenShort(double price,double sl,double tp);
   //--- trade reverse positions check
   virtual bool      CheckReverse(void);
   virtual bool      CheckReverseLong(void);
   virtual bool      CheckReverseShort(void);
   //--- trade reverse positions processing
   virtual bool      ReverseLong(double price,double sl,double tp);
   virtual bool      ReverseShort(double price,double sl,double tp);
   //--- trade close positions check
   virtual bool      CheckClose(void);
   virtual bool      CheckCloseLong(void);
   virtual bool      CheckCloseShort(void);
   //--- trade close positions processing
   virtual bool      CloseAll(double lot);
   virtual bool      Close(void);
   virtual bool      CloseLong(double price);
   virtual bool      CloseShort(double price);
   //--- trailing stop check
   virtual bool      CheckTrailingStop(void);
   virtual bool      CheckTrailingStopLong(void);
   virtual bool      CheckTrailingStopShort(void);
   //--- trailing stop processing
   virtual bool      TrailingStopLong(double sl,double tp);
   virtual bool      TrailingStopShort(double sl,double tp);
   //--- trailing order check
   virtual bool      CheckTrailingOrderLong(void);
   virtual bool      CheckTrailingOrderShort(void);
   //--- trailing order processing
   virtual bool      TrailingOrderLong(double delta);
   virtual bool      TrailingOrderShort(double delta);
   //--- delete order check
   virtual bool      CheckDeleteOrderLong(void);
   virtual bool      CheckDeleteOrderShort(void);
   //--- delete order processing
   virtual bool      DeleteOrders(void);
   virtual bool      DeleteOrdersLong(void);
   virtual bool      DeleteOrdersShort(void);
   virtual bool      DeleteOrder(void);
   virtual bool      DeleteOrderLong(void);
   virtual bool      DeleteOrderShort(void);
   //--- lot for trade
   double            LotOpenLong(double price,double sl);
   double            LotOpenShort(double price,double sl);
   double            LotReverse(double sl);
   double            LotCheck(double volume,double price,ENUM_ORDER_TYPE order_type);
   //--- methods of working with trade history
   void              PrepareHistoryDate(void);
   void              HistoryPoint(bool from_check_trade=false);
   bool              CheckTradeState(void);
   //--- set/reset waiting events
   void              WaitEvent(ENUM_TRADE_EVENTS event)     { m_waiting_event|=event;  }
   void              NoWaitEvent(ENUM_TRADE_EVENTS event)   { m_waiting_event&=~event; }
   //--- trade events
   virtual bool      TradeEventPositionStopTake(void)       { return(true); }
   virtual bool      TradeEventOrderTriggered(void)         { return(true); }
   virtual bool      TradeEventPositionOpened(void)         { return(true); }
   virtual bool      TradeEventPositionVolumeChanged(void)  { return(true); }
   virtual bool      TradeEventPositionModified(void)       { return(true); }
   virtual bool      TradeEventPositionClosed(void)         { return(true); }
   virtual bool      TradeEventOrderPlaced(void)            { return(true); }
   virtual bool      TradeEventOrderModified(void)          { return(true); }
   virtual bool      TradeEventOrderDeleted(void)           { return(true); }
   virtual bool      TradeEventNotIdentified(void)          { return(true); }
   //--- timeframe functions
   void              TimeframeAdd(ENUM_TIMEFRAMES period);
   int               TimeframesFlags(MqlDateTime &time);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
ExpertModKRV ::ExpertModKRV(void) : m_positions(BOTH_POSITION)
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
ExpertModKRV ::~ExpertModKRV(void)
  {
  }
//+------------------------------------------------------------------+
//| Check open for allowed positions                                 |
//+------------------------------------------------------------------+
bool ExpertModKRV :: CheckOpen()
  {
   switch(m_positions)
     {
      case LONG_POSITION:
         return CheckOpenLong();         //check only new long positions
      case SHORT_POSITION:
         return CheckOpenShort();        //check only new short positions
      default:
         return CExpert::CheckOpen();    //default behaviour
     }
  }
//+------------------------------------------------------------------+
//| Check reverse only if both position types are allowed            |
//+------------------------------------------------------------------+
bool ExpertModKRV::CheckReverse()
  {
   switch(m_positions)
     {
      case LONG_POSITION:
      case SHORT_POSITION:
         return false;                    // no reversal is allowed
      default:
         return CExpert::CheckReverse(); //default behaviour
     }
  }
//+------------------------------------------------------------------+
