import java.io.IOException;
import java.util.Scanner;

import net.tinyos.message.*;
import net.tinyos.packet.*;
import net.tinyos.util.*;

public class PCClient implements MessageListener {

  private MoteIF moteIF;
  public short node_id = 4;
  public short packet_type = 3;
  public PCClientMsg msg1, msg2;
  
  public PCClient(MoteIF moteIF) {
    this.moteIF = moteIF;
    this.moteIF.registerListener(new PCClientMsg(), this);
  }

  public void requestNodeTime() {
    while(true){
      msg1 = null;//delete previous packet
      msg2 = null;//delete previous packet
      sendPackets();
      
      try{
        Thread.sleep(2000);
      } catch(InterruptedException e){
        e.printStackTrace();
      }
    }
  }
  
  public void sendPackets() {
    PCClientMsg payload = new PCClientMsg();
    
    try {
  		payload.set_node_id(node_id);
      payload.set_type(packet_type);
  		moteIF.send(0, payload);
    }
    catch (IOException exception) {
      System.err.println("Exception thrown when sending packets. Exiting.");
      System.err.println(exception);
    }
  }

  public void messageReceived(int to, Message message) {
    PCClientMsg msg = (PCClientMsg)message;

    if (msg.get_node_id()==1 && msg.get_type()==3) {
      msg1 = msg;
      showNodeTime(msg1);
    }
    else if (msg.get_node_id()==2 && msg.get_type()==3) {
      msg2 = msg;
      showNodeTime(msg2);
    }
  }

  public void showNodeTime(PCClientMsg msg){
    System.out.println("Node " + msg.get_node_id() + ": " + msg.get_timestamp());//time conversion??????
  }
  
  private static void usage() {
    System.err.println("usage: PCClient [-comm <source>]");
  }
  
  public static void main(String[] args) throws Exception {
    String source = null;
    if (args.length == 2) {
      if (!args[0].equals("-comm")) {
        usage();
        System.exit(1);
      }
      source = args[1];
    }
    else if (args.length != 0) {
      usage();
      System.exit(1);
    }
    
    PhoenixSource phoenix;
    
    if (source == null) {
      phoenix = BuildSource.makePhoenix(PrintStreamMessenger.err);
    }
    else {
      phoenix = BuildSource.makePhoenix(source, PrintStreamMessenger.err);
    }

    MoteIF mif = new MoteIF(phoenix);
    PCClient serial = new PCClient(mif);
    serial.requestNodeTime();
  }
}
