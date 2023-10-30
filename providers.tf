terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 4.6.0"    
    }
  }  
}

provider "aws" {
    region = "ap-south-1"
    shared_credentials_files = [ "C:/Users/Rishabh.Zutshi/.aws/credentials" ]
    shared_config_files = [ "C:/Users/Rishabh.Zutshi/.aws/config" ]
    profile = "new" 
}
