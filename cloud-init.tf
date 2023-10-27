# A simple example how to use cloud-init init IONOS cloud. Please see the
# helloworld example for more comments on the generic components. This example
# focuses commenting and documenting only the cloud-init feature.
#
# In short, the cloud-init content is defined into a variable cloud_init with
# the terraform heredoc syntax. After this, the variable cloud_init content is
# given into the "user_data" parameter in the volume definition. 
# Use the IONOS cloud provider. 
terraform {
  required_providers {
    ionoscloud = {
      source = "ionos-cloud/ionoscloud"
      version = "= 6.4.9" 
    }
  }
}

# This will create an empty VDC (Virtual Data Center)
resource "ionoscloud_datacenter" "myvdc" {
  name                = "Cloud-init VDC Example"
  location            = "de/fra"
  description         = "My Virtual Datacenter created with Terraform"
}


# Create the public LAN. Needed to get our VM below to get internet access
resource "ionoscloud_lan" "publan" {
    datacenter_id         = ionoscloud_datacenter.myvdc.id
    public                = true
    name                  = "Public LAN"
}

# first we use the heredoc syntax to put the cloud init yaml content into a
# terraform variable. If you have a long cloud-init configuration, you would
# probably want to maintain it in a separate file though.
variable "cloud_init" {
  description = "Cloud-init configuration"
  default     = <<-EOF
                #cloud-config
                hostname: cloudinitexample
                runcmd:
                  - echo "Hello World!" > /tmp/hello
                EOF
}

resource "ionoscloud_server" "myserver" {
    name                  = "My Server"
    datacenter_id         = ionoscloud_datacenter.myvdc.id
    cores                 = 1
    ram                   = 1024
    image_name            = "ubuntu:latest"
    image_password        = "superpswd123"
    type                  = "ENTERPRISE"
    # you will need to replace the /home/mnylund with your home directory
    ssh_keys              = ["/home/mnylund/.ssh/id_rsa.pub"]
    volume {
        name              = "OS"
        size              = 50
        disk_type         = "SSD Standard"

        # here we include the cloud init into the user_data parameter. the data
        # needs to be base64 encoded so we do that with the terraform
        # base64encode function. If you wonder why the paramenter is called
        # user_data instead of cloud_init or something similar, user_data is
        # commonly use by cloud providers for cloud init, partly due to
        # historical reasons.
        user_data         = base64encode(var.cloud_init)
    }
    nic {
        lan               = ionoscloud_lan.publan.id
        dhcp              = true
    }
}

# This is just an optional directive to output the above VMs public IP address
# so that you can use it with ssh to connect to the server
output "myserver_ip_address" {
  value = ionoscloud_server.myserver.primary_ip
}


