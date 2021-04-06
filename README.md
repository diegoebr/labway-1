Este projeto tem como objetivo a resolução do lab:
https://github.com/ikauzak/lmbr-devops-challenge/tree/master/infraestrutura

Para resolução foi utilizado somente a ferramenta TERRAFORM, com o modulo https://github.com/terraform-google-modules/terraform-google-container-vm e o agente startup https://github.com/GoogleCloudPlatform/konlet/blob/master/scripts/konlet-startup.service.

Pre reqs.
Ferramenta = TERRAFORM

VARS

TF_VAR_subnetwork_project= (INSERIR PROJETO COM REDE),

TF_VAR_subnetwork=(INSERIR ENDEREÇO API REDE),

TF_VAR_team=(TIME A UTILIZAR),

TF_VAR_mysql_password=(PASSWORD BANCO),

TF_VAR_mysql_password_root=(PASSWORD ROOT BANCO)



