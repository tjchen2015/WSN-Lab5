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
  uses interface AMSend as RadioAMSend;
  uses interface Receive as RadioReceive;
  uses interface SplitControl as RadioControl;
  //Serial define
  uses interface SplitControl as SerialControl;
  uses interface Receive as SerialReceive;
  uses interface AMSend as SerialAMSend;
  uses interface Packet as SerialPacket;
}
implementation
{
  bool radioBusy = FALSE;
  bool serialBusy = FALSE;
  message_t radioPacket, serialPacket;

  event void Boot.booted()
  {
    call RadioControl.start();
    call SerialControl.start();
  }

  event void RadioControl.startDone(error_t error){
    if (error == FAIL){
      call RadioControl.start();
    }
  }

  event void RadioControl.stopDone(error_t error){
  }

  event void SerialControl.startDone(error_t error){
    if (error == FAIL){
      call SerialControl.start();
    }
  }

  event void SerialControl.stopDone(error_t error){
  }

  event message_t * RadioReceive.receive(message_t *msg, void *payload, uint8_t len){
    if(len == sizeof(SyncPacketMsg)){
      SyncPacketMsg* syncPacket = (SyncPacketMsg*)payload;

      if(syncPacket->type == 1){
        if(!radioBusy){
          SyncPacketMsg* broadcastPacket = (SyncPacketMsg*)(call RadioPacket.getPayload(&radioPacket, sizeof (SyncPacketMsg)));
          broadcastPacket -> node_id = NODE_ID;
          broadcastPacket -> type = 2;
          broadcastPacket -> sync_id = syncPacket -> sync_id;//??????
          broadcastPacket -> timestamp = call LocalTime0.get();

          if(call RadioAMSend.send(AM_BROADCAST_ADDR, &radioPacket, sizeof(SyncPacketMsg)) == SUCCESS){
            radioBusy = TRUE;
          }
        }
      }
      else if(syncPacket->type == 2){
        //regression
        //table
      }
    }

    return msg;
  }

  event message_t * SerialReceive.receive(message_t *msg, void *payload, uint8_t len){
    if(len == sizeof(SyncPacketMsg)){
      SyncPacketMsg* requestPacket = (SyncPacketMsg*)payload;

      if(requestPacket->node_id==4 && requestPacket->type==3){//check node id????
        if(!serialBusy){
          SyncPacketMsg* timePacket = (SyncPacketMsg*)(call SerialPacket.getPayload(&serialPacket, sizeof (SyncPacketMsg)));
          timePacket -> node_id = NODE_ID;
          timePacket -> type = 3;
          //timestamp -> timestamp = ;//????????
          if(call SerialAMSend.send(AM_BROADCAST_ADDR, &serialPacket, sizeof(SyncPacketMsg)) == SUCCESS){
            serialBusy = TRUE;
          }
        }
      }
    }
    return msg;
  }

  event void RadioAMSend.sendDone(message_t *msg, error_t error){
    if(&radioPacket == msg){
      radioBusy = FALSE;
    }
  }

  event void SerialAMSend.sendDone(message_t *msg, error_t error){
    if(&serialPacket == msg){
      serialBusy = FALSE;
    }
  }
}

