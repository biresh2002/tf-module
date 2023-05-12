variable "location"{
    type=string
    description = "This is the location"
    default ="East US 2"
}
   variable "vnet"{
    type=string
    description = "This is the Vnet-1 name"
    default ="Vnet-1"
}

variable "address_space"{
     
   }
variable "address_subnet_1"{
     
   }

  
   variable "rg_name"{
    type=string
    description = "This is the location RG name"
    default ="My-First-tf-resource"
}
   variable "vm_size"{
    type=string
    description = "This is the vm Size"
    default ="Standard_B1s"
}
   variable "Linux_vm"{
    type=string
  }

   variable "Linux_disk"{
    type=string
  }
  
