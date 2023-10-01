terraform {
  required_providers {
    yandex = {
    source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
    token = "" # Получить OAuth-токен для  Yandex Cloud  с помощью запроса к Яндекс OAuth"
    cloud_id = "b1g3e3esaheu3s6on970"
    folder_id = "b1gov3unfr7e8jj3g22v"
    zone = "ru-central1-b"
}

# конфигурации ресурсов

resource "yandex_compute_instance" "vm-1" {
  name        = "my-debian-vm-terraform-ansible"
  zone        = "ru-central1-b"

  resources {
    core_fraction = 20
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8suc83g7bvp2o7edee"
      size = 5
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.subnet-1.id}"
    nat       = true
  }

  metadata = {
    user-data = "${file("./meta.txt")}"
    #ssh-keys = "user:{file(~/.ssh/id_rsa.pub)}"
  }
}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-b"
  v4_cidr_blocks = ["192.168.10.0/24"]
  network_id     = "${yandex_vpc_network.network-1.id}"
}

output "internal-vm-1" {
    value = yandex_compute_instance.vm-1.network_interface.0.ip_address
}

output "external-vm-1" {
    value = yandex_compute_instance.vm-1.network_interface.0.net_ip_address
}

output "macAddress-vm-1" {
    value = yandex_compute_instance.vm-1.network_interface.0.mac_address
}
