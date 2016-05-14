#include "Timer.h"
#include "../SyncPacket.h"

module ReceiverC @safe()
{
  uses interface LocalTime<TMilli> as LocalTime0;
  uses interface Timer<TMilli> as Timer0;
  uses interface Leds;
  uses interface Boot;

  //Radio define
  uses interface Packet;
  uses interface AMPacket;
  uses interface AMSend;
  uses interface SplitControl as AMControl;
  uses interface Receive as AMReceive;
}
implementation
{
  bool busy = FALSE, synced = FALSE;
  message_t radioPacket;

  event void Boot.booted()
  {
    call AMControl.start();
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
      call Leds.led1Toggle();
      busy = FALSE;
    }
  }


  event message_t * AMReceive.receive(message_t *msg, void *payload, uint8_t len){
    if(len == sizeof(SyncPacketMsg)){
      uint32_t t5 = call LocalTime0.get();
      SyncPacketMsg* syncPacket = (SyncPacketMsg*)payload;

      if(!busy && !synced){
        SyncPacketMsg* broadcastPacket = (SyncPacketMsg*)(call Packet.getPayload(&radioPacket, sizeof (SyncPacketMsg)));
        call Leds.led2Toggle();
        broadcastPacket -> node_id = TOS_NODE_ID;
        broadcastPacket -> timestamp5 = t5;
        broadcastPacket -> timestamp6 = call LocalTime0.get();

        if(call AMSend.send(AM_BROADCAST_ADDR, &radioPacket, sizeof(SyncPacketMsg)) == SUCCESS){
          busy = TRUE;
          synced = TRUE;
          call Timer0.startPeriodic(1000);
        }
      }
    }
    return msg;
  }

  event void Timer0.fired()
  {
    printf("now time: %d\n", call LocalTime0.get());
  }

}

