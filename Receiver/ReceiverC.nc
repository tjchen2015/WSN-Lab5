#include "Timer.h"
#include "../SyncPacket.h"

#define NODE_ID 1

module ReceiverC @safe()
{
  //uses interface Timer<TMilli> as Timer0;
  uses interface LocalTime<TMilli> as LocalTime0;
  uses interface Leds;
  uses interface Boot;
  uses interface BusyWait<TMicro, typeof(uint16_t)>;

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
  uses interface LocalTime<TMilli>;
}
implementation
{
  bool radioBusy = FALSE;
  bool serialBusy = FALSE;
  message_t radioPacket, serialPacket;
  int sync_packet_storage[MAX_NEIGHBOR_NUM][CACHED_SYNC_PACKET_NUM];
  int sync_id_now[MAX_NEIGHBOR_NUM];

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

  void save(SyncPacketMsg *sync_packet) {
    sync_packet_storage[sync_packet->node_id - 1][sync_packet->sync_id % CACHED_SYNC_PACKET_NUM] = sync_packet->timestamp;
    sync_id_now[sync_packet->node_id - 1] = sync_packet->sync_id;
  }

  event message_t * RadioReceive.receive(message_t *msg, void *payload, uint8_t len){
    if(len == sizeof(SyncPacketMsg)){
      SyncPacketMsg* syncPacket = (SyncPacketMsg*)payload;

      if(syncPacket->type == 1){
        if(!radioBusy){
          SyncPacketMsg* broadcastPacket = (SyncPacketMsg*)(call RadioPacket.getPayload(&radioPacket, sizeof (SyncPacketMsg)));
          call Leds.led2Toggle();
          broadcastPacket -> node_id = NODE_ID;
          broadcastPacket -> type = 2;
          broadcastPacket -> sync_id = syncPacket -> sync_id;//??????
          broadcastPacket -> timestamp = call LocalTime0.get();
          call BusyWait.wait(6000000);
          if(call RadioAMSend.send(AM_BROADCAST_ADDR, &radioPacket, sizeof(SyncPacketMsg)) == SUCCESS){
            radioBusy = TRUE;
            call Leds.led0Toggle();
          }
        }
      }
      else if(syncPacket->type == 2){
        call Leds.led1Toggle();
        save(syncPacket);
      }
    }

    return msg;
  }

  void doLinearRegression(double x[], double y[], int len, double * slope, double * intercept) {
    int i;
    double xbar;
    double ybar;
    double xxbar = 0.0, yybar = 0.0, xybar = 0.0;

    // first pass: read in data, compute xbar and ybar
    double sumx = 0.0, sumy = 0.0, sumx2 = 0.0;
    for (i = 0; i < len; i += 1) {
        sumx  += x[i];
        sumx2 += x[i] * x[i];
        sumy  += y[i];
    }
    xbar = sumx / len;
    ybar = sumy / len;

    // second pass: compute summary statistics

    for (i = 0; i < len; i++) {
        xxbar += (x[i] - xbar) * (x[i] - xbar);
        yybar += (y[i] - ybar) * (y[i] - ybar);
        xybar += (x[i] - xbar) * (y[i] - ybar);
    }
    *slope = xybar / xxbar;
    *intercept = ybar - *slope * xbar;
  }

  uint32_t getTimestampForNode(int node_id, uint32_t our_time) {
    int i, counter;
    double x[MAX_NEIGHBOR_NUM], y[MAX_NEIGHBOR_NUM];
    double slope, intercept;
    uint32_t their_time;

    for (i = (sync_id_now[node_id - 1] + 1) % CACHED_SYNC_PACKET_NUM, counter = 0;
        counter < 30;
        counter += 1, i = (i + 1) % CACHED_SYNC_PACKET_NUM) {
      x[counter] = sync_packet_storage[NODE_ID][i];
      y[counter] = sync_packet_storage[node_id - 1][i] - sync_packet_storage[NODE_ID][i];
    }
    
    doLinearRegression(x, y, CACHED_SYNC_PACKET_NUM, &slope, &intercept);

    their_time = our_time + slope * our_time + intercept;

    return their_time > our_time ? their_time : our_time;
  }

  uint32_t getTimestamp() {
    int i;
    uint32_t tmp;
    uint32_t max_time = 0;
    uint32_t our_time = call LocalTime0.get();
    for (i = 0; i < MAX_NEIGHBOR_NUM; i += 1) {
      if (i+1 == NODE_ID) continue;
      tmp = getTimestampForNode(i, our_time);
      if (tmp > max_time) {
        max_time = tmp;
      }
    }
    return max_time;
  }

  event message_t * SerialReceive.receive(message_t *msg, void *payload, uint8_t len){
    if(len == sizeof(SyncPacketMsg)){
      SyncPacketMsg* requestPacket = (SyncPacketMsg*)payload;

      if(requestPacket->node_id==4 && requestPacket->type==3){//check node id????
        if(!serialBusy){
          SyncPacketMsg* timePacket = (SyncPacketMsg*)(call SerialPacket.getPayload(&serialPacket, sizeof (SyncPacketMsg)));
          call Leds.led3Toggle();
          timePacket -> node_id = NODE_ID;
          timePacket -> type = 3;
          timePacket -> timestamp = getTimestamp();//????????
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

