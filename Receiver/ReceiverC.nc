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
  //Serial define
  uses interface SplitControl as SerialControl;
  uses interface Receive as SerialReceive;
  uses interface AMSend as SerialAMSend;
  uses interface Packet as SerialPacket;
}
implementation
{
  bool busy = FALSE, synced = FALSE, serialBusy = FALSE;
  message_t radioPacket, serialPacket;

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

  event void SerialControl.startDone(error_t error){
    if (error == FAIL){
      call SerialControl.start();
    }
  }

  event void SerialControl.stopDone(error_t error){
  }

  event message_t * SerialReceive.receive(message_t *msg, void *payload, uint8_t len){
    if(len == sizeof(SyncPacketMsg)){
      SyncPacketMsg* requestPacket = (SyncPacketMsg*)payload;

      if(requestPacket->node_id==4 && requestPacket->type==3){//check node id????
        if(!serialBusy){
          SyncPacketMsg* timePacket = (SyncPacketMsg*)(call SerialPacket.getPayload(&serialPacket, sizeof (SyncPacketMsg)));
          timePacket -> node_id = TOS_NODE_ID;
          timePacket -> type = 3;
          timePacket -> timestamp = call LocalTime0.get();//????????
          if(call SerialAMSend.send(AM_BROADCAST_ADDR, &serialPacket, sizeof(SyncPacketMsg)) == SUCCESS){
            serialBusy = TRUE;
          }
        }
      }
    }
    return msg;
  }

  event void SerialAMSend.sendDone(message_t *msg, error_t error){
    if(&serialPacket == msg){
      serialBusy = FALSE;
    }
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
          call Leds.led3Toggle();
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

