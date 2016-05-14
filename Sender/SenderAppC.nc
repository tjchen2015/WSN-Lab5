configuration SenderAppC
{
}
implementation
{
  components MainC, SenderC, LedsC;
  components LocalTimeMilliC;
  components new TimerMilliC() as Timer0;
  
  //Radio
  components ActiveMessageC;
  components new AMSenderC(AM_SYNCPACKETMSG);
  components new AMReceiverC(AM_SYNCPACKETMSG);
  components SerialActiveMessageC;


  SenderC -> MainC.Boot;

  SenderC.Leds -> LedsC;
  
  //Radio define
  SenderC.Packet -> AMSenderC;
  SenderC.AMPacket -> AMSenderC;
  SenderC.AMSend -> AMSenderC;
  SenderC.AMControl -> ActiveMessageC;
  SenderC.LocalTime0 -> LocalTimeMilliC;
  SenderC.AMReceive -> AMReceiverC;
  SenderC.Timer0 -> Timer0;
  //Serial define
  SenderC.SerialControl -> SerialActiveMessageC;
  SenderC.SerialReceive -> SerialActiveMessageC.Receive[AM_SYNCPACKETMSG];
  SenderC.SerialAMSend -> SerialActiveMessageC.AMSend[AM_SYNCPACKETMSG];
  SenderC.SerialPacket -> SerialActiveMessageC;
}



