#!/bin/bash

# Check if curl is installed
if ! command -v curl &> /dev/null; then
  echo "curl is not installed. Installing curl..."
  if command -v yum &> /dev/null; then
    sudo yum install curl -y
  elif command -v apt-get &> /dev/null; then
    sudo apt-get install curl -y
  else
    echo "Your system package manager is not supported. Please install curl manually."
    exit 1
  fi
fi

# Check if grep is installed
if ! command -v grep &> /dev/null; then
  echo "grep is not installed. Installing grep..."
  if command -v yum &> /dev/null; then
    sudo yum install grep -y
  elif command -v apt-get &> /dev/null; then
    sudo apt-get install grep -y
  else
    echo "Your system package manager is not supported. Please install grep manually."
    exit 1
  fi
fi

RED='\033[0;31m'
PLAIN='\033[0m'
GREEN='\033[0;32m'
log="unlock-chatgpt-test-result.log"

function UnlockChatGPTTest() {
    if [[ $(curl --max-time 10 -sS https://chat.openai.com/ -I | grep "text/plain") != "" ]]
    then
        echo -e " ChatGPT: ${RED}IP不支持 IP is BLOCKED${PLAIN}" | tee -a $log
        return
    fi
    local countryCode="$(curl --max-time 10 -sS https://chat.openai.com/cdn-cgi/trace | grep "loc=" | awk -F= '{print $2}')";
    if [ $? -eq 1 ]; then
        echo -e " ChatGPT: ${RED}网络连接失败 Network connection failed${PLAIN}" | tee -a $log
        return
    fi
    if [ -n "$countryCode" ]; then
        support_countryCodes=(T1 XX AL DZ AD AO AG AR AM AU AT AZ BS BD BB BE BZ BJ BT BA BW BR BG BF CV CA CL CO KM CR HR CY DK DJ DM DO EC SV EE FJ FI FR GA GM GE DE GH GR GD GT GN GW GY HT HN HU IS IN ID IQ IE IL IT JM JP JO KZ KE KI KW KG LV LB LS LR LI LT LU MG MW MY MV ML MT MH MR MU MX MC MN ME MA MZ MM NA NR NP NL NZ NI NE NG MK NO OM PK PW PA PG PE PH PL PT QA RO RW KN LC VC WS SM ST SN RS SC SL SG SK SI SB ZA ES LK SR SE CH TH TG TO TT TN TR TV UG AE US UY VU ZM BO BN CG CZ VA FM MD PS KR TW TZ TL GB)
        if [[ "${support_countryCodes[@]}"  =~ "${countryCode}" ]];  then
            echo -e " ChatGPT: ${GREEN}支持 Yes (Region: ${countryCode})${PLAIN}" | tee -a $log
            return
        else
            echo -e " ChatGPT: ${RED}No${PLAIN}" | tee -a $log
            return
        fi
    else
        echo -e " ChatGPT: ${RED}Failed${PLAIN}" | tee -a $log
        return
    fi

}

UnlockChatGPTTest
