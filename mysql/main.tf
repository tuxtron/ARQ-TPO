
provider "mysql" {
  endpoint = "localhost:3306"  # MySQL Endpoint
  username = "root"   # Some existing ser with privileges
  password = "Pb5c2.<:-Gf7vc4M"  # User pass
}

# Crear base de datos
resource "mysql_database" "some_db" {
  name = "some_db_name"  #Database to be created
}

# Crear usuario
resource "mysql_user" "demo" {
  user     = "demo"  # User to be created
  host     = "localhost"  #host where database will be created
  password = "Xd5c2.<:-Gf7vc5M"    # Some strong pass for demo user
}