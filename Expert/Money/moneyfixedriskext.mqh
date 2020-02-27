//+------------------------------------------------------------------+
//|                                            MoneyFixedRiskExt.mqh |
//|                                    Copyright 2010, http://Investeo.pl
//|                                               |
//|        Based on MoneyFixedRisk by MetaQuotes Revision 2010.10.08 |
//+------------------------------------------------------------------+
#include <Expert\ExpertMoney.mqh>

#define dbg 0
// wizard description start
//+------------------------------------------------------------------+
//| Description of the class                                         |
//| Title=Trading fixed risk ext                                        |
//| Type=Money                                                       |
//| Name=FixRiskExt                                                     |
//| Class=CMoneyFixedRiskExt                                            |
//| Page=                                                            |
//| Parameter=Percent,double,10.0                                    |
//+------------------------------------------------------------------+
// wizard description end
//+------------------------------------------------------------------+
//| Class CMoneyFixedRiskExt.                                           |
//| Appointment: Class money managment with fixed percent risk.      |
//|              Derives from class CExpertMoney.                    |
//+------------------------------------------------------------------+
class CMoneyFixedRiskExt : public CExpertMoney
  {
public:
   //---
   virtual double    CheckOpenLong(double price,double sl);
   virtual double    CheckOpenShort(double price,double sl);

   double            GetMaxSLPossible(double price,ENUM_ORDER_TYPE orderType);

   double            CalcMaxTicksLoss();
   double            CalcOrderEquityRisk(double price,double sl,double lots);
   double            CalcOrderEquityReward(double price,double sl,double lots,double rrratio);
  };
//+------------------------------------------------------------------+
//| Getting lot size for open long position.                         |
//| INPUT:  no.                                                      |
//| OUTPUT: lot-if successful, 0.0 otherwise.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CMoneyFixedRiskExt::CheckOpenLong(double price,double sl)
  {
   if(m_symbol==NULL) return(0.0);
   if(sl==0.0)		return (0.15);
//--- select lot size
   double lot;
   double minvol=0.3;//m_symbol.LotsMin();
   double maxvol=MathMin(m_symbol.LotsMax(),4) ;
   //double stepvol=m_symbol.LotsStep();
    lot=MathFloor(m_account.Balance()*0.02)*0.01;///lot=MathFloor(m_account.Balance()*0.002/stepvol)*stepvol;
	  if(lot<minvol) lot=0.05;
	  if(lot>maxvol) lot=maxvol;
   //--- return trading volume
    if(dbg) Print("lot = "+DoubleToString(lot));
    
   return(lot);
  }
//+------------------------------------------------------------------+
//| Getting lot size for open short position.                        |
//| INPUT:  no.                                                      |
//| OUTPUT: lot-if successful, 0.0 otherwise.                        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
double CMoneyFixedRiskExt::CheckOpenShort(double price,double sl)
  {
   if(m_symbol==NULL) return(0.0);
   if(sl==0.0)		return (0.15);
//--- select lot size
   double lot;
   double minvol=0.3;//m_symbol.LotsMin();
   double maxvol=MathMin(m_symbol.LotsMax(),4) ;
    /*double loss;
   if(maxvol<minvol)maxvol=2;
      if(price==0.0)
         loss=-m_account.OrderProfitCheck(m_symbol.Name(),ORDER_TYPE_SELL,1.0,m_symbol.Bid(),sl);
      else
         loss=-m_account.OrderProfitCheck(m_symbol.Name(),ORDER_TYPE_SELL,1.0,price,sl);
         double stepvol=m_symbol.LotsStep();
      lot=MathFloor(m_account.Balance()*0.02)*0.01;// lot=MathFloor(m_account.Balance()*m_percent/loss/100.0/stepvol)*stepvol;
	  */
	  lot=MathFloor(m_account.Balance()*0.02)*0.01;
	  if(lot<minvol) lot=0.05;
	  if(lot>maxvol) lot=maxvol;
	  if(dbg) Print("lot = "+DoubleToString(lot));
//--- return trading volume
   return(lot);
  }
//+------------------------------------------------------------------+
double CMoneyFixedRiskExt::GetMaxSLPossible(double price,ENUM_ORDER_TYPE orderType)
  {
   double maxEquityLoss,tickValLoss,maxTicksLoss;
   double minvol=m_symbol.LotsMin();
   double orderTypeMultiplier;

   if(m_symbol==NULL) return(0.0);

   switch(orderType)
     {
      case ORDER_TYPE_SELL: orderTypeMultiplier= -1.0; break;
      case ORDER_TYPE_BUY: orderTypeMultiplier = 1.0; break;
      default: orderTypeMultiplier=0.0;

     }
   if(dbg) Print("TickValueProfit = "+DoubleToString(m_symbol.TickValueProfit()));
   if(dbg) Print("TickValueLoss = "+DoubleToString(m_symbol.TickValueLoss()));

   maxEquityLoss=m_account.Balance()*m_percent/100.0; // max loss 
   tickValLoss=minvol*m_symbol.TickValueLoss(); // tick val loss
   maxTicksLoss=MathFloor(maxEquityLoss/tickValLoss);

   double maxRealLoss=maxTicksLoss*tickValLoss;

   if(dbg) Print("Max Equity Loss Allowed "+DoubleToString(maxEquityLoss)+" tick loss min vol "+DoubleToString(tickValLoss)+" max ticks loss "+DoubleToString(maxTicksLoss));
   if(dbg) Print("Max real loss = "+DoubleToString(maxRealLoss));

   return(price-maxTicksLoss*m_symbol.TickSize()*orderTypeMultiplier);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CMoneyFixedRiskExt::CalcMaxTicksLoss()
  {
   double maxEquityLoss,tickValLoss,maxTicksLoss;
   double minvol=m_symbol.LotsMin();

   if(m_symbol==NULL) return(0.0);

   maxEquityLoss=m_account.Balance()*m_percent/100.0; // max loss 
   tickValLoss=minvol*m_symbol.TickValueLoss(); // tick val loss
   maxTicksLoss=MathFloor(maxEquityLoss/tickValLoss);

   return(maxTicksLoss);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CMoneyFixedRiskExt::CalcOrderEquityRisk(double price,double sl,double lots)
  {
   double equityRisk;

   equityRisk=lots*m_symbol.TickValueLoss()*(MathAbs(price-sl)/m_symbol.TickSize());

   if(dbg) Print("calcEquityRisk: lots = "+DoubleToString(lots)+" TickValueLoss = "+DoubleToString(m_symbol.TickValueLoss())+" risk = "+DoubleToString(equityRisk));

   return equityRisk;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CMoneyFixedRiskExt::CalcOrderEquityReward(double price,double sl,double lots,double rrratio)
  {
   double equityReward;

   equityReward=lots*m_symbol.TickValueProfit()*(MathAbs(price-sl)/m_symbol.TickSize())*rrratio;

   if(dbg) Print("calcEquityReward: lots = "+DoubleToString(lots)+" TickValueProfit = "+DoubleToString(m_symbol.TickValueProfit())+" reward = "+DoubleToString(equityReward));

   return equityReward;
  }
//+------------------------------------------------------------------+
