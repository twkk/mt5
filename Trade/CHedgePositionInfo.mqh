//+------------------------------------------------------------------+
//| Class CHedgePositionInfo                                         |
//| 目标: 用于访问锁仓仓位信息的类                                        |  
//|              派生于 CObject 类.                                   |
//+------------------------------------------------------------------+
class CHedgePositionInfo : public CObject
  {
   //--- === 数据成员 === --- 
private:
   ENUM_HEDGE_TYPE   m_type;
   double            m_volume;
   double            m_price;
   double            m_stop_loss;
   double            m_take_profit;
   ulong             m_magic;
   //--- 对象
   CArrayLong        m_tickets;
   CSymbolInfo       m_symbol;
   CPositionInfo     m_pos_info;

   //--- === 方法 === --- 
public:
   //--- 构造函数/析构函数
   void              CHedgePositionInfo(void){};
   void             ~CHedgePositionInfo(void){};
   //--- 初始化
   bool              Init(const string _symbol,const ulong _magic=0);
   //--- get 方法
   CSymbolInfo      *Symbol(void)       {return GetPointer(m_symbol);};
   CArrayLong       *HedgeTickets(void) {return GetPointer(m_tickets);};
   CPositionInfo    *PositionInfo(void) {return GetPointer(m_pos_info);};
   ulong             Magic(void) const  {return m_magic;};
   //--- 快速访问锁仓的整数属性的方法
   datetime          Time(void);
   ulong             TimeMsc(void);
   datetime          TimeUpdate(void);
   ulong             TimeUpdateMsc(void);
   ENUM_HEDGE_TYPE   HedgeType(void);
   //--- 快速访问锁仓的双精度浮点型属性的方法
   double            Volume(double &_buy_volume,double &_sell_volume);
   double            PriceOpen(const ENUM_TRADE_TYPE_DIR _dir_type=TRADE_TYPE_ALL);
   double            StopLoss(const ENUM_TRADE_TYPE_DIR _dir_type=TRADE_TYPE_ALL);
   double            TakeProfit(const ENUM_TRADE_TYPE_DIR _dir_type=TRADE_TYPE_ALL);
   double            PriceCurrent(const ENUM_TRADE_TYPE_DIR _dir_type=TRADE_TYPE_ALL);
   double            Commission(const bool _full=false);
   double            Swap(void);
   double            Profit(void);
   double            Margin(void);
   //--- 快速访问锁仓字符串型属性的方法
   string            TypeDescription(void);
   //--- 信息方法
   string            FormatType(string &_str,const uint _type) const;
   //--- 选择
   bool              Select(void);
   //--- 状态
   void              StoreState(void);
   bool              CheckState(void);

private:
   //--- 计算方法
   bool              AveragePrice(
                                  const SPositionParams &_pos_params,
                                  double &_avg_pr,
                                  double &_base_volume,
                                  double &_quote_volume
                                  );
   int               CheckLoadHistory(ENUM_TIMEFRAMES period,datetime start_date);
  };
              |
