/**
 * This class is automatically generated by mig. DO NOT EDIT THIS FILE.
 * This class implements a Java interface to the 'PCClientMsg'
 * message type.
 */

public class PCClientMsg extends net.tinyos.message.Message {

    /** The default size of this message type in bytes. */
    public static final int DEFAULT_MESSAGE_SIZE = 26;

    /** The Active Message type associated with this message. */
    public static final int AM_TYPE = 6;

    /** Create a new PCClientMsg of size 26. */
    public PCClientMsg() {
        super(DEFAULT_MESSAGE_SIZE);
        amTypeSet(AM_TYPE);
    }

    /** Create a new PCClientMsg of the given data_length. */
    public PCClientMsg(int data_length) {
        super(data_length);
        amTypeSet(AM_TYPE);
    }

    /**
     * Create a new PCClientMsg with the given data_length
     * and base offset.
     */
    public PCClientMsg(int data_length, int base_offset) {
        super(data_length, base_offset);
        amTypeSet(AM_TYPE);
    }

    /**
     * Create a new PCClientMsg using the given byte array
     * as backing store.
     */
    public PCClientMsg(byte[] data) {
        super(data);
        amTypeSet(AM_TYPE);
    }

    /**
     * Create a new PCClientMsg using the given byte array
     * as backing store, with the given base offset.
     */
    public PCClientMsg(byte[] data, int base_offset) {
        super(data, base_offset);
        amTypeSet(AM_TYPE);
    }

    /**
     * Create a new PCClientMsg using the given byte array
     * as backing store, with the given base offset and data length.
     */
    public PCClientMsg(byte[] data, int base_offset, int data_length) {
        super(data, base_offset, data_length);
        amTypeSet(AM_TYPE);
    }

    /**
     * Create a new PCClientMsg embedded in the given message
     * at the given base offset.
     */
    public PCClientMsg(net.tinyos.message.Message msg, int base_offset) {
        super(msg, base_offset, DEFAULT_MESSAGE_SIZE);
        amTypeSet(AM_TYPE);
    }

    /**
     * Create a new PCClientMsg embedded in the given message
     * at the given base offset and length.
     */
    public PCClientMsg(net.tinyos.message.Message msg, int base_offset, int data_length) {
        super(msg, base_offset, data_length);
        amTypeSet(AM_TYPE);
    }

    /**
    /* Return a String representation of this message. Includes the
     * message type name and the non-indexed field values.
     */
    public String toString() {
      String s = "Message <PCClientMsg> \n";
      try {
        s += "  [node_id=0x"+Long.toHexString(get_node_id())+"]\n";
      } catch (ArrayIndexOutOfBoundsException aioobe) { /* Skip field */ }
      try {
        s += "  [type=0x"+Long.toHexString(get_type())+"]\n";
      } catch (ArrayIndexOutOfBoundsException aioobe) { /* Skip field */ }
      try {
        s += "  [timestamp=0x"+Long.toHexString(get_timestamp())+"]\n";
      } catch (ArrayIndexOutOfBoundsException aioobe) { /* Skip field */ }
      try {
        s += "  [timestamp1=0x"+Long.toHexString(get_timestamp1())+"]\n";
      } catch (ArrayIndexOutOfBoundsException aioobe) { /* Skip field */ }
      try {
        s += "  [timestamp5=0x"+Long.toHexString(get_timestamp5())+"]\n";
      } catch (ArrayIndexOutOfBoundsException aioobe) { /* Skip field */ }
      try {
        s += "  [timestamp6=0x"+Long.toHexString(get_timestamp6())+"]\n";
      } catch (ArrayIndexOutOfBoundsException aioobe) { /* Skip field */ }
      try {
        s += "  [timestamp8=0x"+Long.toHexString(get_timestamp8())+"]\n";
      } catch (ArrayIndexOutOfBoundsException aioobe) { /* Skip field */ }
      try {
        s += "  [delta=0x"+Long.toHexString(get_delta())+"]\n";
      } catch (ArrayIndexOutOfBoundsException aioobe) { /* Skip field */ }
      return s;
    }

    // Message-type-specific access methods appear below.

    /////////////////////////////////////////////////////////
    // Accessor methods for field: node_id
    //   Field type: short, signed
    //   Offset (bits): 0
    //   Size (bits): 8
    /////////////////////////////////////////////////////////

    /**
     * Return whether the field 'node_id' is signed (true).
     */
    public static boolean isSigned_node_id() {
        return true;
    }

    /**
     * Return whether the field 'node_id' is an array (false).
     */
    public static boolean isArray_node_id() {
        return false;
    }

    /**
     * Return the offset (in bytes) of the field 'node_id'
     */
    public static int offset_node_id() {
        return (0 / 8);
    }

    /**
     * Return the offset (in bits) of the field 'node_id'
     */
    public static int offsetBits_node_id() {
        return 0;
    }

    /**
     * Return the value (as a short) of the field 'node_id'
     */
    public short get_node_id() {
        return (short)getUIntBEElement(offsetBits_node_id(), 8);
    }

