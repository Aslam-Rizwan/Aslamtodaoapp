module "rg01"{
    source= "../MODULE/Azurerm_Resource_Group"
    rg_name="aslamrg"
    rg_location="westeurope"
}
module "vnet" {
    depends_on = [module.rg01  ]
    source = "../MODULE/Azurerm_Vnet"
    vnet_name = "aslamvnet"
    location = "westeurope"
    resource_group_name = "aslamrg"
    address_space = ["10.0.0.0/16"]
    }
module "subnet01" {
    depends_on = [module.vnet]
    source = "../MODULE/Azurerm_SUBNET"
    subnet_name= "frontendsubnet"
  resource_group_name  = "aslamrg"
  virtual_network_name = "aslamvnet"
  address_prefixes=["10.0.1.0/24"]
}
module "subnet02" {
    depends_on = [module.vnet]
    source =  "../MODULE/Azurerm_SUBNET"
    subnet_name= "backendsubnet"
  resource_group_name  = "aslamrg"
  virtual_network_name = "aslamvnet"
  address_prefixes=["10.0.2.0/24"]
}
module "fe-pip" {
  depends_on= [module.rg01]
  source="../MODULE/Azurerm_public_ip"
  pip_name = "frontend_pip"
  location = "westeurope"
  rg_name  = "aslamrg"
}
# This is a comment for the frontend public IP module

module "ba_pip" {
  depends_on= [module.rg01]
  source="../MODULE/Azurerm_public_ip"
  pip_name = "backend_pip"
  location = "westeurope"
  rg_name  = "aslamrg"
}
module "fe_vm" {
  depends_on = [module.subnet01, module.fe-pip]
  source= "../MODULE/Azurerm_Linux-Virtual_Machine"
  nic_name = "fe-nic"
  location = "westeurope"
  resource_group_name = "aslamrg"
  fe_vm_name = "fe-vm"
  subnet_id = "/subscriptions/8888575e-1be3-4d16-8500-ee8a4a1b570c/resourceGroups/aslamrg/providers/Microsoft.Network/virtualNetworks/aslamvnet/subnets/frontendsubnet"
  pip_id = "/subscriptions/8888575e-1be3-4d16-8500-ee8a4a1b570c/resourceGroups/aslamrg/providers/Microsoft.Network/publicIPAddresses/frontend_pip"

}
