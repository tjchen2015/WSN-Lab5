#include "Timer.h"
#include "../SyncPacket.h"

module SenderC @safe()
{
  uses interface Timer<TMilli> as Timer0;
  uses interface Leds;
  uses interface Boot;

  //Serial define
  uses interface SplitControl as SerialControl;
  uses interface Receive as SerialReceive;
  uses interface AMSend as SerialAMSend;
  uses interface Packet as SerialPacket;
}
implementation
{
  bool busy = FALSE;
  uint8_t counter = 0;
  message_t pkt;

  event void Boot.booted()
  {
    call SerialControl.start();
  }

  event void Timer0.fired()
  {
    if(!busy){
      SyncPacketMsg* btrpkt = (SyncPacketMsg*)(call SerialPacket.getPayload(&pkt, sizeof (SyncPacketMsg)));
      btrpkt -> nodeid = TOS_NODE_ID;
      btrpkt-> counter = counter;
      if(call SerialAMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(SyncPacketMsg)) == SUCCESS){
        busy = TRUE;
      }
    }
  }

  event void SerialControl.startDone(error_t error){
    if (error == SUCCESS){
      call Timer0.startPeriodic(TIMER_PERIOD_MILLI);
    }
    else{
      call SerialControl.start();
    }
  }

  event void SerialControl.stopDone(error_t error){
  }

  event message_t * SerialReceive.receive(message_t *msg, void *payload, uint8_t len){
    if(len == sizeof(SyncPacketMsg)){
      SyncPacketMsg* btrpkt = (SyncPacketMsg*)payload;
      call Leds.set(btrpkt->counter);
    }
    return msg;
  }

  event void SerialAMSend.sendDone(message_t *msg, error_t error){
    if(&pkt == msg){
      busy = FALSE;
      counter++;
    }
  }
}

