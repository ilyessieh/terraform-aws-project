Bonjour,

Voici quelques détails concernant ma démarche :

J'ai bien déployé une infrastructure comme sur le schéma avec 4 subnets (2 publics et 2 privés), les instances wordpress
ainsi que les bases de données mysql (RDS) sont bien dans les subnets privés. Les instances wordpress sont dans un autoscaling group.
Dans les subnets publics j'ai mis des instances bastion dans un auto scaling group.
Et j'ai bien un elastic load balancer qui distribue les connections dans l'auto-scaling group des instances wordpress.
J'ai également bien pris le temps d'organiser mon code terraform en modules.

Pour lancer le déploiement de l'infrastructure lancez la commande :
terraform apply --auto-approve 
ensuite il saisissez le mot de passe pour la base de données (que l'on choisit)
et puis il saisissez le nom du user pour la base de données (que l'on choisit également)

J'ai choisi d'utiliser route53 pour accéder à l'application via une nom de domaine.
Pour accéder à l'application il suffit de copier coller l'ALB DNS NAME (qui s'affiche en output , exemple : wordpress-alb-1579772800.eu-west-3.elb.amazonaws.com  ), 
on accède ainsi au serveur APACHE, et en ajoutant /wordpress à l'adresse : wordpress-alb-1579772800.eu-west-3.elb.amazonaws.com/wordpress
on accède bien à wordpress.

J'ai également choisi de créer un bucket s3 pour ma sauvegarde terraform.tfstate

Concernant les gateway, j'ai bien mon internet gateway par contre je n'ai déployé qu'un seul NAT dans un des 2 subnets public_subnets
et qui est relié aux 2 sous-réseaux privés. J'ai bien essayé de déployer 2 NAT :
J'ai mis en commentaires les lignes 84 à 161 dans le fichier modules/networking/main.tf , il s'agissait des 2 NAT (1 dans chaque subnet public).
En déployant ainsi je rencontrait une erreur (voir ci-dessous):


Error: creating Route Table (rtb-0b36bb886d4f75ee2) Association: operation error EC2: AssociateRouteTable, https response error StatusCode: 400, RequestID: a0754b87-418a-4671-aaff-d7cb6e646e13, api error Resource.AlreadyAssociated: the specified association for route table rtb-0b36bb886d4f75ee2 conflicts with an existing association
│ 
│   with module.networking.aws_route_table_association.private_app_rt_assoc_1,
│   on modules/networking/main.tf line 116, in resource "aws_route_table_association" "private_app_rt_assoc_1":
│  116: resource "aws_route_table_association" "private_app_rt_assoc_1" {
│ 
╵
╷
│ Error: creating Route Table (rtb-0e37f6f6ab7a92e96) Association: operation error EC2: AssociateRouteTable, https response error StatusCode: 400, RequestID: c775d285-3868-4d60-90e5-b29e59670e94, api error Resource.AlreadyAssociated: the specified association for route table rtb-0e37f6f6ab7a92e96 conflicts with an existing association
│ 
│   with module.networking.aws_route_table_association.private_app_rt_assoc_2,
│   on modules/networking/main.tf line 155, in resource "aws_route_table_association" "private_app_rt_assoc_2":
│  155: resource "aws_route_table_association" "private_app_rt_assoc_2" {

N'ayant pas réussi à trouver une solution j'ai donc déployer avec 1 seul NAT (code dans le fichier modules/networking/main.tf de la ligne 165 à 202). Ainsi mon application fonctionne.
Si vous avez une solution à m'apporter par rapport à mon problème lors de l'association des route tables avec 2 NAT, je suis preneur.
J'ai pu consulter ce site pour comprendre mon problème : https://registry.terraform.io/providers/hashicorp/aws/4.15.1/docs/resources/route_table_association

Je vous remercie pour l'examen de mon rendu.

Cordialement,

Ilyess EL HAMDANI