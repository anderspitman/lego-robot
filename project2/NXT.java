package lego;

/*
 * NXT.java
 *
 * Created on March 15, 2008, 8:56 AM
 * Modified 11/28/09 BC
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintStream;
import java.io.UnsupportedEncodingException;
import javax.microedition.io.Connector;
import javax.microedition.io.StreamConnection;

/**
 *
 * @author rsims
 */
public class NXT {
    
    // NXT Communication Protocol Definitions
    public static final byte DIRECT_COMMAND_REPLY=0x00;
    public static final byte SYSTEM_COMMAND_REPLY=0x01;
    public static final byte REPLY_COMMAND=0x02;
    public static final byte DIRECT_COMMAND_NOREPLY=(byte)0x80;
    public static final byte SYSTEM_COMMAND_NOREPLY=(byte)0x81;

    // System Command Definitions
    public static final byte GET_FIRMWARE_VERSION=(byte)0x88;
    
    // Direct Command Definitions
    public static final byte START_PROGRAM=0x00;
    public static final byte STOP_PROGRAM=0x01;
    public static final byte PLAY_TONE=0x03;
    public static final byte SET_OUTPUT_STATE=0x04;
    public static final byte SET_INPUT_MODE=0x05;
    public static final byte GET_OUTPUT_STATE=0x06;
    public static final byte GET_INPUT_VALUES=0x07;
    public static final byte RESET_INPUT_SCALED_VALUE=0x08;
    public static final byte MESSAGE_WRITE=0x09;
    public static final byte RESET_MOTOR_POSITION=0x0A;
    public static final byte GET_BATTERY_LEVEL=0x0B;
    public static final byte LOW_SPEED_STATUS=0x0E;
    public static final byte LOW_SPEED_WRITE=0x0F;
    public static final byte LOW_SPEED_READ=0x10;

    // NXC JavaController Operation Codes
    public static final byte OP_PROGSTOP=0x00;
    public static final byte OP_MOTORFWD=0x01;
    public static final byte OP_MOTORREV=0x02;
    public static final byte OP_MOTORBRAKE=0x03;
    public static final byte OP_MOTORCOAST=0x04;
    public static final byte OP_MOTORFWDREG=0x05;
    public static final byte OP_MOTORREVREG=0x06;
    public static final byte OP_MOTORFWDSYNC=0x07;
    public static final byte OP_MOTORREVSYNC=0x08;
    public static final byte OP_MOTORROTATE=0x09;
    public static final byte OP_MOTORROTATEEXT=0x0A;
    
    // Motor Output Port Enumeration Codes
    public static final byte OUT_A=0x00;
    public static final byte OUT_B=0x01;
    public static final byte OUT_C=0x02;
    public static final byte OUT_AB=0x03;
    public static final byte OUT_AC=0x04;
    public static final byte OUT_BC=0x05;
    public static final byte OUT_ABC=0x06;

    // Sensor Type Enumeration Codes
    public static final byte SENSOR_TYPE_NONE=0x00;
    public static final byte SENSOR_TYPE_TOUCH=0x01;
    public static final byte SENSOR_TYPE_TEMPERATURE=0x02;
    public static final byte SENSOR_TYPE_LIGHT=0x03;
    public static final byte SENSOR_TYPE_ROTATION=0x04;
    public static final byte SENSOR_TYPE_LIGHT_ACTIVE=0x05;
    public static final byte SENSOR_TYPE_LIGHT_INACTIVE=0x06;
    public static final byte SENSOR_TYPE_COLORFULL=0x0D;
    public static final byte SENSOR_TYPE_COLORRED=0x0E;
    public static final byte SENSOR_TYPE_COLORBLUE=0x10;
    public static final byte SENSOR_TYPE_COLORGREEN=0x0F;
    public static final byte SENSOR_TYPE_COLORNONE=0x11;
    public static final byte SENSOR_TYPE_SOUND_DB=0x07;
    public static final byte SENSOR_TYPE_SOUND_DBA=0x08;
    public static final byte SENSOR_TYPE_CUSTOM=0x09;
    public static final byte SENSOR_TYPE_LOWSPEED=0x0A;
    public static final byte SENSOR_TYPE_LOWSPEED_9V=0x0B;

