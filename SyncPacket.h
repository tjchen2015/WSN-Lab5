// $Id: BlinkToRadio.h,v 1.4 2006/12/12 18:22:52 vlahan Exp $

#ifndef SYNCPACKET_H
#define SYNCPACKET_H

enum {
  AM_SYNCPACKETMSG = 6,
  TIMER_PERIOD_MILLI = 1000
};

typedef nx_struct SyncPacketMsg {
  nx_uint16_t nodeid;
  nx_uint16_t counter;
} SyncPacketMsg;

#endif
