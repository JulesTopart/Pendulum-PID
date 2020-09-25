#include <AccelStepper.h>

AccelStepper stepper(AccelStepper::DRIVER, 2, 5);

const int sensorPin = A2;
const int enableDriverPin = 8;
const int enablePin = 12;
const int debugPin = 13;
const int regulPin = A3;

bool enableState = true;
bool regulState;
bool chute = true;

float Setpoint, Input, Output, somme_erreur, erreur_precedente ;
float dT = 0.1;

float Kp, Ki, Kd;
//float KpUser = 80, KiUser = 8, KdUser = 10;
float KpUser = 80, KiUser = 8, KdUser = 100;


//80 8 10
void asservissement();

void setup()
{
  Serial.begin(115200);
  pinMode(enableDriverPin, OUTPUT);

  pinMode(enablePin, INPUT_PULLUP);
  pinMode(debugPin, INPUT_PULLUP);
  pinMode(regulPin, INPUT_PULLUP);

  digitalWrite(enableDriverPin, enableState);

  regulButton();

  Setpoint = 587.0;

  stepper.setMaxSpeed(50000);
  stepper.setAcceleration(50000);
}

void loop()
{
  if (digitalRead(enablePin) != enableState)
  {
    enableState = digitalRead(enablePin);
    digitalWrite(enableDriverPin, enableState);
    somme_erreur = 0;
    erreur_precedente = 0;
  }

  Input = analogRead(sensorPin);
  //Input = (analogRead(sensorPin) + analogRead(sensorPin) + analogRead(sensorPin))/3;

  if (Input >= Setpoint - 100 && Input <= Setpoint + 100)
  {
    if (chute)
    {
      chute = false;
      enableState = digitalRead(enablePin);
      digitalWrite(enableDriverPin, enableState);
      somme_erreur = 0;
      erreur_precedente = 0;
    }
    asservissement();

    stepper.setSpeed(Output);
    stepper.runSpeed();
  }
  else
  {
    chute = true;
    digitalWrite(enableDriverPin, true);
    somme_erreur = 0;
    erreur_precedente = 0;
  }

  if (!digitalRead(debugPin))
  {
    //Serial.print(int(Setpoint));
    //Serial.print("\t");
    byte buf[4];
    buf[0] = 'b';
    buf[1] = (int)Input >> 8;
    buf[2] = ((int)Input) & 255;
    buf[3] = '\n';
    Serial.write(buf, 4 * sizeof(byte));
    //Serial.println((int(Output)/100)+Setpoint);
  }

  if (regulState != digitalRead(regulPin)) regulButton();

}

void asservissement()
{
  float erreur = Setpoint - Input;

  somme_erreur += (erreur * dT);
  float delta_erreur = (erreur - erreur_precedente) / dT;

  Output = Kp * erreur + Ki * somme_erreur + Kd * delta_erreur;

  erreur_precedente = erreur;
}

void regulButton()
{
  regulState = digitalRead(regulPin);
  if (regulState)
  {
    Kp = KpUser;
    Ki = 0;
    Kd = 0;
    somme_erreur = 0;
    erreur_precedente = 0;
  }
  else
  {
    Kp = KpUser;
    Ki = KiUser;
    Kd = KdUser;
    somme_erreur = 0;
    erreur_precedente = 0;
  }
}
