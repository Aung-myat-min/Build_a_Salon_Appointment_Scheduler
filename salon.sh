#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

MAIN_MENU(){
  if [[ -z $1 ]]
  then
    echo -e "\n$1\n"
  fi

  echo -e "Here are lists of service avaliable here:"
  SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")

  echo "$SERVICES" | while read SERVICE_ID BAR NAME
  do
    if [[ ! $SERVICE_ID == "service_id" ]]
    then
      echo "$SERVICE_ID) $NAME Service"
    fi
  done

  echo -e "\nType the service number:"
  read SERVICE_ID_SELECTED

  SERVICE_TO_GIVE=$($PSQL "SELECT service_id, name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
  if [[ -z $SERVICE_TO_GIVE ]]
  then
    MAIN_MENU "Sorry, that is not a valid service number."
  else
    echo -e "\nPlease enter your phone number:"
    read CUSTOMER_PHONE

    CUSTOMER=$($PSQL "SELECT customer_id, name, phone FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    if [[ -z $CUSTOMER ]]
    then
      echo -e "\nLook like you are new here. Let's create a new account!\nEnter your name:"
      read CUSTOMER_NAME
      
      NEW_CUSTOMER=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
    fi

    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    echo -e "\nEnter Time:"
    read SERVICE_TIME
    
    APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
    if [[ $APPOINTMENT == "INSERT 0 1" ]]
    then
      CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
      SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
      echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME,$CUSTOMER_NAME."
    fi
  fi
}

MAKE_APPOINTMENT(){
  echo -e "\nMAKE APPOINTMENT"
}

EXIT(){
  echo -e "\nThanks you for visiting us."
}

MAIN_MENU
