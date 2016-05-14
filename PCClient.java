import java.io.IOException;
import java.util.Scanner;

import net.tinyos.message.*;
import net.tinyos.packet.*;
import net.tinyos.util.*;

public class PCClient implements MessageListener {

  private MoteIF moteIF1, moteIF2;
  public short node_id = 4;
  public short packet_type = 3;
  public PCClientMsg msg1, msg2;
  
  public PCClient(MoteIF moteIF1, MoteIF moteIF2) {
    this.moteIF1 = moteIF1;
    this.moteIF2 = moteIF2;
    this.moteIF1.registerListener(new PCClientMsg(), this);
    this.moteIF2.registerListener(new PCClientMsg(), this);
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
  		moteIF1.send(1, payload);
      moteIF2.send(2, payload);
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
    System.out.print("Node " + msg.get_node_id() + ": " + msg.get_timestamp());//time conversion??????
    if (msg.get_node_id() == 1) { //sender
      System.out.printf(", Delta: %d, T1 T5 T6 T8: %d %d %d %d" , msg.get_delta(), msg.get_timestamp1(), msg.get_timestamp5(),
        msg.get_timestamp6(), msg.get_timestamp8());
    }
    System.out.println();
  }
  
  private static void usage() {
    System.err.println("usage: PCClient [-comm <source>]");
  }
  
  public static void main(String[] args) throws Exception {
    String source1 = null;
    String source2 = null;
    if (args.length == 3) {
      if (!args[0].equals("-comm")) {
        usage();
        System.exit(1);
      }
      source1 = args[1];
      source2 = args[2];
    }
    else if (args.length != 0) {
      usage();
      System.exit(1);
    }
    
    PhoenixSource phoenix1, phoenix2;
    
    if (source1==null || source2==null) {
      phoenix1 = BuildSource.makePhoenix(PrintStreamMessenger.err);
      phoenix2 = BuildSource.makePhoenix(PrintStreamMessenger.err);
    }
    else {
      phoenix1 = BuildSource.makePhoenix(source1, PrintStreamMessenger.err);
      phoenix2 = BuildSource.makePhoenix(source2, PrintStreamMessenger.err);
    }

    MoteIF mif1 = new MoteIF(phoenix1);
    MoteIF mif2 = new MoteIF(phoenix2);
    PCClient serial = new PCClient(mif1, mif2);
    serial.requestNodeTime();
  }
}
