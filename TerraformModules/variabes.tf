variable "prefix" {
  type = string
  default = "prod"
}
variable "subscription_id" {
  type = string
}
variable "client_id" {
  type = string
}
variable "client_secret" {
  type = string
}
variable "tenant_id" {
  type = string
}
variable "location" {
  type = string
  default = "westus"
}
output "public-ip" {
  value = [azurerm_public_ip.publicIP]
}