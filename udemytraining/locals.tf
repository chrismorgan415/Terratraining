locals {
  resource_location="South Central US"
  virtual_network={
    name="goku-network"
    address_prefixes=["10.0.0.0/16"]
  }
  subnet_address_prefix=["10.0.1.0/24", "10.0.2.0/24"]
  subnets=[
    {
        name="gohansubnet01"
        address_prefixes=["10.0.1.0/24"]
    },
    {
        name="gotensubnet01"
        address_prefixes=["10.0.2.0/24"]
    }
  ]
  }
