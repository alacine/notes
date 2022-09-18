# 来自阿里云文档: 创建一台 ECS 实例
# https://help.aliyun.com/document_detail/95829.html
# 使用需要确保余额在 100 或以上
terraform {
  required_providers {
    alicloud = {
      source =  "aliyun/alicloud"
      version = "1.184.0"
    }
  }
}

provider "alicloud" {
  # 实测明文提交到 github 几秒内就会被阿里扫描到，有短信通知和控制台提醒
  access_key = "xxxxxxxxxxxx"
  secret_key = "xxxxxxxxxxxx"
  region = "cn-beijing"
}

resource "alicloud_vpc" "vpc" {
  vpc_name = "tf_test_foo"
  cidr_block = "172.16.0.0/12"
}

resource "alicloud_vswitch" "vsw" {
  vpc_id = alicloud_vpc.vpc.id
  cidr_block = "172.16.0.0/21"
  zone_id = "cn-beijing-b"
}

resource "alicloud_security_group" "default" {
  name = "default"
  vpc_id = alicloud_vpc.vpc.id
}

resource "alicloud_security_group_rule" "allow_all_tcp" {
  type = "ingress"
  ip_protocol = "tcp"
  nic_type = "intranet"
  policy = "accept"
  port_range = "1/65535"
  priority = 1
  security_group_id = alicloud_security_group.default.id
  cidr_ip = "0.0.0.0/0"
}

resource "alicloud_instance" "instance" {
  # cn-beijing
  availability_zone = "cn-beijing-b"
  security_groups = alicloud_security_group.default.*.id
  # series III
  instance_type        = "ecs.n2.small"
  system_disk_category = "cloud_efficiency"
  image_id = "ubuntu_22_04_x64_20G_alibase_20220803.vhd"
  instance_name        = "test_foo"
  vswitch_id = alicloud_vswitch.vsw.id
  internet_max_bandwidth_out = 10
}
