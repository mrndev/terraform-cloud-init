# terraform-cloud-init
Terraform example how to use cloud-init with IONOS cloud VMs. This is what you should see after running the script:

<pre>
$ <b>terraform apply</b>
ionoscloud_datacenter.myvdc: Refreshing state... [id=28e7defb-49c9-4ac4-bc7c-6d0b95ba1059]
ionoscloud_lan.publan: Refreshing state... [id=1]
.
.
.
ionoscloud_server.myserver: Still creating... [50s elapsed]
ionoscloud_server.myserver: Creation complete after 57s [id=7aca1e7c-a5ed-4fd6-b07f-75b1bb7b2b4e]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

myserver_ip_address = "217.160.221.209"
$ <b>ssh root@217.160.221.209</b>
.
.
.
Last login: Fri Oct 27 12:27:40 2023 from 185.56.150.12
root@cloudinitexample:~# <b>cat /tmp/hello</b>
Hello World!
</pre>