    // Sensor Mode Enumeration Codes
    public static final byte SENSOR_MODE_RAW=0x00;
    public static final byte SENSOR_MODE_BOOLEAN=0x20;
    public static final byte SENSOR_MODE_EDGE=0x40;
    public static final byte SENSOR_MODE_PULSE=0x60;
    public static final byte SENSOR_MODE_PERCENT=(byte)0x80;
    public static final byte SENSOR_MODE_CELSIUS=(byte)0xA0;
    public static final byte SENSOR_MODE_FAHRENHEIT=(byte)0xC0;
    public static final byte SENSOR_MODE_ROTATION=(byte)0xE0;

    // Sensor Input Ports Enumeration Codes
    public static final byte IN_1=0x00;
    public static final byte IN_2=0x01;
    public static final byte IN_3=0x02;
    public static final byte IN_4=0x03;

    // Motor Output State Inner Class
    public class OutputState {
        public byte statusCode;
        public byte port;
        public byte powerSetPoint;
        public byte mode;
        public byte regulationMode;
        public byte turnRatio;
        public byte runState;
        public int tachoLimit;
        public int tachoCount;
        public int blockTachoCount;
        public int rotationCount;
    }

    // Sensor Input Values Inner Class
    public class InputValues {
        public byte statusCode;
        public byte port;
        public byte valid;
        public byte calibrated;
        public byte sensorType;
        public byte sensorMode;
        public int rawValue;
        public int normalizedValue;
        public int scaledValue;
        public int calibratedValue;
    }

    // Low Speed Status Inner Class
    public class LowSpeedStatus {
        public byte statusCode;
        public byte bytesReady;
    }

    // Low Speed Status Inner Class
    public class LowSpeedData {
        public byte statusCode;
        public byte bytesRead;
        public byte[] rxData = new byte[16];
    }

    // Bluetooth Connection and Output Stream Related Instance Variables
    String address;
    StreamConnection connection;
    InputStream input;
    OutputStream output;
    PrintStream consoleSave;
    NXTOutputStream consoleFilter;
    
    /** Creates a new instance of NXT */
    public NXT(String address) {
        this.address=address;
        consoleFilter=new NXTOutputStream(System.out);
        consoleSave = System.out;
        System.setOut(new PrintStream(consoleFilter));
        open();
    }

    public void open() {
        try {
            consoleFilter.setSuspendOutput(true);
            connection = (StreamConnection) Connector.open("btspp://" + address + ":1;authenticate=false;encrypt=false");
            input = connection.openInputStream();
            output = connection.openOutputStream();
            int retVal = startProgram("javaCtrl.rxe");
            consoleFilter.setSuspendOutput(false);
            if (retVal != 0x00) {
                String num = String.format("%x", (retVal & 0xFF));
                System.out.println("Error: Motor Control Program Execution Error " + num);
            }
        } catch (IOException ex) {
            ex.printStackTrace();
        }
    }
    