    /**
     * Set the value of the field 'node_id'
     */
    public void set_node_id(short value) {
        setUIntBEElement(offsetBits_node_id(), 8, value);
    }

    /**
     * Return the size, in bytes, of the field 'node_id'
     */
    public static int size_node_id() {
        return (8 / 8);
    }

    /**
     * Return the size, in bits, of the field 'node_id'
     */
    public static int sizeBits_node_id() {
        return 8;
    }

    /////////////////////////////////////////////////////////
    // Accessor methods for field: type
    //   Field type: short, signed
    //   Offset (bits): 8
    //   Size (bits): 8
    /////////////////////////////////////////////////////////

    /**
     * Return whether the field 'type' is signed (true).
     */
    public static boolean isSigned_type() {
        return true;
    }

    /**
     * Return whether the field 'type' is an array (false).
     */
    public static boolean isArray_type() {
        return false;
    }

    /**
     * Return the offset (in bytes) of the field 'type'
     */
    public static int offset_type() {
        return (8 / 8);
    }

    /**
     * Return the offset (in bits) of the field 'type'
     */
    public static int offsetBits_type() {
        return 8;
    }

    /**
     * Return the value (as a short) of the field 'type'
     */
    public short get_type() {
        return (short)getUIntBEElement(offsetBits_type(), 8);
    }

    /**
     * Set the value of the field 'type'
     */
    public void set_type(short value) {
        setUIntBEElement(offsetBits_type(), 8, value);
    }

    /**
     * Return the size, in bytes, of the field 'type'
     */
    public static int size_type() {
        return (8 / 8);
    }

    /**
     * Return the size, in bits, of the field 'type'
     */
    public static int sizeBits_type() {
        return 8;
    }

    /////////////////////////////////////////////////////////
    // Accessor methods for field: timestamp
    //   Field type: long, signed
    //   Offset (bits): 16
    //   Size (bits): 32
    /////////////////////////////////////////////////////////

    /**
     * Return whether the field 'timestamp' is signed (true).
     */
    public static boolean isSigned_timestamp() {
        return true;
    }

    /**
     * Return whether the field 'timestamp' is an array (false).
     */
    public static boolean isArray_timestamp() {
        return false;
    }

    /**
     * Return the offset (in bytes) of the field 'timestamp'
     */
    public static int offset_timestamp() {
        return (16 / 8);
    }

    /**
     * Return the offset (in bits) of the field 'timestamp'
     */
    public static int offsetBits_timestamp() {
        return 16;
    }

    /**
     * Return the value (as a long) of the field 'timestamp'
     */
    public long get_timestamp() {
        return (long)getUIntBEElement(offsetBits_timestamp(), 32);
    }

    /**
     * Set the value of the field 'timestamp'
     */
    public void set_timestamp(long value) {
        setUIntBEElement(offsetBits_timestamp(), 32, value);
    }

    /**
     * Return the size, in bytes, of the field 'timestamp'
     */
    public static int size_timestamp() {
        return (32 / 8);
    }

    /**
     * Return the size, in bits, of the field 'timestamp'
     */
    public static int sizeBits_timestamp() {
        return 32;
    }

    /////////////////////////////////////////////////////////
    // Accessor methods for field: timestamp1
    //   Field type: long, signed
    //   Offset (bits): 48
    //   Size (bits): 32
    /////////////////////////////////////////////////////////

    /**
     * Return whether the field 'timestamp1' is signed (true).
     */
    public static boolean isSigned_timestamp1() {
        return true;
    }

    /**
     * Return whether the field 'timestamp1' is an array (false).
     */
    public static boolean isArray_timestamp1() {
        return false;
    }

    /**
     * Return the offset (in bytes) of the field 'timestamp1'
     */
    public static int offset_timestamp1() {
        return (48 / 8);
    }

    /**
     * Return the offset (in bits) of the field 'timestamp1'
     */
    public static int offsetBits_timestamp1() {
        return 48;
    }

    /**
     * Return the value (as a long) of the field 'timestamp1'
     */
    public long get_timestamp1() {
        return (long)getUIntBEElement(offsetBits_timestamp1(), 32);
    }

    /**
     * Set the value of the field 'timestamp1'
     */
    public void set_timestamp1(long value) {
        setUIntBEElement(offsetBits_timestamp1(), 32, value);
    }

    /**
     * Return the size, in bytes, of the field 'timestamp1'
     */
    public static int size_timestamp1() {
        return (32 / 8);
    }

    /**
     * Return the size, in bits, of the field 'timestamp1'
     */
    public static int sizeBits_timestamp1() {
        return 32;
    }

    /////////////////////////////////////////////////////////
    // Accessor methods for field: timestamp5
    //   Field type: long, signed
    //   Offset (bits): 80
    //   Size (bits): 32
    /////////////////////////////////////////////////////////

    /**
     * Return whether the field 'timestamp5' is signed (true).
     */
    public static boolean isSigned_timestamp5() {
        return true;
    }

    /**
     * Return whether the field 'timestamp5' is an array (false).
     */
    public static boolean isArray_timestamp5() {
        return false;
    }

    /**
     * Return the offset (in bytes) of the field 'timestamp5'
     */
    public static int offset_timestamp5() {
        return (80 / 8);
    }

