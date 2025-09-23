#!/bin/bash

# netconn_response=$(curl -Is https://github.com)
# # echo "$netconn_response"
# echo "$netconn_response" | awk '{print $2}'
netconn_response=$(curl -I https://github.com | head -n 1)
echo "$netconn_response"
# 提取 HTTP 状态码
netconn_statcode=$(echo "$netconn_response" | awk '{print $2}')
echo "$netconn_statcode"