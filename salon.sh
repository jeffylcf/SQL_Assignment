#!/bin/bash

# Connect to the salon database
PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c"

# Function to display services
display_services() {
  echo "$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")" | while IFS="|" read SERVICE_ID SERVICE_NAME; do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done
}

# Function to prompt for service
prompt_service() {
  echo -e "\nWelcome to the Salon Appointment Scheduler. Please select a service:"
  display_services
  read SERVICE_ID_SELECTED
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  if [[ -z $SERVICE_NAME ]]; then
    echo -e "\nI could not find that service. What would you like today?"
    prompt_service
  fi
}

# Start of script
prompt_service

# Prompt for phone number
echo -e "\nPlease enter your phone number:"
read CUSTOMER_PHONE

# Check if customer exists
CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")

if [[ -z $CUSTOMER_NAME ]]; then
  # New customer, prompt for name
  echo -e "\nIt looks like you're a new customer. Please enter your name:"
  read CUSTOMER_NAME
  # Insert new customer
  INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers (phone, name) VALUES ('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
fi

# Get customer ID
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

# Prompt for appointment time
echo -e "\nPlease enter your preferred appointment time:"
read SERVICE_TIME

# Insert appointment
INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

# Output confirmation
SERVICE_NAME=$(echo $SERVICE_NAME | xargs) # Trim whitespace
echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."

