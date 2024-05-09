#!/bin/bash

# Go to the wavfiles director (a different repo) and upload the new audio file
cd /root/final_proj/csee4840/project/software/wavfiles
git add anonymous_audio.wav; git commit -m "new file"; git push;
cd ../twilio 

# Call the Twilio API to place a call. The Twilio script will fetch from the repo we just uploaded to
curl -X POST "https://api.twilio.com/2010-04-01/Accounts/$ACCOUNT_ID/Calls.json" \
--data-urlencode "ApplicationSid=$APPLICATION_SID" \
--data-urlencode "To=$$TO_NUMBER" \
--data-urlencode "From=+1$FROM_NUMBER" \
-u $USERNAME:$PASSWORD
