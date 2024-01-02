# eks_infra

## 목표
아래 기본 인프라 구성 정보를 Terraform 으로 구축한다.

## 인프라 구성 정보 
|자원|이름|정보|
|------|---|---|
|VPC|myeks-VPC|IP CIDR: 192.168.0.0/16|
|서브넷|myeks-PublicSubnet1|IP CIDR: 192.168.1.0/24, ap-northeast-2a|
|서브넷|myeks-PublicSubnet2|IP CIDR: 192.168.2.0/24, ap-northeast-2a|
|서브넷|myeks-PrivateSubnet1|IP CIDR: 192.168.3.0/24, ap-northeast-2a|
|서브넷|myeks-PrivateSubnet2|IP CIDR: 192.168.4.0/24, ap-northeast-2a|
|인터넷 게이트웨이|igw|연결: myeks-VPC|
|라우팅 테이블|myeks-PublicSubnetRT|연결: myeks-PublicSubnet1/2, 경로: 0.0.0.0/0 -> igw|
|라우팅 테이블|myeks-PrivateSubnetRT|연결: myeks-PrivateSubnet1/2, 경로: local|
|EC2 인스턴스|myeks-host|연결: myeks-PublicSubnet1, Public IP 할당: <br> 설치: kubectl, awscli, docker, krew, kube_ps1, etc.|
|보안그룹|myeks-host-SG|연결: myeks-host, 인바운드 규칙: 개인 PC의 Public IP/32, 모든 트래픽|

### 선행 작업
1. Terraform 클라우드 계정 및 조직 구성
2. Terraform에서 VCS 연결(GitHub)
3. Terraform에서 AWS에 접근 가능한 액세스 키 설정
4. Terraform Workspace 초기화
