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
  components new AMReceiverC(AM_SYNCPACKETMSG);


  ReceiverC -> MainC.Boot;

  //ReceiverC.Timer0 -> Timer0;
  ReceiverC.LocalTime0 -> LocalTimeMilliC;
  ReceiverC.Leds -> LedsC;
  
  //Radio define
  ReceiverC.RadioReceive -> AMReceiverC;
  ReceiverC.RadioControl -> ActiveMessageC;
}

