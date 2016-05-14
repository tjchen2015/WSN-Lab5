#include "Timer.h"
#include "../SyncPacket.h"

module SenderC @safe()
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
  int delta;

  int32_t t8;
  int32_t t1;
  int32_t t6;
  int32_t t5;

  event void Boot.booted()
  {
    call AMControl.start();
  }

  event void AMControl.startDone(error_t error){
    if (error == SUCCESS){
      if(!busy && !synced){
        SyncPacketMsg* broadcastPacket = (SyncPacketMsg*)(call Packet.getPayload(&radioPacket, sizeof (SyncPacketMsg)));
        call Leds.led2Toggle();
        broadcastPacket -> node_id = TOS_NODE_ID;
        broadcastPacket -> timestamp1 = call LocalTime0.get();

        if(call AMSend.send(AM_BROADCAST_ADDR, &radioPacket, sizeof(SyncPacketMsg)) == SUCCESS){
          busy = TRUE;
          call Leds.led0Toggle();
        }
      }
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
          timePacket -> timestamp = call LocalTime0.get() + delta;//????????
          timePacket -> delta = delta;
          timePacket -> timestamp1 = t1;
          timePacket -> timestamp5 = t5;
          timePacket -> timestamp6 = t6;
          timePacket -> timestamp8 = t8;
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
      busy = FALSE;
      call Leds.led1Toggle();
    }
  }


  event message_t * AMReceive.receive(message_t *msg, void *payload, uint8_t len){
    if(len == sizeof(SyncPacketMsg)){
      if (!synced){
        SyncPacketMsg* syncPacket;
        t8 = call LocalTime0.get();
        syncPacket = (SyncPacketMsg*)payload;
        t1 = syncPacket->timestamp1;
        t6 = syncPacket->timestamp6;
        t5 = syncPacket->timestamp5;
        

        delta = (t8 + t1 - t6 - t5) / 2;
        synced = TRUE;
        call Leds.led3Toggle();
        call Timer0.startPeriodic(5000);
      }
    }
    return msg;
  }

  event void Timer0.fired()
  {
    printf("delta: %d\n", delta);
  }

}

