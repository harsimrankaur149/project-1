variable "users" {
    default = ["Harsimranjit", "Jaspal", "Afsah", "Snehal"]
  
}

variable "s3bucket_names" {
  default = ["development_project_bucket", "testing_project_bucket", "deployment_project_bucket",]
}

variable "prefix" {
  default = "hygpjgdr"
}

variable "name" {
    default = "project"
    description = "This defines the name of the resource group"
}

variable "location" {
  default = "West Europe"
  description = "This define the location of the resource group"
}