resource "nsxt_policy_group" "cats" {
    display_name = "tf-group1"
    description  = "Terraform provisioned Group"
    domain = "cgw"

    criteria {
        ipaddress_expression {
            ip_addresses = ["211.1.1.1", "212.1.1.1", "192.168.1.1-192.168.1.100"]
        }
    }
}
resource "nsxt_policy_group" "fish" {
    display_name = "tf-group2"
    description  = "Terraform provisioned Group2"
    domain = "cgw"

    criteria {
        condition {
            key         = "Name"
            member_type = "VirtualMachine"
            operator    = "STARTSWITH"
            value       = "public"
        }
        condition {
            key         = "OSName"
            member_type = "VirtualMachine"
            operator    = "CONTAINS"
            value       = "Ubuntu"
        }
    }
    conjunction {
        operator = "OR"
    }

    criteria {
        ipaddress_expression {
            ip_addresses = ["211.1.1.1", "212.1.1.1", "192.168.1.1-192.168.1.100"]
        }
    }
}

resource "nsxt_policy_service" "service_l4port" {
  description  = "L4 ports service provisioned by Terraform"
  display_name = "S1"

  l4_port_set_entry {
    display_name      = "TCP80"
    description       = "TCP port 80 entry"
    protocol          = "TCP"
    destination_ports = [ "80" ]
  }

  tag {
    scope = "color"
    tag   = "pink"
  }
}

resource "nsxt_policy_security_policy" "policy1" {
    display_name = "test_policy1"
    description  = "Terraform provisioned Security Policy"
    category     = "Application"
    locked       = false
    stateful     = true
    tcp_strict   = false
    scope        = [nsxt_policy_group.fish.path]
    domain       = "cgw"

    rule {
      display_name     = "allow_udp"
      source_groups    = [nsxt_policy_group.fish.path]
      sources_excluded = true
      scope            = [nsxt_policy_group.cats.path]
      action           = "ALLOW"
      services         = [nsxt_policy_service.service_l4port.path]
      logged           = true
      disabled         = true
      notes            = "Disabled by starfish for debugging"
    }
}