    public void close() {
        try {
            int retVal=stopProgram();
            if(retVal!=0x00) {
                String num=String.format("%x", (retVal&0xFF));
                System.out.println("Error: Motor Control Program Termination Error " + num );
            }
            consoleFilter.setSuspendOutput(true);
            input.close();
            output.close();
            connection.close();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    public int startProgram(String file) {
        byte[] request = new byte[64];
        byte[] response = new byte[3];
        byte[] fileBytes = toASCII(file);

        // Construct Packet (Always Wait for Reply)
        request[0] = DIRECT_COMMAND_REPLY;
        request[1] = START_PROGRAM;
        System.arraycopy(fileBytes, 0, request, 2, fileBytes.length);

        // Write Packet and Get Return Status if Requested
        writePacket(request);
        readPacket(response);
        return (int) response[2];
    }

    public int stopProgram() {
        byte[] request = {DIRECT_COMMAND_REPLY, STOP_PROGRAM};
        byte[] response = new byte[3];

        // Write Packet and Get Return Status if Requested
        writePacket(request);
        readPacket(response);
        return (int) response[2];
    }

    public String getFirmwareVersion() {
         byte[] request={SYSTEM_COMMAND_REPLY,GET_FIRMWARE_VERSION};
         byte[] response=new byte[7];
         writePacket(request);
         readPacket(response);
         if(response[2]==0x00) {
             String protocolVersion=new String(response[4]+"."+response[3]);
             String firmwareVersion=new String(response[6]+"."+response[5]);
             return "Protocol Version: " + protocolVersion + " Firmware Version: " + firmwareVersion;
         }
         return("Unavailable");
    }

    public int getBatteryLevel() {
        byte[] request = {DIRECT_COMMAND_REPLY, GET_BATTERY_LEVEL};
        byte[] response = new byte[5];

        // Write Packet and Set Return Value
        writePacket(request);
        readPacket(response);
        return response[2] == 0x00 ? ((response[3] & 0xFF) | ((response[4] & 0xFF) << 8)) : -1;
    }

    public int playTone(int frequency, int duration) {
        byte[] request = {DIRECT_COMMAND_REPLY, PLAY_TONE, (byte) frequency, (byte) (frequency >>> 8),
                          (byte) duration, (byte) (duration >>> 8)};
        byte[] response = new byte[3];
        
        // Write Packet and Set Return Value
        writePacket(request);
        readPacket(response);
        return ((int) response[2]);
    }

    public int messageWrite(int inbox, byte[] message) {
        byte[] request = new byte[message.length+4];
        byte[] response = new byte[3];

        // Construct Packet
        request[0] = DIRECT_COMMAND_REPLY;
        request[1] = MESSAGE_WRITE;
        request[2] = (byte) inbox;
        request[3] = (byte) (message.length);
        System.arraycopy(message, 0, request, 4, message.length);

        // Write Packet
        writePacket(request);
        readPacket(response);
        return (int) response[2];
    }

    public LowSpeedStatus lowSpeedGetStatus(int port) {
        byte[] request = {DIRECT_COMMAND_REPLY, LOW_SPEED_STATUS, (byte) port};
        byte[] response = new byte[4];
        LowSpeedStatus result = new LowSpeedStatus();
        writePacket(request);
        readPacket(response);
        result.statusCode = response[2];
        if (result.statusCode == 0) {
            result.bytesReady = response[3];

            //System.out.println("LS statusCode: " + result.statusCode );
            //System.out.println("LS bytesReady: " + result.bytesReady );
        }
        return (result);
    }

    public int lowSpeedWrite(int port,int rxDataLength,byte[] txData) {
        byte[] request = new byte[txData.length+5];
        byte[] response = new byte[3];

        // Construct Packet
        request[0] = DIRECT_COMMAND_REPLY;
        request[1] = LOW_SPEED_WRITE;
        request[2] = (byte) port;
        request[3] = (byte) (txData.length);
        request[4] = (byte) rxDataLength;
        System.arraycopy(txData, 0, request, 5, txData.length);

        // Write Packet
        writePacket(request);
        readPacket(response);
        return (int) response[2];
    }

    public LowSpeedData lowSpeedRead(int port) {
        byte[] request = {DIRECT_COMMAND_REPLY, LOW_SPEED_READ, (byte) port};
        byte[] response = new byte[20];
        LowSpeedData result = new LowSpeedData();
        writePacket(request);
        readPacket(response);
        result.statusCode = response[2];
        if (result.statusCode == 0) {
            result.bytesRead = response[3];
            System.arraycopy(response, 4, result.rxData, 0, 16);

            //System.out.println("LS Read bytesRead: " + result.bytesRead);
            //for(int i=0;i<result.bytesRead;i++)
            //    System.out.println("LS Read Byte " + i + ": " + result.rxData[i]);
        }
        return (result);
    }

    public int setOutputState(int port,int power,int mode,int regulationMode,int turnRatio,int runState,int tachoLimit) {
        byte[] request={DIRECT_COMMAND_REPLY,SET_OUTPUT_STATE,(byte)port,(byte)power,(byte)mode,(byte)regulationMode,
                        (byte)turnRatio,(byte)runState,(byte)(tachoLimit),(byte)(tachoLimit>>>8),(byte)(tachoLimit>>>16),
                        (byte)(tachoLimit>>>24)};
        byte[] response=new byte[3];
        writePacket(request);
        readPacket(response);
        return((int)response[2]);
    }

    public OutputState getOutputState(int port) {
         byte[] request={DIRECT_COMMAND_REPLY,GET_OUTPUT_STATE,(byte)port};
         byte[] response=new byte[25];
         OutputState result=new OutputState();
         writePacket(request);
         readPacket(response);
         result.statusCode=response[2];
         if(result.statusCode==0) {
             result.port=response[3];
             result.powerSetPoint=response[4];
             result.mode=response[5];
             result.regulationMode=response[6];
             result.turnRatio=response[7];
             result.runState=response[8];
             result.tachoLimit=     (response[9] &0xFF) | ((response[10]&0xFF)<<8) | ((response[11]&0xFF)<<16) | ((response[12]&0xFF)<<24);
             result.tachoCount=     (response[13]&0xFF) | ((response[14]&0xFF)<<8) | ((response[15]&0xFF)<<16) | ((response[16]&0xFF)<<24);
             result.blockTachoCount=(response[17]&0xFF) | ((response[18]&0xFF)<<8) | ((response[19]&0xFF)<<16) | ((response[20]&0xFF)<<24);
             result.rotationCount=  (response[21]&0xFF) | ((response[22]&0xFF)<<8) | ((response[23]&0xFF)<<16) | ((response[24]&0xFF)<<24);
         }
         return(result);
    }

    public int setInputMode(int port, int sensorType, int sensorMode) {
        byte[] request = {DIRECT_COMMAND_REPLY, SET_INPUT_MODE, (byte) port, (byte) sensorType, (byte) sensorMode};
        byte[] response = new byte[3];
        writePacket(request);
        readPacket(response);
        return ((int) response[2]);
    }

    public InputValues getInputValues(int port) {
        byte[] request = {DIRECT_COMMAND_REPLY, GET_INPUT_VALUES, (byte) port};
        byte[] response = new byte[16];
        writePacket(request);
        readPacket(response);
        InputValues result=new InputValues();
        result.statusCode=response[2];
        if(result.statusCode==0) {
             result.port=response[3];
             result.valid=response[4];
             result.calibrated=response[5];
             result.sensorType=response[6];
             result.sensorMode=response[7];
             result.rawValue= (response[8] &0xFF) | ((response[9]&0xFF)<<8);
             result.normalizedValue= (response[10]&0xFF) | ((response[11]&0xFF)<<8);
             result.scaledValue=     (response[12]&0xFF) | ((response[13]&0xFF)<<8);
             result.calibratedValue= (response[14]&0xFF) | ((response[15]&0xFF)<<8);
         }
         return(result);
    }

    public int resetInputScaledValue(int port) {
        byte[] request = {DIRECT_COMMAND_REPLY, RESET_INPUT_SCALED_VALUE, (byte) port};
        byte[] response = new byte[3];
        writePacket(request);
        readPacket(response);
        return ((int) response[2]);
    }

    private void writePacket(byte[] buffer) {
        try {
            // Write Packet Length
            output.write((byte)buffer.length);
            output.write((byte)(buffer.length>>>8));

            // Write Packet Contents
            output.write(buffer);
        } catch (IOException ex) {
            ex.printStackTrace();
        }
   }

    @SuppressWarnings("empty-statement")
    private int readPacket(byte[] buffer) {
        int lengthLSB, lengthMSB, length;

        try {
            // Block Until Packet Length is Available
            while ((lengthLSB = input.read()) < 0);
            lengthMSB = input.read();
            length = (0xFF & lengthLSB) | ((0xFF & lengthMSB) << 8);

            // Read Length Bytes from Input Stream
            input.read(buffer, 0, length);
            return (length);
        } catch (IOException ex) {
            ex.printStackTrace();
        }
        return (-1);
    }

    private byte[] toASCII(String str) {

        // Create Byte Array
        int len=str.length();
        byte[] asciiBytes = new byte[len + 1];

        // Get Byte Representation of Message
        try {
            System.arraycopy(str.getBytes("US-ASCII"), 0, asciiBytes, 0, len);
            asciiBytes[len]=0x00;
        } catch (UnsupportedEncodingException ex) {
            asciiBytes = new byte[1];
            asciiBytes[0]=0x00;
        }
        for(int i=0;i<len;i++) {
            System.out.print(asciiBytes[i]+" ");
        }
        System.out.println();
        return asciiBytes;
    }

    public int motorForward(int port, int power) {
        byte[] message = {OP_MOTORFWD, (byte) port, (byte) ((short) power), (byte) (((short) power) >>> 8), (byte) 0x00};
        return messageWrite(0, message);
    }

    public int motorReverse(int port, int power) {
        byte[] message = {OP_MOTORREV, (byte) port, (byte) ((short) power), (byte) (((short) power) >>> 8), (byte) 0x00};
        return messageWrite(0, message);
    }

    public int motorBrake(int port) {
        byte[] message = {OP_MOTORBRAKE, (byte) port, (byte) 0x00};
        return messageWrite(0, message);
    }

     public int motorCoast(int port) {
        byte[] message = {OP_MOTORCOAST, (byte) port, (byte) 0x00};
        return messageWrite(0, message);
    }

    public int motorForwardReg(int port, int power) {
        byte[] message = {OP_MOTORFWDREG, (byte) port, (byte) ((short) power), (byte) (((short) power) >>> 8), (byte) 0x00};
        return messageWrite(0, message);
    }

    public int motorReverseReg(int port, int power) {
        byte[] message = {OP_MOTORREVREG, (byte) port, (byte) ((short) power), (byte) (((short) power) >>> 8), (byte) 0x00};
        return messageWrite(0, message);
    }

    public int motorForwardSync(int port, int power, int turnpct) {
        byte[] message = {OP_MOTORFWDSYNC, (byte) port, (byte) ((short) power), (byte) (((short) power) >>> 8),
                          (byte) ((short) turnpct), (byte) (((short) turnpct) >>> 8), (byte) 0x00};
        return messageWrite(0, message);
    }

    public int motorReverseSync(int port, int power, int turnpct) {
        byte[] message = {OP_MOTORREVSYNC, (byte) port, (byte) ((short) power), (byte) (((short) power) >>> 8),
                          (byte) ((short) turnpct), (byte) (((short) turnpct) >>> 8),(byte) 0x00};
        return messageWrite(0, message);
    }

    public int motorRotate(int port, int power, int angle) {
        byte[] message = {OP_MOTORROTATE, (byte) port, (byte) ((short) power), (byte) (((short) power) >>> 8),
                          (byte) ((short) angle), (byte) (((short) angle) >>> 8), (byte) 0x00};
        return messageWrite(0, message);
    }

    public int motorRotateExt(int port, int power, int angle, int turnpct, boolean sync, boolean stop) {
        byte[] message = {OP_MOTORROTATEEXT, (byte) port, (byte) ((short) power), (byte) (((short) power) >>> 8),
                          (byte) ((short) angle), (byte) (((short) angle) >>> 8),
                          (byte) ((short) turnpct), (byte) (((short) turnpct) >>> 8),
                          (byte) (sync ? 0x01 : 0x00), (byte) (stop ? 0x01 : 0x00), (byte) 0x00};
        return messageWrite(0, message);
    }

    public int setSensorTouch(int port) {
        int retVal=setInputMode(port,SENSOR_TYPE_TOUCH,SENSOR_MODE_BOOLEAN);
        resetInputScaledValue(port);
        return retVal;
    }

    public int setSensorSound(int port) {
        int retVal=setInputMode(port,SENSOR_TYPE_SOUND_DB,SENSOR_MODE_PERCENT);
        resetInputScaledValue(port);
        return retVal;
    }

    public int setSensorSoundAdjusted(int port) {
        int retVal=setInputMode(port,SENSOR_TYPE_SOUND_DBA,SENSOR_MODE_PERCENT);
        resetInputScaledValue(port);
        return retVal;
    }

    public int setSensorLight(int port) {
        int retVal = setInputMode(port, SENSOR_TYPE_LIGHT_INACTIVE, SENSOR_MODE_PERCENT);
        resetInputScaledValue(port);
        return retVal;
    }

    public int setSensorLightActive(int port) {
        int retVal = setInputMode(port, SENSOR_TYPE_LIGHT_ACTIVE, SENSOR_MODE_PERCENT);
        resetInputScaledValue(port);
        return retVal;
    }

    public int setSensorColorFull(int port) {
//        int retVal = setInputMode(port, SENSOR_TYPE_COLORFULL, SENSOR_MODE_PERCENT);
        int retVal = setInputMode(port, SENSOR_TYPE_COLORFULL, ReadColorSensorEx);
        resetInputScaledValue(port);
        return retVal;
    }
    
    public int setSensorColorRed(int port) {
//        int retVal = setInputMode(port, SENSOR_TYPE_COLORRED, SENSOR_MODE_PERCENT);
        int retVal = setInputMode(port, SENSOR_TYPE_COLORRED, ReadColorSensorEx);
        resetInputScaledValue(port);
        return retVal;
    }
    
    public int setSensorColorBlue(int port) {
//        int retVal = setInputMode(port, SENSOR_TYPE_COLORBLUE, SENSOR_MODE_PERCENT);
        int retVal = setInputMode(port, SENSOR_TYPE_COLORBLUE, ReadColorSensorEx);
        resetInputScaledValue(port);
        return retVal;
    }
    
    public int setSensorColorGreen(int port) {
//        int retVal = setInputMode(port, SENSOR_TYPE_COLORGREEN, SENSOR_MODE_PERCENT);
        int retVal = setInputMode(port, SENSOR_TYPE_COLORGREEN, ReadColorSensorEx);
        resetInputScaledValue(port);
        return retVal;
    }
    
    public int setSensorColorNone(int port) {
//        int retVal = setInputMode(port, SENSOR_TYPE_COLORNONE, SENSOR_MODE_PERCENT);
        int retVal = setInputMode(port, SENSOR_TYPE_COLORNONE, ReadColorSensorEx);
        resetInputScaledValue(port);
        return retVal;
    }

    public int setSensorUltrasonic(int port) {
        byte[] warmReset = { 0x02, 0x41, 0x04 };       // I2C Warm Reset Command
        byte[] continuousMode = { 0x02, 0x41, 0x02 };  // I2C Continuous Measurement Command

        int retVal = setInputMode(port, SENSOR_TYPE_LOWSPEED_9V, SENSOR_MODE_RAW);
        if(retVal==0x00) {
            retVal=lowSpeedWrite(port,0,warmReset);
            if(retVal==0x00)
                retVal=lowSpeedWrite(port,0,continuousMode);
        }
        return retVal;
    }

    public int sensorValue(int port) {
        int retVal = -1;
        InputValues result = getInputValues(port);
        if (result.statusCode == 0x00) {
            if (result.sensorType < SENSOR_TYPE_CUSTOM) {
                retVal = result.scaledValue;
            } else {
                byte[] command = {0x02, 0x42};
                retVal = lowSpeedWrite(port, 1, command) == 0x00 ? 0x00 : -1;
                if (retVal == 0x00) {
                    boolean looping = true;
                    LowSpeedStatus status;
                    while (looping) {
                        status = lowSpeedGetStatus(port);
                        if (status.statusCode == 0x00 && status.bytesReady > 0) {
                            looping = false;
                        }
                    }
                    LowSpeedData data = lowSpeedRead(port);
                    retVal = data.statusCode == 0x00 ? data.rxData[0] : -1;
                }
            }
        }
        return retVal;
    }

    public static void main(String[] args) throws InterruptedException {
        NXT brick;

        // Make Connection
        brick = new NXT("0016530281E5");

        // Display Frimware Version and Batter Level
        System.out.println("Battery Level: " + brick.getBatteryLevel());
        System.out.println(brick.getFirmwareVersion());

        // Separate Basic Motor Control
        brick.motorForward(NXT.OUT_A, 25);
        Thread.sleep(2000);
        brick.motorReverse(NXT.OUT_B, 25);
        Thread.sleep(2000);
        brick.motorForwardReg(NXT.OUT_C, 25);
        Thread.sleep(2000);
        brick.motorCoast(NXT.OUT_ABC);
        Thread.sleep(2000);

        // Regulated Motor Control - Mutliple Motors
        brick.motorForwardReg(NXT.OUT_AB, 25);
        Thread.sleep(2000);
        brick.motorBrake(NXT.OUT_AB);
        Thread.sleep(1000);
        brick.motorReverseReg(NXT.OUT_AC, 25);
        Thread.sleep(2000);
        brick.motorBrake(NXT.OUT_AC);
        Thread.sleep(1000);
        brick.motorForwardReg(NXT.OUT_ABC, 25);
        Thread.sleep(2000);
        brick.motorBrake(NXT.OUT_ABC);
        Thread.sleep(1000);

        // Synchronized Motor Control
        brick.motorForwardSync(NXT.OUT_AB, 25,0);
        Thread.sleep(2000);
        brick.motorBrake(NXT.OUT_AB);
        Thread.sleep(1000);
        brick.motorReverseSync(NXT.OUT_AC, 25,50);
        Thread.sleep(2000);
        brick.motorBrake(NXT.OUT_AC);
        Thread.sleep(1000);
        brick.motorForwardSync(NXT.OUT_BC,25,-50);
        Thread.sleep(2000);
        brick.motorBrake(NXT.OUT_BC);
        Thread.sleep(1000);

        // Rotation Motor Control
        brick.motorRotate(NXT.OUT_ABC,25,360);
        Thread.sleep(3000);
        brick.motorRotate(NXT.OUT_AB,-25,360);
        Thread.sleep(3000);

        // Touch Sensor Input
        brick.setSensorTouch(IN_1);
        for(int i=0;i<50;i++) {
            System.out.println("Touch Sensor Value: " + brick.sensorValue(IN_1));
        }

        // Sound Sensor Input
        brick.setSensorSound(IN_2);
        for(int i=0;i<50;i++) {
            System.out.println("Sound Sensor Value: " + brick.sensorValue(IN_2));
        }

        // Active Light Sensor Input
        brick.setSensorLightActive(IN_3);
        for(int i=0;i<50;i++) {
            System.out.println("Active Light Sensor Value: " + brick.sensorValue(IN_3));
        }

        // Color Light Sensor Input
        brick.setSensorColorFull(IN_3);
        for(int i=0;i<50;i++) {
            System.out.println("Color Full Light Sensor Value: " + brick.sensorValue(IN_3));
        }

        // Color Blue Light Sensor Input
        brick.setSensorColorBlue(IN_3);
        for(int i=0;i<50;i++) {
            System.out.println("Color Blue Light Sensor Value: " + brick.sensorValue(IN_3));
        }

        // Color Green Light Sensor Input
        brick.setSensorColorGreen(IN_3);
        for(int i=0;i<50;i++) {
            System.out.println("Color Green Light Sensor Value: " + brick.sensorValue(IN_3));
        }

        // Color Blue Light Sensor Input
        brick.setSensorColorRed(IN_3);
        for(int i=0;i<50;i++) {
            System.out.println("Color Red Light Sensor Value: " + brick.sensorValue(IN_3));
        }

        // Color None Light Sensor Input
        brick.setSensorColorNone(IN_3);
        for(int i=0;i<50;i++) {
            System.out.println("Color None Light Sensor Value: " + brick.sensorValue(IN_3));
        }

        // Ultrasonic Sensor Input
        brick.setSensorUltrasonic(IN_4);
        for(int i=0;i<50;i++) {
            System.out.println("Ultrasonic Sensor Value: " + brick.sensorValue(IN_4));
        }
        brick.close();
     }
}
