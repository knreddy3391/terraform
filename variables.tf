variable "rgname" {
    type = string   
    description = "used for naming the resource group"
  }
  variable "rglocation" {
    type = string
    description = "used for location"
    default = "east europe"
  }
  variable "storagename" {
    type = string
    description = "used for storage name"
  }
  variable "prefix" {
    type = string 
    description = "vnetname"
    }
    variable "vnet_cidr_prefix" {
        type = string
        description = "used for define the vnet address"
    }
    variable "subnettf_cidr_prefix" {
        type = string
        description = "used for define the subnet address space"
      
    }
    variable "appservice" {
        type = string
        description = "used for define the appservice"
      
    }    
    variable "appserviceplan" {
        type = string
            description = "used for define the appservice plan"
    }