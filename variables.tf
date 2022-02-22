variable "vm_number" {
  default = "1"
}

variable "public_key" {
  # replace this with the name of your public ssh key you want to include in the vm
  default = "!!! REPLACE ME WITH YOUR PUBLIC KEY NAME"
}

variable "image_id" {
  # replace this with the image id of the ubuntu iso you want to use
  default = " !!! REPLACE ME!! "
}

variable "network_id" {
  # replace this with the id of the public interface on JS
  default = "!!! REPLACE ME !!!"
}
