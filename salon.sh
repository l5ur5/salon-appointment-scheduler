#! /bin/bash
PSQL="psql --username=postgres --dbname=salon -t --no-align -c"

echo -e "\n~~~~~ MY SALON ~~~~~"
echo " "
echo Welcome to My Salon, how can I help you?
echo " " 

#print services
SERVICES=$($PSQL "SELECT service_id || ') ' || name FROM services ORDER BY service_id")
echo "$SERVICES"
read SERVICE_ID_SELECTED
echo " "


#get service ID
SERVICE_ID_SELECTED=$($PSQL "SELECT service_id FROM services WHERE service_id = '$SERVICE_ID_SELECTED'")


#if service ID doesn't exist
while [[ -z $SERVICE_ID_SELECTED ]]
 do

   echo "I could not find that service. What would you like today?"
   echo "$SERVICES"
   read SERVICE_ID_SELECTED
   SERVICE_ID_SELECTED=$($PSQL "SELECT service_id FROM services WHERE service_id = '$SERVICE_ID_SELECTED'")

done


#if service ID exists ask for phone number
echo "What's your phone number?"
read CUSTOMER_PHONE


#search customer in database
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")


#if customer doesn't exist
if [[ -z $CUSTOMER_ID ]]
then
    echo "I don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME  

    #save customer
    $PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')"

    #get customer ID
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
fi

#get customer name
CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

#get service name
SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = '$SERVICE_ID_SELECTED'")

#ask for service time
echo "What time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
read SERVICE_TIME

#insert appointment
$PSQL "INSERT INTO appointments(time, customer_id, service_id) VALUES('$SERVICE_TIME', '$CUSTOMER_ID', '$SERVICE_ID_SELECTED')"


#confirmation message
echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."











