
variable "instance-type" {
  type    = string
  default = "t3.micro"
}



variable "external_ip" {
  type    = string
  default = "0.0.0.0/0"

}
