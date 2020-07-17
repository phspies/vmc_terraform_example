provider "nsxt" {
  host                 = format("x-52-39-76-157.rp.vmwarevmc.com/vmc/reverse-proxy/api/orgs/%s/sddcs/%s/sks-nsxt-manager", var.vmc_vars_organization_id, var.vmc_vars_sddc_id)    
  vmc_token            = var.vmc_vars_token
  allow_unverified_ssl = true
  enforcement_point    = "vmc-enforcementpoint"
}

