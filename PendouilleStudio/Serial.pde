import processing.serial.*;

Serial uno;

void initSerial(){
  printArray(Serial.list());
  uno = new Serial(this, Serial.list()[1], 115200); 
  delay(1000);
}

int parse_u_byte(byte b){
  if(b < 0) return b+256;
  return b;
}


void serialEvent(Serial p) {
  if(p.available() >= 4){
    byte[] buf = p.readBytes();
    p.clear();
    if(buf != null && buf[0] == 'b' && buf[3] == '\n'){
          println("Coucou");
      int[] intBuf = new int[3];
      
      for(int i = 1; i <= 3; i++) intBuf[i-1] = parse_u_byte(buf[i]);
      
      float value = (int)(intBuf[0] << 8 | intBuf[1]);
      value = (map(value, 0.0, 1024.0, 0.0, 360.0));
      data.plot(value);
      println(value);
    }
  }

}
