#include "Timer.h"
#include "../SyncPacket.h"

#define NODE_ID 1

module ReceiverC @safe()
{
  //uses interface Timer<TMilli> as Timer0;
  uses interface LocalTime<TMilli> as LocalTime0;
  uses interface Leds;
  uses interface Boot;

  //Radio define
  uses interface Packet as RadioPacket;
  uses interface AMPacket as RadioAMPacket;
  uses interface Receive as RadioReceive;
  uses interface SplitControl as RadioControl;
}
implementation
{
  bool radioBusy = FALSE;
  bool serialBusy = FALSE;
  message_t radioPacket;

  event void Boot.booted()
  {
    call RadioControl.start();
  }

  event void RadioControl.startDone(error_t error){
    if (error == FAIL){
      call RadioControl.start();
    }
  }

  event void RadioControl.stopDone(error_t error){
  }

  event message_t * RadioReceive.receive(message_t *msg, void *payload, uint8_t len){
    if(len == sizeof(SyncPacketMsg)){
      SyncPacketMsg* syncPacket = (SyncPacketMsg*)payload;

      if(syncPacket->type == 1){
        call Leds.led2Toggle();
      }
      else if(syncPacket->type == 2){
        call Leds.led0Toggle();
      }
      else {
        call Leds.led1Toggle();
      }
    }

    return msg;
  }
}

