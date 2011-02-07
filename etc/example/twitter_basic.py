#! /usr/bin/env python
import oauth2 as oauth

# Create your consumer with the proper key/secret.
consumer = oauth.Consumer(key="Ww5HvnJycEuzN1NNalOxQ", 
    secret="dqSVhRF6iDm3sko4AcjV6uKRPM7eNokpJ4SruLLo")

# Request token URL for Twitter.
request_token_url = "http://twitter.com/oauth/request_token"

# Create our client.
client = oauth.Client(consumer)

# The OAuth Client request works just like httplib2 for the most part.
resp, content = client.request(request_token_url, "GET")
print resp
print content