//+------------------------------------------------------------------+
//| 初始化                                                            |
//+------------------------------------------------------------------+
bool CHedgePositionInfo::Init(const string _symbol,const ulong _magic=0)
  {
//--- 账户预付款模式
   ENUM_ACCOUNT_MARGIN_MODE margin_mode=(ENUM_ACCOUNT_MARGIN_MODE)AccountInfoInteger(ACCOUNT_MARGIN_MODE);
   if(margin_mode!=ACCOUNT_MARGIN_MODE_RETAIL_HEDGING)
     {
      Print(__FUNCTION__+": 不是锁仓模式!");
      return false;
     }
   if(!m_symbol.Name(_symbol))
     {
      Print(__FUNCTION__+": 交易品种没有被选择!");
      return false;
     }
   ENUM_SYMBOL_CALC_MODE  symbol_calc_mode=(ENUM_SYMBOL_CALC_MODE)SymbolInfoInteger(_symbol,SYMBOL_TRADE_CALC_MODE);
   if(symbol_calc_mode!=SYMBOL_CALC_MODE_FOREX)
     {
      Print(__FUNCTION__+": 只用于外汇交易模式!");
      return false;
     }
   m_magic=_magic;
//---
   return true;
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| 取得锁仓开启的时间                                                  |
//+------------------------------------------------------------------+
datetime CHedgePositionInfo::Time(void)
  {
   datetime hedge_time=WRONG_VALUE;
   int hedge_pos_num=m_tickets.Total();
//--- 如果有仓位
   if(hedge_pos_num>0)
     {
      //--- 找到第一个开启的仓位
      for(int pos_idx=0;pos_idx<hedge_pos_num;pos_idx++)
        {
         ulong curr_pos_ticket=m_tickets.At(pos_idx);
         if(curr_pos_ticket<LONG_MAX)
            if(m_pos_info.SelectByTicket(curr_pos_ticket))
              {
               datetime curr_pos_time=m_pos_info.Time();
               if(curr_pos_time>0)
                 {
                  if(hedge_time==0)
                     hedge_time=curr_pos_time;
                  else
                    {
                     if(curr_pos_time<hedge_time)
                        hedge_time=curr_pos_time;
                    }
                 }
              }
        }
     }
//---
   return hedge_time;
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| 取得锁仓更新的时间                                                  |
//+------------------------------------------------------------------+
datetime CHedgePositionInfo::TimeUpdate(void)
  {
   datetime hedge_time_update=0;
   int hedge_pos_num=m_tickets.Total();
//--- 如果有仓位
   if(hedge_pos_num>0)
     {
      //--- 找到第一个开启的仓位
      for(int pos_idx=0;pos_idx<hedge_pos_num;pos_idx++)
        {
         ulong curr_pos_ticket=m_tickets.At(pos_idx);
         if(curr_pos_ticket<LONG_MAX)
            if(m_pos_info.SelectByTicket(curr_pos_ticket))
              {
               //--- 取得当前仓位的更新时间
               datetime curr_pos_time_update=m_pos_info.TimeUpdate();
               if(curr_pos_time_update>0)
                  if(curr_pos_time_update>hedge_time_update)
                     hedge_time_update=curr_pos_time_update;
              }
        }
     }
//---
   return hedge_time_update;
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| 取得锁仓类型                                                       |
//+------------------------------------------------------------------+
ENUM_HEDGE_TYPE CHedgePositionInfo::HedgeType(void)
  {
   ENUM_HEDGE_TYPE curr_hedge_type=WRONG_VALUE;
   int hedge_pos_num=m_tickets.Total();
//--- 如果有仓位
   if(hedge_pos_num>0)
     {
      //--- 取得交易量      
      double total_vol,buy_volume,sell_volume;
      buy_volume=sell_volume=0.;
      total_vol=this.Volume(buy_volume,sell_volume);
      //--- 定义锁仓类型
      if(buy_volume>0. && sell_volume>0.)
        {
         if(buy_volume>sell_volume)
            curr_hedge_type=HEDGE_NETTING_BUY;
         else if(buy_volume<sell_volume)
            curr_hedge_type=HEDGE_NETTING_SELL;
         else
            curr_hedge_type=HEDGE_LOCKED;
        }
      else if(buy_volume>0. && sell_volume==0.)
         curr_hedge_type=HEDGE_BUY;
      else if(buy_volume==0. && sell_volume>0.)
         curr_hedge_type=HEDGE_SELL;
     }
//---
   return curr_hedge_type;
  };
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| 取得锁仓交易量                                                     |
//+------------------------------------------------------------------+
double CHedgePositionInfo::Volume(double &_buy_volume,double &_sell_volume)
  {
   double total_vol=0.;
   int hedge_pos_num=m_tickets.Total();
//--- 如果有仓位
   if(hedge_pos_num>0)
     {
      _buy_volume=_sell_volume=0.;
      //--- 取得买入/卖出交易量      
      for(int pos_idx=0;pos_idx<hedge_pos_num;pos_idx++)
        {
         ulong curr_pos_ticket=m_tickets.At(pos_idx);
         if(curr_pos_ticket<LONG_MAX)
            if(m_pos_info.SelectByTicket(curr_pos_ticket))
              {
               ENUM_POSITION_TYPE curr_pos_type=m_pos_info.PositionType();
               double curr_pos_vol=m_pos_info.Volume();
               if(curr_pos_vol>0.)
                 {
                  //--- 对于一个买入仓位
                  if(curr_pos_type==POSITION_TYPE_BUY)
                     _buy_volume+=curr_pos_vol;
                  //--- 对于卖出仓位
                  else if(curr_pos_type==POSITION_TYPE_SELL)
                     _sell_volume+=curr_pos_vol;
                 }
              }
        }
      total_vol=_buy_volume-_sell_volume;
     }
//---
   return total_vol;
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| 取得锁仓的手续费                                                    |
//+------------------------------------------------------------------+
double CHedgePositionInfo::Commission(const bool _full=false)
  {
   double hedge_commission=0.;
   int hedge_pos_num=m_tickets.Total();
//--- 如果有仓位
   if(hedge_pos_num>0)
      for(int pos_idx=0;pos_idx<hedge_pos_num;pos_idx++)
        {
         ulong curr_pos_ticket=m_tickets.At(pos_idx);
         if(curr_pos_ticket<LONG_MAX)
            if(m_pos_info.SelectByTicket(curr_pos_ticket))
              {
               long curr_pos_id=m_pos_info.Identifier();
               if(curr_pos_id>0)
                  //--- 取得与所选仓位相关的交易历史 
                  if(HistorySelectByPosition(curr_pos_id))
                    {
                     CDealInfo curr_deal;
                     int deals_num=HistoryDealsTotal();
                     for(int deal_idx=0;deal_idx<deals_num;deal_idx++)
                        if(curr_deal.SelectByIndex(deal_idx))
                          {
                           ENUM_DEAL_ENTRY curr_deal_entry=curr_deal.Entry();
                           if(curr_deal_entry==DEAL_ENTRY_IN)
                             {
                              double curr_deal_commission=NormalizeDouble(curr_deal.Commission(),2);
                              if(curr_deal_commission!=0.)
                                {
                                 double fac=1.;
                                 if(_full) fac=2.;
                                 hedge_commission+=(fac*curr_deal_commission);
                                }
                             }
                          }

                    }
              }
        }
//---
   return hedge_commission;
  }
//+------------------------------------------------------------------+
