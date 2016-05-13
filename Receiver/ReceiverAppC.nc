configuration ReceiverAppC
{
}
implementation
{
  components MainC, ReceiverC, LedsC;
  components new TimerMilliC() as Timer0;
  
  //Serial
  components SerialActiveMessageC;


  ReceiverC -> MainC.Boot;

  ReceiverC.Timer0 -> Timer0;
  ReceiverC.Leds -> LedsC;
  
  //Serial define
  ReceiverC.SerialControl -> SerialActiveMessageC;
  ReceiverC.SerialReceive -> SerialActiveMessageC.Receive[AM_SYNCPACKETMSG];
  ReceiverC.SerialAMSend -> SerialActiveMessageC.AMSend[AM_SYNCPACKETMSG];
  ReceiverC.SerialPacket -> SerialActiveMessageC;
}

