#define power 23

#define enA 9
#define in1 22
#define in2 7

#define enB 8
#define in3 6
#define in4 24

#define trig 13
#define echo 12
long duration;
int distance;

void setup() {
  pinMode(power, INPUT);
  
  pinMode(enA, OUTPUT);
  pinMode(in1, OUTPUT);
  pinMode(in2, OUTPUT);
  
  pinMode(enB, OUTPUT);
  pinMode(in3, OUTPUT);
  pinMode(in4, OUTPUT);

  pinMode(trig, OUTPUT);
  pinMode(echo, INPUT);

}

void loop() {

  // disable if jumper switch is disconnected
  digitalWrite(power, HIGH);
  if (digitalRead(power) == 1) {
    analogWrite(enA, 0);
    analogWrite(enB, 0);
    return;
  }

  // measure distance to objects in path
  digitalWrite(trig, LOW);
  delayMicroseconds(2);
  digitalWrite(trig, HIGH);
  delayMicroseconds(10);
  digitalWrite(trig, LOW);
  duration = pulseIn(echo, HIGH);
  distance = duration * 0.034 / 2;

  // reverse left motor if path not clear
  if (distance <= 16) {
    digitalWrite(in1, LOW);
    digitalWrite(in2, HIGH);
  } else {
    digitalWrite(in1, HIGH);
    digitalWrite(in2, LOW);
  }
  
  digitalWrite(in3, HIGH);
  digitalWrite(in4, LOW);
  
  analogWrite(enA, 255);
  analogWrite(enB, 255);
}
