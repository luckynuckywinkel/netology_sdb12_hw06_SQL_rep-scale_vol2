resource "yandex_compute_instance" "vm-1" {
  name = "sql-master"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8u2e47jlq81vqvg87t"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    user-data = "${file("./meta.yaml")}"
  }

provisioner "remote-exec" {
  inline = [
    "sudo apt-get update",
    "sudo apt-get install ca-certificates curl gnupg -y",
#    "sudo install -m 0755 -d /etc/apt/keyrings",
#    "curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg",
#    "sudo chmod a+r /etc/apt/keyrings/docker.gpg",
#    "echo \"deb [arch=\\\"$(dpkg --print-architecture)\\\" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \\\"$(. /etc/os-release && echo \\\"$VERSION_CODENAME\\\")\\\" stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/nul$
#    "sudo apt-get update",
#    "sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y",
#    "sudo apt-get remove docker-compose",
#    "wget https://github.com/docker/compose/releases/download/v2.19.1/docker-compose-linux-x86_64",
#    "sudo mv docker-compose-linux-x86_64 /usr/local/bin/docker-compose",
#    "sudo chmod +x /usr/local/bin/docker-compose",
    "sudo apt-get install python-minimal -y",
    "sudo apt-get update"
    ]
    connection {
      type = "ssh"
      user = "winkel"
      private_key = file("./ykey")
      host = yandex_compute_instance.vm-1.network_interface[0].nat_ip_address
    }
  }

provisioner "remote-exec" {
  inline = [
    "echo '[master]\n${yandex_compute_instance.vm-1.network_interface.0.nat_ip_address} ansible_ssh_user=winkel ansible_ssh_private_key_file=/home/vagrant/ansible_proj/ykey' >> /home/vagrant/ansible_proj/inventory"
    ]
  connection {
      type = "ssh"
      user = "vagrant"
      password = var.vagrant_password
      host = "192.168.1.1"
  }
 }

provisioner "remote-exec" {
  inline = [
    "echo 'host_ip: \"${yandex_compute_instance.vm-1.network_interface.0.ip_address}\"' >> /home/vagrant/ansible_proj/sqlpass.yaml"
    ]
  connection {
      type = "ssh"
      user = "vagrant"
      password = var.vagrant_password
      host = "192.168.1.1"
   }
 }
#provisioner "local-exec" {
#   command = " echo 'master\n${yandex_compute_instance.vm-1.network_interface.0.nat_ip_address}' >> inventory"
# }
}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  v4_cidr_blocks = ["192.168.10.0/24"]
  network_id     = yandex_vpc_network.network-1.id

}

resource "yandex_compute_instance" "vm-2" {
  name = "sql-slave"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8u2e47jlq81vqvg87t"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    user-data = "${file("./meta.yaml")}"
  }
provisioner "remote-exec" {
  inline = [
    "sudo apt-get update",
    "sudo apt-get install ca-certificates curl gnupg -y",
#    "sudo install -m 0755 -d /etc/apt/keyrings",
#    "curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg",
#    "sudo chmod a+r /etc/apt/keyrings/docker.gpg",
#    "echo \"deb [arch=\\\"$(dpkg --print-architecture)\\\" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \\\"$(. /etc/os-release && echo \\\"$VERSION_CODENAME\\\")\\\" stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/nul$
#    "sudo apt-get update",
#    "sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y",
#    "sudo apt-get remove docker-compose",
#    "wget https://github.com/docker/compose/releases/download/v2.19.1/docker-compose-linux-x86_64",
#    "sudo mv docker-compose-linux-x86_64 /usr/local/bin/docker-compose",
#    "sudo chmod +x /usr/local/bin/docker-compose",
    "sudo apt-get install python-minimal -y",
    "sudo apt-get update"
    ]
    connection {
      type = "ssh"
      user = "winkel"
      private_key = file("./ykey")
      host = yandex_compute_instance.vm-2.network_interface[0].nat_ip_address
    }
  }

provisioner "remote-exec" {
  inline = [
    "echo '[slave]\n${yandex_compute_instance.vm-2.network_interface.0.nat_ip_address} ansible_ssh_user=winkel ansible_ssh_private_key_file=/home/vagrant/ansible_proj/ykey' >> /home/vagrant/ansible_proj/inventory"
    ]
  connection {
      type = "ssh"
      user = "vagrant"
      password = var.vagrant_password
      host = "192.168.1.2"
  }
 }
#provisioner "local-exec" {
#   command = " echo 'slave\n${yandex_compute_instance.vm-2.network_interface.0.nat_ip_address}' >> inventory"
# }
}
