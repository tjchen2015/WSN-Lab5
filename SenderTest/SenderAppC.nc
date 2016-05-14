configuration SenderAppC
{
}
implementation
{
  components MainC, SenderC, LedsC;
  components new TimerMilliC() as Timer0;
  
  //Radio
  components ActiveMessageC;
  components new AMSenderC(AM_SYNCPACKETMSG);


  SenderC -> MainC.Boot;

  SenderC.Timer0 -> Timer0;
  SenderC.Leds -> LedsC;
  
  //Radio define
  SenderC.Packet -> AMSenderC;
  SenderC.AMPacket -> AMSenderC;
  SenderC.AMSend -> AMSenderC;
  SenderC.AMControl -> ActiveMessageC;
}

