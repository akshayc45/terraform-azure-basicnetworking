
#################### RESOURCE GROUP VARIABLES ##################

variable "resourcegroup"{
  type = map(object({
   rgname = string
   rglocation = string
   tags = map(string)
 }
))
default = {
  "default" = {
    rgname = "tflz-default"
    rglocation = "centralindia"
    tags = {
      "Created By" = "Terraform Default values"
    }
  }
}
}


