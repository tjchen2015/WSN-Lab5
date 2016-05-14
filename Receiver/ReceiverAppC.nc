configuration ReceiverAppC
{
}
implementation
{
  components MainC, ReceiverC, LedsC;
  components LocalTimeMilliC;
  components new TimerMilliC() as Timer0;
  
  //Radio
  components ActiveMessageC;
  components new AMSenderC(AM_SYNCPACKETMSG);
  components new AMReceiverC(AM_SYNCPACKETMSG);


  ReceiverC -> MainC.Boot;

  ReceiverC.Leds -> LedsC;
  
  //Radio define
  ReceiverC.Packet -> AMSenderC;
  ReceiverC.AMPacket -> AMSenderC;
  ReceiverC.AMSend -> AMSenderC;
  ReceiverC.AMControl -> ActiveMessageC;
  ReceiverC.LocalTime0 -> LocalTimeMilliC;
  ReceiverC.AMReceive -> AMReceiverC;
  ReceiverC.Timer0 -> Timer0;
}

