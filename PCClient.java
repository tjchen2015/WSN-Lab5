import java.io.IOException;
import java.util.Scanner;

import net.tinyos.message.*;
import net.tinyos.packet.*;
import net.tinyos.util.*;

public class PCClient implements MessageListener {

  private MoteIF moteIF;
  
  public PCClient(MoteIF moteIF) {
    this.moteIF = moteIF;
    this.moteIF.registerListener(new PCClientMsg(), this);
  }

  public void userInput() {
    Scanner scanner = new Scanner(System.in);
  	while(true){
  		System.out.println("Please input a number to show on the LEDs: ");
  		int inputNum = scanner.nextInt();
  		System.out.println();
  		
  		sendPackets(inputNum);
  	}
  }
  
  public void sendPackets(int inputNum) {
    PCClientMsg payload = new PCClientMsg();
    
    try {
  		System.out.println("Sending packet with input " + inputNum);
  		payload.set_counter(inputNum);
  		moteIF.send(0, payload);
    }
    catch (IOException exception) {
      System.err.println("Exception thrown when sending packets. Exiting.");
      System.err.println(exception);
    }
  }

  public void messageReceived(int to, Message message) {
    PCClientMsg msg = (PCClientMsg)message;
    System.out.println("Received packet from nodeid " + msg.get_nodeid() + " ; counter " + msg.get_counter());
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
    serial.userInput();
  }


}
