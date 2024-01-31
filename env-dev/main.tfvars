env = "dev"
vpc = {
  main = {
    cidr_block = "10.0.0.0/16"
    subnets    = {
      public = {
        name       = "public"
        cidr_block = ["10.0.0.0/24", "10.0.1.0/24"]
      }
      web = {
        name       = "web"
        cidr_block = ["10.0.2.0/24", "10.0.3.0/24"]
      }
      app = {
        name       = "app"
        cidr_block = ["10.0.4.0/24", "10.0.5.0/24"]
      }
      db = {
        name       = "db"
        cidr_block = ["10.0.6.0/24", "10.0.7.0/24"]
      }
    }
  }
}