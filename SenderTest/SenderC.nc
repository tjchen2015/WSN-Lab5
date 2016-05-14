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
  uses interface Receive as RadioReceive;
  uses interface SplitControl as AMControl;
}
implementation
{
  bool radioBusy = FALSE;
  uint8_t counter = 0;
  message_t radioPacket;

  event void Boot.booted()
  {
    call AMControl.start();
  }

  event void Timer0.fired()
  {
    if(!radioBusy){
      SyncPacketMsg* broadcastPacket = (SyncPacketMsg*)(call Packet.getPayload(&radioPacket, sizeof (SyncPacketMsg)));
      call Leds.led1Toggle();
      broadcastPacket -> node_id = TOS_NODE_ID;
      broadcastPacket -> type = 2;
      broadcastPacket -> sync_id = 4;//??????
      broadcastPacket -> timestamp = 4;

      if(call AMSend.send(AM_BROADCAST_ADDR, &radioPacket, sizeof(SyncPacketMsg)) == SUCCESS){
        radioBusy = TRUE;
        call Leds.led0Toggle();
      }
    }
  }

  event message_t * RadioReceive.receive(message_t *msg, void *payload, uint8_t len){
    if(len == sizeof(SyncPacketMsg)){
      SyncPacketMsg* syncPacket = (SyncPacketMsg*)payload;

      if(syncPacket->type == 1){
        call Timer0.startPeriodic(TOS_NODE_ID * 2000);
        call Leds.led2Toggle();
      }
      else if(syncPacket->type == 2){
        call Leds.led0Toggle();
      }
    }

    return msg;
  }

  event void AMControl.startDone(error_t error){
    if (error == SUCCESS){
    }
    else{
      call AMControl.start();
    }
  }

  event void AMControl.stopDone(error_t error){
  }

  event void AMSend.sendDone(message_t *msg, error_t error){
    if(&radioPacket == msg){
      radioBusy = FALSE;
      counter++;
    }
  }
}

