configuration ReceiverAppC
{
}
implementation
{
  components MainC, ReceiverC, LedsC;
  //components new TimerMilliC() as Timer0;
  components LocalTimeMilliC;
  
  //Radio
  components ActiveMessageC;
  components new AMSenderC(AM_SYNCPACKETMSG);
  components new AMReceiverC(AM_SYNCPACKETMSG);
  //Serial
  components SerialActiveMessageC;


  ReceiverC -> MainC.Boot;

  //ReceiverC.Timer0 -> Timer0;
  ReceiverC.LocalTime0 -> LocalTimeMilliC;
  ReceiverC.Leds -> LedsC;
  
  //Radio define
  ReceiverC.RadioPacket -> AMSenderC;
  ReceiverC.RadioAMPacket -> AMSenderC;
  ReceiverC.RadioAMSend -> AMSenderC;
  ReceiverC.RadioReceive -> AMReceiverC;
  ReceiverC.RadioControl -> ActiveMessageC;
  //Serial define
  ReceiverC.SerialControl -> SerialActiveMessageC;
  ReceiverC.SerialReceive -> SerialActiveMessageC.Receive[AM_SYNCPACKETMSG];
  ReceiverC.SerialAMSend -> SerialActiveMessageC.AMSend[AM_SYNCPACKETMSG];
  ReceiverC.SerialPacket -> SerialActiveMessageC;
}

