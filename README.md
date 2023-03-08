# my_Terraform
##  Установка
Установка через repository git
```
cd /usr/local/src && git clone https://github.com/hashicorp/terraform.git
```
Вручную
```
cd /usr/local/src && curl -O 
https://releases.hashicorp.com/terraform/0.15.4/terraform_0.15.4_linux_arm.zip 
```
 Установка через repository apt
 ```
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=$(dpkg --print-architecture)] 
https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt install terraform

 ```
 ## Из зеркала yandex
 ```
 wget https://hashicorp-releases.yandexcloud.net/terraform/1.3.6/terraform_1.3.6_linux_amd64.zip
 ```
После загрузки добавьте путь к папке, в которой находится исполняемый файл, в переменную PATH:

```
export PATH=$PATH:/path/to/terraform
zcat terraform_1.3.6_linux_amd64.zip > terraformBin
file terraformBin
chmod 744 terraformBin
./terraformBin
./terraformBin --version
cp terraformBin /usr/local/bin/
cd ~
```
Добавьте в него следующий блок
```
nano .terraformrc

provider_installation {
  network_mirror {
    url = "https://terraform-mirror.yandexcloud.net/"
    include = ["registry.terraform.io/*/*"]
  }
  direct {
    exclude = ["registry.terraform.io/*/*"]
  }
}
```

 ##  Terraform настройка

 Terraform использует конфигурационные файлы с расширением .tf 

Минимальный набор переменных для успешного 
подключения:
```
provider "Имя провайдера" {
 user = "ваш_логин"
 password = "ваш_пароль"
 org = "название_организации"
 url = "название сайта с api "
}

```
Для проверки запуска локально
```
nano main.tf
# 
terraform {
        required_providers {
                yandex = {
                        source = "yandex-cloud/yandex"
                }
        }
} 
```
Сохраняем конфигурацию, и пробуем подключиться: 
Запускать надо там, где находится файл xxx.tf
```
terraform init
terraform apply
```

## Создание инфраструктуры
Создаем файл main.tf

```
# конфигурация провайдера

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
      image_id = "fd8pqqqelpfjceogov30"
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
```
```
terraform plan
terraform validate
terraform show
terraformBin destroy

```
### Добавить пользователя на создаваемую ВМ metadataю Для этого создаем файл с мета информацией:

nano meta.txt (yml) 

генерируем ssh ключ:
ssh-keygen ./id_rsa
cat id_rsa.pub cp ./meta.txt - ssh-rsa

```
#cloud-config
users:
  - name: user
    groups: sudo
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    ssh-authorized-keys:
      - xxxx(cat id_rsa.pub)
```
terraform apply
:~/terraform# ssh user@84.252.136.98 -i id_rsa
sudo su

Даем права root при работе через WinSCP
whereis sftp-server
sftp-server: /usr/lib/sftp-server /usr/share/man/man8/sftp-server.8.gz
sudo nano /etc/sudoers
В самом конце файла, с новой строки пишем:
ВАШЛОГИН ALL=NOPASSWD:/usr/lib/sftp-server
"Сервер SFTP" пишем следующее:
sudo /usr/lib/sftp-server

## Ansible use whith terraform


