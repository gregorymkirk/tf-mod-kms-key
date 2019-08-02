variable description {
  default ""
}
variable deletion_window_in_days {
  default = 30
}
variable enable_key_rotation {
  default = "true"
}

variable tags {
  description = "tags to use for the key"
  type        = "map"

  default = {
    "SnowAppCode"     = ""
    "SnowAppName"     = ""
    "SnowAppSupport"  = ""
    "SnowAppSysId"    = ""
    "SnowChargeCode"  = ""
    "SnowEnvironment" = ""
    "SnowRITM"        = ""
  }
}

variable create_alias {
  default = false
}

variable alias {
  type        = "string"
  description = "Alias name for the key (optional)"
  default     = ""
}

variable create_custom_policy {
  default = false
}

variable custom_policy {
  type        = "string"
  description = "File name of custom JSON policy document (optional)"
  default     = ""
}
