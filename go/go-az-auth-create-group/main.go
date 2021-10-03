package main

import (
	"context"
	"fmt"
	"os"

	"github.com/Azure/azure-sdk-for-go/services/compute/mgmt/2020-06-01/compute"
	"github.com/Azure/azure-sdk-for-go/services/resources/mgmt/2019-05-01/resources"
	"github.com/Azure/go-autorest/autorest/azure/auth"
	"github.com/Azure/go-autorest/autorest/to"
)

const location = "eastus"

func main() {
	// go run main.go 590f79be-f0a3-4037-b444-21d2aebea87e
	subscriptionID := os.Args[1]

	AzureAuth(subscriptionID)
}

func AzureAuth(subscriptionID string) compute.VirtualMachinesClient {
	vmClient := compute.NewVirtualMachinesClient(subscriptionID)

	a, err := auth.NewAuthorizerFromCLI()
	if err != nil {
		fmt.Println(err)
	} else {
		fmt.Println("Auth: Successful")
		vmClient.Authorizer = a
	}
	rgClient := resources.NewGroupsClient(subscriptionID)
	rgClient.Authorizer = a

	_, err = rgClient.CreateOrUpdate(context.Background(), "myRG5", resources.Group{
		Location: to.StringPtr(location),
	})
	if err != nil {
		fmt.Println(err)
	}
	return vmClient
}
