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
```

## Создание инфраструктуры
Создаем файл main.tf
```
terraform {
 required_providers {
 yandex = {
 source = "yandex-cloud/yandex"
 }
 }
}
provider "yandex" {
 token = "Получить OAuth-токен для работы с Yandex Cloud можно с помощью запроса к сервису Яндекс OAuth"
 cloud_id = "b1g3e3esaheu3s6on970"
 folder_id = "b1gov3unfr7e8jj3g22v"
 zone = "ru-central1-b"
}
####
resource "yandex_compute_instance" "vm-1" {

  name        = "linux-vm"
  
  zone        = "ru-central1-b"

  resources {
    core_fraction = 20
    cores  = 2
    memory = 1
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

  #metadata = {
  #  ssh-keys = "<имя пользователя>:<содержимое SSH-ключа>"
 # }
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


```