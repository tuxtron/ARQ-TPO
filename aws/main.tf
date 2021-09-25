variable "my_access_key" {
  description = "Access-key-for-AWS"
  default = "no_access_key_value_found"
}

variable "my_secret_key" {
  description = "Secret-key-for-AWS"
  default = "no_secret_key_value_found"
}


provider "aws" {
	region = "${var.aws_region}"
	access_key = "${var.my_access_key}"
	secret_key = "${var.my_secret_key}"
}

resource "aws_security_group" "SG-TPO-ARQ" {
    name = "SG-TPO-ARQ"
    description = "segurity group creado para TPO"

    //HTTP
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    //Salida Internet 
    egress{
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

##listar AZ

// Retorna las AZ
data "aws_availability_zones" "all_zones" {}

## Crear LB en todas las AZ

resource "aws_elb" "tpo_elb" {
    name = "tpo-elb"
    availability_zones = "${data.aws_availability_zones.all_zones.names}"
    security_groups = ["${aws_security_group.SG-TPO-ARQ.id}"]

    listener {
        instance_port = 80
        instance_protocol = "http"
        lb_port = 80
        lb_protocol = "http"
    }

    health_check{
        healthy_threshold = 2
        unhealthy_threshold = 2
        timeout = 4
        target = "HTTP:80/"
        interval = 30
    }
}

##Configuration Launcher

//lanza intancias ec2

resource "aws_launch_configuration" "tpo_lc"{
    name = "tpo_lc"
    image_id = "${lookup(var.aws_ami, var.aws_region)}" //toma los valores de variables
    instance_type = "${var.intance_type}"

    ##si es necesario correr un userdata
    user_data = "${file("start.sh")}"
    
    ##SSH KEY
    key_name = "${lookup(var.key_name, var.aws_region)}"
}


resource "aws_autoscaling_group" "TPO_asg"{
    name = "TPO_asg"
    availability_zones = "${data.aws_availability_zones.all_zones.names}"
    min_size = "${var.asg_min}"
    max_size = "${var.asg_max}"
    desired_capacity= "${var.asg_desired}"
    force_delete = true

    launch_configuration = "${aws_launch_configuration.tpo_lc.name}"

    load_balancers = ["${aws_elb.tpo_elb.name}"]

    tag {
        key = "Name"
        value = " TPO-ARG"
        propagate_at_launch = "true"
    }
}