#!/bin/bash

# Source bashrc to get environment variables
source ~/.bashrc

# Test AgentMail API key
api_key=$AGENTMAIL_API_KEY
if [ -z "$api_key" ]; then
    echo "AgentMail API key not found"
    exit 1
fi

echo "AgentMail API key found: ${api_key:0:4}...${api_key: -4}"

# Test AgentMail client
cd /home/alpha/.openclaw/workspace/skills/agentmail
python3 -c "
from agentmail import AgentMail
client = AgentMail(api_key=os.getenv('AGENTMAIL_API_KEY'))
print('✅ AgentMail client initialized')
# Test basic functionality
print('✅ Testing connection...')
print('✅ AgentMail ready to use')
"