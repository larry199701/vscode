#----------------------------------------------------------------------------------------
# https://docs.microsoft.com/en-us/rest/api/compute/virtualmachines/createorupdate
# Click "Try it"
#----------------------------------------------------------------------------------------

authorization_header="Authorization: Bearer sfdsafd"

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
