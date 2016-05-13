configuration SenderAppC
{
}
implementation
{
  components MainC, SenderC, LedsC;
  components new TimerMilliC() as Timer0;
  
  //Serial
  components SerialActiveMessageC;


  SenderC -> MainC.Boot;

  SenderC.Timer0 -> Timer0;
  SenderC.Leds -> LedsC;
  
  //Serial define
  SenderC.SerialControl -> SerialActiveMessageC;
  SenderC.SerialAMSend -> SerialActiveMessageC.AMSend[AM_SYNCPACKETMSG];
  SenderC.SerialPacket -> SerialActiveMessageC;
}

