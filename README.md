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
 ##  Terraform настройка

 Terraform использует конфигурационные файлы с расширением 
.tf. 

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
