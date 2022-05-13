terraform {
  required_providers {
    bigip = {
      source = "F5Networks/bigip"
      version = "1.13.1"
    }
    vault = {
      source = "hashicorp/vault"
      version = "3.5.0"
    }
  }
}

variable "tenant" {
  type = string
}
variable "vip_address" {
  type = string
}
provider "vault" {
    address = "http://192.168.86.69:8200"
    token = "hvs.CAESIBZoOLXng8FQ8Qh84dDdrNyGzQdSkvefQYg6eCSv02E1Gh4KHGh2cy5LUER0OXRVUzRQWWc2TFFOQmdENkQyenk"
}

provider "bigip" {
  address  = "192.168.86.46"
  username = "admin"
  password = "W3lcome098!"	  
}

data "template_file" "init" {
  template = "${file("./as3templates/dev.tmpl")}"
  vars = {
    UUID = "uuid()"
    TENANT = var.tenant
    VIP_ADDRESS = var.vip_address
  }
}
resource "bigip_as3"  "as3-example" {
     as3_json = data.template_file.init.rendered
     tenant_filter = var.tenant
}

