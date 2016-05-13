#include "Timer.h"
#include "../SyncPacket.h"

#define NODE_ID 3

module SenderC @safe()
{
  uses interface Timer<TMilli> as Timer0;
  uses interface Leds;
  uses interface Boot;

  //Radio define
  uses interface Packet;
  uses interface AMPacket;
  uses interface AMSend;
  uses interface SplitControl as AMControl;
}
implementation
{
  bool busy = FALSE;
  uint8_t counter = 0;
  message_t pkt;

  event void Boot.booted()
  {
    call AMControl.start();
  }

  event void Timer0.fired()
  {
    if(!busy){
      SyncPacketMsg* syncPacket = (SyncPacketMsg*)(call Packet.getPayload(&pkt, sizeof (SyncPacketMsg)));
      syncPacket -> node_id = NODE_ID;
      syncPacket -> type = 1;
      syncPacket -> sync_id = counter;
      if(call AMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(SyncPacketMsg)) == SUCCESS){
        busy = TRUE;
      }
    }
  }

  event void AMControl.startDone(error_t error){
    if (error == SUCCESS){
      call Timer0.startPeriodic(TIMER_PERIOD_MILLI);
    }
    else{
      call AMControl.start();
    }
  }

  event void AMControl.stopDone(error_t error){
  }

  event void AMSend.sendDone(message_t *msg, error_t error){
    if(&pkt == msg){
      busy = FALSE;
      counter++;
    }
  }
}

