#----------------------------------------------------------------------------------------
# https://docs.microsoft.com/en-us/rest/api/compute/virtualmachines/createorupdate
# Click "Try it"
#----------------------------------------------------------------------------------------

authorization_header="Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6Imwzc1EtNTBjQ0g0eEJWWkxIVEd3blNSNzY4MCIsImtpZCI6Imwzc1EtNTBjQ0g0eEJWWkxIVEd3blNSNzY4MCJ9.eyJhdWQiOiJodHRwczovL21hbmFnZW1lbnQuY29yZS53aW5kb3dzLm5ldC8iLCJpc3MiOiJodHRwczovL3N0cy53aW5kb3dzLm5ldC9kNmFkMGMwNC0yNWJlLTQwYzQtOGYwMS03MjY1NDE1NDAzNmMvIiwiaWF0IjoxNjMzMTQyNTczLCJuYmYiOjE2MzMxNDI1NzMsImV4cCI6MTYzMzE0NjQ3MywiYWNyIjoiMSIsImFpbyI6IkFXUUFtLzhUQUFBQWJoZ0F4ZzZOdzBVYjBMNkoydVRSSkVselRFdW4rN0JUUXRuSUVIZlhuRGEveURBVjRQMjBjcHdNQ2ZpQnF0YUJOQk1aeDR3ODlOTk1hQit1dnJlWHJ1VFF2NHVsVFNYSFYzdUd0cVMrSC9DcUhmaFFxUjlPaHphc29zMUJ6dDUvIiwiYWx0c2VjaWQiOiI1OjoxMDAzMjAwMTZERTE5MDQ3IiwiYW1yIjpbInB3ZCJdLCJhcHBpZCI6IjdmNTlhNzczLTJlYWYtNDI5Yy1hMDU5LTUwZmM1YmIyOGI0NCIsImFwcGlkYWNyIjoiMiIsImVtYWlsIjoibGFycnkuc3VpQHZpZGl6bW8uY29tIiwiZmFtaWx5X25hbWUiOiJTdWkiLCJnaXZlbl9uYW1lIjoibGFycnkuc3VpQHZpZGl6bW8uY29tIiwiZ3JvdXBzIjpbIjU0ZGVhNmM4LTk4YmMtNDgyOC05Njc1LTc1MjUyZjNlOTI5ZCJdLCJpZHAiOiJodHRwczovL3N0cy53aW5kb3dzLm5ldC8yZDUwMDMxOS1mYmI1LTQ0MmMtYmE1MS0xN2Q3NGUwZDdlMmEvIiwiaXBhZGRyIjoiNzMuMzEuMjQyLjIzNiIsIm5hbWUiOiJsYXJyeS5zdWlAdmlkaXptby5jb20gU3VpIiwib2lkIjoiNzMyMjRlNzQtYTZiMi00MGE2LTgyOTYtODkzYWY4MDgyYTJhIiwicHVpZCI6IjEwMDMyMDAxN0E2RDAwNTYiLCJyaCI6IjAuQVVZQUJBeXQxcjRseEVDUEFYSmxRVlFEYkhPbldYLXZMcHhDb0ZsUV9GdXlpMFJHQU9JLiIsInNjcCI6InVzZXJfaW1wZXJzb25hdGlvbiIsInN1YiI6IjB6V1J6aVFKLXRvY2tyZUNDdDNXVy1iaWM1aldFN1JpbXdQWkZPa1l6TVUiLCJ0aWQiOiJkNmFkMGMwNC0yNWJlLTQwYzQtOGYwMS03MjY1NDE1NDAzNmMiLCJ1bmlxdWVfbmFtZSI6ImxhcnJ5LnN1aUB2aWRpem1vLmNvbSIsInV0aSI6ImlnaUN0VDYtRGttY3NvbUdPUzBwQUEiLCJ2ZXIiOiIxLjAiLCJ3aWRzIjpbIjYyZTkwMzk0LTY5ZjUtNDIzNy05MTkwLTAxMjE3NzE0NWUxMCIsImI3OWZiZjRkLTNlZjktNDY4OS04MTQzLTc2YjE5NGU4NTUwOSJdLCJ4bXNfdGNkdCI6MTYzMDc2NTA4OH0.djNrHWV4fpym1Q_Ty3qGUAiAOtmUBREjRWYryKLx2pvVAoO_qYtff9oU8LQ77KHPkX6IaxOr2WxNW_U-m5uaBkBOS5TMomywm3XB_1uD1MUWyF5G8EQucW_8TaAxrwwkZfUb3gncymBpaC6RorfgPNIA4QLQFpgB7EWA5Y4gCBbyu04q1kjjJTJ3b3xmWI5WlY35KkL_QGApW2fdKmdq0b8M1XTtlN2lquBNIUTfQKc4j3nhtqEeR66ogmUhDtJCarlrpj2GFcJMI6LCpg_SeenMk7Fuy1PPDZ5wG07mVBJy9kExnbvB7tJbYvURHX44amRBGoLWOtSg3A1xZK8dvA"

subscription_id="{590f79be-f0a3-4037-b444-21d2aebea87e}"

new_group_name="myGroup2"
curl -X PUT \
    -d '{"location": "eastus"}' https://management.azure.com/subscriptions/$subscription_id/resourcegroups/$new_group_name?api-version=2018-02-01 \
    -H "$authorization_header" \
    -H "Content-type: application/json"


 curl -i -X PUT -d \
'{                                       '\
'  "location":"eastus",                  '\
'  "properties":{                        '\
'    "addressSpace":{                    '\
'      "addressPrefixes":[               '\
'        "10.0.0.0/8"                    '\
'      ]                                 '\
'    },                                  '\
'    "subnets":[                         '\
'      {                                 '\
'        "name":"ourSubnet",             '\
'        "properties":{                  '\
'          "addressPrefix":"10.0.0.0/16" '\
'        }                               '\
'      }                                 '\
'    ]                                   '\
'  }                                     '\
'}' \
https://management.azure.com/subscriptions/$subscription_id/resourcegroups/$new_group_name/providers/Microsoft.Network/virtualNetworks/ourVNet?api-version=2018-02-01 -H "$authorization_header" -H "Content-type: application/json"
