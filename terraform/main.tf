terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  zone = "ru-central1-a"
  token                    = "my_token"
  cloud_id                 = "my_cloud_id"
  folder_id                = "my_folder_id"
}