    /**
     * Return the offset (in bits) of the field 'timestamp5'
     */
    public static int offsetBits_timestamp5() {
        return 80;
    }

    /**
     * Return the value (as a long) of the field 'timestamp5'
     */
    public long get_timestamp5() {
        return (long)getUIntBEElement(offsetBits_timestamp5(), 32);
    }

    /**
     * Set the value of the field 'timestamp5'
     */
    public void set_timestamp5(long value) {
        setUIntBEElement(offsetBits_timestamp5(), 32, value);
    }

    /**
     * Return the size, in bytes, of the field 'timestamp5'
     */
    public static int size_timestamp5() {
        return (32 / 8);
    }

    /**
     * Return the size, in bits, of the field 'timestamp5'
     */
    public static int sizeBits_timestamp5() {
        return 32;
    }

    /////////////////////////////////////////////////////////
    // Accessor methods for field: timestamp6
    //   Field type: long, signed
    //   Offset (bits): 112
    //   Size (bits): 32
    /////////////////////////////////////////////////////////

    /**
     * Return whether the field 'timestamp6' is signed (true).
     */
    public static boolean isSigned_timestamp6() {
        return true;
    }

    /**
     * Return whether the field 'timestamp6' is an array (false).
     */
    public static boolean isArray_timestamp6() {
        return false;
    }

    /**
     * Return the offset (in bytes) of the field 'timestamp6'
     */
    public static int offset_timestamp6() {
        return (112 / 8);
    }

    /**
     * Return the offset (in bits) of the field 'timestamp6'
     */
    public static int offsetBits_timestamp6() {
        return 112;
    }

    /**
     * Return the value (as a long) of the field 'timestamp6'
     */
    public long get_timestamp6() {
        return (long)getUIntBEElement(offsetBits_timestamp6(), 32);
    }

    /**
     * Set the value of the field 'timestamp6'
     */
    public void set_timestamp6(long value) {
        setUIntBEElement(offsetBits_timestamp6(), 32, value);
    }

    /**
     * Return the size, in bytes, of the field 'timestamp6'
     */
    public static int size_timestamp6() {
        return (32 / 8);
    }

    /**
     * Return the size, in bits, of the field 'timestamp6'
     */
    public static int sizeBits_timestamp6() {
        return 32;
    }

    /////////////////////////////////////////////////////////
    // Accessor methods for field: timestamp8
    //   Field type: long, signed
    //   Offset (bits): 144
    //   Size (bits): 32
    /////////////////////////////////////////////////////////

    /**
     * Return whether the field 'timestamp8' is signed (true).
     */
    public static boolean isSigned_timestamp8() {
        return true;
    }

    /**
     * Return whether the field 'timestamp8' is an array (false).
     */
    public static boolean isArray_timestamp8() {
        return false;
    }

    /**
     * Return the offset (in bytes) of the field 'timestamp8'
     */
    public static int offset_timestamp8() {
        return (144 / 8);
    }

    /**
     * Return the offset (in bits) of the field 'timestamp8'
     */
    public static int offsetBits_timestamp8() {
        return 144;
    }

    /**
     * Return the value (as a long) of the field 'timestamp8'
     */
    public long get_timestamp8() {
        return (long)getUIntBEElement(offsetBits_timestamp8(), 32);
    }

    /**
     * Set the value of the field 'timestamp8'
     */
    public void set_timestamp8(long value) {
        setUIntBEElement(offsetBits_timestamp8(), 32, value);
    }

    /**
     * Return the size, in bytes, of the field 'timestamp8'
     */
    public static int size_timestamp8() {
        return (32 / 8);
    }

    /**
     * Return the size, in bits, of the field 'timestamp8'
     */
    public static int sizeBits_timestamp8() {
        return 32;
    }

    /////////////////////////////////////////////////////////
    // Accessor methods for field: delta
    //   Field type: int, signed
    //   Offset (bits): 176
    //   Size (bits): 32
    /////////////////////////////////////////////////////////

    /**
     * Return whether the field 'delta' is signed (true).
     */
    public static boolean isSigned_delta() {
        return true;
    }

    /**
     * Return whether the field 'delta' is an array (false).
     */
    public static boolean isArray_delta() {
        return false;
    }

    /**
     * Return the offset (in bytes) of the field 'delta'
     */
    public static int offset_delta() {
        return (176 / 8);
    }

    /**
     * Return the offset (in bits) of the field 'delta'
     */
    public static int offsetBits_delta() {
        return 176;
    }

    /**
     * Return the value (as a int) of the field 'delta'
     */
    public int get_delta() {
        return (int)getSIntBEElement(offsetBits_delta(), 32);
    }

    /**
     * Set the value of the field 'delta'
     */
    public void set_delta(int value) {
        setSIntBEElement(offsetBits_delta(), 32, value);
    }

    /**
     * Return the size, in bytes, of the field 'delta'
     */
    public static int size_delta() {
        return (32 / 8);
    }

    /**
     * Return the size, in bits, of the field 'delta'
     */
    public static int sizeBits_delta() {
        return 32;
    }

}
