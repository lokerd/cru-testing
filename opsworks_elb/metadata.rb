name              "opsworks-elb"
maintainer        "CrowdMob Inc."
maintainer_email  "developers@crowdmob.com"
license           "Apache 2.0"
description       "Provides recipes to register and deregister from elb for an opsworks instance"
version           "0.0.2"

recipe            "opsworks-elb::register", "Registers an instance with the ELB"
recipe            "opsworks-elb::deregister", "De-registers an instance from the ELB"
depends           "java"
