#!/bin/bash
declare port_array=(
  8088
  8043
  8843
  27001
  29810
  29811
)

# Loop through all elements
for next_port in "${port_array[@]}"; do
  echo -n "Adding port $next_port to public zone. Result is:" $(firewall-cmd --zone=public --add-port=${next_port}/tcp)
  firewall-cmd --permanent --zone=public --add-port=${next_port}/tcp
done


firewall-cmd --reload
